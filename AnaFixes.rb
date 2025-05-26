
Variables[:Outfit] = 259

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

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil])

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

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil])

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


# Patch common events

# Player Dupe (D)
anafixes_fix_darchsprite($cache.RXevents[23])
# Player Dupe Distress
anafixes_inject_special_sprite($cache.RXevents[49], 'PlayerHeadache_8')
# Player Dupe Knocked
anafixes_inject_special_sprite($cache.RXevents[50], 'PlayerKnockedOut_8')
# Batty Friends
anafixes_hotfix_battyfriends($cache.RXevents[136])

# Patch map events

class Cache_Game
  if !defined?(anafixes_old_map_load)
    alias :anafixes_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return anafixes_old_map_load(mapid)
    end

    ret = anafixes_old_map_load(mapid)

    if mapid == 53 # I Nightmare Realm
      aevdupe = ret.events[2] # Aevis/Dupe
      anapage = aevdupe.pages[1] # if Ana on
      alainpage = aevdupe.pages[7] # if Alain on
      anafixes_replacewitheyesprite(anapage)
      # Swap them so Ana always runs last, displaying properly
      aevdupe.pages[1] = alainpage
      aevdupe.pages[7] = anapage
    elsif mapid == 291 # Pokestar Studios
      anafixes_addLegacyRedCarpet(ret.events[72]) # Red Carpet Event
    end
    return ret
  end
end