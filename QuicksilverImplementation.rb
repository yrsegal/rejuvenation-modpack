class PokeBattle_Battle
  alias :quicksilver_old_pbCanSwitch? :pbCanSwitch?
  def pbCanSwitch?(idxPokemon,pkmnidxTo,showMessages,ai_phase=false,running: false)
    return false unless quicksilver_old_pbCanSwitch?(idxPokemon,pkmnidxTo,showMessages,ai_phase, running:running)
    thispkmn=@battlers[idxPokemon]

    if thispkmn.hasType?(:GHOST) && (@field.effect != :DIMENSIONAL || !(thispkmn.pbOpposing1.ability == :SHADOWTAG || thispkmn.pbOpposing2.ability == :SHADOWTAG))
      return true
    end
    if thispkmn.hasWorkingItem(:SHEDSHELL)
      return true
    end

    if thispkmn.effects[:Quicksilver]
      pbDisplayPaused(_INTL("The quicksilver spear holds {1} in place!",thispkmn.pbThis(true))) if showMessages 
      return false
    end

    return true
  end
  alias :quicksilver_old_pbEndOfRoundPhase :pbEndOfRoundPhase

  def pbEndOfRoundPhase
    quicksilver_old_pbEndOfRoundPhase
    for i in priority
      next if i.isFainted?
      next if !i.effects[:Quicksilver]
      if i.ability != :MAGICGUARD && !(i.ability == :WONDERGUARD && @battle.FE == :COLOSSEUM)
        if i.hasType?(:SHADOW) || i.isbossmon
          pbCommonAnimation("StanceAttack",i,nil)
          pbDisplay(_INTL("Blessed quicksilver strikes true on {1}!",i.pbThis(true)))
          i.pbReduceHP((i.totalhp/8.0).floor,true)
        else
          pbCommonAnimation("Skull Bash charging",i,nil)
          pbDisplay(_INTL("{1} is hurt by the quicksilver spear!",i.pbThis))
          i.pbReduceHP((i.totalhp/16.0).floor,true)
        end
      end
      if i.isFainted?
        return if !i.pbFaint
        next
      end
    end
  end
end

class PokeBattle_Battler
  alias :quicksilver_old_isAirborne? :isAirborne?
  def isAirborne?
    return false if @effects[:Quicksilver]
    return quicksilver_old_isAirborne?
  end
end

# Roar
class PokeBattle_Move_0EB
  alias :quicksilver_old_pbEffect :pbEffect
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if opponent.effects[:Quicksilver]
      @battle.pbDisplay(_INTL("The quicksilver spear holds {1} in place!",thispkmn.pbThis(true))) if showMessages 
      return -1
    end
    return quicksilver_old_pbEffect(attacker, opponent, hitnum, alltargets, showanimation)
  end
end

# Dragon Tail / Circle Throw
class PokeBattle_Move_0EC
  alias :quicksilver_old_pbEffect :pbEffect
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    wasingrained = opponent.effects[:Ingrain]
    opponent.effects[:Ingrain] = true if opponent.effects[:Quicksilver]
    ret = quicksilver_old_pbEffect(attacker, opponent, hitnum, alltargets, showanimation)
    opponent.effects[:Ingrain] = wasingrained
    return ret
  end
end
