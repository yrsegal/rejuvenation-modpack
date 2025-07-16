TextureOverrides.registerTrainerClass(:CANDIDGIRLDARCH, {
  :title => "Candid Girl",
  :trainerID => 63932,
  :skill => 100,
  :moneymult => 15,
  :battleBGM => "Battle - Rival.mp3",
  :winBGM => "Gym Battle Victory.mp3",
  :replacements => {
    TextureOverrides::CHARS + 'trBack{ID}' => TextureOverrides::MOD + 'Darch/ErinBack'
  }
})

# This is the only time Florin is a battle partner, so we can replace the base sprite)
TextureOverrides.registerTextureOverride(TextureOverrides::CHARS + 'trBack144', TextureOverrides::MOD + 'Darch/FlorinBack')

TextureOverrides.replaceTrainerClass("Erin", :CANDIDGIRL, 0,
  newTrainerClass: :CANDIDGIRLDARCH)
