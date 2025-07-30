begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

# claiming var 1991

$OUTFITOPTIONS_SWITCH_ICEPTOUTFIT = 1991

Variables[:Outfit] = 259
Switches[:BecameOne] = 1134
Switches[:DarchOutfit] = 1666
Switches[:LegacyOutfit] = 1052
Switches[:XGOutfitAvailable] = 1645
Switches[:outfitoptions_IceptOutfit] = $OUTFITOPTIONS_SWITCH_ICEPTOUTFIT

# Code blocks

def outfitoptions_makeMoveRoute(base, outfit, direction = 8)
  return [
    false,
    [:SetCharacter, base + '_' + outfit.to_s, 0, direction, 0],
    :Done
  ]
end

def outfitoptions_wakeup_section(outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:Script, '$Trainer.outfit=' + outfit.to_s],
      [:JumpToLabel, 'outfitoptions-end'],
    :Done
  ]
end

def outfitoptions_generateWindstormBranch(outfit, running, event_id)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      *outfitoptions_charSection(outfit, event_id, :Ana, running ? 'BGirlrun2' : 'BGirlwalk'),
      *outfitoptions_charSection(outfit, event_id, :Alain, running ? 'nb_run2' : 'nb_walk2'),
      *outfitoptions_charSection(outfit, event_id, :Aero, running ? 'nb_run' : 'nb_walk'),
      *outfitoptions_charSection(outfit, event_id, :Ariana, running ? 'BGirlRun' : 'trchar003'),
      *outfitoptions_charSection(outfit, event_id, :Axel, running ? 'Boy_Run2' : 'trchar004'),
      *outfitoptions_charSection(outfit, event_id, :Aevia, running ? 'girl_run' : 'trchar001'),
      *outfitoptions_charSection(outfit, event_id, :Aevis, running ? 'boy_run' : 'trchar000'),
    :Done
  ]
end

def outfitoptions_charSection(outfit, event_id, variable, base)
  return [
    [:ConditionalBranch, :Switch, :Ana, true],
      [:SetMoveRoute, event_id, outfitoptions_makeMoveRoute(base, outfit)],
      :WaitForMovement,
      [:JumpToLabel, 'End'],
    :Done]
end

# Injections

def outfitoptions_arbitrary_outfit(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :outfitoptions_arbitrary_outfit) {
      matched = InjectionHelper.lookForAll(insns,
        [:Script, /^\$Trainer\.outfit=[0-24-9]/])
      for insn in matched
        insn.parameters[0] = '$Trainer.outfit=$game_variables[:Outfit]'
      end

      next matched.length > 0
    }
  end
end

def outfitoptions_replace_outfits_with_darchflag(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :outfitoptions_replace_outfits_with_darchflag) {
      matched = InjectionHelper.lookForAll(insns,
        [:Script, /^\$Trainer\.outfit=/])

      for insn in matched
        insns[insns.index(insn)] = InjectionHelper.parseEventCommand(insn.indent,
          :ControlSwitch, :DarchOutfit, true)
      end

      next matched.length > 0
    }
  end
end

def outfitoptions_nix_darchoutfit_set(event, replaceWithChoices)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :outfitoptions_nix_darchoutfit_set) {
      matched = InjectionHelper.lookForAll(insns,
        [:ControlSwitch, :DarchOutfit, false])

      for insn in matched
        if replaceWithChoices
          insns[insns.index(insn)] = InjectionHelper.parseEventCommand(insn.indent,
            :Script, 'outfitoptions_handle_clothing_choices')
        else
          insns.delete_at(insns.index(insn))
        end
      end

      next matched.length > 0
    }
  end
end

def outfitoptions_wake_up(page)
  insns = page.list

  InjectionHelper.patch(insns, :outfitoptions_wake_up) {
    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :Equals],
      :Else,
      [:Script, 'Kernel.pbSetPokemonCenter'])

    if matched
      insns.insert(insns.index(matched[2]), # before pokemon center
        *InjectionHelper.parseEventCommands(
        [:Label, 'outfitoptions-end'],
        :Done,
        baseIndent: matched[2].indent))

      payload = []
      for outfit in [2,3,4,6]
        payload += outfitoptions_wakeup_section(outfit)
      end

      insns.insert(insns.index(matched[1]) + 1, *InjectionHelper.parseEventCommands(*payload,
        baseIndent: matched[1].indent + 1))

    end
    next matched
  }
end

def outfitoptions_injectBeforeOutfit0(subevent, event_id, nums, running)
  insns = subevent.list

  InjectionHelper.patch(insns, :outfitoptions_injectBeforeOutfit0) {
    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :Equals])

    if matched
      newinsns = []
      nums.each {|num| newinsns += outfitoptions_generateWindstormBranch(num,running,event_id) }

      insns.insert(insns.index(matched), *InjectionHelper.parseEventCommands(*newinsns, baseIndent: matched.indent))
    end
    next matched
  }
