# Move Tweaks

# Enums

module TweakMoveFunctions
  SLEEP = 0x003
  DROWSY = 0x004
  POISON = 0x005
  BAD_POISON = 0x006
  PARALYZE = 0x007
  PARALYZE_OR_FLINCH = 0x009
  BURN = 0x00A
  BURN_OR_FLINCH = 0x00B
  FREEZE = 0x00C
  FREEZE_OR_FLINCH = 0x00E
  FLINCH = 0x00F
  FLINCH_AND_CRUSH_MINIMIZE = 0x010
  CONFUSE = 0x013
  PARALYZE_OR_BURN_OR_FREEZE = 0x017
  DECIMATION = 0x200

  INCREASE_ATTACK = 0x01C
  INCREASE_DEFENSE = 0x01D
  INCREASE_SPEED = 0x01F
  INCREASE_SPATK = 0x020
  INCREASE_EVASION = 0x022
  INCREASE_CRIT = 0x023
  OMNIBOOST = 0x02D

  SHARPLY_INCREASE_ATTACK = 0x02E
  SHARPLY_INCREASE_DEFENSE = 0x02F
  SHARPLY_INCREASE_SPEED = 0x030
  SHARPLY_INCREASE_SPATK = 0x032
  SHARPLY_INCREASE_SPDEF = 0x033

  DRASTIC_ATTACK_RAISE_IF_FAINT = 0x147

  MINIMIZE = 0x034

  DRASTICALLY_INCREASE_DEFENSE = 0x038
  DRASTICALLY_INCREASE_SPATK = 0x039

  LOWER_OWN_PHYSICAL = 0x03B
  LOWER_OWN_DEFENSES = 0x03C
  LOWER_OWN_DEFENSES_AND_SPEED = 0x03D
  LOWER_OWN_SPEED = 0x03E
  HARSHLY_LOWER_OWN_SPATK = 0x03F

  LOWER_ATTACK = 0x042
  LOWER_DEFENSE = 0x043
  LOWER_SPEED = 0x044
  LOWER_SPATK = 0x045
  LOWER_SPDEF = 0x046
  LOWER_ACCURACY = 0x047
  HARSHLY_LOWER_EVASION = 0x048
  HARSHLY_LOWER_ATTACK = 0x04B
  HARSHLY_LOWER_DEFENSE = 0x04C
  HARSHLY_LOWER_SPEED = 0x04D
  HARSHLY_LOWER_SPDEF = 0x04F

  RESET_STATS = 0x050

  STRIKE_DIVING = 0x075
  STRIKE_DIGGING = 0x076
  STRIKE_FLYING = 0x077
  STRIKE_FLYING_AND_FLINCH = 0x078
  STRIKE_BOSS = 0x178
  BREAK_PROTECT = 0x0AD
  BREAK_SCREENS = 0x10A
  HIT_AIRBORNE = 0x11B
  FORCE_TO_GROUND = 0x11C

  DOUBLE_POWER_IF_POISONED = 0x07B
  DOUBLE_POWER_IF_STATUSED = 0x07E
  DOUBLE_POWER_IF_TARGET_STATUSED = 0x07F
  DOUBLE_POWER_AGAINST_WEAKENED = 0x080
  DOUBLE_POWER_IF_ATTACKED = 0x081
  DOUBLE_POWER_IF_DOUBLEUP = 0x082
  DOUBLE_POWER_IF_MOVED_SECOND = 0x084
  DOUBLE_POWER_IF_ALLY_FAINTED = 0x085
  DOUBLE_POWER_WITHOUT_HELD_ITEM = 0x086
  DOUBLE_POWER_IF_TARGET_SWITCHED = 0x088
  DOUBLE_POWER_IF_MOVED_FIRST = 0x181

  SCALE_WITH_USER_HP = 0x08B
  SCALE_WITH_TARGET_HP = 0x08C
  SCALE_WITH_TARGET_SPEED = 0x08D
  SCALE_WITH_USER_BOOSTS = 0x08E
  SCALE_WITH_TARGET_BOOSTS = 0x08F
  SCALE_WITH_LOST_HP = 0x098
  SCALE_WITH_USER_SPEED = 0x99
  SCALE_WITH_TARGET_WEIGHT = 0x9A
  SCALE_WITH_USER_WEIGHT = 0x9B

  ALWAYS_CRIT = 0x0A0
  ALWAYS_CRIT_AGAINST_WEAKENED = 0x201
  ALWAYS_HIT = 0x0A5

  IGNORE_STAT_CHANGES = 0x0A9

  HIT_TWICE = 0x0BD
  HIT_TWICE_AND_POISON = 0x0BE
  HIT_INCREASING_THRICE = 0x0BF
  MULTIHIT = 0x0C0
  
  BIND = 0x0CF
  PIVOT = 0x0EE
  TRAP_WITH_USER = 0x0EF
  UNCONDITIONAL_TRAP = 0x155
  TORMENT = 0x0B7

  NEEDS_RECHARGE = 0x0C2
  FATIGUE = 0x0D2
  ROLLOUT = 0x0D3

  DRAIN_HALF = 0x0DD
  DRAIN_THREE_QUARTERS = 0x139

  KNOCK_OFF = 0x0F0
  STEAL_ITEM = 0x0F1
  SWAP_ITEMS = 0x0F2
  GIVE_ITEM = 0x0F3
  EAT_BERRY = 0x0F4
  DESTROY_BERRY = 0x0F5

  QUARTER_RECOIL = 0x0FA
  THIRD_RECOIL = 0x0FB
  HALF_RECOIL = 0x0FC
  CRASH_DAMAGE = 0x10B

  USE_TARGET_ATTACK_AS_STAT = 0x121
  HIT_PHYSICAL_DEFENSE = 0x122
  USE_DEFENSE_AS_STAT = 0x184
  USE_BETTER_STAT = 0x175
  HIT_SPECIAL_DEFENSE = 0x204

  FALSE_SWIPE = 0x0E9
  BREAKS_MOLD = 0x166
  SCATTER_MONEY = 0x109
  HEAL_ALLIES_NOT_DAMAGE = 0x167
  IGNORE_REDIRECTION = 0x179
