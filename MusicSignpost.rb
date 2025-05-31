
$musicSignpost_lastTrackDisplayed = nil
$musicSignpost_signpostWaiting = nil
$musicSignpost_transitioning = false
$musicSignpost_storedInfo = nil

class Scene_Map
  attr_reader :spritesets
end
class Spriteset_Map
  attr_reader :usersprites
end
class LocationWindow
  attr_reader :window
  attr_reader :frames
end

MUSIC_SIGNPOST_ICONS = ["Awakening", "BadMusic", "Battle", "GSCMusic", "Music"]

MUSIC_SIGNPOST_MAPPING = {
  "Bad Mood - Club REM Part 2" => "[BadMusic] Club REM (Panic)",
  "Bad Mood - Club REM" => "[BadMusic] Club REM",
  "Bad Mood - GuiltyOrNah" => "[BadMusic] GuiltyOrNah",
  "Bad Mood - Hunt Part 2" => "[BadMusic] Hunt Ends",
  "Bad Mood - Hunt" => "[BadMusic] Hunt",
  "Bad Mood - The System Binds Us Part 2" => "[BadMusic] Axiom Waltz (Storm)",
  "Bad Mood - The System Binds Us" => "[BadMusic] Axiom Waltz (Rain)",
  "Battle - Ana's Lament" => "[Battle] Ana's Lament",
  "Battle - Angie" => "[Battle] Angie",
  "Battle - Boss" => "[Battle] Boss",
  "Battle - Club" => "[Battle] Club",
  "Battle - Conclusive_1" => "[Battle] Conclusive 2",
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
  "Battle - Legendary_1" => "[Battle] Legendary 2",
  "Battle - Legendary" => "[Battle] Legendary",
  "Battle - Lonely Moon" => "[Battle] Lonely Moon",
  "Battle - Lucile" => "[Battle] Lucile",
  "Battle - Machine" => "[Battle] Machine",
  "Battle - Master of Nightmares (Chiptune)" => "[Battle] Master of Nightmares (Chiptune)",
  "Battle - Master of Nightmares" => "[Battle] Master of Nightmares",
  "Battle - Mini Boss" => "[Battle] Mini Boss",
  "Battle - Monstrosity" => "[Battle] Monstrosity",
  "Battle - Mysterious Figures" => "[Battle] Mysterious Figures",
  "Battle - Nightmare_1" => "[Battle] Nightmare_1",
  "Battle - Nightmare" => "[Battle] Nightmare",
  "Battle - Paradox" => "[Battle] Paradox",
  "Battle - Protector of Aevium" => "[Battle] Protector of Aevium",
  "Battle - Pseudo Contribution" => "[Battle] Pseudo Contribution",
  "Battle - Pseudo Gym" => "[Battle] Pseudo Gym",
  "Battle - Regis" => "[Battle] Regis",
  "Battle - Rival 2" => "[Battle] Rival 2",
  "Battle - Rival" => "[Battle] Rival",
  "Battle - Rorrim B." => "[Battle] Rorim B.",
  "Battle - Soul" => "[Battle] Soul",
  "Battle - Space and Time" => "[Battle] Space and Time",
  "Battle - Team Xen_1" => "[Battle] Team Xen 2",
  "Battle - Team Xen" => "[Battle] Team Xen",
  "Battle - Tera" => "[Battle] Tera",
  "Battle - Tournament" => "[Battle] Tournament",
  "Battle - Trainers" => "[Battle] Trainers",
  "Battle - Trainers2" => "[Battle] Trainers 2",
  "Battle - Trainers3" => "[Battle] Trainers 3",
  "Battle - Xen Executives" => "[Battle] Xen Executives",
  "Battle - XG Rival" => "[Battle] XG Rival",
  "citamginE - gnileeF" => "citamginE - gnileeF [Music] ",
  "Cool and Serene" => "[Music] Cool and Serene",
  "Cryptic Feelings" => "[Music] Cryptic Feelings",
  "Evolution" => "[Music] Evolution",
  "Feeling - Amazing" => "[Music] Feeling - Amazing",
  "Feeling - Attacked Part 2" => "[Music] Feeling - Attacked Part 2",
  "Feeling - Attacked" => "[Music] Feeling - Attacked",
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
  "Feeling - Hopeful_2" => "[Music] Feeling - Hopeful 2",
  "Feeling - Hopeful" => "[Music] Feeling - Hopeful",
  "Feeling - Hotheaded" => "[Music] Feeling - Hotheaded",
  "Feeling - Immediate Danger" => "[Music] Feeling - Immediate Danger",
  "Feeling - Inconsistent" => "[Music] Feeling - Inconsistent",
  "Feeling - Lifeless" => "[Music] Feeling - Lifeless",
  "Feeling - Lonely" => "[Music] Feeling - Lonely",
  "Feeling - Lost" => "[Music] Feeling - Lost",
  "Feeling - Magical" => "[Music] Feeling - Magical",
  "Feeling - Magma" => "[Music] Feeling - Magma",
  "Feeling - Miracle_1" => "[Music] Feeling - Miracle 2",
  "Feeling - Miracle" => "[Music] Feeling - Miracle",
  "Feeling - Mysterious" => "[Music] Feeling - Mysterious",
  "Feeling - Mysterious2" => "[Music] Feeling - Mysterious2",
  "Feeling - New Beginning" => "[Music] Feeling - New Beginning",
  "Feeling - Nostalgic" => "[Music] Feeling - Nostalgic",
  "Feeling - Ominous_2" => "[Music] Feeling - Ominous 2",
  "Feeling - Ominous" => "[Music] Feeling - Ominous",
  "Feeling - Onslaught" => "[Music] Feeling - Onslaught",
  "Feeling - Ragged" => "[Music] Feeling - Ragged",
  "Feeling - Rebellious_2" => "[Music] Feeling - Rebellious 2",
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
  "Feeling - Utter Despair2" => "[Music] Feeling - Utter Despair2",
  "Feeling - Wacky" => "[Music] Feeling - Wacky",
  "Feeling - Winter Is Coming" => "[Music] Feeling - Winter Is Coming",
  "Feeling - yeehaw" => "[Music] Feeling - yeehaw",
  "Fighting for Victory_1" => "[Music] Fighting for Victory 2",
  "Fighting for Victory" => "[Music] Fighting for Victory",
  "Fighting for What's Right" => "[Music] Fighting for What's Right",
  "GDC - City of Dreams" => "[Music] City of Dreams",
  "GDC - City of Dreamsn" => "[Music] City of Dreams (Night)",
  "Gearen News!" => "[Music] Gearen News!",
  "GSC - Gym Leader" => "\\gsc[GSCMusic] Gym Leader",
  "GSC - New Bark Town" => "\\gsc[GSCMusic] New Bark Town",
  "GSC - Queen Alice" => "\\gsc[GSCMusic] Queen Alice",
  "GSC - Trouble" => "\\gsc[GSCMusic] Trouble",
  "Gym Battle Victory GS" => "\\gsc[GSCMusic] Gym Battle Victory",
  "Gym Battle Victory" => "[Music] Gym Battle Victory",
  "Her_Awakening_1" => "[Awakening] Her Awakening",
  "Her_Awakening_2" => "[Awakening] Her Awakening 2",
  "It Changes" => "[Awakening] Her Awakening",
  "Keep Marching on!" => "[Music] Keep Marching On!",
  "Melia's Theme" => "[Music] Melia's Theme",
  "Mood - Breakthrough" => "[Music] Mood - Breakthrough",
  "Mood - Calming" => "[Music] Mood - Calming",
  "Mood - Carnival" => "[Music] Mood - Carnival",
  "Mood - Chaos" => "[Music] Mood - Chaos",
  "Mood - Coffee" => "[Music] Mood - Coffee",
  "Mood - Comeback_1" => "[Music] Mood - Comeback 2",
  "Mood - Comeback" => "[Music] Mood - Comeback",
  "Mood - Conniving" => "[Music] Mood - Conniving",
  "Mood - Craggy" => "[Music] Mood - Craggy",
  "Mood - Dangerous Cave" => "[Music] Mood - Dangerous Cave",
  "Mood - Dark City" => "[Music] Mood - Dark City",
  "Mood - Departure" => "[Music] Mood - Departure",
  "Mood - Desert Chamber" => "[Music] Mood - Desert Chamber",
  "Mood - Determination!" => "[Music] Mood - Determination!",
  "Mood - Disaster_1" => "[Music] Mood - Disaster 2",
  "Mood - Disaster" => "[Music] Mood - Disaster",
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
  "Mood - Rivalry" => "[Music] Mood - Rivalry",
  "Mood - Royal" => "[Music] Mood - Royal",
  "Mood - Ruins_1" => "[Music] Mood - Ruins 2",
  "Mood - Ruins" => "[Music] Mood - Ruins",
  "Mood - Sanctuary" => "[Music] Mood - Sanctuary",
  "Mood - Sandy" => "[Music] Mood - Sandy",
  "Mood - Seashore Panic" => "[Music] Mood - Seashore Panic",
  "Mood - Set Out" => "[Music] Mood - Set Out",
  "Mood - Shopaholic" => "[Music] Mood - Shopaholic",
  "Mood - Sinister" => "[Music] Mood - Sinister",
  "Mood - Stardom" => "[Music] Mood - Stardom",
  "Mood - Teamwork_1" => "[Music] Mood - Teamwork 2",
  "Mood - Teamwork_2" => "[Music] Mood - Teamwork 3",
  "Mood - Teamwork" => "[Music] Mood - Teamwork",
  "Mood - Technical_1" => "[Music] Mood - Technical",
  "Mood - That's right" => "[Music] Mood - That's right",
  "Mood - The Bog" => "[Music] Mood - The Bog",
  "Mood - Tower" => "[Music] Mood - Tower",
  "Mood - Triumphant" => "[Music] Mood - Triumphant",
  "Mood - Tropical" => "[Music] Mood - Tropical",
  "Mood - Truth" => "[Music] Mood - Truth",
  "Mood - Village_1" => "[Music] Mood - Village 2",
  "Mood - Village" => "[Music] Mood - Village",
  "Music - 3rd Heaven" => "[Awakening] ARCHETYPE (Third Heaven)",
  "Music - 3rd HQ" => "[Awakening] ARCHETYPE (Third Layer HQ)",
  "Music - Akuwa Town_1" => "[Music] Akuwa Town 2",
  "Music - Akuwa Town" => "[Music] Akuwa Town",
  "Music - Alamissa Urben" => "[Music] Alamissa Urben",
  "Music - Angie's Manor" => "[Music] Angie's Manor",
  "Music - AtebitWorld_1" => "\\gsc[GSCMusic] AtebitWorld 2",
  "Music - AtebitWorld" => "\\gsc[GSCMusic] AtebitWorld",
  "Music - BestieBeatdown_1" => "[Music] BestieBeatdown 2",
  "Music - BestieBeatdown" => "[Music] BestieBeatdown",
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
  "Music - Dive(m)" => "[Music] Dive (m)",
  "Music - Enemy Base" => "[Music] Enemy Base",
  "Music - Festival" => "[Music] Festival",
  "Music - Forest of Time" => "[Music] Forest of Time",
  "Music - Garden" => "[Music] Garden",
  "Music - Garufa Inc" => "[Music] Garufa Inc.",
  "Music - Gates" => "[Music] Gates",
  "Music - Goldenleaf" => "[Music] Goldenleaf",
  "Music - Guitar" => "[Music] Guitar",
  "Music - Hang Out_1" => "[Music] Hang Out 2",
  "Music - Hang Out" => "[Music] Hang Out",
  "Music - I'm Aelita" => "[Music] I'm Aelita",
  "Music - Investigative" => "[Music] Investigative",
  "Music - Jungle_1" => "[Music] Jungle 2",
  "Music - Jungle_2" => "[Music] Jungle 3",
  "Music - Jungle" => "[Music] Jungle",
  "Music - Jynnobi" => "[Music] Jynnobi",
  "Music - Kakori Village" => "[Music] Kakori Village",
  "Music - Marine Tube" => "[Music] Marine Tube",
  "Music - My Memories With Precious Friends" => "[Music] My Memories With Precious Friends",
  "Music - Neo Gearen City" => "[Music] Neo Gearen City",
  "Music - News HQ" => "[Music] News HQ",
  "Music - Nightmare Realm" => "[Music] Nightmare Realm ~ Huey",
  "Music - Nightmare Realm2" => "[Music] Nightmare Realm ~ Amber and Aelita",
  "Music - Nightmare Realm3" => "[Music] Nightmare Realm ~ Saki",
  "Music - Nightmare School" => "[Music] Nightmare School",
  "Music - Nostalgia Reborn" => "[Music] Nostalgia Reborn",
  "Music - Phone Call" => "[Music] Phone Call",
  "Music - PKMN Centers" => "[Music] PKMN Centers",
  "Music - PKMN Centersn" => "[Music] PKMN Centers (Night)",
  "Music - Pokeflute" => "[Music] Pokeflute",
  "Music - RAMPAGE" => "[Music] RAMPAGE",
  "Music - Relic Song" => "[Music] Relic Song",
  "Music - Reservoir" => "[Music] Reservoir",
  "Music - Reservoirn" => "[Music] Reservoir (Night)",
  "Music - Rigid Annihilation" => "[Music] Rigid Annihilation",
  "Music - Route 2" => "[Music] Route 2",
  "Music - Route 3" => "[Music] Route 3",
  "Music - Route 6" => "[Music] Route 6",
  "Music - Route 7" => "[Music] Route 7",
  "Music - Route 9" => "[Music] Route 9",
  "Music - Saki's Hijinx" => "[Music] Saki's Hijinx",
  "Music - Savior" => "[Music] Savior",
  "Music - Song of The Faithful" => "[Music] Song of The Faithful",
  "Music - Space-Time Distortion" => "[Music] Space-Time Distortion",
  "Music - Story of The Ancients_1" => "[Awakening] Story of The Ancients 2",
  "Music - Story of The Ancients" => "[Awakening] Story of The Ancients",
  "Music - Struggle_1" => "[Music] Struggle 2",
  "Music - Struggle" => "[Music] Struggle",
  "Music - Surf" => "[Music] Surf",
  "Music - Taelia" => "[Music] Taelia",
  "Music - Target Acquired" => "[Music] Target Acquired",
  "Music - Teila Resort" => "[Music] Teila Resort",
  "Music - Temple" => "[Music] Temple",
  "Music - Terajuma Jungle" => "[Music] Terajuma Jungle",
  "Music - The Lounge_1" => "[Music] The Lounge 2",
  "Music - The Lounge" => "[Music] The Lounge",
  "Music - The Play's Right" => "[Music] The Play's Right",
  "Music - The Under" => "[Music] The Under",
  "Music - Third Layer" => "[Music] Third Layer",
  "Music - Tournament" => "[Music] Tournament",
  "Music - Unown" => "[Music] Unown",
  "Music - Valor Mountain" => "[Music] Valor Mountain",
  "Music - Voidlands" => "[Music] Voidlands",
  "Music - Wispy Path" => "[Music] Wispy Path",
  "Music - Wispy Tower" => "[Music] Wispy Tower",
  "Music - Xen Antics" => "[Music] Xen Antics",
  "Music - Xen Base" => "[Music] Xen Base",
  "Music - Xen HQ" => "[Music] Xen HQ",
  "Music - Xenogene" => "[Music] Xenogene",
  "Music - Zone Zero" => "[Music] Zone Zero",
  "Rejuvenation - ..." => "[Awakening] ...",
  "Rejuvenation - Title Screen_2" => "[Awakening] Title Screen 2",
  "Rejuvenation - Title Screen" => "[Awakening] Title Screen",
  "Roxie - Doggars!" => "[Music] Roxie - Doggars!",
  "RSE - Battle Deoxys" => "[Battle] RSE - Battle Deoxys",
  "RSE - Battle Regis" => "[Battle] RSE - Battle Regis",
  "RSE - Battle" => "[Battle] RSE - Battle",
  "RSE - BattlePike" => "[Music] RSE - BattlePike",
  "RSE - Enemy Battle" => "[Music] RSE - Enemy Battle",
  "RSE - Fallarbor Town" => "[Music] RSE - Fallarbor Town",
  "RSE - H-Help!" => "[Music] RSE - H-Help!",
  "RSE - Lilycove City" => "[Music] RSE - Lilycove City",
  "RSE - Museum" => "[Music] RSE - Museum",
  "RSE - Petalburg Woods" => "[Music] RSE - Petalburg Woods",
  "RSE - Poke Center" => "[Music] RSE - Poke Center",
  "RSE - Poke Mart" => "[Music] RSE - Poke Mart",
  "RSE - Route 101" => "[Music] RSE - Route 101",
  "RSE - Route120" => "[Music] RSE - Route120",
  "RSE - Rustboro City" => "[Music] RSE - Rustboro City",
  "RSE - Surf" => "[Music] RSE - Surf",
  "RSE - Verdanturf Town" => "[Music] RSE - Verdanturf Town",
  "Stop! Thief!" => "[Music] Stop! Thief!",
  "Team Player" => "[Music] Team Player",
  "Time to Party!" => "[Music] Time to Party",
  "Venam's Theme" => "[Music] Venam's Theme",
  "Victory - RSE!" => "[Music] RSE - Victory!",
  "Victory! - RSETRAINER!" => "[Music] RSE Trainer - Victory!",
  "Victory! - Tera" => "[Music] Tera - Victory!",
  "Victory!" => "[Music] Victory!",
  "Wild Battle - Badlands" => "[Battle] Wild - Badlands",
  "Wild Battle - Gen 2" => "\\gsc[GSCMusic] Battle Wild",
  "Wild Battle - Regular" => "[Battle] Wild",
  "Wild Battle - RSE" => "[Battle] Wild - RSE",
  "Wild Battle - Terajuma" => "[Battle] Wild - Terajuma",
  "Wild Battle - Terrial" => "[Battle] Wild - Terrial",
  "WMute" => nil
}

