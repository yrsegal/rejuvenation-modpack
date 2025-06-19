
Variables[:Outfit] = 259
Variables[:MCname] = 701

# Code blocks

def anafixes_makeMoveRoute(graphic, direction = :Up)
  return [
    false,
    [:SetCharacter, graphic, 0, direction, 0],
    :Done
  ]
end

def anafixes_transmuteMoveRoute(prevRoute, replaceGraphic)
  newRoute = RPG::MoveRoute.new
  newRoute.repeat = prevRoute.repeat
  newRoute.skippable = prevRoute.skippable
  newRoute.list = prevRoute.list.map { |cmd|
    RPG::MoveCommand.new(cmd.code, cmd.parameters.map { |it|
      it.is_a?(String) ? replaceGraphic : it
    })
  }
  return newRoute
end

def anafixes_batty_section(outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:SetMoveRoute, :This, anafixes_makeMoveRoute('BattyFriends_Ana_' + outfit.to_s, :Down)],
      [:JumpToLabel, 'done'],
    :Done
  ]
end


def anafixes_special_sprite_section(special, outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:SetMoveRoute, :This, anafixes_makeMoveRoute(special + '_' + outfit.to_s, :Down)],
      [:JumpToLabel, 'End'],
    :Done
  ]
end

# Injections

def anafixes_fix_darchsprite(event)
  insns = event.list
  InjectionHelper.patch(insns, :anafixes_inject_special_sprite) {
    matched = InjectionHelper.lookForAll(insns,
      [:SetMoveRoute, nil, nil])

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil], InjectionHelper::MOVE_INSNS)

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand.parameters[0] = 'BGirlwalk_4' if submatcher.matches?(movecommand)
      }
    end

    next matched.length > 0
  }
end

def anafixes_replacewitheyesprite(event)
  insns = event.list
  InjectionHelper.patch(insns, :anafixes_inject_special_sprite) {
    matched = InjectionHelper.lookForAll(insns,
      [:SetMoveRoute, nil, nil])

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil], InjectionHelper::MOVE_INSNS)

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand.parameters[0] = 'BGirlwalk_1' if submatcher.matches?(movecommand)
      }
    end

    next matched.length > 0
  }
end

def anafixes_inject_special_sprite(event, special)
  insns = event.list
  InjectionHelper.patch(insns, :anafixes_inject_special_sprite) {
    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :Equals])

    if matched
      insns.insert(insns.index(matched), *InjectionHelper.parseEventCommands(
        *anafixes_special_sprite_section(special, 3),
        *anafixes_special_sprite_section(special, 4),
        baseIndent: matched.indent))
    end
    next matched
  }
end

def anafixes_addLegacyRedCarpet(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :anafixes_addLegacyRedCarpet) {
      matched = InjectionHelper.lookForSequence(insns,
        [:SetMoveRoute, 93, [ false,
          :FaceUp,
          [:SetCharacter, 'xgene_ana_redcarpet', nil, nil, nil],
          :Done
        ]])


      if matched
        targetIdx = insns.index(matched)
        insns[targetIdx..targetIdx] = InjectionHelper.parseEventCommands(
          [:ConditionalBranch, :Variable, :Outfit, :Constant, 2, :GreaterOrEquals],
            [:ConditionalBranch, :Variable, :Outfit, :Constant, 5, :Less],
              [:SetMoveRoute, matched.parameters[0], anafixes_transmuteMoveRoute(matched.parameters[1], 'xgene_legacyana_redcarpet')],
            :Else,
              matched,
            :Done,
          :Else,
            matched,
          :Done,
          baseIndent: matched.indent)
      end
      next matched
    }
  end
end

def anafixes_hotfix_battyfriends(event)
  insns = event.list
  InjectionHelper.patch(insns, :anafixes_hotfix_battyfriends) {
    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Switch, :Aevia, true],
      :BranchEndConditional,
      [:ConditionalBranch, :Switch, :Ana, true],
      :BranchEndConditional)

    if matched
      aeviasection = insns[insns.index(matched[0])..insns.index(matched[1])]
      anasection = insns[insns.index(matched[2])..insns.index(matched[3])]
      tempMarker = "Temporary Marker"

      insns[insns.index(matched[2])..insns.index(matched[3])] = [tempMarker]
      insns[insns.index(matched[0])..insns.index(matched[1])] = anasection
      insns[insns.index(tempMarker)..insns.index(tempMarker)] = aeviasection

    end
    next matched
  }

  InjectionHelper.patch(insns, :anafixes_batty_sprites) {
    matched = InjectionHelper.lookForSequence(insns,
      [:ConditionalBranch, :Switch, :Ana, true])

    if matched
      insns.insert(insns.index(matched) + 1, 
        *InjectionHelper.parseEventCommands(
          *anafixes_batty_section(3),
          *anafixes_batty_section(4),
          baseIndent: matched.indent + 1))

    end
    next matched
  }
