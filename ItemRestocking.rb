class PokeBattle_Battle
  alias :restocking_old_pbEndOfBattle :pbEndOfBattle

  def pbEndOfBattle(*args, **kwargs)
    for i in $Trainer.party
      itemToCheck = i.itemReallyInitialHonestlyIMeanItThisTime
      if !itemToCheck.nil? && $PokemonBag.pbQuantity(itemToCheck) > 0 && i.itemInitial.nil?
        $PokemonBag.pbDeleteItem(itemToCheck)
        i.itemInitial = itemToCheck
      end
    end
    return restocking_old_pbEndOfBattle(*args, **kwargs)
  end

end
