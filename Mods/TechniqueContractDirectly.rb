

Variables[:LuckQuest] = 780

class TechniqueContract_MoveRelearnerScene < MoveRelearnerScene

  def initialize(tech)
    @tech = tech
  end

  def initializePage(pokemon, page)
    @pokemon = pokemon
    @partyid = @party.index(pokemon)
    @page = page
    @moves = []
    @error = nil

    pbDrawBackground()
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible = false
    @sprites["msgwindow"].viewport = @viewport
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow", 8, 40, 28, 2, @viewport)
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow", 8, 40, 28, 2, @viewport)
    @sprites["leftarrow"].y = ARROW_POS_X[0]
    @sprites["rightarrow"].x = ARROW_POS_X[1]
    @sprites["rightarrow"].y = ARROW_POS_Y
    @sprites["leftarrow"].y = ARROW_POS_Y
    @sprites["leftarrow"].play
    @sprites["rightarrow"].play

    @label = "Technique Contract"
    @moves = @tech.clone

    if @moves == [] && @error.nil?
      @error = _INTL("No moves available.")
    end

    applySorting

    tts("#{pokemon.name}'s #{@label}") unless @relearner

    @sprites["pokeicon"].dispose if @sprites["pokeicon"]
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
    @sprites["pokeicon"].x = SPRITESM_OFFSET[0]
    @sprites["pokeicon"].y = SPRITESM_OFFSET[1]

    moveCommands = @moves.map { |i| pbGetDisplayMoveName(i) }
    @sprites["commands"] = Window_CommandPokemon.new(moveCommands, 32)
    @sprites["commands"].x = Graphics.width
    @sprites["commands"].height = 32 * (VISIBLEMOVES + 1)
    pbDrawMoveList
  end
end

class TechniqueContract_MoveTutorScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon, moves)
    @scene.pbStartScene($Trainer.party, $Trainer.party.index(pokemon), true)
    loop do
      pokemon, move = @scene.pbChooseMove
      if !move.is_a?(Symbol)
        # Learning from party menu doesn't require a confirmation to exit.
        if Kernel.pbConfirmMessage(_INTL("Give up trying to teach a new move to {1}?", pokemon.name))
          @scene.pbEndScene
          return false
        end
      elsif Kernel.pbConfirmMessage(_INTL("Teach {1}?", getMoveName(move)))
        if pbTryLearnMove(pokemon, move, dontrestorePP: false)
          @scene.pbEndScene
          return true
        end
      end
    end
  end
end

def techniquecontract_movelist(pokemon, machinemoves, tutormoves)
  bonuslist = pokemon.getCacheData.compatiblemoves
  exceptionlist = pokemon.getCacheData.moveexceptions
  bonuslist = bonuslist + (getUniversalTMs() - exceptionlist)
  bonuslist += pokemon.getEggMoveList
  bonuslist.uniq!
  bonuslist = bonuslist - [:FISSURE, :ROCKCLIMB, :MAGMADRIFT, :QUICKSILVERSPEAR]

  relearnlist = pokemon.pbGetNaturalMovesMenu(true) + pokemon.pbGetTMMovesMenu + pokemon.pbGetTutorMovesMenu + pokemon.pbGetEggMovesMenu
  bonuslist.select! { |move| 
    !relearnlist.include?(move) && 
    !pokemon.knowsMove?(move) }
  return bonuslist
end

def techniquecontract_movetutorannotations(machinemoves, tutormoves)
  annot = []
  for i in 0...6
    annot[i] = nil
    next if i >= $Trainer.party.length

    mon = $Trainer.party[i]
    if mon.isEgg?
      text = _INTL("Not Able")
      colors = ANNOT_INELIGIBLE_COLORS
    else
      l = techniquecontract_movelist($Trainer.party[i], machinemoves, tutormoves)
      if l.empty?
        text = _INTL("Not Able")
        colors = ANNOT_INELIGIBLE_COLORS
      else
        text = _INTL("Able")
        colors = ANNOT_ELIGIBLE_COLORS
      end
    end
    annot[i] = [text, colors]
  end
  return annot
end

