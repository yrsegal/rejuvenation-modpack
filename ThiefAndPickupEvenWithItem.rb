class PokeBattle_Move_0F1 < PokeBattle_Move

  if !defined?(evenWithItem_old_pbEffect)
    alias :evenWithItem_old_pbEffect :pbEffect
  end

  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
  	initialItem = attacker.pokemon.itemInitial
  	veryInitialItem = attacker.pokemon.itemReallyInitialHonestlyIMeanItThisTime
  	currItem = attacker.item
  	attacker.pokemon.itemInitial = nil
  	attacker.pokemon.itemReallyInitialHonestlyIMeanItThisTime = nil
  	attacker.item = nil

  	ret = evenWithItem_old_pbEffect(attacker,opponent,hitnum,alltargets,showanimation)

  	# If we stole an item in a way we're supposed to keep
  	if attacker.pokemon.itemInitial
  		if $PokemonBag.pbCanStore?(attacker.pokemon.itemInitial)
    		$PokemonBag.pbStoreItem(attacker.pokemon.itemInitial)
    	end
    end

  	attacker.pokemon.itemInitial = initialItem
  	attacker.pokemon.itemReallyInitialHonestlyIMeanItThisTime = veryInitialItem
    attacker.item = currItem if currItem
  	
  	return ret
  end
end

class Event
  attr_accessor :callbacks
end

Events.onEndBattle.callbacks.unshift proc {|sender,e|
  decision=e[0]
  if decision==1
    for pkmn in $Trainer.party
      pkmn.itemReallyInitialHonestlyIMeanItThisTime = pkmn.item
      pkmn.item = nil
    end
  end
}
Events.onEndBattle += proc {|sender,e|
  decision=e[0]
  if decision==1
    for pkmn in $Trainer.party
      pkmn.item = pkmn.itemReallyInitialHonestlyIMeanItThisTime
    end
  end
}