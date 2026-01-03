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
Variables[:BattleshipStory] = 8

InjectionHelper.defineMapPatch(13, 24) { # Akuwa town, warp to blacksteeple
  patch(:addskipforblacksteeple) {
    matched = lookForSequence([:TransferPlayer, :Constant, 128, nil, nil, nil, nil])
    if matched
      insertBefore(matched) {
        branch(variables[:UnidataBadgeCount], :>=, 5) {
          label 'blacksteepleskipstart'
          show_choices("Skip through Blacksteeple Castle?") {
            choice("Yes") {
              show_choices("Skip to Madame X, the Battleship, or Terajuma?") {
                choice("Madame X") {
                  script '$PokemonBag.pbStoreItem(:MININGKIT,1)
                          $PokemonBag.pbStoreItem(:BLASTPOWDER,1)
                          $PokemonBag.pbStoreItem(:FOCUSSASH,1)'
                  variables[:BlacksteepleStory] = 81
                  script "$game_screen.blacksteepleskip_tookskip = true"
                  transfer_player map: 440, x: 59, y: 70, direction: :Up, fading: false
                  exit_event_processing
                }

                choice("Battleship") {
                  script '$PokemonBag.pbStoreItem(:MININGKIT,1)
                          $PokemonBag.pbStoreItem(:BLASTPOWDER,1)
                          $PokemonBag.pbStoreItem(:FOCUSSASH,1)'
                  variables[:BlacksteepleStory] = 84
                  script "$game_screen.blacksteepleskip_tookskip = true"
                  transfer_player map: 89, x: 69, y: 39, direction: :Down, fading: false
                  change_tone 0, 0, 0, frames: 10
                  exit_event_processing

                }

                choice("Terajuma") {
                  script '$PokemonBag.pbStoreItem(:MININGKIT,1)
                          $PokemonBag.pbStoreItem(:BLASTPOWDER,1)
                          $PokemonBag.pbStoreItem(:FOCUSSASH,1)'
                  variables[:BlacksteepleStory] = 84
                  variables[:BattleshipStory] = 8
                  script "$game_screen.blacksteepleskip_tookskip = true"
                  transfer_player map: 207, x: 92, y: 66, direction: :Down, fading: false
                  exit_event_processing

                }

                when_cancel {
                  jump_label 'blacksteepleskipstart'
                }
              }
            }
            default_choice("No") {}
          }
        }
      }
    end
  }
}

InjectionHelper.defineMapPatch(440) { # Blacksteeple Castle Confrontation
  createSinglePageEvent(60, 69, "pc_star") { 
    setGraphic "HealBell", hueShift: 100
    self.direction_fix = true
    self.move_speed = 1
    self.step_anime = true
    requiresSwitch InjectionHelper.getScriptSwitch("$game_screen.blacksteepleskip_tookskip")
    interact {
      script 'Kernel.pbPokeCenterPC'
    }
  }
}

InjectionHelper.defineMapPatch(207) { # Terajuma Shipyard
  for x, y, i in [[32, 14, 0],
                  [33, 14, 1],
                  [35, 14, 2],
                  [36, 14, 3],
                  [36, 13, 4]]
    createNewEvent(x, y, "miningrock", "blacksteepleskip_miningrock#{i}") {
      newPage { |page|
        setGraphic "Object Mineable Rock"
        self.direction_fix = true
        self.move_speed = 1
        self.move_frequency = 1
        self.step_anime = true
        requiresSwitch InjectionHelper.getScriptSwitch("$game_screen.blacksteepleskip_tookskip")
        page.interact {
          text "It appears to have been moved here from the Blacksteeple Mines."
          branch("$PokemonBag.pbQuantity(:MININGKIT)>0") {
            show_choices("Do you want to mine the rock?") {
              choice("Yes") {
                script "pbMiningGame"
                self_switch["A"] = true
                text "The rock crumbled away."
              }
              default_choice("No") {}
            }
          }.else {
            text "It seems too sturdy to break or move..."
          }
        }
      }

      newPage {
        requiresSelfSwitch "A"
      }
    }
  end
}
