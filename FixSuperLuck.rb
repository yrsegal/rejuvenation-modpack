def pbGenerateWildPokemon(species,level,sos=false)
  if Rejuv
    bossdata = $cache.bosses
    bossspecies = species
    if $game_variables[:DifficultyModes] == 1
      bossspecies = ((species.to_s) +"_EASY").intern
      bossspecies = species if !bossdata[bossspecies]
    end
    if bossdata[bossspecies]
      Events.onBossCreate.trigger(nil,species)
    end
    return pbLoadWildBoss(bossspecies,bossdata) if bossdata[bossspecies]
  end
  if $cache.pkmn[species].formInit.is_a?(String)
    genwildpoke=PokeBattle_Pokemon.new(species,level,$Trainer,false,eval($cache.pkmn[species].formInit).call)
  else
    genwildpoke=PokeBattle_Pokemon.new(species,level,$Trainer)
  end
  items=genwildpoke.wildHoldItems
  chances=[50,5,1]
  ### MODDED/ also this line of code causes me physical pain
  chances=[60,20,5] if !$Trainer.party[0].isEgg? &&
     ($Trainer.party[0].ability == :COMPOUNDEYES || $Trainer.party[0].ability == :SUPERLUCK)
  ### /MODDED
  itemrnd=rand(100)
  if itemrnd<chances[0] || (items[0]==items[1] && items[1]==items[2])
    genwildpoke.setItem(items[0])
  elsif itemrnd<(chances[0]+chances[1])
    genwildpoke.setItem(items[1])
  elsif itemrnd<(chances[0]+chances[1]+chances[2])
    genwildpoke.setItem(items[2])
  end
  if rand(65536)<POKERUSCHANCE
    genwildpoke.givePokerus
  end
  Events.onWildPokemonCreate.trigger(nil,genwildpoke)
  return genwildpoke
end
