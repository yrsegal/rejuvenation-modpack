begin
  missing = ['0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

$WOOP_TEXTURE_FOLDER = TextureOverrides::MODBASE + "Woop/"

# Credit to @1moonn_ (Buck) on discord for creating the original sprites!
TextureOverrides.registerTextureOverrides({
  TextureOverrides::BATTLER + "194"  => $WOOP_TEXTURE_FOLDER + "WoopM",
  TextureOverrides::BATTLER + "194f" => $WOOP_TEXTURE_FOLDER + "WoopF",
  TextureOverrides::BATTLER + "194Egg" => $WOOP_TEXTURE_FOLDER + "WoopEggM",
  TextureOverrides::BATTLER + "194fEgg" => $WOOP_TEXTURE_FOLDER + "WoopEggF",
  TextureOverrides::BATTLER + "195" => $WOOP_TEXTURE_FOLDER + "QuagM",
  TextureOverrides::BATTLER + "195f" => $WOOP_TEXTURE_FOLDER + "QuagF",

  TextureOverrides::ICONS + "icon194" => $WOOP_TEXTURE_FOLDER + "WoopIconM",
  TextureOverrides::ICONS + "icon194f" => $WOOP_TEXTURE_FOLDER + "WoopIconF",
  TextureOverrides::ICONS + "icon194egg" => $WOOP_TEXTURE_FOLDER + "WoopEggIconM",
  TextureOverrides::ICONS + "icon194fegg" => $WOOP_TEXTURE_FOLDER + "WoopEggIconF",
  TextureOverrides::ICONS + "icon195" => $WOOP_TEXTURE_FOLDER + "QuagIconM",
  TextureOverrides::ICONS + "icon195f" => $WOOP_TEXTURE_FOLDER + "QuagIconF",
})
