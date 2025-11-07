begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
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

def techniquecontract_movetutorannotations(machinemoves, tutormoves)
  ret=[]
  for i in 0...6
    ret[i]=nil
    next if i>=$Trainer.party.length
    if $Trainer.party[i].isEgg? || ($Trainer.party[i].isShadow rescue false)
      ret[i]=_INTL("NOT ABLE")
    else
      l = techniquecontract_movelist($Trainer.party[i], machinemoves, tutormoves)
      if l.empty?
        ret[i]=_INTL("NOT ABLE")
      else
        ret[i]=_INTL("ABLE")
      end
    end
  end
  return ret
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
      screen.pbStartScene(_INTL("Teach which Pokémon?"),false,annot)
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
