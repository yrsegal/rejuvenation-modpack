# Always catch, option to force win with ctrl
module PokeBattle_BattleCommon
  if !defined?(partialdebug_old_pbThrowPokeBall)
    alias :partialdebug_old_pbThrowPokeBall :pbThrowPokeBall
  end
  def pbThrowPokeBall(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbThrowPokeBall(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

class PokeBattle_Battle
  if !defined?(partialdebug_old_pbRun)
    alias :partialdebug_old_pbRun :pbRun
  end
  def pbRun(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbRun(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Hold ctrl for 100% effect chance
class PokeBattle_Battler

  if !defined?(partialdebug_old_pbProcessMoveAgainstTarget)
    alias :partialdebug_old_pbProcessMoveAgainstTarget :pbProcessMoveAgainstTarget
  end
  def pbProcessMoveAgainstTarget(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbProcessMoveAgainstTarget(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Debug menu in party
class PokemonScreen

  if !defined?(partialdebug_old_pbPokemonScreen)
    alias :partialdebug_old_pbPokemonScreen :pbPokemonScreen
  end
  def pbPokemonScreen(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbPokemonScreen(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Debug menu in box
class PokemonStorageScreen

  if !defined?(partialdebug_old_pbStartScreen)
    alias :partialdebug_old_pbStartScreen :pbStartScreen
  end
  def pbStartScreen(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbStartScreen(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Debug menu in party
class PokemonMenu

  if !defined?(partialdebug_old_pbStartPokemonMenu)
    alias :partialdebug_old_pbStartPokemonMenu :pbStartPokemonMenu
  end
  def pbStartPokemonMenu(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbStartPokemonMenu(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Toss items that are normally untossable
class PokemonBagScreen

  if !defined?(partialdebug_old_pbStartScreen)
    alias :partialdebug_old_pbStartScreen :pbStartScreen
  end
  def pbStartScreen(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbStartScreen(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Forget HM moves
class PokemonSummary

  if !defined?(partialdebug_old_pbStartForgetScreen)
    alias :partialdebug_old_pbStartForgetScreen :pbStartForgetScreen
  end
  def pbStartForgetScreen(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbStartForgetScreen(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Pass through walls if holding ctrl
class Game_Player < Game_Character

  if !defined?(partialdebug_old_passable?)
    alias :partialdebug_old_passable? :passable?
  end
  def passable?(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_passable?(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Mine without damage if ctrl
class MiningGameScene

  if !defined?(partialdebug_old_pbHit)
    alias :partialdebug_old_pbHit :pbHit
  end
  def pbHit(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = true
    ret = partialdebug_old_pbHit(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
end

# Berry plant fastforward
if !defined?(partialdebug_old_pbBerryPlant)
  alias :partialdebug_old_pbBerryPlant :pbBerryPlant
end
def pbBerryPlant(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbBerryPlant(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

# No hms early
Kernel.singleton_class.class_eval do
  if !defined?(partialdebug_old_pbRockSmash)
    alias :partialdebug_old_pbRockSmash :pbRockSmash
  end
  if !defined?(partialdebug_old_pbStrength)
    alias :partialdebug_old_pbStrength :pbStrength
  end
  if !defined?(partialdebug_old_pbSurf)
    alias :partialdebug_old_pbSurf :pbSurf
  end
  if !defined?(partialdebug_old_pbLavaSurf)
    alias :partialdebug_old_pbLavaSurf :pbLavaSurf
  end
  if !defined?(partialdebug_old_pbWaterfall)
    alias :partialdebug_old_pbWaterfall :pbWaterfall
  end
  if !defined?(partialdebug_old_pbDive)
    alias :partialdebug_old_pbDive :pbDive
  end
  if !defined?(partialdebug_old_pbSurfacing)
    alias :partialdebug_old_pbSurfacing :pbSurfacing
  end
  if !defined?(partialdebug_old_pbRockClimb)
    alias :partialdebug_old_pbRockClimb :pbRockClimb
  end
  if !defined?(partialdebug_old_pbCut)
    alias :partialdebug_old_pbCut :pbCut
  end
  def pbRockSmash(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbRockSmash(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbStrength(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbStrength(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbSurf(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbSurf(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbLavaSurf(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbLavaSurf(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbWaterfall(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbWaterfall(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbDive(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbDive(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbSurfacing(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbSurfacing(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbRockClimb(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbRockClimb(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end
  def pbCut(*args, **kwargs)
    wasdebug = $DEBUG
    $DEBUG = false
    ret = partialdebug_old_pbCut(*args, **kwargs)
    $DEBUG = wasdebug
    return ret
  end

  
end


# Skip battles with ctrl
if !defined?(partialdebug_old_pbDoubleTrainerBattle)
  alias :partialdebug_old_pbDoubleTrainerBattle :pbDoubleTrainerBattle
end
def pbDoubleTrainerBattle(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbDoubleTrainerBattle(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

if !defined?(partialdebug_old_pbTrainerBattle)
  alias :partialdebug_old_pbTrainerBattle :pbTrainerBattle
end
def pbTrainerBattle(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbTrainerBattle(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end
if !defined?(partialdebug_old_pbDoubleTrainerBattle100)
  alias :partialdebug_old_pbDoubleTrainerBattle100 :pbDoubleTrainerBattle100
end
def pbDoubleTrainerBattle100(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbDoubleTrainerBattle100(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

if !defined?(partialdebug_old_pbTrainerBattle100)
  alias :partialdebug_old_pbTrainerBattle100 :pbTrainerBattle100
end
def pbTrainerBattle100(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbTrainerBattle100(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

if !defined?(partialdebug_old_pbWildBattle)
  alias :partialdebug_old_pbWildBattle :pbWildBattle
end
def pbWildBattle(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbWildBattle(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

if !defined?(partialdebug_old_pbWildBattleObject)
  alias :partialdebug_old_pbWildBattleObject :pbWildBattleObject
end
def pbWildBattleObject(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbWildBattleObject(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

if !defined?(partialdebug_old_pbDoubleWildBattle)
  alias :partialdebug_old_pbDoubleWildBattle :pbDoubleWildBattle
end
def pbDoubleWildBattle(*args, **kwargs)
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbDoubleWildBattle(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end

# Title Skip after first appearance
if !defined?($partialdebug_skippedfirst)
  $partialdebug_skippedfirst = false
end

if !defined?(partialdebug_old_pbCallTitle)
  alias :partialdebug_old_pbCallTitle :pbCallTitle
end
def pbCallTitle(*args, **kwargs)
  if !$partialdebug_skippedfirst
    $partialdebug_skippedfirst = true
    return partialdebug_old_pbCallTitle(*args, **kwargs)
  end
  wasdebug = $DEBUG
  $DEBUG = true
  ret = partialdebug_old_pbCallTitle(*args, **kwargs)
  $DEBUG = wasdebug
  return ret
end
