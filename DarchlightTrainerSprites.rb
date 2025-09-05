begin
  missing = ['0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

TextureOverrides.registerTrainerClass(:CANDIDGIRLDARCH, {
  title: "Candid Girl",
  trainerID: 63932,
  skill: 100,
  moneymult: 15,
  battleBGM: "Battle - Rival.mp3",
  winBGM: "Gym Battle Victory.mp3",
  replacements: {
    TextureOverrides::CHARS + 'trBack{ID}' => TextureOverrides::MOD + 'Darch/ErinBack'
  }
})

# This is the only time Florin is a battle partner, so we can replace the base sprite)
TextureOverrides.registerTextureOverride(TextureOverrides::CHARS + 'trBack144', TextureOverrides::MOD + 'Darch/FlorinBack')

TextureOverrides.replaceTrainerClass("Erin", :CANDIDGIRL, 0,
  newTrainerClass: :CANDIDGIRLDARCH)
