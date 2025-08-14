begin
  missing = ['0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

TextureOverrides.registerTextureOverrides({
  TextureOverrides::SPEECH + "choice 34" => TextureOverrides::SKINS + "choice 34",
  TextureOverrides::SPEECH + "choice rse" => TextureOverrides::SKINS + "choice rse"
})

module MusicSignpostDisplay

  ANIM_ICONS = ["BadMood"]

  LIGHT_ICONS = ["Battle", "Music"]

  ICONS = ["Awakening", "AwakeningBase", "BadMood", "LightBattle", "Battle", "LightMusic", "Music", "Rampage", "Night"]

  MAPPING = {
    "Bad Mood - Club REM Part 2" => "[BadMood] Club REM (Panic)",
    "Bad Mood - Club REM" => "[BadMood] Club REM",
    "Bad Mood - GuiltyOrNah" => "[BadMood] Guilty or Nah?",
    "Bad Mood - Hunt Part 2" => "[BadMood] Hunt Ends",
    "Bad Mood - Hunt" => "[BadMood] Hunt",
    "Bad Mood - The System Binds Us Part 2" => "[BadMood] Axiom Waltz (Storm)",
    "Bad Mood - The System Binds Us" => "[BadMood] Axiom Waltz (Rain)",
    "Battle - Ana's Lament" => "[Battle] Ana's Lament",
    "Battle - Angie" => "[Battle] Angie",
    "Battle - Boss" => "[Battle] Boss",
    "Battle - Club" => "[Battle] Club",
    "Battle - Conclusive_1" => "[Battle] All on the Line",
    "Battle - Conclusive" => "[Battle] Conclusive",
    "Battle - Crowd" => "[Battle] Crowd",
    "Battle - Dimensional Rift" => "[Battle] Dimensional Rift",
    "Battle - End of Night" => "[Battle] End of Night",
    "Battle - Final Duel" => "[Battle] Final Duel",
    "Battle - Final Endeavor" => "[Battle] Final Endeavor",
    "Battle - Flora" => "[Battle] Flora",
    "Battle - Giratina" => "[Battle] Giratina",
    "Battle - Gyms" => "[Battle] Gyms",
    "Battle - Insanity" => "[Battle] Insanity",
    "Battle - Intense" => "[Battle] Intense",
    "Battle - Legendary_1" => "[Battle] VS. Legendary",
    "Battle - Legendary" => "[Battle] Legendary",
    "Battle - Lonely Moon" => "[Battle] Lonely Moon",
    "Battle - Lucile" => "[Battle] Lucile",
    "Battle - Machine" => "[Battle] Machine",
    "Battle - Master of Nightmares (Chiptune)" => "[Battle] Master of Nightmares (Chiptune)",
    "Battle - Master of Nightmares" => "[Battle] Master of Nightmares",
    "Battle - Mini Boss" => "[Battle] Mini Boss",
    "Battle - Monstrosity" => "[Battle] Monstrosity",
    "Battle - Mysterious Figures" => "[Battle] Mysterious Figures",
    "Battle - Nightmare_1" => "[Battle] Night Terror",
    "Battle - Nightmare" => "[Battle] Old Nightmare",
    "Battle - Paradox" => "[Battle] Paradox",
    "Battle - Protector of Aevium" => "[Battle] Protector of Aevium",
    "Battle - Pseudo Contribution" => "[Battle] Pseudo Contribution",
    "Battle - Pseudo Gym" => "[Battle] Pseudo Gym",
    "Battle - Regis" => "[Battle] VS. Regis",
    "Battle - Rival 2" => "[Battle] Rival II",
    "Battle - Rival" => "[Battle] Rival",
    "Battle - Rorrim B." => "[Battle] Rorim B.",
    "Battle - Soul" => "[Battle] Soul",
    "Battle - Space and Time" => "[Battle] Space and Time",
    "Battle - Team Xen_1" => "[Battle] Team Xen (Intense)",
    "Battle - Team Xen" => "[Battle] Team Xen",
    "Battle - Tera" => "[Battle] Tera",
    "Battle - Tournament" => "[Battle] Tournament",
    "Battle - Trainers" => "[Battle] Trainer",
    "Battle - Trainers2" => "[Battle] Trainer II",
    "Battle - Trainers3" => "[Battle] Trainer III",
    "Battle - Xen Executives" => "[Battle] Xen Executives",
    "Battle - XG Rival" => "[Battle] XG Rival",
    "citamginE - gnileeF" => "citamginE - gnileeF [Music] ",
    "Cool and Serene" => "[Music] Cool and Serene",
    "Cryptic Feelings" => "[Music] Cryptic Feelings",
    "Evolution" => "[Music] Evolution",
    "Feeling - Amazing" => "[Music] Feeling - Amazing",
    "Feeling - Attacked Part 2" => "[Music] Feeling - Attacked",
    "Feeling - Attacked" => "[Music] Feeling - Danger",
    "Feeling - Conflict" => "[Music] Feeling - Conflict",
    "Feeling - Dark and Sinister" => "[Music] Feeling - Dark and Sinister",
    "Feeling - Despair" => "[Music] Feeling - Despair",
    "Feeling - Enigmatic" => "[Music] Feeling - Enigmatic",
    "Feeling - Enlightened" => "[Music] Feeling - Enlightened",
    "Feeling - Far Gone" => "[Music] Feeling - Far Gone",
    "Feeling - Frosty" => "[Music] Feeling - Frosty",
    "Feeling - Frozen" => "[Music] Feeling - Frozen",
    "Feeling - Futile" => "[Music] Feeling - Futile",
    "Feeling - Genetic" => "[Music] Feeling - Genetic",
    "Feeling - Hopeful_2" => "[Music] Feeling - Hopeful",
    "Feeling - Hopeful" => "[Music] Feeling - With New Hope",
    "Feeling - Hotheaded" => "[Music] Feeling - Hotheaded",
    "Feeling - Immediate Danger" => "[Music] Feeling - Immediate Danger",
    "Feeling - Inconsistent" => "[Music] Feeling - Inconsistent",
    "Feeling - Lifeless" => "[Music] Feeling - Lifeless",
    "Feeling - Lonely" => "[Music] Feeling - Lonely",
    "Feeling - Lost" => "[Music] Feeling - Lost",
    "Feeling - Magical" => "[Music] Feeling - Magical",
    "Feeling - Magma" => "[Music] Feeling - Magma",
    "Feeling - Miracle_1" => "[Awakening] Feeling - Make a Miracle",
    "Feeling - Miracle" => "[Awakening] Feeling - Miracle",
    "Feeling - Mysterious" => "[Music] Feeling - Mysterious",
    "Feeling - Mysterious2" => "[Music] Feeling - Unnerved",
    "Feeling - New Beginning" => "[Music] Feeling - New Beginning",
    "Feeling - Nostalgic" => "[Music] Feeling - Nostalgic",
    "Feeling - Ominous_2" => "[Music] Feeling - Paranoid",
    "Feeling - Ominous" => "[Music] Feeling - Ominous",
    "Feeling - Onslaught" => "[Music] Feeling - Onslaught",
    "Feeling - Ragged" => "[Music] Feeling - Ragged",
    "Feeling - Rebellious_2" => "[Music] Feeling - That's Enough!",
    "Feeling - Rebellious" => "[Music] Feeling - Rebellious",
    "Feeling - Reflective" => "[Music] Feeling - Reflective",
    "Feeling - Sadness" => "[Music] Feeling - Sadness",
    "Feeling - Sketchy" => "[Music] Feeling - Sketchy",
    "Feeling - Suspicious" => "[Music] Feeling - Suspicious",
    "Feeling - Tension" => "[Music] Feeling - Tension",
    "Feeling - Tricky" => "[Music] Feeling - Tricky",
    "Feeling - Tropical" => "[Music] Feeling - Tropical",
    "Feeling - Unsettled" => "[Music] Feeling - Unsettled",
    "Feeling - Unwavering Hope" => "[Music] Feeling - Unwavering Hope",
    "Feeling - Utter Despair" => "[Music] Feeling - Utter Despair",
    "Feeling - Utter Despair2" => "[Music] Feeling - Absolute Despair",
    "Feeling - Wacky" => "[Music] Feeling - Wacky",
    "Feeling - Winter Is Coming" => "[Music] Feeling - Winter Is Coming",
    "Feeling - yeehaw" => "[Music] Feeling - yeehaw",
    "Fighting for Victory_1" => "[Music] Fighting for Victory",
    "Fighting for Victory" => "[Music] Fighting for Victory (Classic)",
    "Fighting for What's Right" => "[Music] Fighting for What's Right",
    "GDC - City of Dreams" => "[Music] City of Dreams",
    "GDC - City of Dreamsn" => "[Music][Night] City of Dreams",
    "Gearen News!" => "[Music] Gearen News!",
    "GSC - Gym Leader" => "\\gsc[Battle] Gym Leader",
    "GSC - New Bark Town" => "\\gsc[Music] New Bark Town",
    "GSC - Queen Alice" => "\\gsc[Music] Queen Alice",
    "GSC - Trouble" => "\\gsc[Music] Trouble",
    "Gym Battle Victory GS" => "\\gsc[Music] Gym Battle Victory",
    "Gym Battle Victory" => "[Music] Gym Battle Victory",
    "Her_Awakening_1" => "[AwakeningBase] Her Awakening",
    "Her_Awakening_2" => "[Awakening] <c3=F8C471,8a461e>Her Awakening</c3>",
    "It Changes" => "[Awakening] It Changes",
    "Keep Marching on!" => "[Music] Keep Marching On!",
    "Melia's Theme" => "[Music] Melia's Theme",
    "Mood - Breakthrough" => "[Music] Mood - Breakthrough",
    "Mood - Calming" => "[Music] Mood - Calming",
    "Mood - Carnival" => "[Music] Mood - Carnival",
    "Mood - Chaos" => "[Music] Mood - Chaos",
    "Mood - Coffee" => "[Music] Mood - Coffee",
    "Mood - Comeback_1" => "[Music] Mood - We're Not Finished",
    "Mood - Comeback" => "[Music] Mood - Comeback",
    "Mood - Conniving" => "[Music] Mood - Conniving",
    "Mood - Craggy" => "[Music] Mood - Craggy",
    "Mood - Dangerous Cave" => "[Music] Mood - Dangerous Cave",
    "Mood - Dark City" => "[Music] Mood - Dark City",
    "Mood - Departure" => "[Music] Mood - Departure",
    "Mood - Desert Chamber" => "[Music] Mood - Desert Chamber",
    "Mood - Determination!" => "[Music] Mood - Determination!",
    "Mood - Disaster_1" => "[Music] Mood - Disaster",
    "Mood - Disaster" => "[Music] Mood - Scene of a Disaster",
    "Mood - Distressed" => "[Music] Mood - Distressed",
    "Mood - Encounter" => "[Music] Mood - Encounter",
    "Mood - Gamble" => "[Music] Mood - Gamble",
    "Mood - Happy" => "[Music] Mood - Happy",
    "Mood - Hope For Everyone" => "[Music] Mood - Hope For Everyone",
    "Mood - Hypnotic Battle" => "[Music] Mood - Hypnotic Battle",
    "Mood - Infiltration" => "[Music] Mood - Infiltration",
    "Mood - Intense" => "[Music] Mood - Intense",
    "Mood - Legendary" => "[Music] Mood - Legendary",
    "Mood - Mystery" => "[Music] Mood - Mystery",
    "Mood - Mystic" => "[Music] Mood - Mystic",
    "Mood - Mystical" => "[Music] Mood - Mystical",
    "Mood - Peaceful" => "[Music] Mood - Peaceful",
    "Mood - Really..." => "[Music] Mood - Really...",
    "Mood - Revelation" => "[Music] Mood - Revelation",
    "Mood - Rise Up" => "[Music] Mood - Rise Up",
    "Mood - Ritual" => "[Music] Mood - Ritual",
    "Mood - Rivalry" => "\\gsc[Music] Mood - Rivalry",
    "Mood - Royal" => "[Music] Mood - Royal",
    "Mood - Ruins_1" => "[Music] Mood - Jungle Ruins",
    "Mood - Ruins" => "[Music] Mood - Ruins",
    "Mood - Sanctuary" => "[Music] Mood - Sanctuary",
    "Mood - Sandy" => "[Music] Mood - Sandy",
    "Mood - Seashore Panic" => "[Music] Mood - Seashore Panic",
    "Mood - Set Out" => "[Music] Mood - Set Out",
    "Mood - Shopaholic" => "[Music] Mood - Shopaholic",
    "Mood - Sinister" => "[Music] Mood - Sinister",
    "Mood - Stardom" => "[Music] Mood - Stardom",
    "Mood - Teamwork_1" => "[Music] Mood - All Together Now!",
    "Mood - Teamwork_2" => "[Music] Mood - Absolute Trust",
    "Mood - Teamwork" => "[Music] Mood - Teamwork",
    "Mood - Technical_1" => "[Music] Mood - Technical",
    "Mood - That's right" => "[Music] Mood - That's right",
    "Mood - The Bog" => "[Music] Mood - The Bog",
    "Mood - Tower" => "[Music] Mood - Tower",
    "Mood - Triumphant" => "[Music] Mood - Triumphant",
    "Mood - Tropical" => "[Music] Mood - Tropical",
    "Mood - Truth" => "[Awakening] Mood - Truth",
    "Mood - Village_1" => "[Music] Mood - Goom!", # Goomidra music
    "Mood - Village" => "[Music] Mood - Village",
    "Music - 3rd Heaven" => "[Awakening] ARCHETYPE Third Heaven",
    "Music - 3rd HQ" => "[Awakening] ARCHETYPE Third HQ",
    "Music - Akuwa Town_1" => "[Music] By the Coast",
    "Music - Akuwa Town" => "[Music] Sayonara",
    "Music - Alamissa Urben" => "[Music] What's Been Lost",
    "Music - Angie's Manor" => "[Music] Angie's Manor",
    "Music - AtebitWorld_1" => "\\gsc[Music] Atebit Dread",
    "Music - AtebitWorld" => "\\gsc[Music] Atebit World",
    "Music - BestieBeatdown_1" => "[Music] Bestie Beatdown II",
    "Music - BestieBeatdown" => "[Music] Bestie Beatdown",
    "Music - Bike" => "[Music] Bike",
    "Music - Bladestar Base" => "[Music] Bladestar Base",
    "Music - Celandine City" => "[Music] Celandine City",
    "Music - choo choo! CHOO CHOO" => "[Music] choo choo! CHOO CHOO",
    "Music - Crescent Appears" => "[Awakening] Crescent Appears",
    "Music - Darchlight Escape" => "[Music] Darchlight Escape",
    "Music - Darchlight Woods" => "[Music] Darchlight Woods",
    "Music - Desert Town" => "[Music] Desert Town",
    "Music - Desert" => "[Music] Desert",
    "Music - Despair Desert" => "[Music] Despair Desert",
    "Music - Dive(m)" => "[Music] Dive",
    "Music - Enemy Base" => "[Music] Enemy Base",
    "Music - Festival" => "[Music] Festival",
    "Music - Forest of Time" => "[Music] Forest of Time",
    "Music - Garden" => "[Music] Garden",
    "Music - Garufa Inc" => "[Awakening] Garufa Inc.",
    "Music - Gates" => "[Music] Gates",
    "Music - Goldenleaf" => "[Music] Goldenleaf",
    "Music - Guitar" => "[Music] Guitar",
    "Music - Hang Out_1" => "[Music] Hang Out",
    "Music - Hang Out" => "[Music] Together",
    "Music - I'm Aelita" => "[Music] Enduring Legacy", # Copied from my WLL rename
    "Music - Investigative" => "[Music] Investigative",
    "Music - Jungle_1" => "[Music] Jungle Beats",
    "Music - Jungle_2" => "[Music] Jungle Vibes",
    "Music - Jungle" => "[Music] Deep Jungle",
    "Music - Jynnobi" => "[Music] Jynnobi",
    "Music - Kakori Village" => "[Music] Kakori Village",
    "Music - Marine Tube" => "[Music] Marine Tube",
    "Music - My Memories With Precious Friends" => "[Music] My Memories With Precious Friends",
    "Music - Neo Gearen City" => "[Music] Neo Gearen City",
    "Music - News HQ" => "[Music] News HQ",
    "Music - Nightmare Realm" => "[Music] I Don't Understand...",
    "Music - Nightmare Realm2" => "[Music] On Your Guard...",
    "Music - Nightmare Realm3" => "[Music] This Can't Be Right...",
    "Music - Nightmare School" => "[Music] School of Nightmares",
    "Music - Nostalgia Reborn" => "[Music] Nostalgia Reborn",
    "Music - Phone Call" => "[Music] Phone Call",
    "Music - PKMN Centers" => "[Music] PKMN Centers",
    "Music - PKMN Centersn" => "[Music][Night] PKMN Centers",
    "Music - Pokeflute" => "[Music] Pokeflute",
    "Music - RAMPAGE" => "[Rampage] <outln2><c3=EC7063,7B241C>RAMPAGE!</c3></outln2>",
    "Music - Relic Song" => "[Music] Relic Song",
    "Music - Reservoir" => "[Music] Reservoir",
    "Music - Reservoirn" => "[Music][Night] Reservoir",
    "Music - Rigid Annihilation" => "[Music] Rigid Annihilation",
    "Music - Route 2" => "[Music] Cherry Blossoms",
    "Music - Route 3" => "[Music] Riverside Stroll",
    "Music - Route 6" => "[Music] Path to the Peak",
    "Music - Route 7" => "[Music] Untamed Wilderness",
    "Music - Route 9" => "[Music] Autumn Stroll",
    "Music - Saki's Hijinx" => "[Music] Saki's Hijinx",
    "Music - Savior" => "[Music] Savior",
    "Music - Song of The Faithful" => "[Music] Song of The Faithful",
    "Music - Space-Time Distortion" => "[Music] Space-Time Distortion",
    "Music - Story of The Ancients_1" => "[Awakening] Story of The Ancients II",
    "Music - Story of The Ancients" => "[Awakening] Story of The Ancients",
    "Music - Struggle_1" => "[Music] Defeat Is Not an Option",
    "Music - Struggle" => "[Music] Struggle",
    "Music - Surf" => "[Music] Surf",
    "Music - Taelia" => "[Music] Taelia",
    "Music - Target Acquired" => "[Music] Target Acquired",
    "Music - Teila Resort" => "[Music] Teila Resort",
    "Music - Temple" => "[Music] Temple",
    "Music - Terajuma Jungle" => "[Music] Terajuma Jungle",
    "Music - The Lounge_1" => "[Music] The Lounge?!",
    "Music - The Lounge" => "[Music] The Lounge",
    "Music - The Play's Right" => "[Music] The Play's Right",
    "Music - The Under" => "[Music] The Under",
    "Music - Third Layer" => "[Awakening] Third Layer",
    "Music - Tournament" => "[Music] Tournament",
    "Music - Unown" => "\\gsc[Music] Unown",
    "Music - Valor Mountain" => "[Music] Valor Mountain",
    "Music - Voidlands" => "[Music] Voidlands",
    "Music - Wispy Path" => "[Music] Wispy Path",
    "Music - Wispy Tower" => "[Music] Wispy Tower",
    "Music - Xen Antics" => "[Music] Xen Antics",
    "Music - Xen Base" => "[Music] Xen Base",
    "Music - Xen HQ" => "[Music] Xen HQ",
    "Music - Xenogene" => "[Music] Dreaded Nightmare", # Dunno why this is called xenogene tbh.
    "Music - Zone Zero" => "[Music] Zone Zero",
    "Rejuvenation - ..." => "[Awakening] Painful Truth...?",
    "Rejuvenation - Title Screen_2" => "[Awakening] Dreaded Truth",
    "Rejuvenation - Title Screen" => "[Awakening] Painful Truth",
    "Roxie - Doggars!" => "[Music] Roxie - Doggars!",
    "RSE - Battle Deoxys" => "\\rse[Battle] VS. Deoxys",
    "RSE - Battle Regis" => "\\rse[Battle] VS. Regis",
    "RSE - Battle" => "\\rse[Battle] Battle",
    "RSE - BattlePike" => "\\rse[Music] Battle Pike",
    "RSE - Enemy Battle" => "\\rse[Music] Enemy Battle",
    "RSE - Fallarbor Town" => "\\rse[Music] Fallarbor Town",
    "RSE - H-Help!" => "\\rse[Music] H-Help!",
    "RSE - Lilycove City" => "\\rse[Music] Lilycove City",
    "RSE - Museum" => "\\rse[Music] Museum",
    "RSE - Petalburg Woods" => "\\rse[Music] Petalburg Woods",
    "RSE - Poke Center" => "\\rse[Music] Poke Center",
    "RSE - Poke Mart" => "\\rse[Music] Poke Mart",
    "RSE - Route 101" => "\\rse[Music] Route 101",
    "RSE - Route120" => "\\rse[Music] Route 120",
    "RSE - Rustboro City" => "\\rse[Music] Rustboro City",
    "RSE - Surf" => "\\rse[Music] Surf",
    "RSE - Verdanturf Town" => "\\rse[Music] Verdanturf Town",
    "Stop! Thief!" => "\\rse[Music] Stop! Thief!",
    "Team Player" => "[Music] Team Player",
    "Time to Party!" => "[Music] Time to Party",
    "Venam's Theme" => "[Music] Venam's Theme",
    "Victory - RSE!" => "\\rse[Music] Victory!",
    "Victory! - RSETRAINER!" => "\\rse[Music] Trainer - Victory!",
    "Victory! - Tera" => "[Music] Tera - Victory!",
    "Victory!" => "[Music] Victory!",
    "Wild Battle - Badlands" => "[Battle] Wild - Badlands",
    "Wild Battle - Gen 2" => "\\gsc[Battle] Wild",
    "Wild Battle - Regular" => "[Battle] Wild",
    "Wild Battle - RSE" => "\\rse[Battle] Wild",
    "Wild Battle - Terajuma" => "[Battle] Wild - Terajuma",
    "Wild Battle - Terrial" => "[Battle] Wild - Terrial",
    "WMute" => ""
  }

  @@lastText = ''

  @@lastTrackDisplayed = nil
  @@storedInfo = nil
  @@disabled = false

  def self.ensureBox
    if !defined?(@@displaybox) || @@displaybox.contents.disposed?
      @@displaybox = SignpostWindow.new
      positionBox
    end
  end

  def self.visibleBox
    @@displaybox.visible = !!(@@displaybox.text != '' && $game_system.playing_bgm && !@@disabled &&
      !($game_system.message_position == 0 && $game_temp.message_window_showing))
  end

  def self.positionBox

    @@displaybox.resizeToFit(@@displaybox.text,Graphics.width)
    # Style: bottom corner
    # @@displaybox.x = 0
    # @@displaybox.y = (Graphics.height - @@displaybox.height) * 2 # * 2 because of zoom
    # @@displaybox.y -= 3*32 * 2 if $game_temp.message_window_showing # * 2 because of zoom

    # Style: top middle
    @@displaybox.x = Graphics.width - (@@displaybox.width/2) # No divide by 2 because of zoom
    @@displaybox.y = -4
    @@displaybox.z = 100000
  end

  def self.frameUpdate
    @@displaybox.update if defined?(@@displaybox) && @@displaybox && @@displaybox.animated_icons.size > 0
  end

  def self.updateMusic(createBox=true)
    return if !createBox && (!defined?(@@displaybox) || @@displaybox.contents.disposed?)

    ensureBox
    visibleBox
    frameUpdate
    if $game_system.defaultBGM || $game_system.playing_bgm
      musicCurrent, animicons = msg($game_system.defaultBGM || $game_system.playing_bgm)
      if musicCurrent.nil?
        @@displaybox.visible = false
      elsif @@lastText != musicCurrent
        @@lastText = musicCurrent

        gsc = musicCurrent.start_with?("\\gsc")
        rse = musicCurrent.start_with?("\\rse")
        @@displaybox.setSkin("Graphics/Windowskins/choice 34") if gsc
        @@displaybox.setSkin("Graphics/Windowskins/choice rse") if rse
        @@displaybox.setSkin("Graphics/Windowskins/choice 1") if !gsc && !rse
        musicCurrent = musicCurrent.gsub(/^\\(gsc|rse)/, '') if gsc || rse
        musicCurrent, animicons = adjustForMode(@@displaybox, musicCurrent, animicons)
        @@displaybox.text=musicCurrent
        @@displaybox.animated_icons=animicons
        positionBox
        visibleBox
      end
    end
  end

  def self.adjustForMode(window, trackName, animicons)
    if !isDarkWindowskin(window.windowskin)
      for replacement in MusicSignpostDisplay::LIGHT_ICONS
        icon = "Light#{replacement}"
        trackName.gsub!("<img=#{pbResolveBitmap("#{__dir__[Dir.pwd.length+1..]}/MusicTypes/#{replacement}")}>",
          "<img=#{pbResolveBitmap("#{__dir__[Dir.pwd.length+1..]}/MusicTypes/#{icon}")}>")
        if MusicSignpostDisplay::ANIM_ICONS.include?(replacement)
          animicons.delete(replacement)
        end
        if MusicSignpostDisplay::ANIM_ICONS.include?(icon)
          animicons.push(icon) unless animicons.include?(icon)
        end
      end
    end

    colors=getDefaultTextColors(window.windowskin)
    window.baseColor=colors[0]
    window.shadowColor=colors[1]

    return trackName, animicons
  end

  def self.naiveNameForMusic(trackName)
    trackName.gsub! /^(Music|Battle) -/, "[\1]"
    trackName.gsub! /^Bad Mood -/, "[BadMood]"
    trackName = "[Music] #{trackName}" unless trackName[/\[\w+\]/]
    return trackName
  end

  def self.msg(track)
    animicons = []
    trackName = MusicSignpostDisplay::MAPPING[track.name.gsub(/\.(ogg|mp3)$/, '')].clone
    return nil if trackName == ""
    trackName = naiveNameForMusic(track.name.clone) if trackName.nil?
    for icon in MusicSignpostDisplay::ICONS
      if trackName.include?("[#{icon}]")
        trackName.gsub!("[#{icon}]", "<img=#{pbResolveBitmap("#{__dir__[Dir.pwd.length+1..]}/MusicTypes/#{icon}")}>")
        if MusicSignpostDisplay::ANIM_ICONS.include?(icon)
          animicons.push(icon) unless animicons.include?(icon)
        end
      end
    end

    return trackName, animicons
  end


  def self.playSignpost(track)
    if !@@lastTrackDisplayed.nil? && @@lastTrackDisplayed.name == track.name
      return
    end
    @@lastTrackDisplayed = track
    @@signpostWaiting = track
  end

  def self.disabled=(value)
    @@disabled = value
  end
  def self.lastTrackDisplayed=(value)
    @@lastTrackDisplayed = value
  end


  class SignpostWindow < Window_AdvancedTextPokemon

    attr_reader :animated_icons

    def initialize(text="")
      @animated_icons = {}
      super(text)
      self.zoom_y = 0.5
      self.zoom_x = 0.5
      self.opacity = 200
      @frame = 0
      @subframe = 0
    end

    def dispose
      super
      self.animated_icons.each_value {|icon| icon.dispose }
    end

    def animated_icons=(value)
      @animated_icons = {}
      for icon in value
        @animated_icons["#{__dir__[Dir.pwd.length+1..]}/MusicTypes/#{icon}"] = AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/MusicTypes/#{icon}Anim")
      end
    end

    def update
      return if self.contents.disposed?

      if self.animated_icons.size > 0
        @subframe += 1
        if @subframe >= Graphics.frame_rate / 40
          @frame += 1
          @subframe = 0
        end

        if @frame % 10 == 0
          refresh
          return
        end
      end
      super
    end

    def refresh
      super
      if self.animated_icons.size > 0
        for chr in @fmtchars
          for key, icon in self.animated_icons
            if chr[5] && chr[0] == pbResolveBitmap(key)
              chrrect = chr[15]
              framecount = icon.width / chrrect.width
              frameidx = (@frame / 10) % framecount
              self.contents.blt(chr[1], chr[2], icon.bitmap, Rect.new(frameidx * chrrect.width, 0, chrrect.width, chrrect.height), chr[8].alpha)
            end
          end
        end
      end
    end

    def resizeToFitInternal(text,maxwidth)
      dims=[0,0]
      cwidth=maxwidth<0 ? Graphics.width : maxwidth
      chars=getFormattedTextForDims(self.contents,0,0,
         cwidth-self.borderX-2-6,-1,text,@lineHeight,true)
      ### MODDED/
      chars.delete_at(-1) if chars.size > 0 && chars[-1][0] == ' '
      ### /MODDED
      for ch in chars
        dims[0]=[dims[0],ch[1]+ch[3]].max
        dims[1]=[dims[1],ch[2]+ch[4]].max
      end
      return dims
    end
  end
end

class Game_System
  attr_reader :defaultBGM

  alias :musicSignpost_old_bgm_play :bgm_play

  def bgm_play(bgm)
    oldPlaying = @playing_bgm
    ret = musicSignpost_old_bgm_play(bgm)
    @playing_bgm = oldPlaying if bgm && !FileTest.audio_exist?("Audio/BGM/"+ bgm.name)

    MusicSignpostDisplay.playSignpost(bgm) if bgm
    MusicSignpostDisplay.updateMusic(false) if bgm
    return ret
  end

  alias :musicSignpost_old_bgm_pause :bgm_pause

  def bgm_pause(fadetime=0.0)
    ret = musicSignpost_old_bgm_pause(fadetime)
    MusicSignpostDisplay.lastTrackDisplayed = nil
    MusicSignpostDisplay.updateMusic(false)
    return ret
  end

  alias :musicSignpost_old_bgm_resume :bgm_resume

  def bgm_resume(bgm,position=nil)
    ret = musicSignpost_old_bgm_resume(bgm,position)
    MusicSignpostDisplay.playSignpost(bgm) if bgm
    MusicSignpostDisplay.updateMusic(false) if bgm
    return ret
  end
end

class PokeBattle_Battle
  alias :musicSignpost_old_pbSendOut :pbSendOut
  alias :musicSignpost_old_pbEndOfBattle :pbEndOfBattle

  def pbSendOut(*args, **kwargs)
    MusicSignpostDisplay.disabled = @doublebattle
    MusicSignpostDisplay.ensureBox
    MusicSignpostDisplay.visibleBox
    return musicSignpost_old_pbSendOut(*args, **kwargs)
  end
  def pbEndOfBattle(*args, **kwargs)
    MusicSignpostDisplay.disabled = false
    MusicSignpostDisplay.ensureBox
    MusicSignpostDisplay.visibleBox
    return musicSignpost_old_pbEndOfBattle(*args, **kwargs)
  end
end

class Game_Screen
  alias :musicSignpost_old_update :update

  def update(*args, **kwargs)
    MusicSignpostDisplay.updateMusic
    return musicSignpost_old_update(*args, **kwargs)
  end
end

alias :musicSignpost_old_pbUpdateSpriteHash :pbUpdateSpriteHash

def pbUpdateSpriteHash(windows)
  if $scene && !$scene.is_a?(Scene_Map)
    MusicSignpostDisplay.frameUpdate
  end
  return musicSignpost_old_pbUpdateSpriteHash(windows)
end


