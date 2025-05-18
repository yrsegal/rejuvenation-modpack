Switches[:MoveRelearner] = 1444

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

class Eggmove_EggMoveLearnerScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon)
    moves=eggmove_getEggMoveList(pokemon)
    @scene.pbStartScene(pokemon,moves)
    loop do
      move=@scene.pbChooseMove
      if !move.is_a?(Symbol)
        if @scene.pbConfirm(
          _INTL("Give up trying to teach a new move to {1}?",pokemon.name))
          @scene.pbEndScene
          return false
        end
      else
        if @scene.pbConfirm(_INTL("Teach {1}?",getMoveName(move)))
          if pbLearnMove(pokemon,move)
            @scene.pbEndScene
            return true
          end
        end
      end
    end
  end
end

def eggmove_getEggMoveList(pokemon)
  return pokemon.getEggMoveList(false).select{|i| !pokemon.knowsMove?(i) }
end

def eggmove_pbRelearnMoveScreen(pokemon)
  retval=true
  pbFadeOutIn(99999){
     scene=MoveRelearnerScene.new
     screen=Eggmove_EggMoveLearnerScreen.new(scene)
     retval=screen.pbStartScreen(pokemon)
  }
  return retval
end

class Game_Screen
  attr_accessor :relearnerpc_used
  attr_accessor :relearnerpc_scales
end

