class PokeBattle_Move_0F1 < PokeBattle_Move

  if !defined?(evenWithItem_old_pbEffect)
    alias :evenWithItem_old_pbEffect :pbEffect
  end

  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if !@battle.pbIsWild?
      return evenWithItem_old_pbEffect(attacker,opponent,hitnum,alltargets,showanimation)
    end

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

class PokeBattle_Battler
  if !defined?(evenWithItem_old_pbEffectsOnDealingDamage)
    alias :evenWithItem_old_pbEffectsOnDealingDamage :pbEffectsOnDealingDamage
  end

  def pbEffectsOnDealingDamage(move,user,target,damage,innards)
    if !@battle.pbIsWild? || target.nil?
      return evenWithItem_old_pbEffectsOnDealingDamage(move,user,target,damage,innards)
    end

    tochange = nil
    if user.ability == :MAGICIAN
      tochange = user
    elsif target.ability == :PICKPOCKET && !@battle.opponent && !@battle.pbIsOpposing?(target.index)
      tochange = target
    end

    return evenWithItem_old_pbEffectsOnDealingDamage(move,user,target,damage,innards) if tochange.nil?

    initialItem = tochange.pokemon.itemInitial
    veryInitialItem = tochange.pokemon.itemReallyInitialHonestlyIMeanItThisTime
    currItem = tochange.item
    tochange.pokemon.itemInitial = nil
    tochange.pokemon.itemReallyInitialHonestlyIMeanItThisTime = nil
    tochange.item = nil

    ret = evenWithItem_old_pbEffectsOnDealingDamage(move,user,target,damage,innards)

    if tochange.pokemon.itemInitial
      if $PokemonBag.pbCanStore?(tochange.pokemon.itemInitial)
        $PokemonBag.pbStoreItem(tochange.pokemon.itemInitial)
      end
    end

    tochange.pokemon.itemInitial = initialItem
    tochange.pokemon.itemReallyInitialHonestlyIMeanItThisTime = veryInitialItem
    tochange.item = currItem if currItem

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