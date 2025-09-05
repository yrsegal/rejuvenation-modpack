begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:QuestXenogene] = 620

InjectionHelper.defineMapPatch(203) { |map| # Pokestar Studios Interiors
  torchicDoll = nil

  map.data[86,9,2] = 0 # Remove the torchic doll, so it's exclusively handled by the event

  map.createNewEvent(86, 10, "Torchic", "torchicevent_interactableevent") { |event|
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

  torchicDoll = map.createNewEvent(86, 9, "Torchic Doll", "torchicevent_torchicdoll") { |event|
    event.newPage { |page|
      page.setTile(3046) # Torchic
    }

    event.newPage { |page|
      page.requiresSelfSwitch("A")
    }
  }
}
