class PokemonEncounters

  def pbShouldFilterKnownPkmnFromEncounter?
    ### MODDED/
    return false if $Trainer.party[0].item == :MIRRORLURE
    return true if $game_screen.lurerework_checkIsMagneticLureOn?
    return false
    ### /MODDED
  end
end

class ItemData < DataObject
  attr_accessor :flags
end

ItemHandlers::UseFromBag.add(:MAGNETICLURE,proc{|item| next 1 })

ItemHandlers::UseInField.add(:MAGNETICLURE,proc{|item|
  $game_screen.lurerework_toggleLure
})

$cache.items[:MAGNETICLURE].flags[:keyitem] = true
$cache.items[:MAGNETICLURE].flags[:noUse] = false
$cache.items[:MAGNETICLURE].flags[:utilityhold] = false
$cache.items[:MAGNETICLURE].desc = "A strange device. Draws in uncaught species when activated."

class PokemonBag_Scene
  if !defined?(lurerework_old_pbStartScene)
    alias :lurerework_old_pbStartScene :pbStartScene
  end

  def pbStartScene(bag)
    # Pocket 1 is default items
    if bag.pockets[1].include?(:MAGNETICLURE)
      bag.pockets[1].delete(:MAGNETICLURE)

      bag.pockets[pbGetPocket(:MAGNETICLURE)].push(:MAGNETICLURE) 
    end

    return lurerework_old_pbStartScene(bag)
  end
end

class Game_Screen

  attr_accessor   :lurerework_lureIsOn

  def lurerework_checkIsMagneticLureOn?
    return false if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    @lurerework_lureIsOn=false if !defined?(@lurerework_lureIsOn)
    return @lurerework_lureIsOn
  end

  def lurerework_toggleLure
    @lurerework_lureIsOn=!@lurerework_lureIsOn
    if lurerework_checkIsMagneticLureOn?
      Kernel.pbMessage(_INTL('The Magnetic Lure is now ON.'))
    else
      Kernel.pbMessage(_INTL('The Magnetic Lure is now OFF.'))
    end
  end
end

class PokeBattle_Battle
  def pbRun(idxPokemon,duringBattle=false)
    thispkmn=@battlers[idxPokemon]
    if pbIsOpposing?(idxPokemon)
      return 0 if @opponent
      @choices[i][0]=5 # run
      @choices[i][1]=0
      @choices[i][2]=nil
      return -1
    end
    if @opponent
      if $DEBUG && Input.press?(Input::CTRL)
        if pbDisplayConfirm(_INTL("Treat this battle as a win?"))
          @decision=1
          return 1
        elsif pbDisplayConfirm(_INTL("Treat this battle as a loss?"))
          @decision=2
          return 1
        end
      elsif @internalbattle
        if pbDisplayConfirm(_INTL("Would you like to forfeit the battle?"))
          pbDisplay(_INTL("{1} forfeited the match!",self.pbPlayer.name))
          @decision=2
          return 1
        end
      elsif pbDisplayConfirm(_INTL("Would you like to forfeit the match and quit now?"))
        pbDisplay(_INTL("{1} forfeited the match!",self.pbPlayer.name))
        @decision=3
        return 1
      end
      return 0
    end
    if $DEBUG && Input.press?(Input::CTRL)
      pbSEPlay("escape",100)
      pbDisplayPaused(_INTL("Got away safely!"))
      @decision=3
      return 1
    end
    if @cantescape || $game_switches[:Never_Escape]
      pbDisplayPaused(_INTL("Can't escape!"))
      return 0
    end
    if thispkmn.hasType?(:GHOST)
      pbSEPlay("escape",100)
      pbDisplayPaused(_INTL("Got away safely!"))
      @decision=3
      return 1
    end
    ### MODDED
    if thispkmn.hasWorkingItem(:SMOKEBALL) || thispkmn.hasWorkingItem(:MAGNETICLURE) ||
      thispkmn.hasWorkingItem(:MIRRORLURE) 
      ### /MODDED
      if duringBattle
        pbSEPlay("escape",100)
        pbDisplayPaused(_INTL("Got away safely!"))
      else
        pbSEPlay("escape",100)
        pbDisplayPaused(_INTL("{1} fled using its {2}!",thispkmn.pbThis,getItemName(thispkmn.item)))
      end
      @decision=3
      return 1
    end
    if thispkmn.ability == :RUNAWAY
      if duringBattle
        pbSEPlay("escape",100)
        pbDisplayPaused(_INTL("Got away safely!"))
      else
        pbSEPlay("escape",100)
        pbDisplayPaused(_INTL("{1} fled using Run Away!",thispkmn.pbThis))
      end
      @decision=3
      return 1
    end
    if !duringBattle && !pbCanSwitch?(idxPokemon,-1,false, running: true) # TODO: Use real messages
      pbDisplayPaused(_INTL("Can't escape!"))
      return 0
    end
    # Note: not pbSpeed, because using unmodified Speed
    speedPlayer=@battlers[idxPokemon].speed
    opposing=@battlers[idxPokemon].pbOppositeOpposing
    if opposing.isFainted?
      opposing=opposing.pbPartner
    end
    if !opposing.isFainted?
      speedEnemy=opposing.speed
      if speedPlayer>speedEnemy
        rate=256
      else
        speedEnemy=1 if speedEnemy<=0
        rate=speedPlayer*128/speedEnemy
        rate+=@runCommand*30
        rate&=0xFF
      end
    else
      rate=256
    end
    ret=1
    if pbAIRandom(256)<rate
      pbSEPlay("escape",100)
      pbDisplayPaused(_INTL("Got away safely!"))
      @decision=3
    else
      pbDisplayPaused(_INTL("Can't escape!"))
      ret=-1
    end
    if !duringBattle
      @runCommand+=1
    end
    return ret
  end
end
