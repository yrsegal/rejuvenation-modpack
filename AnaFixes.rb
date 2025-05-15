
Variables[:Outfit] = 259

# Code blocks

def anafixes_makeMoveRoute(base, outfit, direction = :Up)
  return [
    false,
    [:SetCharacter, base + '_' + outfit.to_s, 0, direction, 0],
    :Done
  ]
end

def anafixes_batty_section(outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:SetMoveRoute, :This, anafixes_makeMoveRoute('BattyFriends_Ana', outfit, :Down)],
      [:JumpToLabel, 'done'],
    :Done
  ]
end


def anafixes_special_sprite_section(special, outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:SetMoveRoute, :This, anafixes_makeMoveRoute(special, outfit, :Down)],
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

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        insn.parameters[0] = 'BGirlwalk_4' if insn.parameters[0] == 'BGirlwalk'
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
      next true
    end
  }
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

      next true
    end
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

      next true
    end
  }
end

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
      # Swap them so Ana always runs last, displaying properly
      aevdupe.pages[1] = alainpage
      aevdupe.pages[7] = anapage
    end

    return ret
  end
end