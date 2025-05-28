Rejuvenation Modpack
====================

Libraries:
- 0000.formattedchoices.rb  
  Fixes an issue with the unused "advanced-formatting" choices menu, and allows it to be used.
- 0000.injection.rb  
  Supports code injection mods.
- 0000.textures.rb  
  A framework for texture overrides, which also includes a couple misc overrides.
- 0001.pcservices.rb (depends on 0000.textures.rb)  
  Adds a "service directory" to the PC, which lets you call NPCs for various services. Also makes the Rotom Phone a Remote PC.

"Service" mods (0001.pcservices.rb)
- DayCarePCService.rb (depends on 0000.formattedchoices.rb, 0001.pcservices.rb, 0000.textures.rb)  
  Adds a service for accessing the Day-Care remotely.
- FashionPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a clothing-swapping service.
- FriendshipPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Spa service, which lets you instantly max out or check a pokemon's friendship. Unlocked by entering Teila Resort.
- GenderPCService.rb (depends on 0000.formattedchoices.rb, 00001.pcservices.rb, 0000.textures.rb)  
  Adds a Genderswapping service, for setting Pokemon (and player) gender. Unlocked through Tale of Two Hearts.
- HealPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Field Healing service.
- HiddenPowerPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Hidden Power Changer/checker service. Unlocked by speaking to the relevant NPC in Kristiline.
- MoveRelearnerPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a service which allows relearning, teaching egg moves, and move deletion (always free). Free after 10 Heart Scales.  
  Also fixes missing Egg Move pools and allows evolutions to learn preevo moves.
- PokeballTransferPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Pokeball Transfer service, unlocked after The Inconsistency.
- PokemonValuesPCService.rb (depends on 0000.formattedchoices.rb, 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Lab service for tweaking your pokemon's IVs, EVs, Nature, and Ability. Each component has its own unlock requirements.
- TimeSkipPCService.rb (depends on 0001.pcservices.rb, 0000.textures.rb)  
  Adds a Celebi service for advancing to different times if Unreal Time is on.

Fix/hotfix mods:
- AnaFixes.rb (depends on 0000.injection.rb, 0000.textures.rb)  
  Fixes some issues with the character Ana's sprites.
- BagReclassification.rb  
  Reclassifies some items that are improperly classified.
- FixBasculegionForms.rb  
  Fixes Basculegion's forms on evolution. (Currently, female basculegion does not recieve the proper icon or stats.)
- FixBlueMIC.rb (depends on 0000.injection.rb)  
  Fixes Blue Moon Ice Cream not being rarely available from certain shops as intended. (It was still possible to access, but not in the intended way.)
- FixCdAName.rb  
  Fixes an area name being displayed incorrectly.
- FixMissingItemTextures.rb (depends on 0000.textures.rb)  
  Fixes several missing items textures.
- FixNWSilvally.rb  
  Fixes a field interaction with Silvally.
- FixSuperLuck.rb  
  Super Luck increases held item chances on wild pokemon, as it's supposed to.
- Route4GlobalChange.rb  
  Makes Route 4's reset trigger work in all areas as intended.
- KingleriteHotfix.rb  
  The Kinglerite crashes the game to pick up. This fixes that.
- LabyrinthPuzzleFix.rb  
  A typo in a puzzle causes it to not select the proper type of pokemon.

QoL mods:
- AutoFish.rb  
  Fishing requires no timing, and always succeeds if possible.
- BetterBattleUI.rb  
  Show types and stat boosts visually in battle.
- CleanerPrismPower.rb  
  Makes a Rejuvenation-exclusive ability cleaner.
- HiddenPowerInSummary.rb  
  Hidden Power, Revelation Dance, and such all display their correct type in summaries and move listings.
- ItemRadar.rb (depends on 0000.injection.rb)  
  The Itemfinder becomes a toggleable overlay rather than an item you have to use repeatedly. Also pings you when entering a map with a Zygarde Cell you haven't collected.
- LureRework.rb  
  The Mirror Lure lets you run always, like it says it does. The Magnetic Lure becomes a toggleable key item.
- MoreSpecificGatherCube.rb  
  The Gather Cube tells you how many Cells you've picked up from each region of Aevium.
- NoTMXAnimations.rb  
  Pokemon don't appear in the splash screen when using an HM or similar move.
- SelectFromBoxes.rb *(experimental)* (depends on 0000.injection.rb)  
  Makes all instances of choosing a pokemon from your party use your boxes and party instead.
- ShiftToScent.rb  
  Holding shift overrides your spice scent with 0200.
- ShowMallStamps.rb (depends on 0000.injection.rb)  
  Somniam Mall shops show their Stamp requirements.
- ThiefAndPickupEvenWithItem.rb  
  Thief/Covet, Pickup, Pickpocket, and Magician work even if the user is holding an item in wild battles, and items stolen by these effects are deposited directly into the bag at the end of those battles.
- VendorQuantityDisplay.rb (depends on 0000.injection.rb)  
  Move Tutors and other vendors will show the resources they ask for.
- XOverRun.rb  
  Hitting the "back" button when selecting a command in battle will move your cursor over "Run".
- ZygardeCaffeine.rb  
  Zygarde Cells become indifferent to time of day.


Other mods:
- DarchlightTrainerSprites.rb (depends on 0000.textures.rb)  
  Adds some relevant sprites to the Darchlight Caves segment.
- DarkCutsceneAna.rb  
  Adds an Ana route to a specific cutscene.
- FullOutfitOptions.rb (depends on 0000.injection.rb)  
  You get full options for outfits, and they're supported a little more in cutscenes. This does not add sprites for them, and the only character given spritework currently for this is Ana.
- GDCCentralReputationPillars.rb (depends on 0000.injection.rb)  
  Makes the GDC Central Pillars able to check your reputation (like the game tells you they can).
- MiningOverhaul.rb  
  More items for mining! Nicer sprites, too. Also, you can keep mining after you've fully cracked the bar by spending money.
- MoveTweak.rb  
  A few tweaks to moves. Specifically:
  - Splintered Stormshards destroys terrain, replacing it with temporary Rocky Field.
  - Cut becomes a 65/100 Steel move with high crit rate.
  - Flash becomes a 25/100 Electric special spread move that still lowers accuracy.
  - Rock Smash becomes a 55 BP move that always lowers defense.
  - Rock Climb becomes an 80/100 Rock move with a 10% chance to confuse.
  - Strength becomes a Fighting move.
  - Covet becomes a Fairy move.
  - Play Rough becomes 100% accurate.
  - Air Slash becomes 100% accurate.
  - Fly becomes a 100/100 move.
- MrLuckIsBlind.rb  
  Mr. Luck can no longer tell if you cheat.
- MusicSignpost.rb *(experimental)*  
  Show music near the map signpost.
- OricorioHoldNectar.rb  
  Oricorio hold their Nectar in the wild, as in gen 9, allowing you to get Pink and Yellow Nectars (otherwise unobtainable).
- PasswordAPRefund.rb  
  If a password gives you an item you've already spent AP for, the AP gets refunded.
- SkipTitleSoftResets.rb  
  Skips the intro scene for soft resets, making it easier to get back into the game.
