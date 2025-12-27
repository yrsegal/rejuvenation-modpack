begin
  missing = ['0000.injection.rb', '0000.textures.rb', 'TextureOverrides'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Outfit] = 259
Variables[:MCname] = 701

# Code blocks


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
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      this.set_move_route {
        set_character 'BattyFriends_Ana_' + outfit.to_s
      }
      jump_label 'done'
    }
  }
end


def anafixes_special_sprite_section(special, outfit)
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      branch(switches[:Ana], true) {
        this.set_move_route {
          set_character special + '_' + outfit.to_s
        }
        jump_label 'End'
      }
    }
  }
end

# Injections

def anafixes_fix_darchsprite(event)
  event.patch(:anafixes_inject_special_sprite) {
    matched = lookForAll([:SetMoveRoute, nil, nil])

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil], InjectionHelper::MOVE_INSNS)

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand[0] = 'BGirlwalk_4' if submatcher.matches?(movecommand)
      }
    end
  }
end

def anafixes_replacewitheyesprite(event)
  event.patch(:anafixes_inject_special_sprite) {
    matched = lookForAll([:SetMoveRoute, nil, nil])

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'BGirlwalk', nil, nil, nil], InjectionHelper::MOVE_INSNS)

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand[0] = 'BGirlwalk_1' if submatcher.matches?(movecommand)
      }
    end
  }
end

def anafixes_inject_special_sprite(event, special)
  event.patch(:anafixes_inject_special_sprite) {
    matched = lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :==])

    if matched
      insertBefore(matched,
        *anafixes_special_sprite_section(special, 3),
        *anafixes_special_sprite_section(special, 4))
    end
  }
end

def anafixes_addLegacyRedCarpet(event)
  event.patch(:anafixes_addLegacyRedCarpet) {
    matched = lookForSequence(
      [:SetMoveRoute, 93, [ false,
        :FaceUp,
        [:SetCharacter, 'xgene_ana_redcarpet', nil, nil, nil],
        :Done
      ]])


    if matched
      replace(matched) {
        branch(variables[:Outfit], :>=, 2) {
          branch(variables[:Outfit], :<, 5) {
            command [:SetMoveRoute, matched.parameters[0], anafixes_transmuteMoveRoute(matched.parameters[1], 'xgene_legacyana_redcarpet')]
          }.else {
            command matched
          }
        }.else {
          command matched
        }
      }
    end
  }
end

def anafixes_hotfix_battyfriends(event)
  event.patch(:anafixes_hotfix_battyfriends) {
    matched = lookForSequence(
      [:ConditionalBranch, :Switch, :Aevia, true],
      :BranchEndConditional,
      [:ConditionalBranch, :Switch, :Ana, true],
      :BranchEndConditional)

    if matched
      swap(*matched)
      # aeviasection = event[event.idxOf(matched[0])..event.idxOf(matched[1])]
      # anasection = event[event.idxOf(matched[2])..event.idxOf(matched[3])]
      # tempMarker = "Temporary Marker"

      # event[event.idxOf(matched[2])..event.idxOf(matched[3])] = [tempMarker]
      # event[event.idxOf(matched[0])..event.idxOf(matched[1])] = anasection
      # event[event.idxOf(tempMarker)..event.idxOf(tempMarker)] = aeviasection
    end
  }

  event.patch(:anafixes_batty_sprites) {
    matched = lookForSequence([:ConditionalBranch, :Switch, :Ana, true])

    if matched
      insertAfter(matched,
          *anafixes_batty_section(3),
          *anafixes_batty_section(4))
    end
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
  page.patch(:anafixes_fix_protagname) {
    labelMatch = lookForSequence(
      [:Label, 'point1'])

    textMatches = lookForAll([:ShowText, /\\v\[701\]/]) +
                  lookForAll([:ShowTextContinued, /\\v\[701\]/])

    if labelMatch
      insertBefore(labelMatch) {
        script '$game_variables[5] = anafixes_provide_protagname'
      }
    end

    for matched in textMatches
      matched[0] = matched.parameters[0].gsub /\\v\[701\]/, '\\v[5]'
    end
  }
end

$cache.trainers.dig(:TRAINER_ANA, "Ana").each do |tr|
  if !tr[4] || tr[4].size == 0
    tr[4] = "..."
  end
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

    # Credit to ZUMI (!!!!) for doing the art for Legacy Ana's Gearen News sprite!
    TextureOverrides::PICTURES + 'GearenNewsLegacyAna' => TextureOverrides::MOD + 'Ana/Legacy/GearenNews',
})

