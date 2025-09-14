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
    prevo = movesettweaks_producePreEvolution(prevo)
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

def movesettweaks_producePreEvolution(pokemon)
  prevoSpecies = pbGetPreviousForm(pokemon.species,pokemon.form)
  if prevoSpecies[0] == pokemon.species and prevoSpecies[1] == pokemon.form
    return nil
  end
  prevo=PokeBattle_Pokemon.new(prevoSpecies[0],pokemon.level,$Trainer,false,form=prevoSpecies[1])
  return prevo
end


def movesettweaks_injectMove(moves, move)
  moves.push(move) unless moves.include?(move)
end

class MonData
  attr_writer :EggMoves
end

# Gen 8/9 learnsets for Galarian forms/Indeedee-F/Hisuian Qwilfish/Hisuian Growlithe/Hisuian Sneasel
$cache.pkmn[:SLOWPOKE].formData["Galarian Form"][:EggMoves] = [:BELCH,:BELLYDRUM,:BLOCK,:STOMP]
$cache.pkmn[:PONYTA].formData["Galarian Form"][:EggMoves] = [:DOUBLEKICK,:DOUBLEEDGE,:HORNDRILL,:HYPNOSIS,:MORNINGSUN,:THRASH,:PLAYROUGH] # Because play rough isn't tutorable yet
$cache.pkmn[:FARFETCHD].formData["Galarian Form"][:EggMoves] = [:COVET,:CURSE,:FEATHERDANCE,:FEINT,:FINALGAMBIT,:FLAIL,:GUST,:LEAFBLADE,:MUDSLAP,:NIGHTSLASH,:QUICKATTACK,:REVENGE,:SIMPLEBEAM,:SKYATTACK]
$cache.pkmn[:INDEEDEE].formData["Female"][:EggMoves] = [:FAKEOUT, :HEALPULSE, :PSYCHUP, :PSYCHOSHIFT]
movesettweaks_injectMove($cache.pkmn[:FARFETCHD].formData["Galarian Form"][:compatiblemoves], :CUT)
$cache.pkmn[:QWILFISH].formData["Hisuian Form"][:EggMoves] = [:ACIDSPRAY, :AQUAJET, :AQUATAIL, :ASTONISH, :BUBBLEBEAM, :FLAIL, :HAZE, :SELFDESTRUCT, :SUPERSONIC, :WATERPULSE]
$cache.pkmn[:GROWLITHE].formData["Hisuian Form"][:EggMoves] = [:COVET,:DOUBLEKICK,:DOUBLEEDGE,:HEADSMASH,:MORNINGSUN,:THRASH]
$cache.pkmn[:SNEASEL].formData["Hisuian Form"][:EggMoves] = [:COUNTER,:DOUBLEHIT,:FAKEOUT,:FEINT,:NIGHTSLASH,:QUICKGUARD,:SWITCHEROO]

# So you can have covet/super luck early. because. pain.
movesettweaks_injectMove($cache.pkmn[:PIDOVE].compatiblemoves, :COVET)
movesettweaks_injectMove($cache.pkmn[:TRANQUILL].compatiblemoves, :COVET)
movesettweaks_injectMove($cache.pkmn[:UNFEZANT].compatiblemoves, :COVET)

# Give Quiver Dance to oricorio, as is its right
movesettweaks_injectMove($cache.pkmn[:ORICORIO].EggMoves, :QUIVERDANCE)
$cache.pkmn[:ORICORIO].formData.each_pair { |k, form| form[:EggMoves] = $cache.pkmn[:ORICORIO].EggMoves if form.is_a?(Hash) }

# Give Flabebe and Deerling forms, and partner Eevee, their egg moves
$cache.pkmn[:FLABEBE].formData.each_pair { |k, form| form[:EggMoves] = $cache.pkmn[:FLABEBE].EggMoves if form.is_a?(Hash) }
$cache.pkmn[:DEERLING].formData.each_pair { |k, form| form[:EggMoves] = $cache.pkmn[:DEERLING].EggMoves if form.is_a?(Hash) }
$cache.pkmn[:EEVEE].formData["Partner"][:EggMoves] = $cache.pkmn[:EEVEE].EggMoves if $cache.pkmn[:EEVEE].formData["Partner"]

