$FREE_RESTOCKING = false

class PokeBattle_Battle
  alias :restocking_old_pbEndOfBattle :pbEndOfBattle

  def pbEndOfBattle(*args, **kwargs)
    result = restocking_old_pbEndOfBattle(*args, **kwargs)
    unless $game_switches[:NotPlayerCharacter]
      for i in $Trainer.party
        itemToCheck = @permanenteffects[i][:OriginalItem]
        if !itemToCheck.nil? && ($FREE_RESTOCKING || $PokemonBag.pbQuantity(itemToCheck) > 0) && i.item.nil?
          $PokemonBag.pbDeleteItem(itemToCheck) unless $FREE_RESTOCKING
          i.setItem(itemToCheck)
        end
      end
    end
    return result
  end

end