InjectionHelper.defineCommonPatch(23, &method(:anafixes_fix_darchsprite)) # Player Dupe (D)
InjectionHelper.defineCommonPatch(49) { anafixes_inject_special_sprite(self, 'PlayerHeadache_8') } # Player Dupe Distress
InjectionHelper.defineCommonPatch(50) { anafixes_inject_special_sprite(self, 'PlayerKnockedOut_8') } # Player Dupe Knocked
InjectionHelper.defineCommonPatch(136, &method(:anafixes_hotfix_battyfriends)) # Batty Friends

InjectionHelper.defineMapPatch(53, 2) { # I Nightmare Realm, Aevis/Dupe
  anapage = self.pages[1] # if Ana on
  if anapage.graphic.character_name == "BGirlwalk_1"
    alainpage = self.pages[7] # if Alain on
    anafixes_replacewitheyesprite(anapage)
    # Swap them so Ana always runs last, displaying properly
    self.pages[1] = alainpage
    self.pages[7] = anapage
    InjectionHelper.markPatched
  end
}

InjectionHelper.defineMapPatch(99, 77) { |event| # Nightmare School, soul hotel reveal
  event.patch(:anafixes_aelita_comment) { |page|
    matched = page.lookForSequence(
      [:ShowText, "AELITA: Um, \\PN has darkish pink hair,"],
      [:ShowTextContinued, "with mostly black clothing on."],
      [:ShowText, "She's a little shorter than me, and has"],
      [:ShowText, "pinkish-red eyes."])

    if matched
      page.replaceRange(*matched,
        [:ConditionalBranch, :Script, "[2, 3, 4, 66].include?($game_variables[:Outfit])"],
          [:ShowText, "AELITA: Um, \\PN has dark turquoise hair,"],
          [:ShowTextContinued, "and a cute black and purple dress."],
          [:ShowText, "She's a little shorter than me, and has"],
          [:ShowTextContinued, "eyes that look purple or blue depending on the light."],
          [:ShowText, "She's got a neat glowing... bow?"],
          [:ShowTextContinued, "Which doesn't look like fabric, actually..."],
        :Else,
          *matched,
        :Done)
    end
  }
}

InjectionHelper.defineMapPatch(392, 36) { |event| # Chrysalis Mansion, Marianette nickname
  event.patch(:anafixes_marianette_comment) { |page|
    matched = page.lookForSequence(
      [:ShowText, "Hm... I'm sorta blanking on names for you."],
      [:ShowTextContinued, "Your black attire with your pink hair..."])

    if matched
      page.replaceRange(*matched,
        [:ConditionalBranch, :Script, "[2, 3, 4, 66].include?($game_variables[:Outfit])"],
          [:ShowText, "Hm... I'm sorta blanking on names for you."],
          [:ShowTextContinued, "Your black attire with your blue hair and glowy bits..."],
        :Else,
          *matched,
        :Done)
    end
  }
}

InjectionHelper.defineMapPatch(231, 40, 1, &method(:anafixes_fix_protagname)) # Somniam Mall, Melia, Crescent Conversation
InjectionHelper.defineMapPatch(291, 72, &method(:anafixes_addLegacyRedCarpet)) # Pokestar Studios, Red Carpet Event

InjectionHelper.defineMapPatch(-1) {
  patch(:anafixes_gearen_news_sprite) {
    matched = lookForAll([:ShowPicture, nil, /GearenNewsAna(?:_1)?/, nil, nil, nil, nil, nil, nil, nil, nil])

    for insn in matched
      replace(insn) {
        branch("[2, 3, 4, 66].include?($game_variables[:Outfit])") {
          show_picture graphic: 'GearenNewsLegacyAna',
            number: insn.parameters[0],
            origin: insn.parameters[2],
            x: (insn.parameters[3] == 0 ? insn.parameters[4] : variables[insn.parameters[4]]),
            y: (insn.parameters[3] == 0 ? insn.parameters[5] : variables[insn.parameters[5]]),
            zoom_x: insn.parameters[6],
            zoom_y: insn.parameters[7],
            opacity: insn.parameters[8],
            blending: insn.parameters[9]
        }.else {
          command insn
        }
      }
    end
  }
}
