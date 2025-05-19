Switches[:GreetingsEizen] = 1763
Switches[:EizenKnows] = 1138
Variables[:TheInconsistency] = 431

TextureOverrides.registerServiceSprites('Eizen', 'Matthew')

class Game_Screen
  attr_accessor :pokeballtransferpc_used
  attr_accessor :pokeballtransferpc_eizen_prankcall
  attr_accessor :pokeballtransferpc_explainshiny
  attr_accessor :pokeballtransferpc_explainballfetch
end

class PokeBattle_Pokemon
  attr_accessor :pokeballtransferpc_beforeGlitterBallShiny
end

class PokemonTradeScene
  def pokeballtransferpc_transferBall
    pbBGMStop()
    pbBGMPlay("Evolution")
    pbPlayCry(@pokemon)
    speciesname=getMonName(@pokemon.species)
    Kernel.pbMessageDisplay(@sprites["msgwindow"],
       _ISPRINTF("{1:s}\r\nSpecies: {2:s}<r>Ball: {3:s}\\wtnp[0]",
       @pokemon.name,getMonName(@pokemon.species),getItemName(@pokemon.ballused)))
    Kernel.pbMessageWaitForInput(@sprites["msgwindow"],100,true)
    pbPlayDecisionSE()
    pbScene1
    
    Kernel.pbMessageDisplay(@sprites["msgwindow"],
       _INTL("Matthew tinkers with {1}'s Pokeball.", @pokemon.name))
    pbScene2
    Kernel.pbMessageDisplay(@sprites["msgwindow"],
       _ISPRINTF("{1:s}\r\nSpecies: {2:s}<r>Ball: {3:s}\1",
       @pokemon2.name,getMonName(@pokemon.species),getItemName(@pokemon2.ballused)))
    Kernel.pbMessageDisplay(@sprites["msgwindow"],
       _INTL("{1} is snug in its new {2}!", @pokemon2.name, getItemName(@pokemon2.ballused)))
    pbBGMStop()
  end
end

BallHandlers::OnCatch.add(:GLITTERBALL,proc{|ball,battle,pokemon|
  ### MODDED/
  pokemon.pokeballtransferpc_beforeGlitterBallShiny = pokemon.shinyflag
  ### /MODDED
  pokemon.makeShiny
})

NON_INHERITABLE_BALLS.push(:GLITTERBALL) if !NON_INHERITABLE_BALLS.include?(:GLITTERBALL)