class MusicLocationWindow
  def initialize(track, name, spriteset)
    @track = track
    gsc = name.start_with?("\\gsc")
    name = name.gsub(/^\\gsc/, '') if gsc
    name = '<c3=4F4E4E,979797>' + name if gsc
    @window=Window_AdvancedTextPokemon.new(name)
    @window.setSkin("Graphics/Windowskins/speech hgss 34") if gsc
    @window.resizeToFit(name,Graphics.width)

    @diesToMessageWindow = !$game_temp.message_window_showing && !$game_temp.menu_calling

    if !$musicSignpost_storedInfo.nil?
      @window.setXYZ(0, $musicSignpost_storedInfo[0], 999999) # Higher than transitions
      @frames=$musicSignpost_storedInfo[1]
      @synclength = $musicSignpost_storedInfo[2]
      $musicSignpost_storedInfo = nil
    else
      setxyz = false
      if spriteset.is_a?(Spriteset_Map)
        syncWith = spriteset.usersprites.select { |it| it.is_a?(LocationWindow) && !it.disposed? }.first
        if syncWith
          setxyz = true
          @window.setXYZ(0,syncWith.window.y+syncWith.window.height - @window.height,999999) # Higher than transitions
          @frames=syncWith.frames
          @synclength = syncWith.window.height - 6
        end
      end

      if !setxyz
        @window.setXYZ(0,-@window.height,999999) # Higher than transitions
        @frames=0
        @synclength = 0
      end
    end
  end

  def disposed?
    @window.disposed?
  end

  def dispose
    if !disposed?
      $musicSignpost_storedInfo = [@window.y, @frames, @synclength]
      $musicSignpost_signpostWaiting = @track
    end
    @window.dispose
  end

  def update
    return if @window.disposed?
    @window.update
    if (@diesToMessageWindow && ($game_temp.message_window_showing || $game_temp.menu_calling)) || 
      ($musicSignpost_lastTrackDisplayed && @track.name != $musicSignpost_lastTrackDisplayed.name)
      @window.dispose
      return
    end
    if @frames>80
      @window.y-=(@window.height + @synclength)/16
      @window.dispose if @window.y+@window.height<0
    else
      @window.y+=(@window.height + @synclength)/16 if @window.y<@synclength
      @frames+=1
    end
  end
