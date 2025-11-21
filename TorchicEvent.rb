begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:QuestXenogene] = 620

InjectionHelper.defineMapPatch(203) { # Pokestar Studios Interiors
  torchicDoll = nil

  self.data[86,9,2] = 0 # Remove the torchic doll, so it's exclusively handled by the event

  createNewEvent(86, 10, "Torchic", "torchicevent_interactableevent") {
    newPage {
      interact {
        text "It's a stuffed Torchic doll!"
        text "It's warm..."
      }
    }

    newPage {
      requiresVariable :QuestXenogene, 72
      interact {
        text "It's a stuffed Torchic doll!"
        text "It's warm..."
        play_se "255Cry", 80
        text "TORCHIC: Torchic Tor!"
        player.show_animation(EXCLAMATION_ANIMATION_ID)
        events[18].show_animation(EXCLAMATION_ANIMATION_ID)
        wait 20
        text "DYRE: Oh, yeah. That Torchic loves pretending to be a doll. Don't know why."
        text "I've been meaning to find a home for the fella anyway. Take it, I insist!"
        script "pbSetSelfSwitch(#{torchicDoll.id},'A',true)"
        script "Kernel.pbAddPokemon(:TORCHIC,10)"
        self_switch["A"] = true
      }
    }

    newPage { requiresSelfSwitch "A" }
  }

  torchicDoll = createNewEvent(86, 9, "Torchic Doll", "torchicevent_torchicdoll") {
    newPage { setTile(3046) } # Torchic

    newPage { requiresSelfSwitch("A") }
  }
}
