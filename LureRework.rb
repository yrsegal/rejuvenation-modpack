class PokemonEncounters

  def pbShouldFilterKnownPkmnFromEncounter?
    ### MODDED/
    return false if $Trainer.party[0].item == :MIRRORLURE
    return true if $game_screen.lurerework_checkIsMagneticLureOn?
    return false
    ### /MODDED
  end
end

class ItemData < DataObject
  attr_writer :flags
  attr_writer :desc
end

ItemHandlers::UseFromBag.add(:MAGNETICLURE,proc{|item|
  $game_screen.lurerework_toggleLure
  next 1
})

ItemHandlers::UseInField.add(:MAGNETICLURE,proc{|item|
  $game_screen.lurerework_toggleLure
})

$cache.items[:MAGNETICLURE].flags[:keyitem] = true
$cache.items[:MAGNETICLURE].flags[:noUse] = false
$cache.items[:MAGNETICLURE].flags[:utilityhold] = false
$cache.items[:MAGNETICLURE].desc = "A strange device. Draws in uncaught species when activated."

class PokemonMartAdapter
  alias :lurerework_old_getDisplayName :getDisplayName

  def getDisplayName(item)
    old = lurerework_old_getDisplayName(item)
    if item == :MAGNETICLURE
      if $game_screen && defined?($game_screen.lurerework_lureIsOn) && $game_screen.lurerework_lureIsOn
        old += ' (On)'
      else
        old += ' (Off)'
      end
    end
    return old
  end
end

class PokemonBag_Scene
  alias :lurerework_old_pbStartScene :pbStartScene

  def pbStartScene(bag)
    # Pocket 1 is default items
    if bag.pockets[1].include?(:MAGNETICLURE)
      bag.pockets[1].delete(:MAGNETICLURE)

      bag.pockets[pbGetPocket(:MAGNETICLURE)].push(:MAGNETICLURE)
    end

    return lurerework_old_pbStartScene(bag)
  end
end

class Game_Screen

  attr_accessor   :lurerework_lureIsOn

  def lurerework_checkIsMagneticLureOn?
    return false if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    return false if $PokemonBag.pbQuantity(:MAGNETICLURE) == 0
    @lurerework_lureIsOn=false if !defined?(@lurerework_lureIsOn)
    return @lurerework_lureIsOn
  end

  def lurerework_toggleLure
    @lurerework_lureIsOn=!@lurerework_lureIsOn
    if lurerework_checkIsMagneticLureOn?
      Kernel.pbMessage(_INTL('The Magnetic Lure is now \c[1]ON\c[0].'))
    else
      Kernel.pbMessage(_INTL('The Magnetic Lure is now \c[2]OFF\c[0].'))
    end
  end
end

class PokeBattle_Battler
  alias :lurerework_old_hasWorkingItem :hasWorkingItem

  def hasWorkingItem(item,ignorefainted=false)
    return true if item == :SMOKEBALL && lurerework_old_hasWorkingItem(:MIRRORLURE)
    return lurerework_old_hasWorkingItem(item)
  end
end
