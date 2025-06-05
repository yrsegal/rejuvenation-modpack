
class PokeBattle_Move
  if !defined?(predictedmegamovetypes_old_pbType)
    alias :predictedmegamovetypes_old_pbType :pbType
  end

  def pbType(attacker, type=@type)
    if !attacker.isMega? && attacker.hasMega?
      side=(battle.pbIsOpposing?(attacker.index)) ? 1 : 0
      owner=battle.pbGetOwnerIndex(attacker.index)
      if battle.megaEvolution[side][owner] == attacker.index
        attacker.pokemon.makeMega
        prevAbility = attacker.ability
        attacker.ability = attacker.pokemon.ability
        ret = predictedmegamovetypes_old_pbType(attacker, type)
        attacker.pokemon.makeUnmega
        attacker.ability = prevAbility
        return ret
      end
    elsif !attacker.isUltra? && attacker.hasUltra?
      side=(battle.pbIsOpposing?(attacker.index)) ? 1 : 0
      owner=battle.pbGetOwnerIndex(attacker.index)
      if battle.ultraBurst[side][owner] == attacker.index
        attacker.pokemon.makeUltra
        prevAbility = attacker.ability
        attacker.ability = attacker.pokemon.ability
        ret = predictedmegamovetypes_old_pbType(attacker, type)
        attacker.pokemon.makeUnultra
        attacker.ability = prevAbility
        return ret
      end
    end
    return predictedmegamovetypes_old_pbType(attacker, type)
  end
end
