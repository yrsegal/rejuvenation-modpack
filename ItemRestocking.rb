class PokeBattle_Battler
  if !defined?(restocking_old_pbDisposeItem)
    alias :restocking_old_pbDisposeItem :pbDisposeItem
  end

  def pbDisposeItem(*args, **kwargs)
    itemToCheck = self.item
    itemToCheck = nil if itemToCheck != self.pokemon.itemInitial

    ret = restocking_old_pbDisposeItem(*args, **kwargs)

    if itemToCheck && $PokemonBag.pbHasItem?(self.item)
      $PokemonBag.pbDeleteItem(self.item)
      self.pokemon.itemInitial = itemToCheck
    end

    return ret
  end
end
