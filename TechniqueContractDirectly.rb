begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

Variables[:LuckQuest] = 780

class TechniqueContract_MoveTutorScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon, moves)
    @scene.pbStartScene(pokemon, moves)
    loop do
      move=@scene.pbChooseMove
      if !move.is_a?(Symbol)
        if @scene.pbConfirm(
          _INTL("Give up trying to teach a new move?"))
          @scene.pbEndScene
          return false
        end
      else
        if pbLearnMove(pokemon,move)
          @scene.pbEndScene
          return true
        end
      end
    end
  end
end

def techniquecontract_movelist(pokemon, machinemoves, tutormoves)
  v = pokemon.formCheck(:compatiblemoves)
  if v!=nil
    bonuslist = v
  else      
    bonuslist = $cache.pkmn[pokemon.species].compatiblemoves
  end
  exceptionlist = pokemon.formCheck(:moveexceptions)
  exceptionlist = $cache.pkmn[pokemon.species].moveexceptions if exceptionlist.nil?
  bonuslist = bonuslist + (PBStuff::UNIVERSALTMS - exceptionlist)
  bonuslist += pokemon.getEggMoveList

  relearnlist = pbGetRelearnableMoves(pokemon)

  bonuslist.uniq!
  bonuslist.select! { |move| 
    ![:FISSURE,:ROCKCLIMB,:MAGMADRIFT].include?(move) && 
    !relearnlist.include?(move) && 
    !machinemoves.include?(move) && 
    !tutormoves.include?(move) &&
    !pokemon.knowsMove?(move) }
  return bonuslist
end

def techniquecontract_choosetechnique
  ret=false
  pbFadeOutIn(99999){
    if !defined?(Selectfromboxes_PokemonStorageScreen)
      scene=PokemonScreen_Scene.new
      movename=getMoveName(move)
      screen=PokemonScreen.new(scene,$Trainer.party)
      annot=pbMoveTutorAnnotations(move,movelist)
      screen.pbStartScene(_INTL("Teach which Pokémon?"),false,annot)
    end

    machinemoves = $cache.items.keys.select { |item| pbIsTM?(item) && $PokemonBag.pbQuantity(item) > 0 }.map { |item| $cache.items[item].flags[:tm] }
    tutormoves = pbGetTutorableMoves
    print(machinemoves)

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
          if techniquecontract_choosemove(pokemon,tech)
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
    scene=MoveRelearnerScene.new
    screen=TechniqueContract_MoveTutorScreen.new(scene)
    retval=screen.pbStartScreen(pokemon, tech)
  }
  return retval
end


InjectionHelper.defineMapPatch(434) { |map| # Luck's Tent
  InjectionHelper.createNewEvent(map, 16, 15, "Martel (Technique)") { |event|
    applicator = proc { |page|
      page.setGraphic("pkmn_marshadow", hueShift: 120, direction: :Up)
      page.walk_anime = true
      page.step_anime = true
      page.interact(
        [:ShowText, "MARTEL: I am allergic to Shards. Please support my continued satiation."],
        [:ConditionalBranch, :SelfSwitch, "A", false],
          [:ShowText, "I can teach most of what's in the Technique Contract, so I'm useful."],
          [:ShowText, "The Move Tutor app refuses to support my plight, so I don't support it."],
          [:ControlSelfSwitch, "A", true],
        :Done,
        [:Script, "vendorquantity_show_item_window(:BLKPRISM) if defined?(vendorquantity_show_item_window)"],
        [:ShowText, "Will you feed me?\\ch[1,2,Yes,No]"],
        [:ConditionalBranch, :Variable, 1, :Constant, 0, :Equals],
          [:ShowText, "MARTEL: My dietary requirement is three Black Prisms per move."],
          [:ConditionalBranch, :Script, "$PokemonBag.pbQuantity(:BLKPRISM)>2"],
            [:ConditionalBranch, :Script, "techniquecontract_choosetechnique"],
              [:Script, "$PokemonBag.pbDeleteItem(:BLKPRISM,3)"],
              [:ShowText, "MARTEL: Thank you. I will survive through the winter."],
              [:Script, "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"],
              :ExitEventProcessing,
            :Done,
          :Else,
            [:ShowText, "MARTEL: You offer food you don't have? How cruel."],
            [:Script, "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"],
            :ExitEventProcessing,
          :Done,
        :Done,
        [:ShowText, "MARTEL: Ok. I'll be here, starving."],
        [:Script, "vendorquantity_disposefully if defined?(vendorquantity_disposefully)"])
    }

    event.newPage { |page|
      page.requiresVariable(:LuckQuest, 7) # Luck quest complete
      applicator.call(page)
    }

    event.newPage { |page|
      page.requiresVariable(:ItsALuckyNumber, 2) # You fucked up
    }

    event.newPage { |page|
      page.requiresVariable(:ItsALuckyNumber, 4) # You resolved the fuckup
      applicator.call(page)
    }
  }
}
