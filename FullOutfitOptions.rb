begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Outfit] = 259
Switches[:BecameOne] = 1134
Switches[:DarchOutfit] = 1666
Switches[:LegacyOutfit] = 1052
Switches[:XGOutfitAvailable] = 1645

# Code blocks

class Game_Screen
  attr_accessor :outfitoptions_iceptOutfit
end

# Injections

def outfitoptions_arbitrary_outfit(event)
  event.patch(:outfitoptions_arbitrary_outfit) {
    matched = lookForAll([:Script, /^\$Trainer\.outfit=[0-24-9]/])
    for insn in matched
      insn[0] = '$Trainer.outfit=$game_variables[:Outfit]'
    end
  }
end

def outfitoptions_replace_outfits_with_darchflag(event)
  event.patch(:outfitoptions_replace_outfits_with_darchflag) {
    matched = lookForAll([:Script, /^\$Trainer\.outfit=/])

    for insn in matched
      replace(insn) {
        switches[:DarchOutfit] = true
        call_common_event 131 # Outfit Management
      }
    end
  }
end

def outfitoptions_nix_darchoutfit_set(event, replaceWithChoices)
  event.patch(:outfitoptions_nix_darchoutfit_set) {
    matched = lookForAll([:ControlSwitch, :DarchOutfit, false])

    for insn in matched
      if replaceWithChoices
        replace(insn) {
          script 'outfitoptions_handle_clothing_choices'
        }
      else
        delete(insn)
      end
    end
  }
end

def outfitoptions_wake_up(page)
  page.patch(:outfitoptions_wake_up) {
    matched = lookForSequence(
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :==],
      :Else,
      [:Script, 'Kernel.pbSetPokemonCenter'])

    if matched
      # Done to end? if this breaks, return the done
      insertBefore(matched[2]) { # before pokemon center
        label 'outfitoptions-end'
      }

      insertAfter(matched[1]) {
        for outfit in [2,3,4,6]
          branch(variables[:Outfit], :==, outfit) {
            script '$Trainer.outfit=' + outfit.to_s
            jump_label 'outfitoptions-end'
          }
        end
      }
    end
  }
end

def outfitoptions_injectBeforeOutfit0(event, event_id, nums, running, direction=:Down)
  event.patch(:outfitoptions_injectBeforeOutfit0) {
    matched = lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :==])

    if matched
      insertBefore(matched) {
        for outfit in nums
          branch(variables[:Outfit], :==, outfit) {
            for switch, sprite in { Ana:    running ? 'BGirlrun2' : 'BGirlwalk',
                                    Alain:  running ? 'nb_run2'   : 'nb_walk2',
                                    Aero:   running ? 'nb_run'    : 'nb_walk',
                                    Ariana: running ? 'BGirlRun'  : 'trchar003',
                                    Axel:   running ? 'Boy_Run2'  : 'trchar004',
                                    Aevia:  running ? 'girl_run'  : 'trchar001',
                                    Aevis:  running ? 'boy_run'   : 'trchar000', }
              branch(switches[switch], true) {
                events[event_id].set_move_route { set_character sprite, direction: direction }.wait
                jump_label 'End'
              }
            end
          }
        end
      }
    end
  }
end

def outfitoptions_set_icep_outfit_fight(event)
  event.patch(:outfitoptions_set_icep_outfit_fight) {
    matched = lookForAll([:Script, '$Trainer.outfit=3'])

    for insn in matched
      insertAfter(insn) {
        branch(variables[:Outfit], :==, 3) {
          script "$game_screen.outfitoptions_iceptOutfit=true"
        }
      }
    end
  }
end

def outfitoptions_patch_outfit_management(event)
  event.patch(:outfitoptions_patch_outfit_management) {
    insertAtStart {
      branch(variables[:Outfit], :==, 3) {
        script "$game_screen.outfitoptions_iceptOutfit=true"
      }
    }

    matched = lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 4, :==])

    if matched
      insertAfter(matched) {
        variables[:Outfit] = 4
        script '$Trainer.outfit=4'
      }
    end
  }
end

def outfitoptions_override_outfit_choice(event)
  event.patch(:outfitoptions_override_outfit_choice) {
    reformat {
      script 'outfitoptions_handle_clothing_select'
    }
  }
end

def outfitoptions_restore_sprite(event)
  event.patch(:outfitoptions_restore_sprite) {
    matched = lookForSequence([:Script, 'characterRestore'])

    if matched
      insertAfter(matched) {
        script '$game_player.character_name=pbGetPlayerCharset(:walk)'
      }
    end
  }
end


# Clothing select

def outfitoptions_handle_clothing_select
  if Kernel.pbConfirmMessage(_INTL('Change clothes?'))
    outfitoptions_handle_clothing_choices
  end
