begin
  missing = ['0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

$MISSING_TEXTURE_FOLDER = TextureOverrides::MOD + "MissingTextures/"
$ITEM_REPLACE_FOLDER = TextureOverrides::MOD + "ItemReplace/"

# Based on Caruban's gen 9 compilation
TextureOverrides.registerTextureOverrides({
  TextureOverrides::ICONS + 'rotomphone' => $MISSING_TEXTURE_FOLDER + 'RotomPhone',
  TextureOverrides::ICONS + 'xenwaste' => $MISSING_TEXTURE_FOLDER + 'XenWaste',
  TextureOverrides::ICONS + 'puppetcoin' => $MISSING_TEXTURE_FOLDER + 'PuppetDoubloon',
  TextureOverrides::ICONS + 'glitchmemory' => $MISSING_TEXTURE_FOLDER + 'GlitchMemory',
  TextureOverrides::ICONS + "TM - ???" => $MISSING_TEXTURE_FOLDER + "TM - Glitch",
  TextureOverrides::ICONS + 'phantomcandym' => $MISSING_TEXTURE_FOLDER + 'PhantomCandyM',
  TextureOverrides::ICONS + 'phantomcandys' => $MISSING_TEXTURE_FOLDER + 'PhantomCandyS',
  TextureOverrides::ICONS + "stabilizer" => $MISSING_TEXTURE_FOLDER + "Stabilizer",
  TextureOverrides::ICONS + "nlunarizer" => $MISSING_TEXTURE_FOLDER + "NLunarizer",
  TextureOverrides::ICONS + "nsolarizer" => $MISSING_TEXTURE_FOLDER + "NSolarizer",
  TextureOverrides::ICONS + "prisonbottle" => $MISSING_TEXTURE_FOLDER + "PrisonBottle",
  TextureOverrides::ICONS + "mystblackbox2" => $MISSING_TEXTURE_FOLDER + "MysteriousBox",
  TextureOverrides::ICONS + "blastoisiniteg" => $MISSING_TEXTURE_FOLDER + "BlastoisiniteG",
  TextureOverrides::ICONS + "venusauriteg" => $MISSING_TEXTURE_FOLDER + "VenusauriteG",
  TextureOverrides::ICONS + "rillaboomite" => $MISSING_TEXTURE_FOLDER + "Rillaboomite",
  TextureOverrides::ICONS + "cinderacite" => $MISSING_TEXTURE_FOLDER + "Cinderacite",
  TextureOverrides::ICONS + "inteleonite" => $MISSING_TEXTURE_FOLDER + "Inteleonite",
  TextureOverrides::ICONS + "urshifite" => $MISSING_TEXTURE_FOLDER + "Urshifite",
  TextureOverrides::ICONS + "redgem" => $MISSING_TEXTURE_FOLDER + "RedGem",
  TextureOverrides::ICONS + "hdisk" => $MISSING_TEXTURE_FOLDER + "HDisk",
  TextureOverrides::ICONS + "trainpass" => $MISSING_TEXTURE_FOLDER + "TrainPass",
  TextureOverrides::ICONS + "amberslet" => $MISSING_TEXTURE_FOLDER + "AmbersLetter",
  TextureOverrides::ICONS + "giftcard" => $MISSING_TEXTURE_FOLDER + "ThankYouCard",
  TextureOverrides::ICONS + "concerttck" => $MISSING_TEXTURE_FOLDER + "ConcertTickets",
  TextureOverrides::ICONS + "robocloak" => $MISSING_TEXTURE_FOLDER + "RoboRensCloak",
  TextureOverrides::ICONS + "masterkey" => $MISSING_TEXTURE_FOLDER + "MasterKey",
  TextureOverrides::ICONS + "bellmchn" => $MISSING_TEXTURE_FOLDER + "BellMachine",
  TextureOverrides::ICONS + "datachip" => $MISSING_TEXTURE_FOLDER + "DataDrive",


  TextureOverrides::ICONS + "magstone" => $ITEM_REPLACE_FOLDER + "EarthHeart",
  TextureOverrides::ICONS + "megaring" => $ITEM_REPLACE_FOLDER + "MegaZRing",
  TextureOverrides::ICONS + "gathercube" => $ITEM_REPLACE_FOLDER + "ZygardeCube",
  TextureOverrides::ICONS + "puzzlebox" => $ITEM_REPLACE_FOLDER + "PuzzleBox",
  TextureOverrides::ICONS + "ancientbook" => $ITEM_REPLACE_FOLDER + "AncientBook",
  TextureOverrides::ICONS + "bikev" => $ITEM_REPLACE_FOLDER + "BikeVoucher",
  TextureOverrides::ICONS + "interceptorwish" => $ITEM_REPLACE_FOLDER + "InterceptorWish",
  TextureOverrides::ICONS + "emotionpowder" => $ITEM_REPLACE_FOLDER + "EmotionPowder",
  TextureOverrides::ICONS + "achievementcard" => $ITEM_REPLACE_FOLDER + "AchievementCard",
  TextureOverrides::ICONS + "spuparcel" => $ITEM_REPLACE_FOLDER + "SPUParcel",
  
  # Misc builtin overrides

  # Steel Diamond for better readability
  TextureOverrides::ICONS + 'bosstypeSTEEL' => TextureOverrides::MOD + 'SteelDiamond',

  # Missing Summary ball
  TextureOverrides::SUMMARY + 'summaryballDREAMBALL' => TextureOverrides::MOD + 'Pokeballs/DreamBallSummary',
  # Fix Lure Ball colors
  TextureOverrides::SUMMARY + 'summaryballLUREBALL' => TextureOverrides::MOD + 'Pokeballs/LureBallSummary',
  TextureOverrides::BATTLEICON + 'LUREBALL' => TextureOverrides::MOD + 'Pokeballs/LureBallThrow',
  TextureOverrides::BATTLEICON + 'LUREBALL_open' => TextureOverrides::MOD + 'Pokeballs/LureBallOpen',
  # Fix the misshappen Beast Ball sprites (sprite from Caruban's gen 9 compilation)
  TextureOverrides::SUMMARY + 'summaryballBEASTBALL' => TextureOverrides::MOD + 'Pokeballs/BeastBallSummary',
  TextureOverrides::BATTLEICON + 'BEASTBALL' => TextureOverrides::MOD + 'Pokeballs/BeastBallThrow',
  TextureOverrides::BATTLEICON + 'BEASTBALL_open' => TextureOverrides::MOD + 'Pokeballs/BeastBallOpen',
  # Fix some misshappen/miscolored summary sprites
  TextureOverrides::SUMMARY + 'summaryballMINERALBALL' => TextureOverrides::MOD + 'Pokeballs/MineralBallSummary',
  TextureOverrides::SUMMARY + 'summaryballNETBALL' => TextureOverrides::MOD + 'Pokeballs/NetBallSummary',
  TextureOverrides::SUMMARY + 'summaryballSTEAMBALL' => TextureOverrides::MOD + 'Pokeballs/SteamBallSummary',

  # Fix typos
  TextureOverrides::ICONS + "jynnobikey" => TextureOverrides::ICONS + "lightkey",
  TextureOverrides::ICONS + "blackshard2" => TextureOverrides::ICONS + "blackshard",
  TextureOverrides::ICONS + "blkapricorn" => TextureOverrides::ICONS + "blackapricorn",

  TextureOverrides::CHARS + "trchar117_bike" => TextureOverrides::MOD + 'MissingTextures/ErinRide',
})
