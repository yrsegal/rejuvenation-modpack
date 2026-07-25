# Rejuvenation Modpack

## Note

Not everything has been ported to Version 14. It is actively being worked on.

## Installation

Press the green "Code" button, "Download ZIP," then paste the contents into the patch folder, aside from the "WireUnportedMods" folder.

## Resolving name clashes

If these mods clash with any other mod names you're using, move the entire contents of this modpack to a folder named `WireModpack`, then create `0000.wiremodpack.rb` in `patch/Mods` with the following contents:

```ruby
Dir["./patch/Mods/WireModpack/*.rb"].each {|file| load File.expand_path(file) }
```

## Contents

Libraries:

- 0000.cache_injection.rb
  Allows easier cache injection.
- 0000.map_injection.rb
  Supports map injection mods.
- 0001.pcservices.rb (depends on 0000.textures.rb, ServiceIcons/)  
  Adds a "service directory" to the PC, which lets you call NPCs for various services. Also makes the Rotom Phone a Remote PC.

"Service" mods (0001.pcservices.rb)

- DayCarePCService.rb (depends on 0001.pcservices.rb)  
  Adds a service for accessing the Day-Care remotely.
- FashionPCService.rb (depends on 0001.pcservices.rb)  
  Adds a clothing-swapping service.
- FriendshipPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Spa service, which lets you instantly max out or check a Pokémon's friendship. Unlocked by entering Teila Resort.
- GenderPCService.rb (depends on 0000.formattedchoices.rb, 00001.pcservices.rb)  
  Adds a Genderswapping service, for setting Pokémon (and player) gender. Unlocked through Tale of Two Hearts.
- HealPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Field Healing service.
- HiddenPowerPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Hidden Power Changer/checker service. Unlocked by speaking to the relevant NPC in Kristiline.
- MoveRelearnerPCService.rb (depends on 0001.pcservices.rb)  
  Adds a service which allows relearning, teaching egg moves, and move deletion (always free). Free after 10 Heart Scales.
- PokeballTransferPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Pokeball Transfer service, unlocked after The Inconsistency.
- PokemonValuesPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Lab service for tweaking your Pokémon's IVs, EVs, Nature, and Ability. Each component has its own unlock requirements.
- TimeSkipPCService.rb (depends on 0001.pcservices.rb)  
  Adds a Celebi service for advancing to different times if Unreal Time is on.

Fix/hotfix mods:

- AddMissingEncounterAreas.rb (depends on 0000.injection.rb)  
  Add the missing encounter types to the Scholar's District and Route Z.
- FixForeignGiftShinyChance.rb  
  Fix non-trade gift Pokémon with foreign IDs not being boosted properly by the Shiny Charm or Shiny Contract.
- RelearnPreShadowMoves.rb  
  Shadow Pokémon regain their old moves over time, as they're supposed to.

QoL mods:

- AutoFish.rb  
  Fishing requires no timing, and always succeeds if possible.
- AutoSpeedUpBattles.rb  
  The game will always speed up at the start of battles, then return to the state it was in prior to the battle.
- BadgeCard.rb  
  Using the Badge Card will tell you how many Virtual Badges you have.
- BlacksteepleSkip.rb (depends on 0000.injection.rb)  
  Adds an NG+ skip for Blacksteeple Castle.
- DeleteEndWaits.rb (depends on 0000.injection.rb)  
  Generally remove end-of-message waits, whichcan cause you to accidentally select an option when you didn't mean to.
- FLHUDStatus.rb  
  Makes the in-menu party HUD show if a Pokémon is statused.
- ItemRadar.rb (depends on 0000.injection.rb)  
  The Itemfinder becomes a toggleable overlay rather than an item you have to use repeatedly. Also pings you when entering a map with a Zygarde Cell you haven't collected.
- ItemRestocking.rb  
  If a consumable item is used up, at the end of the battle it will be restored from your Bag if you have another copy.
- NoTMXAnimations.rb  
  Pokémon don't appear in the splash screen when using an HM or similar move.
- ShiftToScent.rb  
  Holding shift overrides your spice scent with 0200.