end

def outfitoptions_handle_clothing_choices(doToneChange = true)
  currVal = $game_variables[:Outfit]

  choices = ["Default outfit", "Secondary outfit"]
  outfits = [0, 1]
  needsCaveat = false
  if $game_switches[:LegacyOutfit] # Legacy outtfit
    choices.push(_INTL("Legacy outfit"))
    outfits.push(2)
  end

  if !$game_screen.outfitoptions_iceptOutfit && $game_variables[:V13Story] >= 97
    $game_screen.outfitoptions_iceptOutfit = true
  end

  if $game_screen.outfitoptions_iceptOutfit
    choices.push(_INTL("Interceptor outfit *"))
    outfits.push(3)
    needsCaveat = true
  end

  if $game_switches[:DarchOutfit] # Darch Outfit
    choices.push(_INTL("Darchlight form *"))
    outfits.push(4)
    needsCaveat = true
  end

  if $game_switches[:XGOutfitAvailable] # XG Outfit
    choices.push(_INTL("Xenogene outfit"))
    outfits.push(6)
  end

  default = outfits.find_index(currVal) || 0

  if needsCaveat
    caveat = _INTL('(Outfits marked with * might act strangely outside intended scenarios.)')
    msgwindow=Kernel.pbCreateMessageWindow(nil,nil)
    ret = Kernel.pbMessageDisplay(msgwindow,caveat,false,
       proc { next Kernel.pbShowCommands(nil,choices,-1,default) })
    Kernel.pbDisposeMessageWindow(msgwindow)
    Input.update
  else
    ret = Kernel.pbShowCommands(nil,choices,-1,default)
  end

  if ret && ret != -1
    newOutfit = outfits[ret]
    if newOutfit != -1
      $game_screen.start_tone_change(Tone.new(-255,-255,-255,0), 14 * 2) if doToneChange
      pbWait(20)
      pbSEPlay('Fire1', 80, 80)
      $game_variables[:Outfit] = newOutfit # Outfit
      $Trainer.outfit = newOutfit
      Kernel.pbMessage(_INTL('\\PN changed clothes!'))
      pbWait(10)
      $game_screen.start_tone_change(Tone.new(0,0,0,0), 10 * 2) if doToneChange
    end
  end
end

# Patch common events

InjectionHelper.defineCommonPatch(29) { # Player Dupe
  outfitoptions_injectBeforeOutfit0(self, 0, [4], false)
}
InjectionHelper.defineCommonPatch(32, &method(:outfitoptions_restore_sprite)) # Change Back player
InjectionHelper.defineCommonPatch(81) { # Player Dupe 2
  outfitoptions_injectBeforeOutfit0(self, 2, [4], false)
}
InjectionHelper.defineCommonPatch(131, &method(:outfitoptions_patch_outfit_management)) # Outfit Management
InjectionHelper.defineCommonPatch(133, &method(:outfitoptions_override_outfit_choice)) # Choose Outfit

InjectionHelper.defineMapPatch(53) { # I Nightmare Realm
  # Mirror match
  outfitoptions_injectBeforeOutfit0(self.events[66].pages[0], 0, [2, 3, 4, 6], true, :Up)
  outfitoptions_injectBeforeOutfit0(self.events[76].pages[0], 0, [2, 3, 4, 6], true, :Up)
  outfitoptions_injectBeforeOutfit0(self.events[86].pages[0], 0, [2, 3, 4, 6], true, :Up)
  outfitoptions_injectBeforeOutfit0(self.events[94].pages[0], 0, [2, 3, 4, 6], true, :Up)
}

InjectionHelper.defineMapPatch(85) { # Nightmare Toy Box
  # Beddtime
  outfitoptions_wake_up(self.events[66].pages[0])
  # Clothing box
  outfitoptions_nix_darchoutfit_set(self.events[63], true)
}

InjectionHelper.defineMapPatch(85, 22) { # Nightbox Theater, PM talk
  outfitoptions_nix_darchoutfit_set(self, false)
}

InjectionHelper.defineMapPatch(57) { # Land of Broken Dreams
  # PM Fights
  outfitoptions_arbitrary_outfit(self.events[91])
  outfitoptions_arbitrary_outfit(self.events[103])
  outfitoptions_set_icep_outfit_fight(self.events[91])
  outfitoptions_set_icep_outfit_fight(self.events[103])
}

InjectionHelper.defineMapPatch(495, 78, &method(:outfitoptions_replace_outfits_with_darchflag)) # Decompression Lab, Elevator

InjectionHelper.defineMapPatch(609, 42, &method(:outfitoptions_arbitrary_outfit)) # ??? .KF P, Paradox Gate
