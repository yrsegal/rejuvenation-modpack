def partialdebug_wrap(name, debugState=true, bindings=TOPLEVEL_BINDING)
  eval <<__END__, bindings
  alias :partialdebug_old_#{name} :#{name}
  def #{name}(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = #{debugState}
    ret = partialdebug_old_#{name}(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
__END__
end

def partialdebug_wrap_class(clazz, name, debugState=true)
  clazz.class_eval { partialdebug_wrap(name, debugState, binding) }
end

def partialdebug_wrap_inst(clazz, name, debugState=true)
  clazz.instance_eval { partialdebug_wrap(name, debugState, binding) }
end

# Always catch, option to force win with ctrl
partialdebug_wrap_class PokeBattle_BattleCommon, :pbThrowPokeBall
partialdebug_wrap_class PokeBattle_Battle, :pbRun

# Hold ctrl for 100% effect chance
partialdebug_wrap_class PokeBattle_Battler, :pbProcessMoveAgainstTarget

# Debug menu in party
partialdebug_wrap_class PokemonScreen, :pbPokemonScreen

# Debug menu in box
partialdebug_wrap_class PokemonStorageScreen, :pbStartScreen

# Debug menu in party
partialdebug_wrap_class PokemonMenu, :pbStartPokemonMenu

# Toss items that are normally untossable
partialdebug_wrap_class PokemonBagScreen, :pbStartScreen

# Forget HM moves
partialdebug_wrap_class PokemonSummary, :pbStartForgetScreen

# Pass through walls if holding ctrl
partialdebug_wrap_class Game_Player, :passable?

# Mine without damage if ctrl
partialdebug_wrap_class MiningGameScene, :pbHit

# Enable debug inputs
partialdebug_wrap_inst Input, :update

# Force berry growth
partialdebug_wrap :pbBerryPlant

# No hms early
[:pbRockSmash, :pbStrength, :pbSurf, :pbLavaSurf, :pbWaterfall, :pbDive, :pbSurfacing, :pbRockClimb, :pbCut].each { |m|
  partialdebug_wrap_inst Kernel, m, false
}

[:pbHeadbutt, :pbHeadbutt2].each { |m|
  partialdebug_wrap_inst Kernel, m
}

# Skip battles with ctrl
[:pbDoubleTrainerBattle, :pbTrainerBattle, :pbDoubleTrainerBattle100, :pbTrainerBattle100, :pbWildBattle, :pbWildBattleObject, :pbDoubleWildBattle].each(
  &method(:partialdebug_wrap))
