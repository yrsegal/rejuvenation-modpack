begin
  missing = ['0000.complexmart.rb','0000.injection.rb', 'ShopIcons'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Switches[:BikeVoucher] = 1699
Switches[:NoctowlCrest] = 1698
Switches[:SimisageCrest] = 1697
Switches[:SimisearCrest] = 1696
Switches[:SimipourCrest] = 1695
Switches[:LuxrayCrest] = 1701
Switches[:DruddigonCrest] = 1702
Switches[:ThievulCrest] = 1703
Switches[:SamurottCrest] = 1704
Switches[:BoltundCrest] = 1771
Switches[:ProbopassCrest] = 1774
Switches[:SwalotCrest] = 1772
Switches[:CinccinoCrest] = 1773
Switches[:DelcattyCrest] = 1775

Switches[:Gym_13] = 295
Switches[:Gym_15] = 297

Variables[:QuestLuckPoison] = 808

module ComplexMartSpecifiers
  VENDOR_DATA = {
    NEO_EAST_GEAREN: {
      corsola: {
        messages: {
          speech: "\\se[222Cry]CORSOLA: Corsa! (Buy something.)",
          come_again: '',
          anything_else: "\\se[222Cry]CORSOLA: Corsa! (Buy something.)",

          purchase_important: "\\se[222Cry]CORSOLA: Corsa! ({2}.)",

          no_items: "\\se[222Cry:100:125]CORSOLA: CORSA!!! (NOT ENOUGH!)",
          success_items: "\\se[222Cry]CORSOLA: C-Corsa! (Thank you!)"
        },
        inventory: [{ move: :THROATCHOP,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }}]
      },

      girl: {
        messages: {
          speech: "I'm a Move Tutor! I know lots of moves!",
          come_again: "Come again!",
          anything_else: "Anything else you need? Anything at all?",

          purchase_important: "{1} will be {2}.",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thank you for your patronage!"
        },
        inventory: [{ move: :IRONHEAD,
                      price: { type: :Item, item: :REDSHARD, amount: 5 }},
                    { move: :FOULPLAY,
                      price: { type: :Item, item: :BLUESHARD, amount: 5 }},
                    { move: :KNOCKOFF,
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }},
                    { move: :POLTERGEIST,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 5 }},
                    { move: :BUGBUZZ,
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }}]
      },

      guy: {
        messages: {
          speech: "STOP! I HAVE MOVES!\nI need to live!",
          come_again: "",
          anything_else: "Please buy one, my family is dying.",

          purchase_important: "{1} is very strong! {2}!",

          no_items: "I... can't go on like this...",
          success_items: "Thanks for the meal!"
        },
        inventory: [{ move: :LASTRESORT,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 4 }},
                    { move: :OUTRAGE,
                      price: { type: :Item, item: :GREENSHARD, amount: 7 }},
                    { move: :LOWKICK,
                      price: { type: :Item, item: :BLUESHARD, amount: 5 }},
                    { move: :STEELROLLER,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 6 }},
                    { move: :POWERGEM,
                      price: { type: :Item, item: :REDSHARD, amount: 6 }}]
      }
    },
    FESTIVAL_PLAZA: {
      pledge: {
        messages: {
          speech: "Pledge your allegiance to your Pokemon! Teach them moves they could only dream of learning!",
          come_again: "Come again!",
          anything_else: "So? What else do you want to do?",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thank you!"
        },
        inventory: [{ move: :FIREPLEDGE,
                      purchase_message: "{1}? Honorable. {2}.",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :WATERPLEDGE,
                      purchase_message: "{1}? How noble... {2}.",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :GRASSPLEDGE,
                      purchase_message: "{1}? How... eh. Anyway, {2}.",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }}]
      },
      punch: {
        messages: {
          speech: "Are you ready for your Pokemon to learn some INSANE moves, gamer??",
          come_again: "Come again!",
          anything_else: "What'll it be, gamer??",

          purchase_important: "{1}? That's a weird decision. {2}.",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Obliged!"
        },
        inventory: [{ move: :EARTHPOWER,
                      price: { type: :Item, item: :BLUESHARD, amount: 6 }},
                    { move: :FOCUSPUNCH,
                      price: { type: :Item, item: :REDSHARD, amount: 5 }},
                    { move: :DRAINPUNCH,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 6 }},
                    { move: :PAINSPLIT,
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :MISTYEXPLOSION,
                      price: { type: :Item, item: :REDSHARD, amount: 7 }}]
      },
      ch14: {
        messages: {
          speech: "Moves, moves, and even more moves for your Pokemon! ",
          come_again: "Come again!",
          anything_else: "What'll it be?",

          purchase_important: "{1}? That'll be {2}!",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thank you for your patronage!"
        },
        inventory: [{ move: :SUPERPOWER,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 6 }},
                    { move: :HEATWAVE,
                      price: { type: :Item, item: :BLUESHARD, amount: 6 }},
                    { move: :STEALTHROCK,
                      price: { type: :Item, item: :REDSHARD, amount: 6 }},
                    { move: :FUTURESIGHT,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :FLIPTURN,
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }}]
      }
    },
    AKUWA_TOWN: {
      punch: {
        messages: {
          speech: "Feel like becoming more powerful? Well, you've come to the right place...",
          come_again: "Come again!",
          anything_else: "Anything else?",

          purchase_important: "{1}? That'll be {2}.",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thanks a million!"
        },
        inventory: [{ move: :FIREPUNCH,
                      price: { type: :Item, item: :REDSHARD, amount: 5 }},
                    { move: :ICEPUNCH,
                      price: { type: :Item, item: :BLUESHARD, amount: 5 }},
                    { move: :THUNDERPUNCH,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 5 }},
                    { move: :HEALBELL,
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }},
                    { move: :BURNINGJEALOUSY,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :SKITTERSMACK,
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }}]
      },
      ohyeah: {
        messages: {
          speech: "OH YEAH! NEW MOVES!\nLET'S GET SCHMOOVIN'!",
          come_again: "COME AGAIN! P-please...",
          anything_else: "LET'S GET SCHMOOVIN'!",

          no_items: "OH NO!",
          success_items: "OH YEAH! THANKS!"
        },
        inventory: [{ move: :STOMPINGTANTRUM,
                      purchase_message: "STOMPY? 5 R-Red shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :REDSHARD, amount: 5 }},
                    { move: :IRONTAIL,
                      purchase_message: "IYUNTAIL? 5 B-Blue shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :BLUESHARD, amount: 5 }},
                    { move: :ENDEAVOR,
                      purchase_message: "DEVA? 4 G-Green shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }},
                    { move: :IRONDEFENSE,
                      purchase_message: "DOFFENSE? 3 Y-Yellow shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }},
                    { move: :LASHOUT,
                      purchase_message: "LA SHIT? 4 B-Blue shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :CORROSIVEGAS,
                      purchase_message: "GASSY? 3 Y-Yellow shards, p-please... D-don't be mad...",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }}]
      },
      pledge: {
        messages: {
          speech: "I hold three pledges here for trainers like you to follow.",
          come_again: "Come again!",
          anything_else: "Which one will you take up?",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thank you!"
        },
        inventory: [{ move: :FIREPLEDGE,
                      purchase_message: "{1}? Honorable. {2}.",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :WATERPLEDGE,
                      purchase_message: "{1}? How noble... {2}.",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :GRASSPLEDGE,
                      purchase_message: "{1}? Fascinating. {2}.",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }}]
      },
      fossils: {
        messages: {
          speech: "Welcome! We sell rare fossils here. Would you like something from our selection?",
          come_again: "Come again!",
          anything_else: "So? What do you want it to be?",

          purchase_quantity: "So {2} of the {1}? {3}s, please.",

          no_items: "I'm very sorry, but you don't have enough shards...\nOur stock isn't very high, so in turn we have to increase prices. Please understand.",
          success_items: "Thank you for your patronage! You can revive your fossils at the counter adjacent to this one."
        },
        inventory: [{ item: :SAILFOSSIL,
                      quantity_message: "Ah, the {1}? That contains Amaura.\nHow many would you like?",
                      price: { type: :Item, item: :BLUESHARD, amount: 10 }},
                    { item: :JAWFOSSIL,
                      quantity_message: "Ah, the {1}? That contains Tyrunt.\nHow many would you like?",
                      price: { type: :Item, item: :REDSHARD, amount: 10 }},
                    { item: :SKULLFOSSIL,
                      quantity_message: "Ah, the {1}? That contains Cranidos.\nHow many would you like?",
                      price: { type: :Item, item: :GREENSHARD, amount: 10 }},
                    { item: :ARMORFOSSIL,
                      quantity_message: "Ah, the {1}? That contains Shieldon.\nHow many would you like?",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 10 }}]
      }
    },
    HIYOSHI: {
      tutor: {
        messages: {
          speech: "Wanting an edge on the competition trainer? Then you've come to the right place!",
          come_again: "Come again!",
          anything_else: "What'll it be?",

          no_items: "Sorry, but you don't have enough shards.",
          success_items: "Thank you!"
        },
        inventory: [{ move: :SKYATTACK,
                      purchase_message: "{1}? Powerful stuff, but risky. That'll be {2}.",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :SKILLSWAP,
                      purchase_message: "If we're talking a game of skill, trainers with this are the top brass. We're talking {2} for it.",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }},
                    { move: :MAGNETRISE,
                      purchase_message: "A hop, skip and a magnet away from rising to the top! {2} please!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }},
                    { move: :GRAVITY,
                      purchase_message: "Dire situations have gravitas, and with this move, so will the battle! {2}!",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }},
                    { move: :RECYCLE,
                      purchase_message: "The mayor's been on about the 3 R's a lot, but I'm all about Recycling in battle! Gotta keep those items, yeah? {2}!",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }}]
      }
    },
    GOOMIDRA: {
      goomatora: {
        messages: {
          speech: "\\se[704Cry:100:110]GOOMATORA: BIiG MushrooMs fOr movEs!",
          come_again: "GOOMATORA: Get MOre sHROOOOoms!",
          anything_else: "GOOMATORA: bIiG? mUSHRoom?",

          purchase_important: "Give GOOMATORA {2}?",

          no_items: "GOOMATORA: NOOOO!",
          success_items: "GOOMATORA: GOOOOOM!"
        },
        inventory: [{ move: :BODYSLAM,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 2 }},
                    { move: :SEEDBOMB,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 2 }},
                    { move: :DRAGONPULSE,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 3 }},
                    { move: :MEGAHORN,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 3 }},
                    { move: :SCORCHINGSANDS,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 3 }},
                    { move: :ZENHEADBUTT,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 2 }},
                    { move: :LIQUIDATION,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 3 }},
                    { move: :MUDDYWATER,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 2 }},
                    { move: :DEFOG,
                      purchase_message: "Give GOOMATORA {2}?",
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 1 }},
                    { move: :DUALWINGBEAT,
                      price: { type: :Item, item: :BIGMUSHROOM, amount: 2 }}]
      },
      meteor: {
        messages: {
          speech: "You aRe reaDy foR thE ulTIMate GOOMIdRA TECHNIQUE!!! OnLy foR gOOmy typeS!!!",
          come_again: "",
          anything_else: "You aRe reaDy foR thE ulTIMate GOOMIdRA TECHNIQUE!!! OnLy foR gOOmy typeS!!!",

          purchase_important: "Give Goomy {2}?",

          no_items: "GOOMBINA: No haVe mushroOm! BegoNe!",
          success_items: "GOOMBINA: GoooOoooOOOO!"
        },
        inventory: [{ move: :DRACOMETEOR,
                      name: "GOoMy mEtEOr",
                      price: { type: :Item, item: :BALMMUSHROOM, amount: 1 }}]
      }
    },
    LUCK_TENT: { 
      marshie: {
        messages: {
          speech: "MARSHIE: I teach you moves... Give... Shards...",
          come_again: "MARSHIE: Alright... you'll be back...",
          anything_else: "MARSHIE: You want to learn...?",

          no_items: "MARSHIE: You no have enough... Me eat you...",
          success_items: "MARSHIE: Yes... Good..."
        },
        inventory: [{ move: :BIND,
                      purchase_message: "MARSHIE: 2 Red... For {2}...",
                      price: { type: :Item, item: :REDSHARD, amount: 2 }},
                    { move: :COVET,
                      purchase_message: "MARSHIE: 2 Blue... For {2}...",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }},
                    { move: :BLOCK,
                      purchase_message: "MARSHIE: 2 Yellow... For {2}...",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }},
                    { move: :SPITE,
                      purchase_message: "MARSHIE: 2 Green... For {2}...",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }},
                    { move: :SWIFT,
                      purchase_message: "MARSHIE: 2 Yellow... For {2}...",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }},
                    { move: :AFTERYOU,
                      purchase_message: "MARSHIE: 2 Red... For {2}...",
                      price: { type: :Item, item: :REDSHARD, amount: 2 }},
                    { move: :GRAVITY,
                      purchase_message: "MARSHIE: 2 Green... For {2}...",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }},
                    { move: :MAGICCOAT,
                      purchase_message: "MARSHIE: 2 Blue... For {2}...",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }},
                    { move: :VENOMDRENCH,
                      purchase_message: "MARSHIE: 2 Blue... For {2}...",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }}]
      },
      margo: { 
        messages: {
          speech: "MARGO: WANT MOVES? I CARRY A VARIETY.",
          come_again: "MARGO: COME AGAIN!",
          anything_else: "MARGO: WHAT CAN I DO YOU FOR?",

          no_items: "MARGO: YOU DON'T HAVE ENOUGH? ME EAT YOU!",
          success_items: "MARGO: YOU'RE TOO KIND."
        },
        inventory: [{ move: :RECYCLE,
                      purchase_message: "MARGO: THAT'LL BE 2 YELLOW SHARDS, BUB.",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }},
                    { move: :WORRYSEED,
                      purchase_message: "MARGO: THAT'LL BE 2 GREEN SHARDS, BUB.",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }},
                    { move: :SNORE,
                      purchase_message: "MARGO: THAT'LL BE 2 RED SHARDS, BUB.",
                      price: { type: :Item, item: :REDSHARD, amount: 2 }},
                    { move: :SHOCKWAVE,
                      purchase_message: "MARGO: THAT'LL BE 2 BLUE SHARDS, BUB.",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }},
                    { move: :WATERPULSE,
                      purchase_message: "MARGO: THAT'LL BE 2 RED SHARDS, BUB.",
                      price: { type: :Item, item: :REDSHARD, amount: 2 }},
                    { move: :SNATCH,
                      purchase_message: "MARGO: THAT'LL BE 2 BLUE SHARDS, BUB.",
                      price: { type: :Item, item: :BLUESHARD, amount: 2 }},
                    { move: :WONDERROOM,
                      purchase_message: "MARGO: THAT'LL BE 2 GREEN SHARDS, BUB.",
                      price: { type: :Item, item: :GREENSHARD, amount: 2 }},
                    { move: :MAGICROOM,
                      purchase_message: "MARGO: THAT'LL BE 2 YELLOW SHARDS, BUB.",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }},
                    { move: :ROLEPLAY,
                      purchase_message: "MARGO: THAT'LL BE 2 YELLOW SHARDS, BUB.",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 2 }}]
      },
      marnie: { 
        messages: {
          speech: "MARNIE: Coupla moves. Wanna laern? Learn*.",
          come_again: "MARNIE: Buy! Bye*.",
          anything_else: "MARNIE: Ya interestde? Interested*.",

          no_items: "MARNIE: You don't have enough! I hate poor people!*",
          success_items: "MARNIE: Yay! I'm so happy! You can leave now.*"
        },
        inventory: [{ move: :BUGBITE,
                      purchase_message: "MARNIE: 1 Geen Sahrd! {2}!",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }},
                    { move: :BOUNCE,
                      purchase_message: "MARNIE: 1 Blu Sahrd! {2}!",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :DRILLRUN,
                      purchase_message: "MARNIE: 1 Ylw Sahrd! {2}!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }},
                    { move: :ELECTROWEB,
                      purchase_message: "MARNIE: 1 Rad Sahrd! {2}!",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :GASTROACID,
                      purchase_message: "MARNIE: 1 Ylw Sahrd! {2}!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }},
                    { move: :FOCUSENERGY,
                      purchase_message: "MARNIE: 1 Rad Sahrd! {2}!",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :SKILLSWAP,
                      purchase_message: "MARNIE: 1 Blu Sahrd! {2}!",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :SIGNALBEAM,
                      purchase_message: "MARNIE: 1 Geen Sahrd! {2}!",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }},
                    { move: :COACHING,
                      purchase_message: "MARNIE: 1 Rad Sahrd! {2}!",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }}]
      },
      marlow: { 
        messages: {
          speech: "MARLOW: Please buy moves, my family is dying a horrible slow death.",
          come_again: "MARLOW: Bokay...",
          anything_else: "MARLOW: Buy moves? Buy them?",

          no_items: "MARLOW: Friend! You don't have enough!",
          success_items: "MARLOW: I'm hungry... Thanks!"
        },
        inventory: [{ move: :AQUATAIL,
                      purchase_message: "MARLOW: That'll be 4 Blues, please!",
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :LASERFOCUS,
                      purchase_message: "MARLOW: That'll be 4 Reds, please!",
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :SPIKES,
                      purchase_message: "MARLOW: That'll be 4 Yellows, please!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 4 }},
                    { move: :REVERSAL,
                      purchase_message: "MARLOW: That'll be 4 Greens, please!",
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }},
                    { move: :ENDURE,
                      purchase_message: "MARLOW: That'll be 4 Greens, please!",
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }},
                    { move: :AMNESIA,
                      purchase_message: "MARLOW: That'll be 4 Blues, please!",
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :ELECTROBALL,
                      purchase_message: "MARLOW: That'll be 4 Yellows, please!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 4 }},
                    { move: :ALLYSWITCH,
                      purchase_message: "MARLOW: That'll be 4 Reds, please!",
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :HYPERVOICE,
                      purchase_message: "MARLOW: That'll be 4 Blues, please!",
                      price: { type: :Item, item: :REDSHARD, amount: 4 }}]
      },
      marley: { 
        messages: {
          speech: "MARLEY: Feeling lonely?",
          come_again: "MARLEY: See you later...",
          anything_else: "MARLEY: You buy something?",

          purchase_important: "MARLEY: Remember to recycle... {2}...",

          no_items: "MARLEY: Not enough... Shards...",
          success_items: "MARLEY: Thank you for thy patronage."
        },
        inventory: [{ move: :SKYATTACK,
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }},
                    { move: :ICYWIND,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :TAILWIND,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 4 }},
                    { move: :BATONPASS,
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :ENCORE,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }},
                    { move: :HIGHHORSEPOWER,
                      price: { type: :Item, item: :GREENSHARD, amount: 4 }},
                    { move: :AGILITY,
                      price: { type: :Item, item: :BLUESHARD, amount: 4 }},
                    { move: :CRUNCH,
                      price: { type: :Item, item: :YELLOWSHARD, amount: 4 }},
                    { move: :BLAZEKICK,
                      price: { type: :Item, item: :REDSHARD, amount: 4 }}]
      },
      marvin: { 
        messages: {
          speech: "MARVIN: Marvin has moves!! Free Marvin!!",
          come_again: "MARVIN: Please pay Marvin's bail!!",
          anything_else: "MARVIN: Buy Marvin's freedom!!",

          no_items: "MARVIN: Marvin will be locked away forever!!",
          success_items: "MARVIN: Marvin is almost free!! Marvin can taste it!!"
        },
        inventory: [{ move: :SUPERFANG,
                      purchase_message: "MARVIN: Marvin says 3 Reds!!",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :TRICK,
                      purchase_message: "MARVIN: Marvin says 3 Blues!!",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :DUALCHOP,
                      purchase_message: "MARVIN: Marvin says 3 Greens!!",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }},
                    { move: :HELPINGHAND,
                      purchase_message: "MARVIN: Marvin says 3 Yellows!!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }},
                    { move: :GIGADRAIN,
                      purchase_message: "MARVIN: Marvin says 3 Yellows!!",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 3 }},
                    { move: :SYNTHESIS,
                      purchase_message: "MARVIN: Marvin says 3 Greens!!",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }},
                    { move: :MAGNETRISE,
                      purchase_message: "MARVIN: Marvin says 3 Blues!!",
                      price: { type: :Item, item: :BLUESHARD, amount: 3 }},
                    { move: :UPROAR,
                      purchase_message: "MARVIN: Marvin says 3 Reds!!",
                      price: { type: :Item, item: :REDSHARD, amount: 3 }},
                    { move: :TELEKINESIS,
                      purchase_message: "MARVIN: Marvin says 3 Greens!!",
                      price: { type: :Item, item: :GREENSHARD, amount: 3 }}]
      },
      macbeth: {
        messages: {
          speech: "<fn=Garufan>MACBETH: I'M GOING TO CAST A SPELL ON YOU.</fn>",
          come_again: "<fn=Garufan>MACBETH: HOCUS POCUS!</fn>",
          anything_else: "<fn=Garufan>MACBETH: ABRACADABRA...</fn>",

          no_items: "<fn=Garufan>MACBETH: DIE!</fn>",
          success_items: "<fn=Garufan>MACBETH: GOOD FORTUNE UPON YOU!.</fn>"
        },
        inventory: [{ move: :COSMICPOWER,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! FIVE YELLOW!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Yellow.)</fn>",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 5 }},
                    { move: :LEAFBLADE,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! FIVE GREEN!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Green.)</fn>",
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }},
                    { move: :TOXICSPIKES,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! SIX BLUE!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Six Blue.)</fn>",
                      price: { type: :Item, item: :BLUESHARD, amount: 6 }},
                    { move: :AURASPHERE,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! SIX RED!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Six Red.)</fn>",
                      price: { type: :Item, item: :REDSHARD, amount: 6 }},
                    { move: :HEAVYSLAM,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! SIX BLUE!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Six Blue.)</fn>",
                      price: { type: :Item, item: :BLUESHARD, amount: 6 }},
                    { move: :HEATCRASH,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! FIVE RED!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Red.)</fn>",
                      price: { type: :Item, item: :REDSHARD, amount: 5 }},
                    { move: :GUNKSHOT,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! FIVE GREEN!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Green.)</fn>",
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }},
                    { move: :POLLENPUFF,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! FIVE GREEN!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Green.)</fn>",
                      price: { type: :Item, item: :GREENSHARD, amount: 5 }},
                    { move: :TERRAINPULSE,
                      purchase_message: "<fn=Garufan>MACBETH: ALAKAZAM! SIX YELLOW!</fn><fn=#{MessageConfig.pbGetSystemFontName}> (Five Yellow.)</fn>",
                      price: { type: :Item, item: :YELLOWSHARD, amount: 5 }}]
      },
      doxie: {
        messages: {
          speech: "DOXIE: (Give me your Black Prisms!)",
          come_again: "",
          anything_else: "\\se[802Cry:80:100]DOXIE: (Give me your Black Prisms!)",

          choose_quantity: "\\se[802Cry:80:100]DOXIE: {1}? How many?",
          purchase_quantity: "I will take {3} for {1} {2}. Is ok?",

          no_items: "DOXIE: Not enough!",
          success_items: "DOXIE: Okie."
        },
        inventory: [{ item: :GREENSHARD, quantity: 10,
                      price: { type: :Item, item: :BLKPRISM, amount: 3 }},
                    { item: :REDSHARD, quantity: 10,
                      price: { type: :Item, item: :BLKPRISM, amount: 3 }},
                    { item: :BLUESHARD, quantity: 10,
                      price: { type: :Item, item: :BLKPRISM, amount: 3 }},
                    { item: :YELLOWSHARD, quantity: 10,
                      price: { type: :Item, item: :BLKPRISM, amount: 3 }},
                    { item: :NUGGET, quantity: 4,
                      price: { type: :Item, item: :BLKPRISM, amount: 5 }},
                    { item: :PEARLSTRING, quantity: 3,
                      price: { type: :Item, item: :BLKPRISM, amount: 8 }},
                    { item: :CELLIMPRINT, quantity: 2,
                      price: { type: :Item, item: :BLKPRISM, amount: 10 }},
                    { item: :GLITTERBALL, quantity: 3,
                      price: { type: :Item, item: :BLKPRISM, amount: 15 }}]
      },
      doxine: {
        messages: {
          speech: "DOXINE: We sell rare Pokemon found fresh in desert!",
          come_again: "DOXINE: Maybe! Maybe!",
          anything_else: "DOXINE: Are you interested? It is rare!",

          choose_quantity: "\\se[802Cry:80:100]DOXIE: {1}? How many?",
          purchase_quantity: "I will take {3} for {1} {2}. Is ok?",

          no_items: "DOXINE: NOT ENOUGH! NOT ENOUGH!",
          success_items: "DOXINE: Wee! A deal has been made! Take it!"
        },
        inventory: [{ pokemon: :JANGMOO, level: 30, form: 1, move: [:BREAKINGSWIPE, :BULLDOZE], name: "A-Jangmo-o",
                      price: { type: :Item, item: :BLKPRISM, amount: 13 },
                      var: [1, 1]}]
      }
    },
    NIGHTMARE: {
      converter: {
        messages: {
          speech: "CLERK: Hey. Convert currency? I hear it's really fun...",
          come_again: "CLERK: Sksk, okay bye!",
          anything_else: "CLERK: Any more...?",

          choose_quantity: "CLERK: And how many {1}?",
          purchase_quantity: "CLERK: {2} {1} will be {3}...",

          full_puppet: "CLERK: You're so full of coins, though...",

          no_coins: "CLERK: NOT ENOUGH. NOT ENOUGH!",
          success_coins: "CLERK: Excellent, here are your Puppet Coins..."
        },
        inventory: [{ puppet: 500,
                      price: { type: :Coins, amount: 1000 }},
                    { puppet: 3500,
                      price: { type: :Coins, amount: 5000 }},
                    { puppet: 8500,
                      price: { type: :Coins, amount: 10000 }}]
      }
    }
  }

  CAIRO_SHOP = [
    { item: :JOYSCENT,
      price: { type: :Money, amount: 5000 },
      quantity: 10},
    { item: :EXCITESCENT,
      price: { type: :Money, amount: 8500 },
      quantity: 10},
    { item: :VIVIDSCENT,
      price: { type: :Money, amount: 11000 },
      quantity: 10},
    { item: :RIFTFRAGMENT,
      price: { type: :Money, amount: 4956 },
      quantity: 5},

    { item: :BIKEV,
      price: { type: :RedEssence, amount: 250 },
      condition: { switch: :Gym_15, is: false },
      switch: :BikeVoucher},
    { item: :BIKEV,
      price: { type: :RedEssence, amount: 500 },
      condition: { switch: :Gym_15, is: true },
      switch: :BikeVoucher},

    { item: :NOCCREST,
      price: { type: :RedEssence, amount: 2000 },
      switch: :NoctowlCrest},
    { item: :SAGECREST,
      price: { type: :RedEssence, amount: 2000 },
      switch: :SimisageCrest},
    { item: :SEARCREST,
      price: { type: :RedEssence, amount: 2000 },
      switch: :SimisearCrest},
    { item: :POURCREST,
      price: { type: :RedEssence, amount: 2000 },
      switch: :SimipourCrest},

    { item: :LUXCREST,
      price: { type: :RedEssence, amount: 5000 },
      condition: { switch: :Gym_8, is: true },
      switch: :LuxrayCrest},
    { item: :DRUDDICREST,
      price: { type: :RedEssence, amount: 5000 },
      condition: { switch: :Gym_8, is: true },
      switch: :DruddigonCrest},
    { item: :THIEVCREST,
      price: { type: :RedEssence, amount: 5000 },
      condition: { switch: :Gym_8, is: true },
      switch: :ThievulCrest},
    { item: :SAMUCREST,
      price: { type: :RedEssence, amount: 5000 },
      condition: { switch: :Gym_8, is: true },
      switch: :SamurottCrest},

    { item: :BOLTCREST,
      price: { type: :RedEssence, amount: 9000 },
      condition: { switch: :Gym_13, is: true },
      switch: :BoltundCrest},
    { item: :PROBOCREST,
      price: { type: :RedEssence, amount: 9000 },
      condition: { switch: :Gym_13, is: true },
      switch: :ProbopassCrest},
    { item: :SWACREST,
      price: { type: :RedEssence, amount: 9000 },
      condition: { switch: :Gym_13, is: true },
      switch: :SwalotCrest},
    { item: :CINCCREST,
      price: { type: :RedEssence, amount: 9000 },
      condition: { switch: :Gym_13, is: true },
      switch: :CinccinoCrest},

    { item: :DELCREST,
      price: { type: :RedEssence, amount: 14000 },
      condition: { switch: :Gym_15, is: true },
      switch: :DelcattyCrest},
  ]
  
  GAME_CORNER = {
    tms: [
      { item: :TM70,
        price: { type: :Coins, amount: 1000 },
        switch: :TM70},
      { item: :TM10,
        price: { type: :Coins, amount: 5000 },
        switch: :TM10}
    ],
    gearenPokemon: [
      { pokemon: :SEEL, move: :STOCKPILE,
        price: { type: :Coins, amount: 1000 }},
      { pokemon: :SPOINK, move: :FUTURESIGHT,
        price: { type: :Coins, amount: 4000 }},
      { pokemon: :MARACTUS, move: :SPIKES,
        price: { type: :Coins, amount: 5000 }},
      { pokemon: :HELIOPTILE, move: :GLARE,
        price: { type: :Coins, amount: 6500 }}
    ],
    ap: [
      [{ item: :GOLDENAXE,
         price: { type: :AP, amount: 10 }},
       { item: :GOLDENHAMMER,
         price: { type: :AP, amount: 10 }},
       { item: :GOLDENLANTERN,
         price: { type: :AP, amount: 10 }},
       { item: :GOLDENSURFBOARD,
         price: { type: :AP, amount: 15 }},
       { item: :GOLDENGAUNTLET,
         price: { type: :AP, amount: 15 }},
       { item: :GOLDENSCUBAGEAR,
         price: { type: :AP, amount: 15 }},
       { item: :GOLDENWINGS,
         price: { type: :AP, amount: 20 }},
       { item: :GOLDENJETPACK,
         price: { type: :AP, amount: 20 }},
       { item: :GOLDENDRIFTBOARD,
         price: { type: :AP, amount: 20 }},
       { item: :GOLDENCLAWS,
         price: { type: :AP, amount: 20 }},
       { item: :EXPALL,
         price: { type: :AP, amount: 30 },
         condition: proc { !$PokemonBag.pbHasItem?(:EXPALLOFF) },
         switch: :Exp_All_On },
       { item: :HPCARD,
         price: { type: :AP, amount: 10 }},
       { item: :ATKCARD,
         price: { type: :AP, amount: 10 }},
       { item: :DEFCARD,
         price: { type: :AP, amount: 10 }},
       { item: :SPATKCARD,
         price: { type: :AP, amount: 10 }},
       { item: :SPDEFCARD,
         price: { type: :AP, amount: 10 }},
       { item: :SPEEDCARD,
         price: { type: :AP, amount: 10 }},
       { item: :TM56,
         price: { type: :AP, amount: 5 },
         condition: { switch: :Gym_4, is: true },
         switch: :TM56},
       { item: :TM47,
         price: { type: :AP, amount: 5 },
         condition: { switch: :Gym_4, is: true },
         switch: :TM47},
       { item: :ABILITYCAPSULE,
         price: { type: :AP, amount: 3 }},
       { item: :PPUP,
         price: { type: :AP, amount: 6 }}],

      [{ item: :SERIOUSMINT,
         price: { type: :AP, amount: 3 }},
       { item: :LONELYMINT,
         price: { type: :AP, amount: 3 }},
       { item: :ADAMANTMINT,
         price: { type: :AP, amount: 3 }},
       { item: :NAUGHTYMINT,
         price: { type: :AP, amount: 3 }},
       { item: :BRAVEMINT,
         price: { type: :AP, amount: 3 }},
       { item: :BOLDMINT,
         price: { type: :AP, amount: 3 }},
       { item: :IMPISHMINT,
         price: { type: :AP, amount: 3 }},
       { item: :LAXMINT,
         price: { type: :AP, amount: 3 }},
       { item: :RELAXEDMINT,
         price: { type: :AP, amount: 3 }},
       { item: :MODESTMINT,
         price: { type: :AP, amount: 3 }},
       { item: :MILDMINT,
         price: { type: :AP, amount: 3 }}, 
       { item: :RASHMINT,
         price: { type: :AP, amount: 3 }},
       { item: :QUIETMINT,
         price: { type: :AP, amount: 3 }},
       { item: :CALMMINT,
         price: { type: :AP, amount: 3 }},
       { item: :GENTLEMINT,
         price: { type: :AP, amount: 3 }},
       { item: :CAREFULMINT,
         price: { type: :AP, amount: 3 }},
       { item: :SASSYMINT,
         price: { type: :AP, amount: 3 }},
       { item: :TIMIDMINT,
         price: { type: :AP, amount: 3 }},
       { item: :HASTYMINT,
         price: { type: :AP, amount: 3 }},
       { item: :JOLLYMINT,
         price: { type: :AP, amount: 3 }},
       { item: :NAIVEMINT,
         price: { type: :AP, amount: 3 }}]
    ],
    gdcPokemon: [
      { pokemon: :ROOKIDEE,
        price: { type: :Coins, amount: 3000 }},
      { pokemon: :MIENFOO, move: :KNOCKOFF,
        price: { type: :Coins, amount: 4000 }},
      { pokemon: :DURANT, move: :BATONPASS,
        price: { type: :Coins, amount: 7500 }},
      { pokemon: :AXEW, move: :NIGHTSLASH,
        price: { type: :Coins, amount: 9000 }}
    ]
  }

  VENDORS = {
    19 => { # Neo East Gearen
      14 => [ # Girl
        [:Script, 'ComplexMartSpecifiers.mart(:NEO_EAST_GEAREN,:girl)']
      ],
      15 => [ # Guy
        [:ConditionalBranch, :Script, '!ComplexMartSpecifiers.mart(:NEO_EAST_GEAREN,:guy)'],
          [:ShowText, "I'm going to die..."],
        :Done
      ],
      43 => [ # Corsola
        [:ConditionalBranch, :Script, '!ComplexMartSpecifiers.mart(:NEO_EAST_GEAREN,:corsola)'],
          [:PlaySoundEvent, '222Cry', 100, 125],
          [:ScreenShake, 5, 5, 5],
          [:SetMoveRoute, :This, [false,
            :SetIntangible,
            [:MoveSpeed, 5],
            :MoveForward,
            [:PlaySound, 'PRSFX- Mega Punch1'],
            [:Wait, 1],
            :MoveBackward,
            [:MoveSpeed, 3],
            :SetTangible,
            :Done]],
          :WaitForMovement,
          [:ShowText, "CORSOLA: CORSA!!! (WASTE MY TIME?! GET THROAT CHOPPED!)"],
          [:Script, "pbFieldDamage"],
          [:ShowText, "You took damage!"],
        :Done
      ]
    },
    28 => { # Festival Plaza
      37 => [ # Pledge tutor
        [:Script, 'ComplexMartSpecifiers.mart(:FESTIVAL_PLAZA,:pledge)']
      ],
      38 => [ # Punch tutor
        [:Script, 'ComplexMartSpecifiers.mart(:FESTIVAL_PLAZA,:punch)']
      ],
      39 => [ # Chapter 14+ tutor
        [:Script, 'ComplexMartSpecifiers.mart(:FESTIVAL_PLAZA,:ch14)']
      ],
    },
    103 => { # Akuwa Town interiors
      7 => [ # Punch tutor
        [:Script, 'ComplexMartSpecifiers.mart(:AKUWA_TOWN,:punch)']
      ],
      8 => [ # Oh Yeah tutor
        [:Script, 'ComplexMartSpecifiers.mart(:AKUWA_TOWN,:ohyeah)']
      ],
      24 => [ # Pledge tutor
        [:Script, 'ComplexMartSpecifiers.mart(:AKUWA_TOWN,:pledge)']
      ],
    },
    176 => { # ACDMC Center
      9 => [ # Fossil shop
        [:Script, 'ComplexMartSpecifiers.mart(:AKUWA_TOWN,:fossils)']
      ]
    },
    330 => { # Hiyoshi City
      94 => [ # Move Tutor
        [:Script, 'ComplexMartSpecifiers.mart(:HIYOSHI,:tutor)']
      ]
    },
    601 => { # Goomidra interiors
      2 => [ # Draco Meteor tutor
        [:PlaySoundEvent, '704Cry', 100, 110],
        [:ShowText, "GOOMBINA: i Know the UlTImate GOOMIDRA TECHNIQUE."],
        [:ShowText, "GoombiNa teaCh yOu goOd moVe fOr tAStieST shroOM!!"],
        [:ConditionalBranch, :Script, '!ComplexMartSpecifiers.mart(:GOOMIDRA,:meteor)'],
          [:ShowText, "GOOMBINA: GoooOOOOM!!!"],
          [:ShowText, "GOOMBINA: GoooOOOOM!!!"],
          [:ShowText, "GOOMBINA: YoU arE noOoooT WOOOoortHY!"],
        :Done
      ],
      25 => [ # Big Mushroom tutor
        [:Script, 'ComplexMartSpecifiers.mart(:GOOMIDRA,:goomatora)']
      ]
    },
    434 => { # Luck's Tent
      38 => [ # Marshie
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:marshie)']
      ], 
      39 => [ # Margo
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:margo)']
      ], 
      40 => [ # Marnie
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:marnie)']
      ], 
      41 => [ # Marlow
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:marlow)']
      ], 
      42 => [ # Marley
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:marley)']
      ], 
      43 => [ # Marvin
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:marvin)']
      ], 
      46 => [ # Macbeth
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:macbeth)']
      ],
      [53, 2] => [ # Doxine, page 2 (jangmo-o shop)
        [:ControlVariable, 1, :[]=, :Constant, 0],
        [:ConditionalBranch, :Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT,:doxine)'],
          [:ShowText, "DOXINE: Thank you for patronage! Thank you! Contract complete!"],
          [:CallCommonEvent, 110], # QuestComplete! (norm)
          [:Script, "completeQuest(:PoisonLuck)"],
          [:CallCommonEvent, 109], # QuestCompleteRem
          [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 20],
          [:Wait, 20],
          [:ControlVariable, :QuestLuckPoison, :[]=, :Constant, 4],
          [:ChangeScreenColorTone, Tone.new(-21,-21,-21,0), 20],
          [:Wait, 20],
        :Done
      ]
    },
    85 => { # Nightmare Toy Box
      36 => [ # Currency Converter
        [:Script, 'ComplexMartSpecifiers.mart(:NIGHTMARE,:converter)']
      ]
    }
  }


  def self.pbCairoMart
    ComplexMartInterface.pbComplexMart(CAIRO_SHOP, true, true, {
      speech: $game_variables[:RedEssence] > 0 ? "CAIRO: I see that you have Red Essence.\nLet's see what we got." : "CAIRO: Well met. I see you made it to my humble abode.",
      come_again: "CAIRO: Darkness need not hide from me. I will find it no matter what.",
      anything_else: "CAIRO: Is that all?",

      no_money: "CAIRO: No money.",
      no_re: "CAIRO: Not enough! I can't do anything with this amount.",

      purchase_important: "CAIRO: Very well. That will be {2}.",
      choose_quantity: "CAIRO: {1}? How many?",
      purchase_quantity: "CAIRO: {2} {1}s.\nThat will be {3}.",

      full_item: "CAIRO: Your bag is full. Absurd.",

      success_money: "CAIRO: Hmph.",
      success_re: "CAIRO: You've earned it."
    })
  end

  def self.mart(location, key, hasPicture=false, clampBottom=false)
    return ComplexMartInterface.vendorComplexMart(VENDOR_DATA[location][key], hasPicture, clampBottom)
  end

  def self.coins(mapid)
    if mapid == 85
      messages = {
        speech: "CLERK: Would you like to buy some coins?",
        come_again: "CLERK: ...",
        anything_else: "CLERK: Would you like to buy some coins?",

        choose_quantity: "CLERK: And how many {1}...",
        purchase_quantity: "CLERK: {2} {1}... {3}...",

        full_coins: "CLERK: Your Coin Case is too full...",

        no_money: "CLERK: No cash, no service...",

        success_money: "CLERK: Thank you..."
      }
    else
      messages = {
        speech: "Would you like to buy some coins?",
        come_again: "Enjoy the games!",
        anything_else: "Would you like to buy some coins?",

        choose_quantity: "And how many {1} would you like?",
        purchase_quantity: "You want {2} {1}. That'll be {3}. OK?",

        no_money: "I'm afraid you don't have the cash. Please come back soon!",

        success_money: "Thank you very much!"
      }
    end

    return ComplexMartInterface.pbComplexMart([{coins: 50, price: { type: :Money, amount: 1000 }}], false, false, messages)
  end
