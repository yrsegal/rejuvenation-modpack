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

  alias :cleanerprismpower_old_pbInitPokemon :pbInitPokemon

  def pbInitPokemon(pkmn, pkmnIndex)
    cleanerprismpower_old_pbInitPokemon(pkmn, pkmnIndex)
    # My soul weeps in pain - this if statement has an !
    if @pokemon.prismPower
      @pokemon.prismPower = false
    end
  end
end


