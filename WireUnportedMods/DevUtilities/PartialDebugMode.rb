class Object
  def partialdebug_wrap(sym, debugState=true)
    self.class.partialdebug_wrap(sym, debugState)
  end
end

class Module
  def partialdebug_wrap(sym, debugState=true)
    m = instance_method(sym)
    define_method(sym) { |*args, **kwargs|
      wasdebug = $DEBUG
      $DEBUG = debugState
      ret = m.bind(self).call(*args, **kwargs)
      $DEBUG = wasdebug
      next ret
    }
  end
end

=begin

basing the wrapping code off of:

class Object
  def wrap_method(sym, &block)
    self.class.wrap_method(sym, &block)
  end
end

class Module
  
  def wrap_method(sym, &block)
    m = instance_method(sym)
    define_method(sym) { |*args, **kwargs|
      instance_exec(m.bind(self), *args, **kwargs, &block)
    }
  end
end
=end

# Always catch, option to force win with ctrl
PokeBattle_BattleCommon.partialdebug_wrap :pbThrowPokeBall
PokeBattle_Battle.partialdebug_wrap :pbRun

# Hold ctrl for 100% effect chance
PokeBattle_Battler.partialdebug_wrap :pbProcessMoveAgainstTarget

# Obedience check still works
PokeBattle_Battler.partialdebug_wrap :pbObedienceCheck?, false

# Debug menu in party
PokemonScreen.partialdebug_wrap :pbPokemonScreen

# Debug menu in box
PokemonStorageScreen.partialdebug_wrap :pbStartScreen

# Debug menu in party
PokemonMenu.partialdebug_wrap :pbStartPokemonMenu

# Toss items that are normally untossable
PokemonBagScreen.partialdebug_wrap :pbStartScreen

# Forget HM moves
PokemonSummary.partialdebug_wrap :pbStartForgetScreen

# Pass through walls if holding ctrl
Game_Player.partialdebug_wrap :passable?

# Mine without damage if ctrl
MiningGameScene.partialdebug_wrap :pbHit

# Enable debug inputs
Input.singleton_class.partialdebug_wrap :update

# Force berry growth
partialdebug_wrap :pbBerryPlant

# No hms early
[:pbRockSmash, :pbStrength, :pbSurf, :pbLavaSurf, :pbWaterfall, :pbDive, :pbSurfacing, :pbRockClimb, :pbCut].each { |m|
  Kernel.singleton_class.partialdebug_wrap m, false
}

[:pbHeadbutt, :pbHeadbutt2].each { |m|
  Kernel.singleton_class.partialdebug_wrap m
}

# Skip battles with ctrl
[:pbDoubleTrainerBattle, :pbTrainerBattle, :pbDoubleTrainerBattle100, :pbTrainerBattle100, :pbWildBattle, :pbWildBattleObject, :pbDoubleWildBattle].each(
  &method(:partialdebug_wrap))
