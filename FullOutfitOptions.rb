# claiming var 1991

$OUTFITOPTIONS_SWITCH_ICEPTOUTFIT = 1991

Variables[:Outfit] = 259
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
        [:Script, /^\$Trainer\.outfit=/])
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
          InjectionHelper.parseEventCommand(insn.indent, :ControlSwitch, :outfitoptions_IceptOutfit, true))
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


# Clothing select

def outfitoptions_handle_clothing_select
  if Kernel.pbConfirmMessage(_INTL('Change clothes?'))
    outfitoptions_handle_clothing_choices
  end
end

def outfitoptions_handle_clothing_choices
  currVal = $game_variables[:Outfit]

  choices = ["Default outfit", "Secondary outfit"]
  outfits = [0, 1]
  if $game_switches[:LegacyOutfit] # Legacy outtfit
    choices.push(_INTL("Legacy outfit"))
    outfits.push(2)
  end

  if !$game_switches[:outfitoptions_IceptOutfit] && $game_variables[:V13Story] >= 97 # V13 story
    $game_switches[:outfitoptions_IceptOutfit] = true
  end

  if $game_switches[:outfitoptions_IceptOutfit]
    choices.push(_INTL("Interceptor outfit *"))
    outfits.push(3)
  end

  if $game_switches[:DarchOutfit] # Darch Outfit
    choices.push(_INTL("Darchlight form *"))
    outfits.push(4)
  end

  if $game_switches[:XGOutfitAvailable] # XG Outfit
    choices.push(_INTL("Xenogene outfit"))
    outfits.push(6)
  end

  default = outfits.find_index(currVal) || 0

  caveat = _INTL('(Outfits marked with * might act strangely outside intended locations.)')
  msgwindow=Kernel.pbCreateMessageWindow(nil,nil)
  ret = Kernel.pbMessageDisplay(msgwindow,caveat,false,
     proc { next Kernel.pbShowCommands(nil,choices,default+1,default) })
  Kernel.pbDisposeMessageWindow(msgwindow)
  Input.update

  newOutfit = outfits[ret]
  if newOutfit != -1
    $game_screen.start_tone_change(Tone.new(-255,-255,-255,0), 14 * 2)
    pbWait(20)
    pbSEPlay('Fire1', 80, 80)
    $game_variables[:Outfit] = newOutfit # Outfit
    $Trainer.outfit = newOutfit
    Kernel.pbMessage(_INTL('\\PN changed clothes!'))
    pbWait(10)
    $game_screen.start_tone_change(Tone.new(0,0,0,0), 10 * 2)
  end
end

# Patch common events

# Player Dupe
outfitoptions_injectBeforeOutfit0($cache.RXevents[29], 0, [4], false)
# Player Dupe 2
outfitoptions_injectBeforeOutfit0($cache.RXevents[81], 2, [4], false)
# Outfit Management
outfitoptions_patch_outfit_management($cache.RXevents[131])
# Choose Outfit
outfitoptions_override_outfit_choice($cache.RXevents[133])

# Patch map events

class Cache_Game
  if !defined?(outfitoptions_old_map_load)
    alias :outfitoptions_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return outfitoptions_old_map_load(mapid)
    end

    ret = outfitoptions_old_map_load(mapid)

    if mapid == 53 # I Nightmare Realm
      # Mirror match
      outfitoptions_injectBeforeOutfit0(ret.events[66].pages[0], 0, [2, 3, 4, 6], true)
      outfitoptions_injectBeforeOutfit0(ret.events[76].pages[0], 0, [2, 3, 4, 6], true)
    elsif mapid == 85 # Nightmare Toy Box
      # Beddtime
      outfitoptions_wake_up(ret.events[66].pages[0])
      # Clothing box
      outfitoptions_nix_darchoutfit_set(ret.events[63], true)
    elsif mapid == 151 # Nightbox Theater
      # PM talk
      outfitoptions_nix_darchoutfit_set(ret.events[22], false)
    elsif mapid == 57 # Land of Broken Dreams
      # PM Fights
      outfitoptions_arbitrary_outfit(ret.events[91])
      outfitoptions_arbitrary_outfit(ret.events[103])
      outfitoptions_set_icep_outfit_fight(ret.events[91])
      outfitoptions_set_icep_outfit_fight(ret.events[103])
    elsif mapid == 495 # Decompression Lab
      # Elevator
      outfitoptions_replace_outfits_with_darchflag(ret.events[78])
    elsif mapid == 609 # ??? (.KF P)
      # P Gate
      outfitoptions_arbitrary_outfit(ret.events[42])
    end

    return ret
  end
end