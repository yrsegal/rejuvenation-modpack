class PokeBattle_Battler
  def rejuvAbilities(onactive)
    if self.ability == :PRISMPOWER && onactive
      if self.pokemon.prismPower == false
        ### MODDED/
        for stat in 1..5
          if self.pbCanIncreaseStatStage?(stat,false)
            pbIncreaseStatBasic(stat,1)
          end
        end

        self.pokemon.prismPower = true
        @battle.scene.pbChangePokemon(self,@pokemon)

        @battle.pbCommonAnimation("StatUp",self)
        @battle.pbDisplay(_INTL("{1}'s {2} activated!", pbThis,getAbilityName(ability)))
        ### /MODDED
      end
    end
  end
end

module PokeBattle_BattleCommon
  alias :cleanerprismpower_old_pbStorePokemon :pbStorePokemon

  def pbStorePokemon(pokemon)
    @pokemon.prismPower = false if @pokemon.prismPower && pokemon.species == :DELPHOX && pokemon.form == 1
    cleanerprismpower_old_pbStorePokemon(pkmn, pkmnIndex)
  end
end
