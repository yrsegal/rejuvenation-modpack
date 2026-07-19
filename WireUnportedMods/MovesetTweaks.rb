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
  prevo = pokemon
  while !prevo.nil?
    prevo = MovesetTweaks.producePreEvolution(prevo)
    if !prevo.nil?
      movelist = prevo.getMoveList
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

class MonData
  attr_writer :EggMoves
end

module MovesetTweaks

  def self.producePreEvolution(pokemon)
    prevoSpecies = pbGetPreviousForm(pokemon.species,pokemon.form)
    if prevoSpecies[0] == pokemon.species and prevoSpecies[1] == pokemon.form
      return nil
    end
    prevo=PokeBattle_Pokemon.new(prevoSpecies[0],pokemon.level,$Trainer,false,form=prevoSpecies[1])
    return prevo
  end

  def self.pkmn(id, form=nil)
    if form.nil?
      return $cache.pkmn[id]
    else
      return $cache.pkmn[id].formData[form]
    end
  end

  def self.getData(pokemon, sym)
    if pokemon.is_a?(MonData)
      pokemon.send("#{sym}=", []) unless pokemon.send(sym)
      return pokemon.send(sym)
    else
      pokemon[sym] = [] unless pokemon[sym]
      return pokemon[sym]
    end
  end

  def self.injectTMMoves(pokemon, *moves)
    compatmoves = getData(pokemon, :compatiblemoves)

    moves.each {|move|
      compatmoves.push(move) unless compatmoves.include?(move)
    }
  end

  def self.injectLevelUpMove(pokemon, level, move)
    moves = getData(pokemon, :Moveset)

    insertion = [level, move]

    unless moves.include?(insertion)
      mvbefore = moves.first { |lv, mv| lv >= level }
      if mvbefore
        moves.insert(moves.index(mvbefore), insertion)
      else
        moves.push(insertion)
      end
    end
  end

  def self.injectEggMoves(pokemon, *moves)
    eggmoves = getData(pokemon, :EggMoves)

    moves.each {|move|
      eggmoves.push(move) unless eggmoves.include?(move)
    }
  end

  def self.spreadEggMoves(pokemon, *forms)
    if forms.empty?
      pokemon.formData.each_pair { |k, form| injectEggMoves(form, *pokemon.EggMoves) if form.is_a?(Hash) }
    else
      forms.each { |form|
        formdata = pokemon.formData[form]
        injectEggMoves(formdata, *pokemon.EggMoves) if formdata && formdata.is_a?(Hash)
      }
    end
  end

  def self.doTweaks
    # Gen 8/9 learnsets for Galarian forms/Indeedee-F/Hisuian Qwilfish/Hisuian Growlithe/Hisuian Sneasel
    injectEggMoves(pkmn(:SLOWPOKE, "Galarian Form"), :BELCH,:BELLYDRUM,:BLOCK,:STOMP)
    injectEggMoves(pkmn(:PONYTA, "Galarian Form"), :DOUBLEKICK,:DOUBLEEDGE,:HORNDRILL,:HYPNOSIS,:MORNINGSUN,:THRASH,:PLAYROUGH) # Because play rough isn't tutorable yet
    injectEggMoves(pkmn(:FARFETCHD, "Galarian Form"), :COVET,:CURSE,:FEATHERDANCE,:FEINT,:FINALGAMBIT,:FLAIL,:GUST,:LEAFBLADE,:MUDSLAP,:NIGHTSLASH,:QUICKATTACK,:REVENGE,:SIMPLEBEAM,:SKYATTACK)
    injectTMMoves(pkmn(:FARFETCHD, "Galarian Form"), :CUT)
    injectTMMoves(pkmn(:SIRFETCHD), :CUT)
    injectEggMoves(pkmn(:QWILFISH, "Hisuian Form"), :ACIDSPRAY,:AQUAJET,:AQUATAIL,:ASTONISH,:BUBBLEBEAM,:FLAIL,:HAZE,:SELFDESTRUCT,:SUPERSONIC,:WATERPULSE)
    injectEggMoves(pkmn(:GROWLITHE, "Hisuian Form"), :COVET,:DOUBLEKICK,:DOUBLEEDGE,:HEADSMASH,:MORNINGSUN,:THRASH)
    injectEggMoves(pkmn(:SNEASEL, "Hisuian Form"), :COUNTER,:DOUBLEHIT,:FAKEOUT,:FEINT,:NIGHTSLASH,:QUICKGUARD,:SWITCHEROO)

    # So you can have covet/super luck early. because. pain.
    injectTMMoves(pkmn(:PIDOVE), :COVET)
    injectTMMoves(pkmn(:TRANQUILL), :COVET)
    injectTMMoves(pkmn(:UNFEZANT), :COVET)

    # Give Quiver Dance to oricorio, as is its right
    injectEggMoves(pkmn(:ORICORIO), :QUIVERDANCE)
    spreadEggMoves(pkmn(:ORICORIO))

    # Give Take Heart to Manaphy and Phione
    injectLevelUpMove(pkmn(:PHIONE), 75, :TAKEHEART)
    injectLevelUpMove(pkmn(:MANAPHY), 76, :TAKEHEART)

    # Give Flabebe and Deerling forms, and partner Eevee, their egg moves
    spreadEggMoves(pkmn(:FLABEBE))
    spreadEggMoves(pkmn(:DEERLING))
    spreadEggMoves(pkmn(:EEVEE), "Partner")

    # Gen 9 egg moves for pokemon who couldn't have egg moves prior
    injectEggMoves(pkmn(:MAGNEMITE), :ELECTROWEB,:EXPLOSION)
    injectEggMoves(pkmn(:VOLTORB), :RECYCLE,:METALSOUND)
    injectEggMoves(pkmn(:VOLTORB, "Hisuian Form"), :LEECHSEED,:RECYCLE,:WORRYSEED)
    injectEggMoves(pkmn(:TAUROS), :CURSE,:ENDEAVOR)
    injectEggMoves(pkmn(:BRONZOR), :GRAVITY,:RECYCLE)
    injectEggMoves(pkmn(:BRONZOR, "Aevian Form"), :GRAVITY,:RECYCLE,:REFLECTTYPE) # Reflect type just kinda fits
    injectEggMoves(pkmn(:CRYOGONAL), :AURORAVEIL,:EXPLOSION,:FROSTBREATH)
    injectEggMoves(pkmn(:RUFFLET), :ROCKSMASH,:ROOST)
    injectEggMoves(pkmn(:SINISTEA), :ALLYSWITCH)
    injectEggMoves(pkmn(:IMPIDIMP), :PARTINGSHOT)

    # Fix East Shellos and Small Pumpkaboo
    spreadEggMoves(pkmn(:SHELLOS), "East Sea")
    spreadEggMoves(pkmn(:PUMPKABOO))

    # Fix Basculin forms
    spreadEggMoves(pkmn(:BASCULIN), "Blue-Striped")
    injectEggMoves(pkmn(:BASCULIN, "White-Striped"), :AGILITY,:ENDEAVOR,:HEADSMASH,:MUDDYWATER,:RAGE,:REVENGE,:SWIFT,:WHIRLPOOL) # No Last Respects

    # Aevian forms with no egg moves
    injectEggMoves(pkmn(:SHELLOS, "West Aevian Form"), :SHELTER,:CHARM,:AMNESIA,:CLEARSMOG,:CURSE,:TOXIC,         :SPITUP,:STOCKPILE,:SWALLOW,:YAWN) # Custom, riffing off s-shellos
    injectEggMoves(pkmn(:SHELLOS, "East Aevian Form"), :SHELTER,:CHARM,:AMNESIA,:CLEARSMOG,:CURSE,:SCORCHINGSANDS,:SPITUP,:STOCKPILE,:SWALLOW,:YAWN)
    injectEggMoves(pkmn(:SEWADDLE, "Aevian Form"), :FIRSTIMPRESSION,:FAKEOUT,:SCREECH,:RAZORLEAF,:POISONFANG,:CAMOUFLAGE,:SCALESHOT) # Custom, original
    injectEggMoves(pkmn(:SIGILYPH, "Aevian Form"), :ANCIENTPOWER,:FUTURESIGHT,:GRUDGE,:MOONLIGHT,:MIRRORMOVE,:ESPERWING,:STOREDPOWER) # Custom, riffing off u-sigilyph
    injectEggMoves(pkmn(:JANGMOO, "Aevian Form"), :COUNTER,:AVALANCHE,:FOCUSPUNCH,:REVENGE) # Custom, original
  end
end

MovesetTweaks.doTweaks
