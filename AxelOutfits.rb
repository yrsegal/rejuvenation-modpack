begin
  missing = ['0000.injection.rb', '0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

# credit to @necrollo on discord for making the original sprites!

Variables[:Outfit] = 259

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
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      this.set_move_route {
        set_character 'BattyFriends_Axel_' + outfit.to_s
      }
      jump_label 'done'
    }
  }
end


def darchaxel_special_sprite_section(special, outfit, outfitname = outfit)
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      branch(switches[:Axel], true) {
        this.set_move_route {
          set_character special + '_' + outfitname.to_s
        }
        jump_label 'End'
      }
    }
  }
end

# Injections

def darchaxel_inject_special_sprite(event, special)
  event.patch(:darchaxel_inject_special_sprite) {
    matched = lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :==])

    if matched
      insertBefore(matched,
        *darchaxel_special_sprite_section(special, 3, 'int'),
        *darchaxel_special_sprite_section(special, 4))
    end
  }
end

def darchaxel_hotfix_battyfriends(event)
  event.patch(:darchaxel_batty_sprites) {
    matched = lookForSequence([:ConditionalBranch, :Switch, :Axel, true])

    if matched
      insertAfter(matched,
          *darchaxel_batty_section(3),
          *darchaxel_batty_section(4))
    end
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
    TextureOverrides::CHARS + 'BattyFriends_Axel_4' => TextureOverrides::MOD + 'Axel/Darch/BattyFriends',

    TextureOverrides::CHARS + 'boy_bike2_3' => TextureOverrides::MOD + 'Axel/Interceptor/Bike',
    TextureOverrides::CHARS + 'boy_surf_offset2_3' => TextureOverrides::MOD + 'Axel/Interceptor/Surf',
    TextureOverrides::CHARS + 'boy_fish_offset2_3' => TextureOverrides::MOD + 'Axel/Interceptor/Fish',
    TextureOverrides::CHARS + 'boy_fishsurf_offset2_3' => TextureOverrides::MOD + 'Axel/Interceptor/SurfFish',
    TextureOverrides::CHARS + 'boy_dive2_3' => TextureOverrides::MOD + 'Axel/Interceptor/Dive',
    TextureOverrides::CHARS + 'trchar004_3' => TextureOverrides::MOD + 'Axel/Interceptor/Walk',
    TextureOverrides::CHARS + 'Boy_Run2_3' => TextureOverrides::MOD + 'Axel/Interceptor/Run',
    TextureOverrides::CHARS + 'Trainer004_3' => TextureOverrides::MOD + 'Axel/Interceptor/Trainer',
    TextureOverrides::MAP + 'mapPlayer004_3' => TextureOverrides::MOD + 'Axel/Interceptor/MapHead',
    TextureOverrides::VS + 'vsTrainer4_3' => TextureOverrides::MOD + 'Axel/Interceptor/VS',
    TextureOverrides::CHARS + 'PlayerHeadache_4_int' => TextureOverrides::MOD + 'Axel/Interceptor/Headache',
    TextureOverrides::CHARS + 'PlayerKnockedOut_4_int' => TextureOverrides::MOD + 'Axel/Interceptor/KO',
    TextureOverrides::CHARS + 'BattyFriends_Axel_3' => TextureOverrides::MOD + 'Axel/Interceptor/BattyFriends'
})

InjectionHelper.defineCommonPatch(49) { darchaxel_inject_special_sprite(self, 'PlayerHeadache_4') } # Player Dupe Distress
InjectionHelper.defineCommonPatch(50) { darchaxel_inject_special_sprite(self, 'PlayerKnockedOut_4') } # Player Dupe Knocked
InjectionHelper.defineCommonPatch(136, &method(:darchaxel_hotfix_battyfriends)) # Batty Friends
