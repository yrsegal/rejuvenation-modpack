Rejuvenation Modpack
====================

Libraries:
- 0000.formattedchoices.rb  
  Fixes an issue with the unused "advanced-formatting" choices menu, and allows it to be used.
- 0000.injection.rb  
  Supports code injection mods.
- 0000.music.rb  
  A framework for music overrides. Currently unused.
- 0000.textures.rb  
  A framework for texture overrides, which also includes a couple misc overrides.
- 0001.boundedentry.rb (depends on 0000.textures.rb)  
  Adds "bounded" text entries, which allow you to choose from a preexisting set.
- 0001.pcservices.rb (depends on 0000.textures.rb)  
  Adds a "service directory" to the PC, which lets you call NPCs for various services. Also makes the Rotom Phone a Remote PC.

"Service" mods (0001.pcservices.rb)
- DayCarePCService.rb (depends on 0000.formattedchoices.rb, 0001.pcservices.rb)  
  Adds a service for accessing the Day-Care remotely.
- FashionPCService.rb (depends on 0001.pcservices.rb)  
  Adds a clothing-swapping service.
- FriendshipPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Spa service, which lets you instantly max out or check a pokemon's friendship. Unlocked by entering Teila Resort.
- GenderPCService.rb (depends on 0000.formattedchoices.rb, 00001.pcservices.rb,  
  Adds a Genderswapping service, for setting Pokemon (and player) gender. Unlocked through Tale of Two Hearts.
- HealPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Field Healing service.
- HiddenPowerPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Hidden Power Changer/checker service. Unlocked by speaking to the relevant NPC in Kristiline.
- MoveRelearnerPCService.rb (depends on 0001.pcservices.rb)  
  Adds a service which allows relearning, teaching egg moves, and move deletion (always free). Free after 10 Heart Scales.  
  Also fixes missing Egg Move pools and allows evolutions to learn preevo moves.
- PokeballTransferPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Pokeball Transfer service, unlocked after The Inconsistency.
- PokemonValuesPCService.rb (depends on 0000.formattedchoices.rb, 0001.pcservices.rb)  
  Adds a Lab service for tweaking your pokemon's IVs, EVs, Nature, and Ability. Each component has its own unlock requirements.
- TimeSkipPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Celebi service for advancing to different times if Unreal Time is on.

Fix/hotfix mods:
- AnaFixes.rb (depends on 0000.injection.rb, 0000.textures.rb)  
  Fixes some issues with the character Ana's sprites.
- BagReclassification.rb  
  Reclassifies some items that are improperly classified.
- BlackBoxFix.rb (depends on 0000.injection.rb)  
  Fixes some logic errors in a cutscene that leaves key items which are intended to be deleted.
- ExcludeAnimationsFromCallable.rb  
  Excludes all moves that are purely for animation purposes from being called by Metronome.
- FixBasculegionForms.rb  
  Fixes Basculegion's forms on evolution. (Currently, female basculegion does not recieve the proper icon or stats.)
- FixBlueMIC.rb (depends on 0000.injection.rb)  
  Fixes Blue Moon Ice Cream not being rarely available from certain shops as intended. (It was still possible to access, but not in the intended way.)
- FixCdAName.rb  
  Fixes an area name being displayed incorrectly.
- FixFactoryAreas.rb (depends on 0000.injection.rb)  
  Adds a field effect message to entering Oceana Pier's field-effect tutorial warehouse, and fixes damage pads not applying the proper types of damage.
- FixForeignGiftShinyChance.rb  
  Fix non-trade gift Pokémon with foreign IDs not being boosted properly by the Shiny Charm or Shiny Contract.
- FixMissingItemTextures.rb (depends on 0000.textures.rb)  
  Fixes several missing items textures.
- FixNWSilvally.rb  
  Fixes a field interaction with Silvally.
- FixProboCrest.rb  
  Fixes the silly internal name of the followup attack of the Probopass Crest from displaying.
- FixRayquazaCrash.rb  
  Fixes Rayquaza crashing the game by simple existence.
- FixSuperLuck.rb  
  Super Luck increases held item chances on wild pokemon, as it's supposed to.
- FixUnderpoweredZMoves.rb  
  Z-upgraded attacks which should have higher base power now do. Moves such as Hidden Power can be upgraded into differently typed Z-Moves.
- PrimalReversionFix.rb  
  Groudon and Kyogre don't constantly re-primal-revert each turn.
- RelearnPreShadowMoves.rb  
  Shadow Pokemon regain their old moves over time, as they're supposed to.
- Route4GlobalChange.rb  
  Makes Route 4's reset trigger work in all areas as intended.
- LabyrinthPuzzleFix.rb  
  A typo in a puzzle causes it to not select the proper type of pokemon.
- QuicksilverImplementation.rb  
  Implements the move Quicksilver Spear's effect to do what it says it does.

QoL mods:
- AutoFish.rb  
  Fishing requires no timing, and always succeeds if possible.
- AutoSpeedUpBattles.rb  
  The game will always speed up at the start of battles, then return to the state it was in prior to the battle.
- BetterBattleUI.rb  
  Show types and stat boosts visually in battle. In addition:  
  Hitting the "back" button when selecting a command in battle will move your cursor over "Run". 
  There's a keybind for Q (which is L) in wild battle to throw the last ball you've used.
  - InspectMenuBBUI.rb (depends on BetterBattleUI.rb)  
    Improves the inspect-a-pokemon menu.
  - SelectMenuBBUI.rb (depends on BetterBattleUI.rb)  
    Improves the select-a-pokemon menu.
  - MoveHelpDisplayBBUI.rb (depends on BetterBattleUI.rb)  
    Adds a move-info display controlled by the Inspect key (A).
- BoxExtensions.rb (depends on 0001.boundedentry.rb)  
  Expand the "Find" functionality of Pokemon boxes, and make Pokéballs visible from the box.
- CleanerPrismPower.rb  
  Makes a Rejuvenation-exclusive ability cleaner.
- DeleteEndWaits.rb (depends on 0000.injection.rb)  
  Generally remove end-of-message waits, whichcan cause you to accidentally select an option when you didn't mean to.
- FLHUDStatus.rb  
  Makes the in-menu party HUD show if a Pokemon is statused.
- FlyExpansion.rb  
  Makes more fly points exist, makes you able to fly to Neo areas you've been to the old versions of, and you can fly from the penthouse.
- ItemRadar.rb (depends on 0000.injection.rb)  
  The Itemfinder becomes a toggleable overlay rather than an item you have to use repeatedly. Also pings you when entering a map with a Zygarde Cell you haven't collected.
- ItemRestocking.rb  
  If a consumable item is used up, at the end of the battle it will be restored from your Bag if you have another copy.
- LRInBoxes.rb  
  L and R (or rather, Q and W, with default mappings) will shift your position in the Box menu. This works even when holding a Pokemon.
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
- TrueTypesInSummary.rb  
  Hidden Power, Revelation Dance, and such all display their correct type in summaries and move listings. Abilities such as Galvanize and Aerilate are also applied.
- VendorQuantityDisplay.rb (depends on 0000.injection.rb)  
  Move Tutors and other vendors will show the resources they ask for.
- ZygardeCaffeine.rb  
  Zygarde Cells become indifferent to time of day.
- ZZRenBetterDialogue.rb (depends on 0000.injection.rb)  
  Fix some deliberately poorly formatted dialogue from being unintentionally poorly formatted.

Other mods:
- AevianLarvestaEgg.rb (depends on 0000.textures.rb, 0000.injection.rb)  
  Adds an Aevian Larvesta egg to the Rose Theatre post Badge 13.
- AshGreninja.rb (depends on 0000.textures.rb)  
  Adds Battle Bond and Ash-Greninja.
  - AshGreninjaFight.rb (depends on AshGreninja.rb)  
    Adds an Ash boss fight in Neo Gearen which rewards you with Battle Bond Greninja.
- BoostPickupOdds.rb  
  Makes Pickup more likely (33%) to trigger after battle.
- ConditionItems.rb (depends on 0000.injection.rb, 0000.textures.rb)  
  Adds items which cause status conditions.
- DarchlightTrainerSprites.rb (depends on 0000.textures.rb)  
  Adds some relevant sprites to the Darchlight Caves segment.
- DarkCutsceneAna.rb (depends on 0000.injection.rb)  
  Adds an Ana route to a specific cutscene.
- EncounterablePikipek.rb (depends on 0000.injection.rb)  
  Makes some Pikipek in certain maps encounterable. (It was a pet peeve, okay?)
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
  - Teleport acts as in Gen 8, as a switching move with -6 priority.
- MrLuckIsBlind.rb  
  Mr. Luck can no longer tell if you cheat.
- MusicSignpost.rb *(experimental)* (depends on 0000.textures.rb)  
  Show music near the map signpost.
- OricorioHoldNectar.rb  
  Oricorio hold their Nectar in the wild, as in gen 9, allowing you to get Pink and Yellow Nectars (otherwise unobtainable).
- PasswordAPRefund.rb  
  If a password gives you an item you've already spent AP for, the AP gets refunded.
- PasswordOptions.rb (depends on 0000.injection.rb)  
  Expands the Password menu in the intro to give you much more info when enabling passwords.
- ReplaceRepelInPickup.rb  
  Replaces Repel in Pickup tables, as it is effectively useless with the Spice Scent.
- SkipTitleSoftResets.rb  
  Skips the intro scene for soft resets, making it easier to get back into the game.
- TorchicEvent.rb (depends on 0000.injection.rb)  
  Makes Dyre's Torchic doll an actual Torchic event.
- WLLRiolu.rb (depends on 0000.injection.rb)  
  Adds the Where Love Lies password Riolu back into GDC Central.
