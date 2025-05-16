Rejuvenation Modpack
====================

Libraries:
- 0000.injection.rb  
  Supports code injection mods.
- 0000.textures.rb  
  Various texture overrides: most of them are for the character Ana. Some mods expect these overrides to be present.

Individual mods:
- AnaFixes.rb (depends on 0000.injection.rb, 0000.textures.rb)  
  Fixes some issues with the character Ana's sprites.
- AutoFish.rb  
  Fishing requires no timing, and always succeeds if possible.
- BetterBattleUI.rb  
  Show types and stat boosts visually in battle.
- CleanerPrismPower.rb  
  Makes a Rejuvenation-exclusive ability cleaner.
- DarkCutsceneAna.rb  
  Adds an Ana route to a specific cutscene.
- FixBasculegionForms.rb  
  Fixes Basculegion's forms on evolution. (Currently, female basculegion does not recieve the proper icon or stats.)
- FixCdAName.rb  
  Fixes an area name being displayed incorrectly.
- FixNWSilvally.rb  
  Fixes a field interaction with Silvally.
- FixSuperLuck.rb  
  Super Luck increases held item chances on wild pokemon, as it's supposed to.
- FullOutfitOptions.rb (depends on 0000.injection.rb)  
  You get full options for outfits, and they're supported a little more in cutscenes. This does not add sprites for them, and the only character given spritework currently for this is Ana.
- HiddenPowerInSummary.rb  
  Hidden Power, Revelation Dance, and such all display their correct type in summaries and move listings.
- ItemRadar.rb  
  The Itemfinder becomes a toggleable overlay rather than an item you have to use repeatedly. Also pings you when entering a map with a Zygarde Cell you haven't collected.
- KingleriteHotfix.rb  
  The Kinglerite crashes the game to pick up. This fixes that.
- LabyrinthPuzzleFix.rb  
  A typo in a puzzle causes it to not select the proper type of pokemon.
- LearnPrevolutionAndEggMoves.rb  
  Allows relearning anywhere for free, and also adds egg moves to that pool. Fixes a few alternate forms' egg move pools.
- LureRework.rb  
  The Mirror Lure lets you run always, like it says it does. The Magnetic Lure becomes a toggleable key item.
- MiningOverhaul.rb  
  More items for mining! Nicer sprites, too. Also, you can keep mining after you've fully cracked the bar by spending money.
- MoreSpecificGatherCube.rb  
  The Gather Cube tells you how many Cells you've picked up from each region of Aevium.
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
- NoTMXAnimations.rb  
  Pokemon don't appear in the splash screen when using an HM or similar move.
- OricorioHoldNectar.rb  
  Oricorio hold their Nectar in the wild, as in gen 9, allowing you to get Pink and Yellow Nectars (otherwise unobtainable).
- PartialDebugMode.rb  
  Enables debug mode without enabling the use of HMs without their badges and prerequisites.
- SelectFromBoxes.rb *(experimental)* (depends on 0000.injection.rb)  
  Makes all instances of choosing a pokemon from your party use your boxes and party instead.
- ShiftToScent.rb  
  Holding shift overrides your spice scent with 0200.
- ThiefAndPickupEvenWithItem.rb  
  Thief/Covet, Pickup, Pickpocket, and Magician work even if the user is holding an item in wild battles, and items stolen by these effects are deposited directly into the bag at the end of those battles.
- XOverRun.rb  
  Hitting the "back" button when selecting a command in battle will move your cursor over "Run".
- ZygardeCaffeine.rb  
  Zygarde Cells become indifferent to time of day.