# Gen 9 egg moves for pokemon who couldn't have egg moves prior
$cache.pkmn[:MAGNEMITE].EggMoves = [:ELECTROWEB,:EXPLOSION]
$cache.pkmn[:VOLTORB].EggMoves = [:RECYCLE,:METALSOUND]
$cache.pkmn[:VOLTORB].formData["Hisuian Form"][:EggMoves] = [:LEECHSEED,:RECYCLE,:WORRYSEED]
$cache.pkmn[:TAUROS].EggMoves = [:CURSE,:ENDEAVOR]
$cache.pkmn[:BRONZOR].EggMoves = [:GRAVITY,:RECYCLE]
$cache.pkmn[:BRONZOR].formData["Aevian Form"][:EggMoves] = [:GRAVITY,:RECYCLE,:REFLECTTYPE] # Reflect type just kinda fits
$cache.pkmn[:CRYOGONAL].EggMoves = [:AURORAVEIL,:EXPLOSION,:FROSTBREATH]
$cache.pkmn[:RUFFLET].EggMoves = [:ROCKSMASH,:ROOST]
$cache.pkmn[:SINISTEA].EggMoves = [:ALLYSWITCH]
$cache.pkmn[:IMPIDIMP].EggMoves = [:PARTINGSHOT]

# Fix East Shellos and Small Pumpkaboo
$cache.pkmn[:SHELLOS].formData["East Sea"][:EggMoves] = $cache.pkmn[:SHELLOS].EggMoves
$cache.pkmn[:PUMPKABOO].formData["Small"][:EggMoves] = $cache.pkmn[:PUMPKABOO].EggMoves

# Fix Basculin forms
$cache.pkmn[:BASCULIN].formData["Blue-Striped"][:EggMoves] = $cache.pkmn[:BASCULIN].EggMoves
$cache.pkmn[:BASCULIN].formData["White-Striped"][:EggMoves] = [:AGILITY,:ENDEAVOR,:HEADSMASH,:MUDDYWATER,:RAGE,:REVENGE,:SWIFT,:WHIRLPOOL,:SHADOWBONE] # Shadow Bone as poor replacement for Last Respects

# Aevian forms with no egg moves
$cache.pkmn[:SHELLOS].formData["West Aevian Form"][:EggMoves] = [:SHELTER,:CHARM,:AMNESIA,:CLEARSMOG,:CURSE,:TOXIC,         :SPITUP,:STOCKPILE,:SWALLOW,:YAWN] # Custom, riffing off s-shellos
$cache.pkmn[:SHELLOS].formData["East Aevian Form"][:EggMoves] = [:SHELTER,:CHARM,:AMNESIA,:CLEARSMOG,:CURSE,:SCORCHINGSANDS,:SPITUP,:STOCKPILE,:SWALLOW,:YAWN]
$cache.pkmn[:SEWADDLE].formData["Aevian Form"][:EggMoves] = [:FIRSTIMPRESSION,:FAKEOUT,:SCREECH,:RAZORLEAF,:POISONFANG,:CAMOUFLAGE,:SCALESHOT] # Custom, original
$cache.pkmn[:SIGILYPH].formData["Aevian Form"][:EggMoves] = [:ANCIENTPOWER,:FUTURESIGHT,:GRUDGE,:MOONLIGHT,:MIRRORMOVE,:ESPERWING,:STOREDPOWER] # Custom, riffing off u-sigilyph
$cache.pkmn[:JANGMOO].formData["Aevian Form"][:EggMoves] = [:COUNTER,:AVALANCHE,:FOCUSPUNCH,:REVENGE] # Custom, original
