class PokemonBag
  if !defined?(aprefund_old_pbStoreItem)
    alias :aprefund_old_pbStoreItem :pbStoreItem
  end

  APREFUND_AP_VALUES = {
    HPCARD: 10,
    ATKCARD: 10,
    DEFCARD: 10,
    SPEEDCARD: 10,
    SPATKCARD: 10,
    SPDEFCARD: 10,
    TM56: 5,
    TM47: 5,
    GOLDENAXE: 10,
    GOLDENHAMMER: 10,
    GOLDENLANTERN: 10,
    GOLDENSURFBOARD: 15,
    GOLDENGAUNTLET: 15,
    GOLDENSCUBAGEAR: 15,
    GOLDENWINGS: 20,
    GOLDENJETPACK: 20,
    GOLDENDRIFTBOARD: 20,
    GOLDENCLAWS: 20
  }

  def pbStoreItem(item,qty=1)
    if pbHasItem?(item) && APREFUND_AP_VALUES[item]
      $game_variables[:APPoints] += APREFUND_AP_VALUES[item] * qty
      return true
    else
      return aprefund_old_pbStoreItem(item,qty)
    end
  end
end