def techniquecontract_choosetechnique
  ret=false
  pbFadeOutIn(99999){
    machinemoves = $cache.items.keys.select { |item| pbIsTM?(item) && $PokemonBag.pbQuantity(item) > 0 }.map { |item| $cache.items[item].flags[:tm] }
    tutormoves = pbGetTutorableMoves

    if !defined?(Selectfromboxes_PokemonStorageScreen)
      scene=PokemonScreen_Scene.new
      screen=PokemonScreen.new(scene,$Trainer.party)
      annot=techniquecontract_movetutorannotations(machinemoves, tutormoves)
      screen.pbStartScene(_INTL("Teach which Pokémon?"),annot)
    end
    
    loop do
      if defined?(Selectfromboxes_PokemonStorageScreen)
        pbChoosePokemon(1, 2, proc {|pkmn|
          !pkmn.isEgg? &&
          !(pkmn.isShadow? rescue false) &&
          techniquecontract_movelist(pkmn, machinemoves, tutormoves).length > 0
        },
        selectfromboxes_commandText: "Teach")
        chosen = pbGet(1)
      else
        chosen = screen.pbChoosePokemon
      end

      if chosen>=0
        pokemon=$Trainer.party[chosen]
        tech = techniquecontract_movelist(pokemon, machinemoves, tutormoves)
        if pokemon.isEgg?
          Kernel.pbMessage(_INTL("Moves can't be taught to an Egg."))
        elsif (pokemon.isShadow? rescue false)
          Kernel.pbMessage(_INTL("Shadow Pokémon can't be taught any moves."))
        elsif tech.length <= 0
          Kernel.pbMessage(_INTL("{1} has no moves it can be taught by Technique Contract.",pokemon.name))
        else
          if techniquecontract_choosemove(pokemon, tech)
            ret=true
            break
          end
        end
      else
        break
      end
    end
    screen.pbEndScene if !defined?(Selectfromboxes_PokemonStorageScreen)
  }
  return ret
end

def techniquecontract_choosemove(pokemon, tech)
  retval=true
  pbFadeOutIn(99999){
    scene=TechniqueContract_MoveRelearnerScene.new(tech)
    screen=TechniqueContract_MoveTutorScreen.new(scene)
    retval=screen.pbStartScreen(pokemon, tech)
  }
  return retval
end


InjectionHelper.defineMapPatch(434) { # Luck's Tent
  createNewEvent(16, 15, "Martel (Technique)", "techniquecontract_techniquemarshadow") {
    applicator = proc {
      setGraphic "pkmn_marshadow", hueShift: 120, direction: :Up
      walk_anime = true
      step_anime = true
      always_on_top = true
      interact {
        text "MARTEL: I am allergic to Shards. Please support my continued satiation."
        branch(self_switch["A"], false) {
          text "I can teach most of what's in the Technique Contract, so I'm useful."
          text "The Move Tutor app refuses to support my plight, so I don't support it."
          self_switch["A"] = true
        }

        script "vendorquantity_show_item_window(:BLKPRISM) if defined?(vendorquantity_show_item_window)"
        text "Will you feed me?\\ch[1,2,Yes,No]"
        branch(variables[1], :==, 0) {
          text "MARTEL: My dietary requirement is three Black Prisms per move."
          branch("$PokemonBag.pbQuantity(:BLKPRISM)>2") {
            branch("techniquecontract_choosetechnique") {
              script "$PokemonBag.pbDeleteItem(:BLKPRISM,3)"
              text "MARTEL: Thank you. I will survive through the winter."
              script "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"
              exit_event_processing 
            }
          }.else {
            text "MARTEL: You offer food you don't have? How cruel."
            script "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"
            exit_event_processing 
          }
        }
        text "MARTEL: Ok. I'll be here, starving."
        script "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"
      }
    }

    newPage {
      requiresVariable(:LuckQuest, 7) # Luck quest complete
      instance_exec(&applicator)
    }

    newPage {
      requiresVariable(:ItsALuckyNumber, 2) # You fucked up
    }

    newPage {
      requiresVariable(:ItsALuckyNumber, 4) # You resolved the fuckup
      instance_exec(&applicator)
    }
  }
}
