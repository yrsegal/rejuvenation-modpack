begin
  missing = ['0000.textures.rb', 'TextureOverrides'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

TextureOverrides.registerTextureOverrides({
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
