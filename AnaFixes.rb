
Variables[:Outfit] = 259

# Code blocks

def anafixes_makeMoveRoute(graphic, direction = :Up)
  return [
    false,
    [:SetCharacter, graphic, 0, direction, 0],
    :Done
  ]
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

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand.parameters[0] = 'BGirlwalk_4' if movecommand.parameters[0] == 'BGirlwalk'
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

def anafixes_makepage(outfitGreaterThanOrEqual, darkOutfit)
  page = RPG::Event::Page.new

  page.condition.switch1_valid = true
  page.condition.switch1_id = Switches[:Ana]
  if outfitGreaterThanOrEqual > 0
    page.condition.variable_valid = true
    page.condition.variable_id = Variables[:Outfit]
    page.condition.variable_value = outfitGreaterThanOrEqual
  end

  page.graphic.direction = InjectionHelper::FACING_DIRECTIONS[:Down]
  page.graphic.character_name = 'BGirlwalk_' + darkOutfit.to_s

  return page
end


def anafixes_add_anapage(event)
  idxToInsertAfter = -1
  for idx in 0...event.pages.size
    page = event.pages[idx]
    if page.condition.switch1_valid && page.condition.switch1_id == Switches[:Alain]
      idxToInsertAfter = idx
    elsif page.condition.switch1_valid && page.condition.switch1_id == Switches[:Ana]
      return # Already injected
    end
  end

  if idxToInsertAfter != -1
    event.pages.insert(idxToInsertAfter + 1, 
      anafixes_makepage(0, 5), # Desolate
      anafixes_makepage(2, 66), # Desolate Legacy
      anafixes_makepage(6, 5)) # Desolate
  end
end


def anafixes_patch_desolatesprite_cutscene(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :anafixes_patch_desolatesprite_cutscene) {
      matched = InjectionHelper.lookForSequence(insns,
        [:SetMoveRoute, 2, anafixes_makeMoveRoute(nil, :Up)])

      if matched
        idx = insns.index(matched)
        insns.delete_at(idx)
        insns.insert(idx, *InjectionHelper.parseEventCommands(
          [:ConditionalBranch, :Switch, :Ana, true],
            [:ConditionalBranch, :Variable, :Outfit, :Constant, 2, :Less],
              [:SetMoveRoute, 2, anafixes_makeMoveRoute('BGirlWalk_5')],
            :Else,
              [:ConditionalBranch, :Variable, :Outfit, :Constant, 6, :GreaterOrEquals],
                [:SetMoveRoute, 2, anafixes_makeMoveRoute('BGirlWalk_5')],
              :Else,
                [:SetMoveRoute, 2, anafixes_makeMoveRoute('BGirlWalk_66')],
              :Done,
            :Done,
          :Else,
            matched,
          :Done,

          baseIndent: matched.indent))
      end

      next matched
    }
  end
end


def anafixes_patch_desolateoutfit(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :anafixes_patch_desolateoutfit) {
      matched = InjectionHelper.lookForAll(insns,
        [:Script, '$Trainer.outfit=5'])

      for insn in matched
        insn.parameters[0] = 'anafixes_determine_outfit_desolate'
      end

      next matched.length > 0
    }
  end
end

def anafixes_determine_outfit_desolate
  if $Trainer.metaID == 8 # Ana
    trueOutfit = $game_variables[:Outfit]
    if 2 <= trueOutfit && trueOutfit < 6 
      $Trainer.outfit = 66
      return
    end
  end
  $Trainer.outfit = 5
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
    elsif mapid == 609 # Desolate Inside
      anafixes_patch_desolatesprite_cutscene(ret.events[2]) # Outside Cutscene
      anafixes_add_anapage(ret.events[12]) # Player Dupe First
      anafixes_patch_desolateoutfit(ret.events[13]) # Finally Awake
      anafixes_patch_desolateoutfit(ret.events[45]) # 100th floor
    elsif mapid == 243 # Desolate Outside
      anafixes_patch_desolateoutfit(ret.events[10]) # M Conversation
    end
    return ret
  end
end