end

def gameCornerShop(index)
  case index
  when 0
    ComplexMartInterface.pbComplexMart(ComplexMartSpecifiers::GAME_CORNER[:tms], false, false, {
      speech: "We exchange your coins for prizes."
    })
  when 1
    ComplexMartInterface.pbComplexMart(ComplexMartSpecifiers::GAME_CORNER[:gearenPokemon], false, false, {
      speech: "We exchange your coins for prizes."
    })
  when 2
    ComplexMartInterface.pbMultiComplexMart(ComplexMartSpecifiers::GAME_CORNER[:ap], [_INTL("AP Shop"), _INTL("Mint Shop")], false, false, {
      speech: "We exchange your achievement points for prizes."
    })
  when 3
    ComplexMartInterface.pbComplexMart(ComplexMartSpecifiers::GAME_CORNER[:gdcPokemon], false, false, {
      speech: "We exchange your coins for prizes."
    })
  end
end

InjectionHelper.defineMapPatch(-1) { |map, mapid|
  if ComplexMartSpecifiers::VENDORS[mapid]
    for evtid, script in ComplexMartSpecifiers::VENDORS[mapid]
      if evtid.is_a?(Array)
        patchTarget = map.events[evtid[0]].pages[evtid[1]-1]
      else
        patchTarget = map.events[evtid]
      end
      patchTarget.patch(:complexmart) { |page|

        textMatches = !page.lookForAll([:ShowText, /\\ch\[/]).empty? || !page.lookForAll([:ShowTextContinued, /\\ch\[/]).empty?

        unless textMatches
          choiceMatches = page.lookForAll([:ShowChoices, nil, nil])
          for insn in choiceMatches
            choiceIdx = page.idxOf(insn)
            insertIdx = choiceIdx - 1
            while insertIdx > 0 && page[insertIdx].command == :ShowTextContinued
              insertIdx -= 1
            end
            if insertIdx >= 0 && page[insertIdx].command == :ShowText
              textMatches = true
              break
            end
          end
        end

        page.insertAtStart(*script, :ExitEventProcessing) if textMatches
      }
    end
  end
}


[[85, 35], [230, 58], [260, 29]].each { |mapid, evtid| # Coin sellers in Nightmare Toy Box, Chrisola Hotel, and GDC Arcade
  InjectionHelper.defineMapPatch(mapid, evtid) { |event|
    event.patch(:coin_seller_interface) { |page|
      matched = page.lookForSequence([:ShowText, /^Coins can be purchased at 50 for \$1000/])
      if matched
        page.insertBefore(matched,
          [:Script, "ComplexMartSpecifiers.coins(#{mapid})"],
          :ExitEventProcessing)
      end
    }
  }
}

InjectionHelper.defineMapPatch(434, 28) { |event| # Doxie
  event.patch(:cairo_shop_interface) { |page|
    matched = page.lookForSequence([:ShowText, /^DOXIE: \(Give me your Black Prisms!\)/])
    labelLoc = page.lookForSequence([:MovePicture, 5, 3, 0, :Constant, -150, 0, 100, 100, 0, 0])

    if matched && labelLoc
      page.insertBefore(matched,
        [:Script, 'ComplexMartSpecifiers.mart(:LUCK_TENT, :doxie, true)'],
        [:JumpToLabel, 'Exit shop'])
      page.insertBefore(labelLoc,
        [:Label, 'Exit shop'])
    end
  }
}

InjectionHelper.defineMapPatch(168, 16) { |event| # Cairo
  event.patch(:cairo_shop_interface) { |page|
    if page.condition.self_switch_valid && page.condition.self_switch_ch == "A"
      matched = page.lookForSequence([:ShowText, /^CAIRO: Well met\./])

      if matched
        page.insertBefore(matched,
          [:Script, 'ComplexMartSpecifiers.pbCairoMart'],
          [:JumpToLabel, 'Exit shop'])
      end
    end
  }
}

