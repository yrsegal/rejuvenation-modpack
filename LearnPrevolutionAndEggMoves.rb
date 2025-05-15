def pbGetRelearnableMoves(pokemon)
  return [] if !pokemon || pokemon.isEgg? || (pokemon.isShadow? rescue false)
  moves=[]
  pbEachNaturalMove(pokemon){|move,level|
     if level<=pokemon.level && !pokemon.knowsMove?(move)
       moves.push(move) if !moves.include?(move)
     end
  }
  tmoves=[]
  if pokemon.firstmoves
    for i in pokemon.firstmoves
      tmoves.push(i) if !pokemon.knowsMove?(i) && !moves.include?(i)
    end
  end
  #####MODDED
  moves= tmoves+pokemon.getEggMoveList(false).select{|i| !pokemon.knowsMove?(i)} + moves# if Rejuv && $PokemonBag.pbHasItem?(:HM02)
  #####/MODDED
  return moves|[] # remove duplicates
end

def pbEachNaturalMove(pokemon)
  movesFound=[]

  movelist=pokemon.getMoveList
  for i in movelist
    if !movesFound.include?(i[1])
      movesFound.push(i[1])
      yield i[1],i[0]
    end
  end

  #####MODDED
  prevo1 = preevo_producePreEvolution(pokemon)
  if !prevo1.nil?
    movelist = prevo1.getMoveList
    for i in movelist
      if !movesFound.include?(i[1])
        movesFound.push(i[1])
        yield i[1],i[0]
      end
    end

    prevo2 = preevo_producePreEvolution(prevo1)
    if !prevo2.nil?
      movelist = prevo2.getMoveList
      for i in movelist
        if !movesFound.include?(i[1])
          movesFound.push(i[1])
          yield i[1],i[0]
        end
      end
    end
  end
  #####/MODDED
end

def preevo_producePreEvolution(pokemon) 
  prevoSpecies = pbGetPreviousForm(pokemon.species,pokemon.form)
  if prevoSpecies[0] == pokemon.species and prevoSpecies[1] == pokemon.form
    return nil
  end
  prevo=PokeBattle_Pokemon.new(prevoSpecies[0],pokemon.level,$Trainer,false,form=prevoSpecies[1])
  return prevo
end

class PokemonScreen

  if !defined?(preevo_old_pbPokemonScreen)
    alias :preevo_old_pbPokemonScreen :pbPokemonScreen
  end

  def pbPokemonScreen(*args, **kwargs)
    if !(Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish])
      for i in 0...$Trainer.party.length
        $Trainer.party[i].relearner=pbHasRelearnableMove?($Trainer.party[i])
      end
    end
    return preevo_old_pbPokemonScreen(*args, **kwargs)
  end
end

# Gen 8 learnsets for Galarian forms/Indeedee-F
$cache.pkmn[:SLOWPOKE].formData["Galarian Form"][:EggMoves] = [:BELCH,:BELLYDRUM,:BLOCK,:STOMP]
$cache.pkmn[:PONYTA].formData["Galarian Form"][:EggMoves] = [:DOUBLEKICK,:DOUBLEEDGE,:HORNDRILL,:HYPNOSIS,:MORNINGSUN,:THRASH,:PLAYROUGH] # Because play rough isn't tutorable yet
$cache.pkmn[:FARFETCHD].formData["Galarian Form"][:EggMoves] = [:COVET,:CURSE,:FEATHERDANCE,:FEINT,:FINALGAMBIT,:FLAIL,:GUST,:LEAFBLADE,:MUDSLAP,:NIGHTSLASH,:QUICKATTACK,:REVENGE,:SIMPLEBEAM,:SKYATTACK]
$cache.pkmn[:INDEEDEE].formData["Female"][:EggMoves] = [:FAKEOUT, :HEALPULSE, :PSYCHUP, :PSYCHOSHIFT]
if !$cache.pkmn[:FARFETCHD].formData["Galarian Form"][:compatiblemoves].include?(:CUT)
  $cache.pkmn[:FARFETCHD].formData["Galarian Form"][:compatiblemoves].push(:CUT)
end
# Aevian Jangmo-o has no egg moves
$cache.pkmn[:JANGMOO].formData["Aevian Form"][:EggMoves] = [:COUNTER,:DRAGONBREATH,:FOCUSPUNCH,:REVERSAL]