class RelearnerPCService

  def shouldShow?
    return $game_switches[:MoveRelearner]
  end

  def name
    return _INTL("Move Relearner")
  end

  def help
    return _INTL("Relearn moves, delete them, or learn egg moves.")
  end

  def relearner(text, *args) 
    return _INTL("\\f[service_MoveRelearner]" + text, *args)
  end

  def sister(text, *args)
    return _INTL("\\f[service_RelearnerSister]" + text, *args)
  end

  def takeScale
    $PokemonBag.pbDeleteItem(:HEARTSCALE)
    Kernel.pbMessage(_INTL("\\PN sent over one Heart Scale in exchange."))
    $game_screen.relearnerpc_scales += 1
    if $game_screen.relearnerpc_scales >= 10
      ServicePCList.exclaimSound
      Kernel.pbMessage(relearner("BRIE: Oh! That's a lot of Heart Scales you've given me!"))
      Kernel.pbMessage(relearner("I can't justify the price for someone my sister speaks so fondly of."))
      Kernel.pbMessage(relearner("Tell you what. This service is free for you, now, and I won't take no for an answer!"))
      ServicePCList.happySound
      Kernel.pbMessage(sister("SAMANTHA: Wow! Thanks, sis! Enjoy, \\PN!"))
      return true
    end
    return false
  end

  def access
    if ServicePCList.offMap? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(sister("SAMANTHA: Hello, you've reached the Sheridan Move Reminder..."))
    Kernel.pbMessage(sister("Oh, it's \\PN! How've you been?"))
    if !$game_screen.relearnerpc_used
      if !$game_self_switches[[425, 15, 'A']] # Sister
        Kernel.pbMessage(sister("Thank you for finding my sister!"))
        Kernel.pbMessage(sister("She's always forgetting that she has a duty here in Sheridan!"))
        Kernel.pbMessage(sister("Um, don't tell her I sent you this, but-"))
        if Kernel.pbReceiveItem(:HEARTSCALE)
          Kernel.pbMessage(sister("You earned that."))
          Kernel.pbMessage(sister("Put it to good use, okay?"))
          $game_self_switches[[425, 15, 'A']] = true
        end
      else
        Kernel.pbMessage(sister("Thank you again for finding my sister!"))
      end
      Kernel.pbMessage(sister("I'm still in training for Move Relearner services, but I'm handling the phone."))
      Kernel.pbMessage(sister("I can do Move Deleting, though! And I can call my sister over for Relearning, or learning rare moves."))
      Kernel.pbMessage(sister("And we've got a special promotion! If you Relearn a move via this service, we'll teach your Pokemon to relearn moves on their own!"))
      $game_screen.relearnerpc_used = true
    end
    $game_screen.relearnerpc_scales = 0 if !$game_screen.relearnerpc_scales

    choice = Kernel.pbMessage(sister("So, what'll it be?"), [_INTL("Move Relearner"),_INTL("Move Deleter"),_INTL("Rare Moves")], -1)
    if choice < 0
      Kernel.pbMessage(sister("SAMANTHA: Oh, just calling to catch up? I appreciate it! Talk to you later!"))
      return
    elsif choice == 0
      Kernel.pbMessage(_INTL("\\sh\\c[7]SAMANTHA: HEY, BRIE! CUSTOMER! IT'S \\PNUpper!\\wtnp[50]"))
      Kernel.pbMessage(relearner("BRIE: Good to hear from you, \\PN. Relearner services? Sure!"))
      if $game_screen.relearnerpc_scales < 10
        if $PokemonBag.pbQuantity(:HEARTSCALE)>0
          Kernel.pbMessage(relearner("You've got a Heart Scale, so I can teach a Pokemon."))
        elsif 
          Kernel.pbMessage(relearner("... Actually, sorry, you need to come back with a Heart Scale."))
          Kernel.pbMessage(sister("SAMANTHA: Oh well! Talk to you later!"))
          return
        end
      end
      Kernel.pbMessage(relearner("Which Pokemon needs tutoring?"))

      loop do
        pbChoosePokemon(1,3,proc{|p| pbHasRelearnableMove?(p)},true)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(relearner("BRIE: Ah, okay. Changed your mind?"))
          Kernel.pbMessage(sister("SAMANTHA: Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(relearner("BRIE: Um, that's an egg."))
          Kernel.pbMessage(relearner("Unless you want me to teach your Pokémon scrambled, or sunny-side..."))
          next
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(relearner("BRIE: What is this thing?! It isn't natural, get it out of here!"))
          next
        elsif !pbHasRelearnableMove?(pkmn)
          Kernel.pbMessage(relearner("BRIE: This Pokémon doesn't have any move that it can relearn. Sorry, \\v[3]."))
          next
        elsif pkmn.canRelearnAll?
          Kernel.pbMessage(relearner("BRIE: \\v[3] can already remember all its moves! Just do it from the party screen."))
          if $game_screen.relearnerpc_scales < 10
            Kernel.pbMessage(relearner("No reason I can't help you out from here, though. Free of charge."))
          else
            Kernel.pbMessage(relearner("No reason I can't help you out from here, though."))
          end
        end

        if pbRelearnMoveScreen(pkmn)
          couldRelearnAll = pkmn.canRelearnAll?
          pkmn.relearner = [true, 3]
          if couldRelearnAll && $game_screen.relearnerpc_scales < 10
            return if takeScale
            Kernel.pbMessage(sister("SAMANTHA: Thanks for doing business with us, \\PN! Call soon!"))
            return
          else
            Kernel.pbMessage(sister("SAMANTHA: Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        else
          Kernel.pbMessage(relearner("BRIE: Which Pokemon needs tutoring?"))
        end
      end
    elsif choice == 1
      Kernel.pbMessage(sister("SAMANTHA: Which Pokemon needs to forget a move?"))

      loop do
        pbChoosePokemon(1,3)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(sister("SAMANTHA: Changed your mind? That's fine."))
          Kernel.pbMessage(sister("Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(sister("SAMANTHA: You... know eggs don't <i>know</i> moves, right?"))
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(sister("SAMANTHA: Oh, I'm not licensed to work with affronts to Arceus."))
        elsif pkmn.moves.length == 1
          Kernel.pbMessage(sister("SAMANTHA: \\v[3] only knows one move!"))
        else
          Kernel.pbMessage(sister("SAMANTHA: Alright, and which move should \\v[3] forget?"))
          pbChooseMove(pkmn,2,4)
          moveresult = pbGet(2)
          if moveresult < 0
            Kernel.pbMessage(sister("SAMANTHA: Which Pokemon needs to forget a move?"))
          elsif Kernel.pbConfirmMessage(sister("SAMANTHA: \\v[3]'s \\v[4]? No problem!"))
            pbDeleteMove(pkmn, moveresult)
            Kernel.pbMessage(sister("And...\\| done! \\v[3] has forgotten \\v[4]!"))
            Kernel.pbMessage(sister("Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        end
      end
    elsif choice == 2
      Kernel.pbMessage(_INTL("\\sh\\c[7]SAMANTHA: HEY, BRIE! CUSTOMER! IT'S \\PNUpper!\\wtnp[50]"))
      Kernel.pbMessage(relearner("BRIE: Good to hear from you, \\PN. Rare moves? Sure!"))
      if $game_screen.relearnerpc_scales < 10
        if $PokemonBag.pbQuantity(:HEARTSCALE)>0
          Kernel.pbMessage(relearner("You've got a Heart Scale, so I can teach a Pokemon."))
        elsif 
          Kernel.pbMessage(relearner("... Actually, sorry, you need to come back with a Heart Scale."))
          Kernel.pbMessage(sister("SAMANTHA: Oh well! Talk to you later!"))
          return
        end
      end
      Kernel.pbMessage(relearner("Which Pokemon needs tutoring?"))

      loop do
        pbChoosePokemon(1,3,proc{|p| eggmove_getEggMoveList(p).size > 0},true)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(relearner("BRIE: Ah, okay. Changed your mind?"))
          Kernel.pbMessage(sister("SAMANTHA: Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(relearner("BRIE: Um, that's an egg."))
          Kernel.pbMessage(relearner("Unless you want me to teach your Pokémon scrambled, or sunny-side..."))
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(relearner("BRIE: What is this thing?! It isn't natural, get it out of here!"))
        elsif eggmove_getEggMoveList(pkmn).size == 0
          Kernel.pbMessage(relearner("BRIE: This Pokémon doesn't have any rare moves to learn. Sorry, \\v[3]."))
        elsif eggmove_pbRelearnMoveScreen(pkmn)
          pkmn.relearner = [true, 3]
          if $game_screen.relearnerpc_scales < 10
            return if takeScale
            Kernel.pbMessage(sister("SAMANTHA: Thanks for doing business with us, \\PN! Call soon!"))
            return
          else
            Kernel.pbMessage(sister("SAMANTHA: Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        else
          Kernel.pbMessage(relearner("BRIE: Which Pokemon needs tutoring?"))
        end
      end
    end
  end
end

ServicePCList.registerService(RelearnerPCService.new)

# Gen 8 learnsets for Galarian forms/Indeedee-F
$cache.pkmn[:SLOWPOKE].formData["Galarian Form"][:EggMoves] = [:BELCH,:BELLYDRUM,:BLOCK,:STOMP]
$cache.pkmn[:PONYTA].formData["Galarian Form"][:EggMoves] = [:DOUBLEKICK,:DOUBLEEDGE,:HORNDRILL,:HYPNOSIS,:MORNINGSUN,:THRASH,:PLAYROUGH] # Because play rough isn't tutorable yet
$cache.pkmn[:FARFETCHD].formData["Galarian Form"][:EggMoves] = [:COVET,:CURSE,:FEATHERDANCE,:FEINT,:FINALGAMBIT,:FLAIL,:GUST,:LEAFBLADE,:MUDSLAP,:NIGHTSLASH,:QUICKATTACK,:REVENGE,:SIMPLEBEAM,:SKYATTACK]
$cache.pkmn[:INDEEDEE].formData["Female"][:EggMoves] = [:FAKEOUT, :HEALPULSE, :PSYCHUP, :PSYCHOSHIFT]
if !$cache.pkmn[:FARFETCHD].formData["Galarian Form"][:compatiblemoves].include?(:CUT)
  $cache.pkmn[:FARFETCHD].formData["Galarian Form"][:compatiblemoves].push(:CUT)
end
# Fix Basculin forms
$cache.pkmn[:BASCULIN].formData["Blue-Striped"][:EggMoves] = [:AGILITY,:BRINE,:BUBBLEBEAM,:ENDEAVOR,:HEADSMASH,:MUDSHOT,:MUDDYWATER,:RAGE,:REVENGE,:SWIFT,:WHIRLPOOL]
$cache.pkmn[:BASCULIN].formData["White-Striped"][:EggMoves] = [:AGILITY,:ENDEAVOR,:HEADSMASH,:MUDDYWATER,:RAGE,:REVENGE,:SWIFT,:WHIRLPOOL,:SHADOWBONE] # Shadow Bone as poor replacement for Last Respects

# Aevian Jangmo-o has no egg moves
$cache.pkmn[:JANGMOO].formData["Aevian Form"][:EggMoves] = [:COUNTER,:DRAGONBREATH,:FOCUSPUNCH,:REVERSAL]