end

def outfitoptions_set_icep_outfit_fight(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :outfitoptions_set_icep_outfit_fight) {
      matched = InjectionHelper.lookForAll(insns,
        [:Script, '$Trainer.outfit=3'])

      for insn in matched
        insns.insert(insns.index(insn) + 1,
          *InjectionHelper.parseEventCommands(
            [:ControlSwitch, :outfitoptions_IceptOutfit, true],
            baseIndent: insn.indent))
      end

      next matched.length > 0
    }
  end
end

def outfitoptions_patch_outfit_management(event)
  insns = event.list
  InjectionHelper.patch(insns, :outfitoptions_patch_outfit_management) {
    insns.unshift(*InjectionHelper.parseEventCommands(
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 3, :Equals],
        [:ControlSwitch, :outfitoptions_IceptOutfit, true],
      :Done))

    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 4, :Equals])

    if matched
      insns.insert(insns.index(matched) + 1,
        *InjectionHelper.parseEventCommands(
          [:ControlVariable, :Outfit, :Set, :Constant, 4],
          [:Script, '$Trainer.outfit=4'],
          baseIndent: matched.indent + 1))
    end
    next matched
  }
end

def outfitoptions_override_outfit_choice(event)
  insns = event.list
  InjectionHelper.patch(insns, :outfitoptions_override_outfit_choice) {
    event.list.clear()
    event.list.push(*InjectionHelper.parseEventCommands(
        [:Script, 'outfitoptions_handle_clothing_select'],
        :Done))
  }
end

def outfitoptions_restore_sprite(event)
  insns = event.list
  InjectionHelper.patch(insns, :outfitoptions_restore_sprite) {
    matched = InjectionHelper.lookForSequence(insns,
      [:Script, 'characterRestore'])

    if matched
      insns.insert(insns.index(matched) + 1,
        *InjectionHelper.parseEventCommands(
          [:Script, '$game_player.character_name=pbGetPlayerCharset(:walk)'],
          baseIndent: matched.indent))
    end
    next matched
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

  if !$game_switches[:outfitoptions_IceptOutfit] && $game_variables[:V13Story] >= 97
    $game_switches[:outfitoptions_IceptOutfit] = true
  end

  if $game_switches[:outfitoptions_IceptOutfit]
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

InjectionHelper.defineCommonPatch(29) { |event| # Player Dupe
  outfitoptions_injectBeforeOutfit0(event, 0, [4], false)
}
InjectionHelper.defineCommonPatch(32, &method(:outfitoptions_restore_sprite)) # Change Back player
InjectionHelper.defineCommonPatch(81) { |event| # Player Dupe 2
  outfitoptions_injectBeforeOutfit0(event, 2, [4], false)
}
InjectionHelper.defineCommonPatch(131, &method(:outfitoptions_patch_outfit_management)) # Outfit Management
InjectionHelper.defineCommonPatch(133, &method(:outfitoptions_override_outfit_choice)) # Choose Outfit

InjectionHelper.defineMapPatch(53) { |map| # I Nightmare Realm
  # Mirror match
  outfitoptions_injectBeforeOutfit0(map.events[66].pages[0], 0, [2, 3, 4, 6], true)
  outfitoptions_injectBeforeOutfit0(map.events[76].pages[0], 0, [2, 3, 4, 6], true)
  outfitoptions_injectBeforeOutfit0(map.events[86].pages[0], 0, [2, 3, 4, 6], true)
  outfitoptions_injectBeforeOutfit0(map.events[94].pages[0], 0, [2, 3, 4, 6], true)
}

InjectionHelper.defineMapPatch(85) { |map| # Nightmare Toy Box
  # Beddtime
  outfitoptions_wake_up(map.events[66].pages[0])
  # Clothing box
  outfitoptions_nix_darchoutfit_set(map.events[63], true)
}

InjectionHelper.defineMapPatch(85, 22) { |event| # Nightbox Theater, PM talk
  outfitoptions_nix_darchoutfit_set(event, false)
}

InjectionHelper.defineMapPatch(57) { |map| # Land of Broken Dreams
  # PM Fights
  outfitoptions_arbitrary_outfit(map.events[91])
  outfitoptions_arbitrary_outfit(map.events[103])
  outfitoptions_set_icep_outfit_fight(map.events[91])
  outfitoptions_set_icep_outfit_fight(map.events[103])
}

InjectionHelper.defineMapPatch(495, 78, &method(:outfitoptions_replace_outfits_with_darchflag)) # Decompression Lab, Elevator

InjectionHelper.defineMapPatch(609, 42, &method(:outfitoptions_arbitrary_outfit)) # ??? .KF P, Paradox Gate