end

def anafixes_provide_protagname
  if !$game_variables[:MCname].is_a?(String) || $game_switches[:Ana]
    return 'Aevis' if $game_switches[:Aevis]
    return 'Aevia' if $game_switches[:Aevia]
    return 'Axel' if $game_switches[:Axel]
    return 'Ariana' if $game_switches[:Ariana]
    return 'Alain' if $game_switches[:Alain]
    return 'Aero' if $game_switches[:Aero]
    return 'Ana' # Should be impossible under normal circumstances
  end
  return $game_variables[:MCname]
end

def anafixes_fix_protagname(page)
  insns = page.list
  InjectionHelper.patch(insns, :anafixes_fix_protagname) {
    labelMatch = InjectionHelper.lookForSequence(insns,
      [:Label, 'point1'])

    textMatches = InjectionHelper.lookForAll(insns,
      [:ShowText, /\\v\[701\]/]) + 
    InjectionHelper.lookForAll(insns,
      [:ShowTextContinued, /\\v\[701\]/])

    if labelMatch
      insns.insert(insns.index(labelMatch), *InjectionHelper.parseEventCommands(
        [:Script, '$game_variables[5] = anafixes_provide_protagname'],
        baseIndent: labelMatch.indent))
    end

    for matched in textMatches
      matched.parameters[0].gsub! /\\v\[701\]/, '\\v[5]'
    end

    next labelMatch && textMatches.length > 0
  }
end

