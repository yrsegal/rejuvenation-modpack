begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

class Game_Screen
  attr_accessor :blacksteepleskip_tookskip
end

InjectionHelper.registerScriptSwitch("$game_screen.blacksteepleskip_tookskip")

Variables[:UnidataBadgeCount] = 759
Variables[:BlacksteepleStory] = 232

InjectionHelper.defineMapPatch(13, 24) { |event| # Akuwa town, warp to blacksteeple
  event.patch(:addskipforblacksteeple) { |page|
    matched = page.lookForSequence([:TransferPlayer, :Constant, 128, nil, nil, nil, nil])
    if matched
      page.insertBefore(matched,
        [:ConditionalBranch, :Variable, :UnidataBadgeCount, :Constant, 5, :>=],
          [:Label, 'blacksteepleskipstart'],
          [:ShowText, "Skip through Blacksteeple Castle?"],
          [:ShowChoices, ["Yes", "No"], 2],
          [:When, 0, "Yes"],
            [:Script, "$PokemonBag.pbStoreItem(:MININGKIT,1)"],
            [:Script, "$PokemonBag.pbStoreItem(:BLASTPOWDER,1)"],
            [:Script, "$PokemonBag.pbStoreItem(:FOCUSSASH,1)"],
            [:ShowText, "Skip to Madame X, the Battleship, or Terajuma?"],
            [:ShowChoices, ["Madame X", "Battleship", "Terajuma"], 5],
            [:When, 0, "Madame X"],
              [:ControlVariable, :BlacksteepleStory, :[]=, :Constant, 81],
              [:Script, "$game_screen.blacksteepleskip_tookskip = true"],
              [:TransferPlayer, :Constant, 440, 59, 70, :Up, false],
              :ExitEventProcessing,
            :Done,
            [:When, 1, "Battleship"],
              [:ControlVariable, :BlacksteepleStory, :[]=, :Constant, 84],
              [:Script, "$game_screen.blacksteepleskip_tookskip = true"],
              [:TransferPlayer, :Constant, 89, 69, 39, :Down, false], # Xen Battleship
              [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
              :ExitEventProcessing,
            :Done,
            [:When, 2, "Terajuma"],
              [:ControlVariable, :BlacksteepleStory, :[]=, :Constant, 84],
              [:Script, "$game_screen.blacksteepleskip_tookskip = true"],
              [:TransferPlayer, :Constant, 207, 92, 66, :Left, false], # Terajuma Password point
              :ExitEventProcessing,
            :Done,
            :WhenCancel,
              [:JumpToLabel, 'blacksteepleskipstart'],
            :Done,
          :Done,
          [:When, 1, "No"],
          :Done,
        :Done)
    end
  }
}

InjectionHelper.defineMapPatch(440) { |map| # Blacksteeple Castle Confrontation
  map.createSinglePageEvent(60, 69, "pc_star") { |page| 
    page.setGraphic("HealBell", hueShift: 100)
    page.direction_fix = true
    page.move_speed = 1
    page.step_anime = true
    page.requiresSwitch(InjectionHelper.getScriptSwitch("$game_screen.blacksteepleskip_tookskip"))
    page.interact(
      [:Script, 'Kernel.pbPokeCenterPC'])
  }
}

InjectionHelper.defineMapPatch(207) { |map| # Terajuma Shipyard
  for x, y, i in [[32, 14, 0],
                  [33, 14, 1],
                  [35, 14, 2],
                  [36, 14, 3],
                  [36, 13, 4]]
    map.createNewEvent(x, y, "miningrock", "blacksteepleskip_miningrock#{i}") { |event|
      event.newPage { |page|
        page.setGraphic("Object Mineable Rock")
        page.direction_fix = true
        page.move_speed = 1
        page.move_frequency = 1
        page.step_anime = true
        page.requiresSwitch(InjectionHelper.getScriptSwitch("$game_screen.blacksteepleskip_tookskip"))
        page.interact(
          [:ShowText, "It appears to have been moved here from the Blacksteeple Mines."],
          [:ConditionalBranch, :Script, "$PokemonBag.pbQuantity(:MININGKIT)>0"],
            [:ShowText, "Do you want to mine the rock?"],
            [:ShowChoices, ["Yes", "No"], 2],
            [:When, 0, "Yes"],
              [:Script, "pbMiningGame"],
              [:ControlSelfSwitch, 'A', true],
              [:ShowText, "The rock crumbled away."],
            :Done,
            [:When, 1, "No"],
            :Done,
          :Else,
            [:ShowText, "It seems too sturdy to break or move..."],
          :Done)
      }

      event.newPage { |page|
        page.requiresSelfSwitch("A")
      }
    }
  end
}
