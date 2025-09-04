begin
  missing = ['0000.complexmart.rb','0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
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

module ComplexMartSpecifiers
  NEO_EAST_GEAREN_VENDORS = {
    corsola: {
      messages: {
        speech: "\\se[222Cry]CORSOLA: Corsa! (Buy something.)",
        come_again: '',
        anything_else: "\\se[222Cry]CORSOLA: Corsa! (Buy something.)",

        purchase_important: "\\se[222Cry]CORSOLA: Corsa! ({2}s.)",

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

        purchase_important: "{1} will be {2}s.",

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

        purchase_important: "{1} is very strong! {2}s!",

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
  }

  VENDORS = {
    19 => { # Neo East Gearen
      14 => [ # Girl
        [:Script, 'ComplexMartInterface.vendorComplexMart(ComplexMartSpecifiers::NEO_EAST_GEAREN_VENDORS[:girl])']
      ],
      15 => [ # Guy
        [:ConditionalBranch, :Script, '!ComplexMartInterface.vendorComplexMart(ComplexMartSpecifiers::NEO_EAST_GEAREN_VENDORS[:guy])'],
          [:ShowText, "I'm going to die..."],
        :Done
      ],
      43 => [ # Corsola
        [:ConditionalBranch, :Script, '!ComplexMartInterface.vendorComplexMart(ComplexMartSpecifiers::NEO_EAST_GEAREN_VENDORS[:corsola])'],
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
    }
  }



  # VENDORS = {
  #   19 => [14, 15, 43], # Neo East Gearen
  #   28 => [27, 37, 38, 39], # Festival Plaza
  #   103 => [7, 8, 24], # Akuwa Interiors
  #   176 => [9], # ACDMC Center
  #   330 => [94], # Hiyoshi City
  #   388 => [35, 36, 37, 38, 39], # The Underground Interiors
  #   434 => [38, 39, 40, 41, 42, 43, 46, [36, :BLKPRISM], [28, :BLKPRISM], [[53, 2], :BLKPRISM]], # Luck's Tent
  #   601 => [[2, :BALMMUSHROOM], [25, :BIGMUSHROOM]] # Goomidra Interiors
  # }

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

  def self.pbCairoMart
    ComplexMartSpecifiers.pbComplexMart(CAIRO_SHOP, true, {
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
end

InjectionHelper.defineMapPatch(-1) { |map, mapid|
  if ComplexMartSpecifiers::VENDORS[mapid]
    for evtid, script in ComplexMartSpecifiers::VENDORS[mapid]
      map.events[evtid].patch(:complexmart) { |page|

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
        next textMatches
      }
    end
  end
}

InjectionHelper.defineMapPatch(168, 16) { |event| # Cairo
  event.patch(:cairo_shop_interface) { |page|
    if page.condition.self_switch_valid && page.condition.self_switch_ch == "A"
      matched = page.lookForSequence([:ShowText, /^CAIRO: Well met\./])

      if matched
        page.insertBefore(matched,
          [:Script, 'ComplexMartSpecifiers.pbCairoMart'],
          [:JumpToLabel, 'Exit shop'])
        next true
      end
    end
  }
}