TextureOverrides.registerTextureOverrides({
    TextureOverrides::CHARS + 'BGirlAerialDrive_2' => TextureOverrides::MOD + 'Ana/Legacy/Flying',
    TextureOverrides::CHARS + 'BGirlAquaDrive_2' => TextureOverrides::MOD + 'Ana/Legacy/Surfing',
    TextureOverrides::CHARS + 'BGirlFishingDrive_2' => TextureOverrides::MOD + 'Ana/Legacy/Fishing',
    TextureOverrides::CHARS + 'BGirlSurfFishDrive_2' => TextureOverrides::MOD + 'Ana/Legacy/SurfFish',
    TextureOverrides::CHARS + 'BGirlDiveDrive_2' => TextureOverrides::MOD + 'Ana/Legacy/Diving',
    TextureOverrides::MAP + 'mapPlayer007_2' => TextureOverrides::MOD + 'Ana/Legacy/MapHead',
    TextureOverrides::CHARS + 'Trainer007_2' => TextureOverrides::MOD + 'Ana/Legacy/Trainer',
    TextureOverrides::CHARS + 'xgene_legacyana_redcarpet' => TextureOverrides::MOD + 'Ana/Legacy/RedCarpet',

    # Star of Hope
    TextureOverrides::CHARS + 'BGirlAerialDrive_3' => TextureOverrides::MOD + 'Ana/Star/Flying',
    TextureOverrides::CHARS + 'BGirlAquaDrive_3' => TextureOverrides::MOD + 'Ana/Star/Surfing',
    TextureOverrides::CHARS + 'BGirlFishingDrive_3' => TextureOverrides::MOD + 'Ana/Star/Fishing',
    TextureOverrides::CHARS + 'BGirlSurfFishDrive_3' => TextureOverrides::MOD + 'Ana/Star/SurfFish',
    TextureOverrides::CHARS + 'BGirlDiveDrive_3' => TextureOverrides::MOD + 'Ana/Star/Diving',
    TextureOverrides::CHARS + 'BGirlWalk_3' => TextureOverrides::MOD + 'Ana/Star/Walk',
    TextureOverrides::CHARS + 'BGirlRun2_3' => TextureOverrides::MOD + 'Ana/Star/Run',
    TextureOverrides::CHARS + 'Trainer007_3' => TextureOverrides::MOD + 'Ana/Star/Trainer',
    TextureOverrides::CHARS + 'trBack007_3' => TextureOverrides::MOD + 'Ana/Star/TrainerBack',
    TextureOverrides::MAP + 'mapPlayer007_3' => TextureOverrides::MOD + 'Ana/Star/MapHead',
    TextureOverrides::VS + 'vsTrainer7_3' => TextureOverrides::MOD + 'Ana/Star/VS',
    TextureOverrides::CHARS + 'PlayerHeadache_8_3' => TextureOverrides::MOD + 'Ana/Star/Headache',
    TextureOverrides::CHARS + 'PlayerKnockedOut_8_3' => TextureOverrides::MOD + 'Ana/Star/KO',
    TextureOverrides::CHARS + 'BattyFriends_Ana_3' => TextureOverrides::MOD + 'Ana/Star/BattyFriends',

    # Darchlight Ana
    TextureOverrides::CHARS + 'BGirlAerialDrive_4' => TextureOverrides::MOD + 'Ana/Darchlight/Drive',
    TextureOverrides::CHARS + 'BGirlAquaDrive_4' => TextureOverrides::MOD + 'Ana/Darchlight/Drive',
    TextureOverrides::CHARS + 'BGirlFishingDrive_4' => TextureOverrides::MOD + 'Ana/Darchlight/Drive',
    TextureOverrides::CHARS + 'BGirlSurfFishDrive_4' => TextureOverrides::MOD + 'Ana/Darchlight/Drive',
    TextureOverrides::CHARS + 'BGirlDiveDrive_4' => TextureOverrides::MOD + 'Ana/Darchlight/Diving',
    TextureOverrides::CHARS + 'BGirlWalk_4' => TextureOverrides::MOD + 'Ana/Darchlight/Walk',
    TextureOverrides::CHARS + 'BGirlRun2_4' => TextureOverrides::MOD + 'Ana/Darchlight/Run',
    TextureOverrides::CHARS + 'Trainer007_4' => TextureOverrides::MOD + 'Ana/Darchlight/Trainer',
    TextureOverrides::CHARS + 'trBack007_4' => TextureOverrides::MOD + 'Ana/Darchlight/TrainerBack',
    TextureOverrides::MAP + 'mapPlayer007_4' => TextureOverrides::MOD + 'Ana/Darchlight/MapHead',
    TextureOverrides::VS + 'vsTrainer7_4' => TextureOverrides::MOD + 'Ana/Darchlight/VS',
    TextureOverrides::CHARS + 'PlayerHeadache_8_4' => TextureOverrides::MOD + 'Ana/Darchlight/Headache',
    TextureOverrides::CHARS + 'PlayerKnockedOut_8_4' => TextureOverrides::MOD + 'Ana/Darchlight/KO',
    TextureOverrides::CHARS + 'BattyFriends_Ana_4' => TextureOverrides::MOD + 'Ana/Darchlight/BattyFriends'
})

InjectionHelper.defineCommonPatch(23) { |event| anafixes_fix_darchsprite(event) } # Player Dupe (D)
InjectionHelper.defineCommonPatch(49) { |event| anafixes_inject_special_sprite(event, 'PlayerHeadache_8') } # Player Dupe Distress
InjectionHelper.defineCommonPatch(50) { |event| anafixes_inject_special_sprite(event, 'PlayerKnockedOut_8') } # Player Dupe Knocked
InjectionHelper.defineCommonPatch(136) { |event| anafixes_hotfix_battyfriends(event) } # Batty Friends

InjectionHelper.defineMapPatch(53, 2) { |event| # I Nightmare Realm, Aevis/Dupe
  anapage = event.pages[1] # if Ana on
  alainpage = event.pages[7] # if Alain on
  anafixes_replacewitheyesprite(anapage)
  # Swap them so Ana always runs last, displaying properly
  event.pages[1] = alainpage
  event.pages[7] = anapage
  next true
}

InjectionHelper.defineMapPatch(231, 40, 1) { |page| # Somniam Mall, Melia, Crescent Conversation
  anafixes_fix_protagname(page)
}

InjectionHelper.defineMapPatch(291, 72) { |event| anafixes_addLegacyRedCarpet(event) } # Pokestar Studios, Red Carpet Event