class PokeballTransferPCService

  def matt(text, *args) 
    return _INTL("\\f[service_Matthew]" + text, *args)
  end
  def eizen(text, *args) 
    return _INTL("\\f[service_Eizen]" + text, *args)
  end

  def transferBall(pkmn, newBall, oldscene)
    originalBall = pkmn.ballused || :POKEBALL

    fakePkmn = pkmn.clone

    shininessChanged = false

    if originalBall == :GLITTERBALL && newBall != :GLITTERBALL
      wasShiny = pkmn.isShiny?
      pkmn.shinyflag = pkmn.pokeballtransferpc_beforeGlitterBallShiny
      pkmn.pokeballtransferpc_beforeGlitterBallShiny = nil
      shininessChanged = pkmn.isShiny? != wasShiny
    elsif newBall == :GLITTERBALL && originalBall != :GLITTERBALL
      wasShiny = pkmn.isShiny?
      pkmn.pokeballtransferpc_beforeGlitterBallShiny = pkmn.shinyflag
      pkmn.makeShiny
      shininessChanged = pkmn.isShiny? != wasShiny
    end

    pkmn.ballused = newBall
    fakePkmn.ballused = originalBall

    $PokemonBag.pbDeleteItem(newBall)

    pbFadeOutInWithMusic(99999){
      evo=PokemonTradeScene.new
      evo.pbStartScreen(fakePkmn,pkmn,$Trainer.name,$Trainer.name)
      oldscene.pbEndScene
      evo.pokeballtransferpc_transferBall
      evo.pbEndScreen
    }

    if pkmn.ability == :BALLFETCH
      Kernel.pbReceiveItem(originalBall)
      if !$game_screen.pokeballtransferpc_explainballfetch
        Kernel.pbMessage(matt("MATTHEW: ...?"))
        ServicePCList.happySound
        Kernel.pbMessage(matt("Oh! Looks like it fetched the {1}! What a good {2}.", getItemName(originalBall), getMonName(pkmn.species)))
        $game_screen.pokeballtransferpc_explainballfetch = true
      else
        ServicePCList.happySound
        Kernel.pbMessage(matt("MATTHEW: What a good {2}! It fetched the {1}.", getItemName(originalBall), getMonName(pkmn.species)))
      end
      explainShiny if shininessChanged
      Kernel.pbMessage(matt("Well, have a good day!"))
    elsif shininessChanged
      explainShiny(true)
      Kernel.pbMessage(matt("Well, have a good day!"))
    else
      Kernel.pbMessage(matt("Have a good day!"))
    end
  end

  def explainShiny(statementStart = false)
    if !$game_screen.pokeballtransferpc_explainshiny
      if statementStart
        Kernel.pbMessage(matt("MATTHEW: ...?"))
        Kernel.pbMessage(matt("Oh! The color changed! Did the ball transfer change something?"))
      else
        Kernel.pbMessage(matt("And the color changed! Did the ball transfer change something?"))
      end
      if $game_switches[:EizenKnows]
        Kernel.pbMessage(eizen("EIZEN: The Glitter Ball sets the shiny flag of a Pokemon artificially."))
        Kernel.pbMessage(eizen("If you transfer a Pokemon to or from one, their status as shiny can change."))
        Kernel.pbMessage(eizen("Naturally occurring shiny Pokemon won't be affected by this."))
        Kernel.pbMessage(matt("MATTHEW: That's really interesting? What's a 'shiny flag'?"))
        Kernel.pbMessage(eizen("EIZEN: \\PN knows."))
        Kernel.pbMessage(matt("MATTHEW: Neat!"))
      else 
        Kernel.pbMessage(matt("A Glitter Ball was involved... those can change a Pokemon's coloration."))
      end
      $game_screen.pokeballtransferpc_explainshiny = true
    else
      if statementStart
        Kernel.pbMessage(matt("MATTHEW: Oh, the color changed again!"))
      elsif
        Kernel.pbMessage(matt("Oh, and the color changed again!"))
      end
    end
  end


  def shouldShow?
    return $game_variables[:TheInconsistency] >= 15
  end

  def name
    return _INTL("Pokeball Transfer")
  end

  def help
    return _INTL("Change the Pokeball a Pokemon is in.")
  end

  def access
    if ServicePCList.inZeight? || ServicePCList.inRift?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("The phone was answered, but immediately hung up..."))
      return
    end

    if ServicePCList.distantTime?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if ServicePCList.inNightmare?
      Kernel.pbMessage(_INTL("..."))
      if $game_switches[:EizenKnows]
        Kernel.pbMessage(eizen("It was picked up?"))
        Kernel.pbMessage(eizen("EIZEN: <i>Some</i> of us are trying to sleep."))
        if $game_switches[:GreetingsEizen] && !$game_screen.pokeballtransferpc_eizen_prankcall
          Kernel.pbMessage(eizen("And please, stop prank calling me."))
          $game_screen.pokeballtransferpc_eizen_prankcall = true
        end
      else
        Kernel.pbMessage(_INTL("The phone was answered, but immediately hung up..."))
      end
      return
    end

    if inPast?
      Kernel.pbMessage(_INTL("..."))
      if $game_switches[:EizenKnows]
        Kernel.pbMessage(eizen("It was picked up?"))
        Kernel.pbMessage(eizen("EIZEN: This service isn't open yet."))
        if $game_switches[:GreetingsEizen] && !$game_screen.pokeballtransferpc_eizen_prankcall
          Kernel.pbMessage(eizen("And please, stop prank calling me."))
          $game_screen.pokeballtransferpc_eizen_prankcall = true
        end
      else
        Kernel.pbMessage(_INTL("The phone was answered, but immediately hung up..."))
      end
      return
    end

    if ServicePCList.offMap? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(matt("MATTHEW: Hello, \\PN! What can I do for you?"))
    if !$game_screen.pokeballtransferpc_used
      if $game_switches[:EizenKnows]
        Kernel.pbMessage(eizen("EIZEN: Matthew, \\PN would like a Pokemon transfered out of its Pokeball."))
        Kernel.pbMessage(matt("MATTHEW: Oh, sure! I can do that, no problem!"))
      else
        ServicePCList.playerTalk
        ServicePCList.exclaimSound
        Kernel.pbMessage(matt("MATTHEW: Ah! You want to transfer a Pokemon into a new ball? I can do that!"))
      end
      Kernel.pbMessage(matt("Just remember, you won't be able to get the original Pokeball back after the transfer."))
      $game_screen.pokeballtransferpc_used = true
    end

    Kernel.pbMessage(matt("Which Pokemon would you like to transfer into a new Pokeball?"))
    pbChooseNonEggPokemon(1,3)
    result = pbGet(1)
    if result < 0
      if $game_switches[:EizenKnows]
        Kernel.pbMessage(matt("MATTHEW: Changed your mind? That's fine! I'll be here!"))
        Kernel.pbMessage(eizen("EIZEN: Forever."))
        Kernel.pbMessage(matt("MATTHEW: Arrow..."))
      else
        Kernel.pbMessage(matt("MATTHEW: Changed your mind? That's fine! I'll be here!"))
      end
      return
    end

    pkmn = $Trainer.party[result]

    Kernel.pbMessage(matt("MATTHEW: And what ball would you like to transfer it into?"))

    itemscene=PokemonBag_Scene.new
    oldlastpocket=$PokemonBag.lastpocket
    $PokemonBag.lastpocket = 3 # Pokeball Pocket
    itemscene.pbStartScene($PokemonBag)

    loop do
      item=itemscene.pbChooseItem
      if item.nil?
        itemscene.pbEndScene
        $PokemonBag.lastpocket = oldlastpocket
        if $game_switches[:EizenKnows]
          Kernel.pbMessage(matt("MATTHEW: Changed your mind? That's fine! I'll be here!"))
          Kernel.pbMessage(eizen("EIZEN: Forever."))
          Kernel.pbMessage(matt("MATTHEW: Arrow..."))
        else
          Kernel.pbMessage(matt("MATTHEW: Changed your mind? That's fine! I'll be here!"))
        end
        return
      end

      if item == :SNOWBALL || item == :SMOKEBALL || item == :IRONBALL || item == :LIGHTBALL
        Kernel.pbMessage(matt("MATTHEW: ... I said a POKEball."))
      elsif !$cache.items[item].checkFlag?(:ball)
        Kernel.pbMessage(matt("MATTHEW: That's not a Pokeball!"))
      elsif pkmn.ballused == item
        Kernel.pbMessage(matt("MATTHEW: {1} is already in a {2}!",pkmn.name,getItemName(item)))
      elsif Kernel.pbConfirmMessage(matt("MATTHEW: Okay, so we'll be moving {1} from a {2} into a {3}?", 
        pkmn.name,getItemName(pkmn.ballused || :POKEBALL),getItemName(item)))
        $PokemonBag.lastpocket = oldlastpocket
        transferBall(pkmn, item, itemscene)
        return
      end
    end

  end
end

ServicePCList.registerSubService(:Consultants, PokeballTransferPCService.new)

