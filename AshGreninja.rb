$cache.abil[:BATTLEBOND] = AbilityData.new(:BATTLEBOND, {
  name: "Battle Bond",
  desc: "Becomes powerful after knocking out a foe...",
  fullDesc: "Defeating an opposing Pokémon strengthens the Pokémon's bond with its Trainer, and it becomes Ash-Greninja. Water Shuriken gets stronger."
})

TextureOverrides.registerTextureOverrides({
  "Graphics/Icons/icon658" => "Data/Mods/AshGreninja/Icon",
  "Graphics/Battlers/658" => "Data/Mods/AshGreninja/Battler"
})

PBStuff::ABILITYBLACKLIST.push(:BATTLEBOND)

$cache.pkmn[:GRENINJA].formData["Battle Bond"] = {
  Abilities: [:BATTLEBOND]
}

$cache.pkmn[:GRENINJA].formData["Ash-Greninja"] = {
  Abilities: [:BATTLEBOND],
  :BaseStats => [72, 145, 67, 153, 71, 132]
}

$cache.pkmn[:GRENINJA].forms[1] = "Battle Bond"
$cache.pkmn[:GRENINJA].forms[2] = "Ash-Greninja"

class PokeBattle_Battle
  alias :ashgreninja_old_pbEndOfBattle :pbEndOfBattle
  def pbEndOfBattle(*args,**kwargs)
    decision=ashgreninja_old_pbEndOfBattle(*args,**kwargs)
    for i in @battlers
      next if i.nil?
      i.ashgreninja_restoreform
    end
    return decision
  end
end

class PokeBattle_Battler
  def ashgreninja_restoreform
    if self.species == :GRENINJA && self.form == 2
      self.form = 1
    end
  end


  alias :ashgreninja_old_pbFaint :pbFaint
  def pbFaint(*args,**kwargs)
    dogreninja = self.isFainted? && !@fainted
    ret = ashgreninja_old_pbFaint(*args,**kwargs)
    ashgreninja_restoreform if dogreninja
    return ret
  end

  alias :ashgreninja_old_pbProcessMoveAgainstTarget :pbProcessMoveAgainstTarget
  def pbProcessMoveAgainstTarget(basemove,user,target,*args,**kwargs)
    ret = ashgreninja_old_pbProcessMoveAgainstTarget(basemove,user,target,*args,**kwargs)
    if !user.isFainted? && target.isFainted?
      if self.species == :GRENINJA && self.form == 1 && self.ability == :BATTLEBOND
        @battle.pbDisplay(_INTL("{1} became fully charged due to its bond with its Trainer!", pbThis))

        @battle.pbCommonAnimation("MegaEvolution",self,nil)

        self.form=2
        backupability = @pokemon.ability
        pbUpdate
        @battle.scene.pbChangePokemon(self,@pokemon) if self.effects[:Substitute]==0

        @battle.pbDisplay(_INTL("{1} became Ash-Greninja!",pbThis))
      end
    end

    return ret
  end
end
class PokeBattle_Move_0C0 # Water Shuriken
  alias :ashgreninja_old_pbNumHits :pbNumHits
  def pbNumHits(attacker)
    return 3 if @move == :WATERSHURIKEN && attacker.species == :GRENINJA && attacker.form == 2 && attacker.ability == :BATTLEBOND
    return ashgreninja_old_pbNumHits(attacker)
  end

  def pbBaseDamage(basedmg,attacker,opponent)
    return 20 if @move == :WATERSHURIKEN && attacker.species == :GRENINJA && attacker.form == 2 && attacker.ability == :BATTLEBOND
    return basedmg
  end
end

