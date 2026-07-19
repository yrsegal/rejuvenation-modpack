
module MusicSignpostDisplay

  ANIM_ICONS = ["BadMood"]

  LIGHT_ICONS = ["Battle", "Music"]

  ICONS = ["Awakening", "AwakeningBase", "BadMood", "LightBattle", "Battle", "LightMusic", "Music", "Rampage", "Night"]

  # bgs support? only for some

  MAPPING = {
    "Bad Mood - Club REM Part 2" => "[BadMood] Club REM (Panic)",
    "Bad Mood - Club REM" => "[BadMood] Club REM",
    "Bad Mood - GuiltyOrNah" => "[BadMood] Guilty or Nah?",
    "Bad Mood - Hunt Part 2" => "[BadMood] Hunt Ends",
    "Bad Mood - Hunt Side B" => "[BadMood] Hunt (B-Side)",
    "Bad Mood - Hunt" => "[BadMood] Hunt",
    "Bad Mood - Seance Finalis" => "[BadMood] Seance Finalis",
    "Bad Mood - The System Binds Us Part 2" => "[BadMood] Axiom Waltz (Storm)",
    "Bad Mood - The System Binds Us" => "[BadMood] Axiom Waltz (Rain)",
    "Battle - Ana's Lament" => "[Battle] Ana's Lament",
    "Battle - Angie" => "[Battle] Angie",
    "Battle - Beasts and Kingdoms PT 1_Full" => "[Battle] Beasts and Kingdoms",
    "Battle - Beasts and Kingdoms PT 1" => "[Battle] Beasts and Kingdoms",
    "Battle - Beasts and Kingdoms PT 2" => "[Battle] Beasts and Kingdoms",
    "Battle - Beasts and Kingdoms PT 3" => "[Battle] Beasts and Kingdoms",
    "Battle - Boss" => "[Battle] Boss",
    "Battle - Club" => "[Battle] Club",
    "Battle - Chaos" => "[Battle] Chaos",
    "Battle - Conclusive_1" => "[Battle] All on the Line",
    "Battle - Conclusive" => "[Battle] Conclusive",
    "Battle - Crowd" => "[Battle] Crowd",
    "Battle - Dimensional Rift_1" => "[Battle] Dimensional Rift - Nemesis",
    "Battle - Dimensional Rift" => "[Battle] Dimensional Rift",
    "Battle - End of Night" => "[Battle] End of Night",
    "Battle - Final Duel" => "[Battle] Final Duel",
    "Battle - Final Endeavor" => "[Battle] Final Endeavor",
    "Battle - Flora" => "[Battle] Flora",
    "Battle - Geara & Zetta" => "[Battle] Geara and Zetta",
    "Battle - Giratina" => "[Battle] Giratina",
    "Battle - Griselda" => "[Battle] Griselda",
    "Battle - Gyms" => "[Battle] Gyms",
    "Battle - Inconsistent_sea" => "[Battle] Inconsistent_sea",
    "Battle - Insanity" => "[Battle] Insanity",
    "Battle - Intense" => "[Battle] Intense",
    "Battle - Kneel" => "[Battle] Kneel",
    "Battle - Legendary_1" => "[Battle] VS. Legendary",
    "Battle - Legendary" => "[Battle] Legendary",
    "Battle - Life and Death" => "[Battle] Life and Death",
    "Battle - Lonely Moon" => "[Battle] Lonely Moon",
    "Battle - Lucile" => "[Battle] Lucile",
    "Battle - Machine" => "[Battle] Machine",
    "Battle - Madame X Duel" => "[Battle] VS. Madame X",
    "Battle - Madame X PT1 (Looped)" => "[Battle] Madame X",
    "Battle - Madame X PT1" => "[Battle] Madame X",
    "Battle - Madame X PT2" => "[Battle] Madame X",
    "Battle - Madame X PT3" => "[Battle] Madame X",
    "Battle - Master of Nightmares (Chiptune)" => "[Battle] Master of Nightmares (Chiptune)",
    "Battle - Master of Nightmares" => "[Battle] Master of Nightmares",
    "Battle - Mini Boss_1" => "[Battle] A Challenge",
    "Battle - Mini Boss" => "[Battle] Mini Boss",
    "Battle - Monstrosity" => "[Battle] Monstrosity",
    "Battle - Mysterious Figures" => "[Battle] Mysterious Figures",
    "Battle - Nightmare_1" => "[Battle] Night Terror",
    "Battle - Nightmare" => "[Battle] Old Nightmare",
    "Battle - Paradox" => "[Battle] Paradox",
    "Battle - Percival, The Whistleblower_1" => "[Battle] Percival, the Whistleblower",
    "Battle - Percival, The Whistleblower" => "[Battle] VS. Percival",
    "Battle - Protector of Aevium" => "[Battle] Protector of Aevium",
    "Battle - Pseudo Contribution" => "[Battle] Pseudo Contribution",
    "Battle - Pseudo Gym" => "[Battle] Pseudo Gym",
    "Battle - R-Interceptor" => "[Battle] interceptoR",
    "Battle - Regis" => "[Battle] VS. Regis",
    "Battle - Revelation" => "[Battle] Revelation",
    "Battle - Riptune" => "[Battle] Riptune",
    "Battle - Rival 2" => "[Battle] Rival II",
    "Battle - Rival" => "[Battle] Rival",
    "Battle - Rorrim B." => "[Battle] Rorim B.",
    "Battle - Servants" => "[Battle] Servants",
    "Battle - Soul" => "[Battle] Soul",
    "Battle - Space and Time" => "[Battle] Space and Time",
    "Battle - Swords & Roses_1" => "[Battle] War of Swords and Roses",
    "Battle - Swords & Roses" => "[Battle] Swords and Roses",
    "Battle - Team Xen Final" => "[Battle] Team Xen (Final)",
    "Battle - Team Xen_2" => "[Battle] Team Xen (Serious)",
    "Battle - Team Xen_1" => "[Battle] Team Xen (Intense)",
    "Battle - Team Xen" => "[Battle] Team Xen",
    "Battle - Tera" => "[Battle] Tera",
    "Battle - Terror" => "[Battle] Terror",
    "Battle - Thorned Crown For a Prince" => "[Battle] Thorned Crown For a Prince",
    "Battle - Tournament" => "[Battle] Tournament",
    "Battle - Trainers" => "[Battle] Trainer",
    "Battle - Trainers2" => "[Battle] Trainer II",
    "Battle - Trainers3" => "[Battle] Trainer III",
    "Battle - Turnabout " => "[Battle] Turnabout",
    "Battle - Witch of the End" => "[Battle] Witch of the End",
    "Battle - World Shatterer" => "[Battle] World Shatterer",
    "Battle - Wrath" => "[Battle] Wrath",
    "Battle - Xen Executives" => "[Battle] Xen Executives",
    "Battle - XG Rival" => "[Battle] XG Rival",
    "citamginE - gnileeF" => "citamginE - gnileeF [Music]",
    "Cool and Serene" => "[Music] Cool and Serene",
    "Credits - Up in Flames" => "[Awakening] Up in Flames",
    "Cryptic Feelings" => "[Music] Cryptic Feelings",
    "Evolution" => "[Music] Evolution",
    "Feeling - Amazing" => "[Music] Feeling - Amazing",
    "Feeling - Attacked Part 2" => "[Music] Feeling - Attacked",
    "Feeling - Attacked" => "[Music] Feeling - Danger",
    "Feeling - Conflict" => "[Music] Feeling - Conflict",
    "Feeling - Dark and Sinister" => "[Music] Feeling - Dark and Sinister",
    "Feeling - Despair" => "[Music] Feeling - Despair",
    "Feeling - Enigmatic_1" => "[Music] Feeling - Strange",
    "Feeling - Enigmatic_2" => "[Music] Feeling - Enigma Unraveled",
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
    "Feeling - New Despair" => "[Music] Feeling - New Despair",
    "Feeling - Nostalgic" => "[Music] Feeling - Nostalgic",
    "Feeling - Ominous_2" => "[Music] Feeling - Paranoid",
    "Feeling - Ominous_3" => "[Music] Feeling - ...",
    "Feeling - Ominous" => "[Music] Feeling - Ominous",
    "Feeling - Onslaught" => "[Music] Feeling - Onslaught",
    "Feeling - Otherworldly End" => "[Music] Feeling - Otherworldly End",
    "Feeling - Otherworldly" => "[Music] Feeling - Otherworldly",
    "Feeling - Ragged" => "[Music] Feeling - Ragged",
    "Feeling - Reality" => "[Music] Feeling - Reality",
    "Feeling - Rebellious_2" => "[Music] Feeling - That's Enough!",
    "Feeling - Rebellious" => "[Music] Feeling - Rebellious",
    "Feeling - Reflective" => "[Music] Feeling - Reflective",
    "Feeling - Sadness" => "[Music] Feeling - Sadness",
    "Feeling - Sketchy" => "[Music] Feeling - Sketchy",
    "Feeling - Somber" => "[Music] Feeling - Somber",
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
    "GDC - City of Dreamsn" => "[Music] [Night] City of Dreams",
    "GDC - City of Ruin_1" => "[Music] City of Ruin",
    "GDC - City of Ruin" => "[Music] Through the City of Ruin",
    "Gearen News!" => "[Music] Gearen News!",
    "GSC - Boss" => "\\gsc[Battle] Boss",
    "GSC - Castle" => "\\gsc[Music] Castle",
    "GSC - Eyes Meet_1" => "\\gsc[Music] Eyes Meet II",
    "GSC - Eyes Meet" => "\\gsc[Music] Eyes Meet",
    "GSC - Gym Leader_1" => "\\gsc[Battle] Gym Leader II",
    "GSC - Gym Leader" => "\\gsc[Battle] Gym Leader",
    "GSC - New Bark Town" => "\\gsc[Music] New Bark Town",
    "GSC - Queen Alice" => "\\gsc[Music] Queen Alice",
    "GSC - Trouble" => "\\gsc[Music] Trouble",
    "GSC - Wild" => "\\gsc[Battle] Wild",
    "GSC - Wonder Tower" => "\\gsc[Battle] Wonder Tower",
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
    "Mood - Destiny" => "[Music] Mood - Destiny",
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
    "Mood - No Longer Having Fun_1" => "[Music] Mood - #{ColorTags[:Red]}No Longer Having Fun",
    "Mood - No Longer Having Fun" => "[Music] Mood - No Longer Having Fun",
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
    "Music - Castle Schwarz" => "[Music] Castle Schwarz",
    "Music - Celandine City" => "[Music] Celandine City",
    "Music - choo choo! CHOO CHOO" => "[Music] choo choo! CHOO CHOO",
    "Music - Church Light" => "[Music] Church Light",
    "Music - Crescent Appears" => "[Awakening] Crescent Appears",
    "Music - Darchlight Escape" => "[Music] Darchlight Escape",
    "Music - Darchlight Woods" => "[Music] Darchlight Woods",
    "Music - Desert Town" => "[Music] Desert Town",
    "Music - Desert" => "[Music] Desert",
    "Music - Despair Desert" => "[Music] Despair Desert",
    "Music - Dive(m)" => "[Music] Dive",
    "Music - Enemy Base" => "[Music] Enemy Base",
    "Music - Father_1" => "[Music] Father II",
    "Music - Father " => "[Music] Father",
    "Music - Festival" => "[Music] Festival",
    "Music - Forest of Time" => "[Music] Forest of Time",
    "Music - Game Over" => "[Music] Game Over",
    "Music - Garden" => "[Music] Garden",
    "Music - Garufa Inc" => "[Awakening] Garufa Inc.",
    "Music - Gates" => "[Music] Gates",
    "Music - GlitchWorld_1" => "\\gsc[Music] Atebit Paranoia",
    "Music - GlitchWorld_2" => "\\gsc[Music] Atebit Prison",
    "Music - GlitchWorld" => "[BadMood] Broken World",
    "Music - Goldenleaf" => "[Music] Goldenleaf",
    "Music - Guitar" => "[Music] Guitar",
    "Music - Hang Out_1" => "[Music] Hang Out",
    "Music - Hang Out" => "[Music] Together",
    "Music - Hell" => "[Music] Hell",
    "Music - I'm Aelita" => "[Music] Enduring Legacy", # Copied from my WLL rename
    "Music - Investigative" => "[Music] Investigative",
    "Music - Jungle_1" => "[Music] Jungle Beats",
    "Music - Jungle_2" => "[Music] Jungle Vibes",
    "Music - Jungle" => "[Music] Deep Jungle",
    "Music - Jynnobi" => "[Music] Jynnobi",
    "Music - Kakori Village" => "[Music] Kakori Village",
    "Music - Marine Tube" => "[Music] Marine Tube",
    "Music - Meloetta Sings" => "[Music] Meloetta Sings",
    "Music - MM" => "[Music] MM",
    "Music - Moms Investigating Lost Family (And One Dad Investigating Lost Family)" => "<ac>[Music] Moms Investigating Lost Family\n(And One Dad Investigating Lost Family)</ac>",
    "Music - Mt Ruin" => "[Music] Mt. Ruin",
    "Music - My Memories With Precious Friends" => "[Music] My Memories With Precious Friends",
    "Music - Neo Gearen City" => "[Music] Neo Gearen City",
    "Music - News HQ" => "[Music] News HQ",
    "Music - Nightmare Realm" => "[Music] I Don't Understand...",
    "Music - Nightmare Realm2" => "[Music] On Your Guard...",
    "Music - Nightmare Realm3" => "[Music] This Can't Be Right...",
    "Music - Nightmare School" => "[Music] School of Nightmares",
    "Music - Nostalgia Reborn" => "[Music] Nostalgia Reborn",
    "Music - Obsidian Garden" => "[Music] Obsidian Garden",
    "Music - Phone Call" => "[Music] Phone Call",
    "Music - PKMN Centers" => "[Music] PKMN Centers",
    "Music - PKMN Centersn" => "[Music][Night] PKMN Centers",
    "Music - Pokeflute" => "[Music] Pokeflute",
    "Music - Purgatorium_1" => "[Music] Face Purgatorium",
    "Music - Purgatorium" => "[Music] Purgatorium",
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
    "Music - Squiggly Line" => "[Music] Squiggly Line",
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
    "Music - Thrash (Carnival)" => "[Music] Thrash (Carnival)",
    "Music - Thrash (Guzma)" => "[Music] Thrash (Guzma)",
    "Music - Thrash (SUMO)" => "[Music] Thrash (SUMO)",
    "Music - Total Annihilation" => "[Music] Total Annihilation",
    "Music - Tournament" => "[Music] Tournament",
    "Music - Unown" => "\\gsc[Music] Unown",
    "Music - Valor Mountain" => "[Music] Valor Mountain",
    "Music - Voidlands" => "[Music] Voidlands",
    "Music - Wispy Path" => "[Music] Wispy Path",
    "Music - Wispy Tower" => "[Music] Wispy Tower",
    "Music - Wretched Throne for a Princess" => "[Music] Wretched Throne for a Princess",
    "Music - Xen Antics" => "[Music] Xen Antics",
    "Music - Xen Base_1" => "[Music] Xen Base II",
    "Music - Xen Base_2" => "[Music] Data Processing",
    "Music - Xen Base" => "[Music] Xen Base",
    "Music - Xen HQ" => "[Music] Xen HQ",
    "Music - Xenogene" => "[Music] Dreaded Nightmare", # Dunno why this is called xenogene tbh.
    "Music - Xenpurgis [Augen Finale]" => "[Music] Xenpurgis - Augen II",
    "Music - Xenpurgis [Augen]" => "[Music] Xenpurgis - Augen",
    "Music - Xenpurgis [Beine]" => "[Music] Xenpurgis - Beine",
    "Music - Xenpurgis [Körper]" => "[Music] Xenpurgis - Körper",
    "Music - Zone Zero" => "[Music] Zone Zero",
    "Rejuvenation - ..." => "[Awakening] Painful Truth...?",
    "Rejuvenation - Title Screen_2" => "[Awakening] Dreaded Truth",
    "Rejuvenation - Title Screen" => "[Awakening] Painful Truth",
    "Roxie - Doggars!" => "[Music] Roxie - Doggars!",
    "RSE - Amberette Town" => "\\rse[Music] Amberette Town",
    "RSE - Battle Deoxys" => "\\rse[Battle] VS. Deoxys",
    "RSE - Battle Regis" => "\\rse[Battle] VS. Regis",
    "RSE - Battle! Hell" => "\\rse[Battle] Hell",
    "RSE - Battle" => "\\rse[Battle] Battle",
    "RSE - BattlePike" => "\\rse[Music] Battle Pike",
    "RSE - Boss_1" => "\\rse[Battle] Boss II",
    "RSE - Boss" => "\\rse[Battle] Boss",
    "RSE - Chateau" => "\\rse[Music] Chateau",
    "RSE - Enemy Battle" => "\\rse[Music] Enemy Battle",
    "RSE - Forest" => "\\rse[Music] Forest",
    "RSE - Girl vs the World" => "\\rse[Music] Girl vs the World",
    "RSE - Gym Battle" => "\\rse[Battle] Gym Battle",
    "RSE - H-Help!" => "\\rse[Music] H-Help!",
    "RSE - Hell" => "\\rse[Music] Hell",
    "RSE - Hiyoshi_1" => "\\rse[Music] Hiyoshi II",
    "RSE - Hiyoshi" => "\\rse[Music] Hiyoshi",
    "RSE - Kugearen City" => "\\rse[Music] Kugearen City",
    "RSE - Laverre" => "\\rse[Music] Laverre",
    "RSE - Marble Mansion" => "\\rse[Music] Marble Mansion",
    "RSE - Pelago" => "\\rse[Music] Pelago",
    "RSE - Poke Center" => "\\rse[Music] Poke Center",
    "RSE - Rejuv Co" => "\\rse[Music] Rejuv Co.",
    "RSE - Route 3" => "\\rse[Music] Route 3",
    "RSE - Route 4" => "\\rse[Music] Route 4",
    "RSE - Ruins" => "\\rse[Music] Ruins",
    "RSE - Shayda Appears" => "\\rse[Music] Shayda Appears",
    "RSE - Sheridan" => "\\rse[Music] Sheridan",
    "RSE - Spotlight City" => "\\rse[Music] Spotlight City",
    "RSE - Surf" => "\\rse[Music] Surf",
    "Stop! Thief!" => "\\rse[Music] Stop! Thief!",
    "Team Player" => "[Music] Team Player",
    "Time to Party!" => "[Music] Time to Party",
    "Venam's Theme" => "[Music] Venam's Theme",
    "Victory - Paragon" => "[Awakening] Victory!",
    "Victory - Renegade" => "[BadMood] Victory!",
    "Victory - RSE!" => "\\rse[Music] Victory!",
    "Victory! - RSETRAINER!" => "\\rse[Music] Trainer - Victory!",
    "Victory! - Tera" => "[Music] Tera - Victory!",
    "Victory! RSE Enemy" => "\\rse[Music] Enemy - Victory!",
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

    @@displaybox.resizeToFit(@@displaybox.text, Graphics.width)
    # p @@displaybox.width
    # @@displaybox.width += 100
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
        @@displaybox.text = musicCurrent
        @@displaybox.animated_icons = animicons
        positionBox
        visibleBox
      end
    end
  end

  def self.generateIcon(iconname) # haruuuuuuuuuuu
    graphic = "Graphics/Icons/MusicTypes/#{iconname}"
    tempgraphic = Bitmap.new(graphic)
    icon = "<img=#{graphic}|0|0|#{tempgraphic.width}|#{tempgraphic.height}>"
    tempgraphic.dispose
    return icon
  end

  def self.adjustForMode(window, trackName, animicons)
    if !isDarkWindowskin(window.windowskin)
      for replacement in MusicSignpostDisplay::LIGHT_ICONS
        icon = "Light#{replacement}"
        trackName.gsub!(/\<img=Graphics\/Icons\/MusicTypes\/#{replacement}(\|0\|0\|\d+\|\d+)>/, generateIcon(icon))
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
    trackName.gsub! /^Music -/, "[Music]"
    trackName.gsub! /^Battle -/, "[Battle]"
    trackName.gsub! /^Bad Mood -/, "[BadMood]"
    trackName = "[Music] #{trackName}" unless trackName[/\[\w+\]/]
    return trackName
  end

  def self.msg(track)
    animicons = []
    trackName = MusicSignpostDisplay::MAPPING[track.name.gsub(/\.(ogg|mp3)$/, '')].clone
    return nil if trackName == ""
    trackName = naiveNameForMusic(track.name.clone) if trackName.nil?
    trackName = trackName + "<o=255>" # lol this is for an internal bug
    for icon in MusicSignpostDisplay::ICONS
      if trackName.include?("[#{icon}]")
        trackName.gsub!("[#{icon}]", generateIcon(icon))
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
        @animated_icons["MusicTypes/#{icon}"] = AnimatedBitmap.new("Graphics/Icons/MusicTypes/#{icon}Anim")
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
            if chr[5] && chr[5].end_with?(key)
              chrrect = chr[15]
              framecount = icon.width / chrrect.width
              frameidx = (@frame / 10) % framecount
              self.contents.blt(chr[1], chr[2], icon.bitmap, Rect.new(frameidx * chrrect.width + chrrect.x, chrrect.y, chrrect.width, chrrect.height), chr[8].alpha)
            end
          end
        end
      end
    end
  end
end

class Game_System
  attr_reader :defaultBGM

  alias :musicSignpost_old_bgm_play :bgm_play

  def bgm_play(bgm, position = 0, fadeIn = true)
    oldPlaying = @playing_bgm
    ret = musicSignpost_old_bgm_play(bgm, position, fadeIn)
    @playing_bgm = oldPlaying if bgm && !FileTest.audio_exist?("Audio/BGM/"+ bgm.name)

    MusicSignpostDisplay.playSignpost(bgm) if bgm
    MusicSignpostDisplay.updateMusic(false) if bgm
    return ret
  end

  alias :musicSignpost_old_bgm_pause :bgm_pause

  def bgm_pause(fadetime = 0.0)
    ret = musicSignpost_old_bgm_pause(fadetime)
    MusicSignpostDisplay.lastTrackDisplayed = nil
    MusicSignpostDisplay.updateMusic(false)
    return ret
  end

  alias :musicSignpost_old_bgm_resume :bgm_resume

  def bgm_resume(bgm, position = nil)
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


