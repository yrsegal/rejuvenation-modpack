begin
  missing = ['0000.injection.rb', '0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

# credit to @necrollo on discord for making the original sprites!

Variables[:Outfit] = 259

def darchaxel_makeMoveRoute(graphic, direction = :Up)
  return [
    false,
    [:SetCharacter, graphic, 0, direction, 0],
    :Done
  ]
end

def darchaxel_transmuteMoveRoute(prevRoute, replaceGraphic)
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

def darchaxel_batty_section(outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:SetMoveRoute, :This, darchaxel_makeMoveRoute('BattyFriends_Axel_' + outfit.to_s, :Down)],
      [:JumpToLabel, 'done'],
    :Done
  ]
end


def darchaxel_special_sprite_section(special, outfit)
  return [
    [:ConditionalBranch, :Variable, :Outfit, :Constant, outfit, :Equals],
      [:ConditionalBranch, :Switch, :Axel, true],
        [:SetMoveRoute, :This, darchaxel_makeMoveRoute(special + '_' + outfit.to_s, :Down)],
        [:JumpToLabel, 'End'],
      :Done,
    :Done
  ]
end

# Injections

def darchaxel_inject_special_sprite(event, special)
  event.patch(:darchaxel_inject_special_sprite) {
    matched = event.lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :Equals])

    if matched
      event.insertBefore(matched,
        *darchaxel_special_sprite_section(special, 3),
        *darchaxel_special_sprite_section(special, 4))
    end
    next matched
  }
end

def darchaxel_hotfix_battyfriends(event)
  event.patch(:darchaxel_batty_sprites) {
    matched = event.lookForSequence([:ConditionalBranch, :Switch, :Axel, true])

    if matched
      event.insertAfter(matched,
          *darchaxel_batty_section(3),
          *darchaxel_batty_section(4))
    end
    next matched
  }
end

TextureOverrides.registerTextureOverrides({
    TextureOverrides::CHARS + 'boy_bike2_4' => TextureOverrides::MOD + 'Axel/Darch/Bike',
    TextureOverrides::CHARS + 'boy_surf_offset2_4' => TextureOverrides::MOD + 'Axel/Darch/Surf',
    TextureOverrides::CHARS + 'boy_fish_offset2_4' => TextureOverrides::MOD + 'Axel/Darch/Fish',
    TextureOverrides::CHARS + 'boy_fishsurf_offset2_4' => TextureOverrides::MOD + 'Axel/Darch/SurfFish',
    TextureOverrides::CHARS + 'boy_dive2_4' => TextureOverrides::MOD + 'Axel/Darch/Dive',
    TextureOverrides::CHARS + 'trchar004_4' => TextureOverrides::MOD + 'Axel/Darch/Walk',
    TextureOverrides::CHARS + 'Boy_Run2_4' => TextureOverrides::MOD + 'Axel/Darch/Run',
    TextureOverrides::CHARS + 'Trainer004_4' => TextureOverrides::MOD + 'Axel/Darch/Trainer',
    TextureOverrides::CHARS + 'trBack004_4' => TextureOverrides::MOD + 'Axel/Darch/TrainerBack',
    TextureOverrides::MAP + 'mapPlayer004_4' => TextureOverrides::MOD + 'Axel/Darch/MapHead',
    TextureOverrides::VS + 'vsTrainer4_4' => TextureOverrides::MOD + 'Axel/Darch/VS',
    TextureOverrides::CHARS + 'PlayerHeadache_4_4' => TextureOverrides::MOD + 'Axel/Darch/Headache',
    TextureOverrides::CHARS + 'PlayerKnockedOut_4_4' => TextureOverrides::MOD + 'Axel/Darch/KO',
    TextureOverrides::CHARS + 'BattyFriends_Axel_4' => TextureOverrides::MOD + 'Axel/Darch/BattyFriends'
})

InjectionHelper.defineCommonPatch(49) { |event| darchaxel_inject_special_sprite(event, 'PlayerHeadache_4') } # Player Dupe Distress
InjectionHelper.defineCommonPatch(50) { |event| darchaxel_inject_special_sprite(event, 'PlayerKnockedOut_4') } # Player Dupe Knocked
InjectionHelper.defineCommonPatch(136, &method(:darchaxel_hotfix_battyfriends)) # Batty Friends