end

# For setting TM desc
class ItemData < DataObject
  attr_accessor :desc
end

# For setting move data
class MoveData < DataObject
  attr_accessor :flags
  attr_accessor :move
  attr_accessor :name
  attr_accessor :function
  attr_accessor :type
  attr_accessor :category
  attr_accessor :basedamage
  attr_accessor :accuracy
  attr_accessor :maxpp
  attr_accessor :target
  attr_accessor :desc
  attr_accessor :priority
end

def move_tweak(id, power: nil, accuracy: nil, type: nil, category: nil, pp: nil, target: nil, priority: nil, function: nil, flags: nil, copyFlags: true, desc: nil, tmdesc: nil) 
  move = $cache.moves[id]
  move.function = function if function != nil
  move.basedamage = power if power != nil
  move.type = type if type != nil
  move.category = category if category != nil
  move.accuracy = accuracy if accuracy != nil
  move.maxpp = pp if pp != nil
  move.target = target if target != nil
  move.desc = desc if desc != nil
  move.priority = priority if priority != nil

  if flags != nil
    if copyFlags
      move.flags = move.flags.merge(flags)
    else
      flags[:ID] = move.flags[:ID] # always copy id
      move.flags = flags
    end
  end

  if tmdesc != nil
    tmitem = getTMFromMove(id)
    tmitem.desc = tmdesc if tmitem != nil
  end
end

# Changes to move functions

# Splintered Stormshards
class PokeBattle_Move_807 < PokeBattle_Move
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    ret=super(attacker,opponent,hitnum,alltargets,showanimation)
    if @battle.canChangeFE?(:ROCKY)
      ### MODDED/
      @battle.breakField
      @battle.setField(:ROCKY)
      ### /MODDED
      @battle.pbDisplay(_INTL("The field was devastated!"))
    end
    return ret
  end
end

# Tweaks

move_tweak(:CUT, 
  power: 65,
  accuracy: 100,
  type: :STEEL,
  flags: {
    :highcrit => true,
  },
  tmdesc: "The target is cut with a scythe or a claw. Critical hits land more easily. It can also cut down thin trees.",
  desc: "The target is cut with a scythe or a claw. Critical hits land more easily.")

move_tweak(:FLASH, 
  power: 25, 
  accuracy: 100, 
  type: :ELECTRIC, 
  category: :special, 
  pp: 10, 
  target: :AllOpposing,
  priority: 0, 
  function: TweakMoveFunctions::LOWER_ACCURACY,
  flags: {
    :kingrock => true,
    :effect => 100,
  },
  copyFlags: false,
  tmdesc: "The user emits a powerful blast of light that also cuts accuracy. It can also light up dark caves.",
  desc: "The user emits a powerful blast of light that also cuts accuracy.")

move_tweak(:ROCKSMASH, 
  power: 55,
  flags: {
    :punchmove => true,
    :effect => 100,
  },
  tmdesc: "The user attacks with a punch that lowers Defense. It can also break rocks.",
  desc: "The user attacks with a punch that lowers Defense.")

move_tweak(:ROCKCLIMB, 
  power: 80,
  accuracy: 100,
  type: :ROCK,
  flags: {
    :effect => 10,
    :contact => true,
  },
  function: TweakMoveFunctions::CONFUSE,
  tmdesc: "A charging attack that may also leave the foe confused. It can also scale rocky walls.",
  desc: "A charging attack that may also leave the foe confused.")

move_tweak(:STRENGTH, 
  type: :FIGHTING)

move_tweak(:COVET, 
  type: :FAIRY,
  desc: "The user endearingly approaches the target, then steals the target's held item.")

move_tweak(:PLAYROUGH, 
  accuracy: 100)

move_tweak(:AIRSLASH,
  accuracy: 100)

move_tweak(:FLY, 
  power: 100,
  accuracy: 100)

# These are mostly cosmetic
move_tweak(:MIRRORBEAM, type: :QMARKS)
move_tweak(:REVELATIONDANCE, type: :QMARKS)
move_tweak(:HIDDENPOWER, type: :QMARKS)













