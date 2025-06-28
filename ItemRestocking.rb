class PokeBattle_Battler

  attr_accessor :restocking_consumedItem

  alias :restocking_old_pbDisposeItem :pbDisposeItem

  def pbDisposeItem(*args, **kwargs)
    itemToCheck = self.item
    itemToCheck = nil if itemToCheck != self.pokemon.itemInitial

    ret = restocking_old_pbDisposeItem(*args, **kwargs)

    if itemToCheck && (restocking_consumedItem == itemToCheck || $PokemonBag.pbQuantity(itemToCheck) > 0)
      $PokemonBag.pbDeleteItem(itemToCheck) unless restocking_consumedItem
      restocking_consumedItem = true
      self.pokemon.itemInitial = itemToCheck
    end

    return ret
  end
end
