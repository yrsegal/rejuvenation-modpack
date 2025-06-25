class PokeBattle_Battler
  alias :restocking_old_pbDisposeItem :pbDisposeItem

  def pbDisposeItem(*args, **kwargs)
    itemToCheck = self.item
    itemToCheck = nil if itemToCheck != self.pokemon.itemInitial

    ret = restocking_old_pbDisposeItem(*args, **kwargs)

    if itemToCheck && $PokemonBag.pbQuantity(itemToCheck) > 0
      $PokemonBag.pbDeleteItem(itemToCheck)
      self.pokemon.itemInitial = itemToCheck
    end

    return ret
  end
end
