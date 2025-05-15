class PokeBattle_Pokemon
  def type1
    if @species == :ARCEUS && @ability == :MULTITYPE
      type = $cache.pkmn[@species].forms[self.form%19].upcase.intern
      type = :QMARKS if type == "???".intern
      return type
    elsif @species == :SILVALLY && @ability == :RKSSYSTEM
      ### MODDED/
      type = $cache.pkmn[@species].forms[self.form%19].upcase.intern
      ### /MODDED
      type = :QMARKS if type == "???".intern
      return type
    else
      val = formCheck(:Type1)
      return !val.nil? ? val : $cache.pkmn[@species].Type1
    end
  end
end

class PokeBattle_Battle
  def NWTypeRoll(mon)
    roll = rand($cache.types.length)
    puts mon.pokemon.trainerID
    roll += $cache.types.length if (mon.species == :ARCEUS && $game_switches[:Pulse_Arceus] && mon.pokemon.trainerID == 00000) || ($DEBUG && $INTERNAL)
    ### MODDED/
    roll = roll % 19
    ### /MODDED
    if mon.form != roll
      backupspecies=mon.pokemon.species
      mon.form = roll
      abil = getAbilityName(mon.ability)
      abil = "RKS System" if mon.crested == :SILVALLY
      pbDisplay(_INTL("{1}'s {2} activated!",mon.pbThis,abil))
      pbCommonAnimation("TypeRoll",mon,nil)
      mon.form=mon.pokemon.form
      mon.pokemon.species=mon.species if mon.effects[:Transform]
      mon.pbUpdate(true)
      @scene.pbChangePokemon(mon,mon.pokemon)
      mon.pokemon.species=backupspecies
      pbDisplay(_INTL("{1} rolled the {2} type!",mon.pbThis,mon.type1.capitalize))
    end
  end
end