end

Events.onMapUpdate += proc {|sender, e|
  if !$game_switches[:Disable_Signposts_Music]
    if !$musicSignpost_signpostWaiting.nil?
      $musicSignpost_transitioning = false
      musicSignpost_createSignpost($scene, $musicSignpost_signpostWaiting)
    end 
  end
}

def musicSignpost_msg(track)
  trackName = MUSIC_SIGNPOST_MAPPING[track.name.gsub(/\.(ogg|mp3)$/, '')]
  return nil if trackName.nil?
  for icon in MUSIC_SIGNPOST_ICONS
    trackName.gsub!('[' + icon + ']', '<img=' + pbResolveBitmap("Data/Mods/MusicTypes/#{icon}.png") + '>')
  end

  return trackName
end

def musicSignpost_createSignpost(scene, track)
  return if track.nil?
  return if !$game_temp || $game_temp.player_transferring || $game_temp.transition_processing || $musicSignpost_transitioning
  if scene.is_a?(Scene_Map) && scene.spritesets && scene.spriteset
    displayName = musicSignpost_msg(track)
    if !displayName.nil?
      scene.spriteset.addUserSprite(MusicLocationWindow.new(track, displayName, scene.spriteset))
    end
    $musicSignpost_signpostWaiting = nil
  end
