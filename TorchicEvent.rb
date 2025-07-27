
Variables[:QuestXenogene] = 620

InjectionHelper.defineMapPatch(203) { |map| # Pokestar Studios Interiors
  torchicDoll = nil

  map.data[86,9,2] = 0 # Remove the torchic doll, so it's exclusively handled by the event

  InjectionHelper.createNewEvent(map, 86, 10, "Torchic") { |event|
    event.newPage { |page|
      page.interact(
        [:ShowText, "It's a stuffed Torchic doll!"],
        [:ShowText, "It's warm..."])
    }

    event.newPage { |page|
      page.requiresVariable(:QuestXenogene, 72)
      page.interact(
        [:ShowText, "It's a stuffed Torchic doll!"],
        [:ShowText, "It's warm..."],
        [:PlaySoundEvent, '255Cry', 80, 100],
        [:ShowText, "TORCHIC: Torchic Tor!"],
        [:ShowAnimation, :Player, EXCLAMATION_ANIMATION_ID],
        [:ShowAnimation, 18, EXCLAMATION_ANIMATION_ID], # Dyre (visual location)
        [:Wait, 20],
        [:ShowText, "DYRE: Oh, yeah. That Torchic loves pretending to be a doll. Don't know why."],
        [:ShowText, "I've been meaning to find a home for the fella anyway. Take it, I insist!"],
        [:Script, "pbSetSelfSwitch(#{torchicDoll.id},'A',true)"],
        [:Script, "Kernel.pbAddPokemon(:TORCHIC,10)"],
        [:ControlSelfSwitch, "A", true])
    }

    event.newPage { |page|
      page.requiresSelfSwitch("A")
    }
  }

  torchicDoll = InjectionHelper.createNewEvent(map, 86, 9, "Torchic Doll") { |event|
    event.newPage { |page|
      page.setTile(3046) # Torchic
    }

    event.newPage { |page|
      page.requiresSelfSwitch("A")
    }
  }
}