- ShowMallStamps.rb (depends on 0000.injection.rb)  
  Somniam Mall shops show their Stamp requirements.
- ZygardeCaffeine.rb  
  Zygarde Cells become indifferent to time of day.

Other mods:

- AnaAlts.rb (depends on Graphics/)  
  Changes some of Ana's sprites to focus on the Legacy Ana appearance instead.
- AshGreninja.rb (depends on Graphics/)  
  Adds Battle Bond and Ash-Greninja.
  - AshGreninjaEvent.rb (depends on AshGreninja.rb, 0000.injection.rb)  
    Adds an Ash boss fight in Neo Gearen which rewards you with Battle Bond Greninja.
- AxelOutfits.rb (depends on 0000.injection.rb, Graphics/)  
  Gives Axel's Darchlight Form and Interceptor Form full spriting.
- BoostPickupOdds.rb  
  Makes Pickup more likely (33%) to trigger after battle.
- ChatotCrest.rb (depends on 0000.injection.rb, Audio/)  
  Adds a Chatot Crest which grants additional effects on sound-based moves, adds Torment to Chatter, gives a 30% Speed boost, and sets its ability to Berserk.
- ConditionItems.rb (depends on 0000.injection.rb, Graphics/)  
  Adds items which cause status conditions.
- DarkCutsceneAna.rb (depends on 0000.injection.rb, Graphics/)  
  Adds an Ana route to a specific cutscene.
- EncounterablePikipek.rb (depends on 0000.injection.rb)  
  Makes some Pikipek in certain maps encounterable. (It was a pet peeve, okay?)
- FriendshipCheckers.rb (depends on 0000.injection.rb)  
  Adds friendship checker NPCs to the two salons that don't have them.
- GDCCentralReputationPillars.rb (depends on 0000.injection.rb)  
  Makes the GDC Central Pillars able to check your reputation (like the game tells you they can).
- MeggChoices.rb (depends on 0000.injection.rb)  
  Mystery Eggs give you a chance to choose what egg you get from them.
- MiningOverhaul.rb (depends on MiningItems.png, MiningTiles.png)  
  More items for mining! Nicer sprites, too. Also, you can keep mining after you've fully cracked the bar by spending money.
- MrLuckIsBlind.rb  
  Mr. Luck can no longer tell if you cheat.
- MusicSignpost.rb (depends on Graphics/)  
  Show music near the map signpost.
- OricorioHoldNectar.rb  
  Oricorio hold their Nectar in the wild, as in gen 9, allowing you to get Pink and Yellow Nectars (otherwise unobtainable).
- PasswordAPRefund.rb  
  If a password gives you an item you've already spent AP for, the AP gets refunded.
- ReplaceRepelInPickup.rb  
  Replaces Repel in Pickup tables, as it is effectively useless with the Spice Scent.
- RouteZHQwil.rb  
  Qwilfish on Route Z are Hisuian.
- SkipTitleSoftResets.rb  
  Skips the intro scene for soft resets, making it easier to get back into the game.
- TechniqueContractDirectly.rb (depends on 0000.injection.rb)  
  Adds a Marshadow tutor to avoid using the Technique Contract, costing 3 Black Prisms each time. Does not add the move to your CyberNav.
- TorchicEvent.rb (depends on 0000.injection.rb)  
  Makes Dyre's Torchic doll an actual Torchic event.
- WLLRiolu.rb (depends on 0000.injection.rb)  
  Adds the Where Love Lies password Riolu back into GDC Central.
- Woop Shiny
  Woop

To be ported:

- DumpSingleEvent.rb
- PartialDebugMode.rb
- ShowPosition.rb
- TileInvestigator.rb
- BetterBattleUI.rb
- FixFactoryAreas.rb
- FlyExpansion.rb
- FullOutfitOptions.rb
- LureRework.rb
- MoreSpecificGatherCube.rb
- MoveTweak.rb
- MovesetTweaks.rb
- QuicksilverImplementation.rb
- SelectFromBoxes.rb
- VendorQuantityDisplay.rb
- VoltorbFlipHelper.rb