end

def musicSignpost_playSignpost(track)
  if !$musicSignpost_lastTrackDisplayed.nil? && $musicSignpost_lastTrackDisplayed.name == track.name
    return
  end
  $musicSignpost_lastTrackDisplayed = track
  $musicSignpost_signpostWaiting = track
  
  musicSignpost_createSignpost($scene, track)
end

class Game_System
  if !defined?(musicSignpost_old_bgm_play)
    alias :musicSignpost_old_bgm_play :bgm_play
  end

  def bgm_play(bgm)
    ret = musicSignpost_old_bgm_play(bgm)
    musicSignpost_playSignpost(bgm) if bgm
    return ret
  end

  if !defined?(musicSignpost_old_bgm_pause)
    alias :musicSignpost_old_bgm_pause :bgm_pause
  end

  def bgm_pause(fadetime=0.0)
    ret = musicSignpost_old_bgm_pause(fadetime)
    $musicSignpost_lastTrackDisplayed = nil
    return ret
  end

  if !defined?(musicSignpost_old_bgm_resume)
    alias :musicSignpost_old_bgm_resume :bgm_resume
  end

  def bgm_resume(bgm,position=nil)
    ret = musicSignpost_old_bgm_resume(bgm,position)
    musicSignpost_playSignpost(bgm) if bgm
    return ret
  end
end

class Scene_Map
  if !defined?(musicSignpost_old_transfer_player)
    alias :musicSignpost_old_transfer_player :transfer_player
  end

  def transfer_player(*args,**kwargs)
    $musicSignpost_transitioning = true
    ret = musicSignpost_old_transfer_player(*args, **kwargs)
    $musicSignpost_transitioning = false
    return ret
  end
end
