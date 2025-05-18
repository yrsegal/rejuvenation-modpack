class Game_Screen
  attr_accessor :hiddenpowerpc_used
end

class HiddenPowerPCService
  def shouldShow?
    return $game_self_switches[[329,90,"A"]] # Talked to Hidden Power changer
  end

  def name
    return _INTL("Hidden Potential")
  end

  def help
    return _INTL("Check or change a Pokemon's Hidden Power type.")
  end

  def nerta(text, *args) 
    return _INTL("\\f[service_Nerta]" + text, *args)
  end

  def hpChange(mon)
    pbHiddenPower(mon) if !mon.hptype
    oldtype=mon.hptype
    typechoices = [_INTL("Bug"),_INTL("Dark"),_INTL("Dragon"),_INTL("Electric"),_INTL("Fairy"),_INTL("Fighting"),_INTL("Fire"),_INTL("Flying"),_INTL("Ghost"),_INTL("Grass"),_INTL("Ground"),_INTL("Ice"),_INTL("Poison"),_INTL("Psychic"),_INTL("Rock"),_INTL("Steel"),_INTL("Water"),_INTL("Cancel")]
    choosetype = Kernel.pbMessage(nerta("Which type should its move become?"),typechoices,18)
    case choosetype
      when 0 then newtype=:BUG
      when 1 then newtype=:DARK
      when 2 then newtype=:DRAGON
      when 3 then newtype=:ELECTRIC
      when 4 then newtype=:FAIRY
      when 5 then newtype=:FIGHTING
      when 6 then newtype=:FIRE
      when 7 then newtype=:FLYING
      when 8 then newtype=:GHOST
      when 9 then newtype=:GRASS
      when 10 then newtype=:GROUND
      when 11 then newtype=:ICE
      when 12 then newtype=:POISON
      when 13 then newtype=:PSYCHIC
      when 14 then newtype=:ROCK
      when 15 then newtype=:STEEL
      when 16 then newtype=:WATER
      else newtype=-1
    end
    if newtype == -1
      Kernel.pbMessage(nerta("Changed your mind?"))
      return false
    end
    if (choosetype >= 0) && (choosetype < 17) && newtype!=oldtype
      mon.hptype=newtype
      return true
    end
    if newtype==oldtype
      Kernel.pbMessage(nerta("It's already that type!"))
    else
      Kernel.pbMessage(nerta("Changed your mind?"))
    end
    return false
  end

  def access
    if ServicePCList.offMap? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if !$game_screen.hiddenpowerpc_used
      Kernel.pbMessage(nerta("NERTA: Oh hey, it's you, kid!"))
      Kernel.pbMessage(nerta("If you send me a Pokemon and a Heart Scale over the PC system, I can unlock the Hidden Power of your pokemon remotely."))
      $game_screen.hiddenpowerpc_used = true
    else
      Kernel.pbMessage(nerta("NERTA: Hey, kid."))
    end

    if $PokemonBag.pbQuantity(:HEARTSCALE)<=0
      Kernel.pbMessage(nerta("Don't got the goods? Then don't expect the looks. Those are the rules kid.\\wtnp[20]"))
      return
    end

    if Kernel.pbMessage(nerta("Let's spiffen them up, shall we?"),[_INTL("Yes"),_INTL("No")], 2, nil, 0) != 0
      Kernel.pbMessage(nerta("Well, call back when you're feeling more decisive.\\wtnp[20]"))
    else
      selected = false
      while !selected
        pbChoosePokemon(1,3)

        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(nerta("NERTA: Change your mind huh?"))
          Kernel.pbMessage(nerta("Well, call back when you're feeling more decisive.\\wtnp[20]"))
          selected = true
        else
          pkmn = $Trainer.party[result]
          if pkmn.isEgg?
            Kernel.pbMessage(nerta("All that's inside here is an uncooked omelette."))
          else
            Kernel.pbMessage(nerta("Okay, {1}\'s Hidden Power is {2}.",pkmn.name,getTypeName(pbHiddenPower(pkmn))))
            if hpChange(pkmn)
              Kernel.pbMessage(nerta("NERTA: Okay, send over that Heart Scale, and..."))
              $PokemonBag.pbDeleteItem(:HEARTSCALE)
              Kernel.pbMessage(nerta("Bada bing, bada boom."))
              pbSEPlay("itemlevel")
              Kernel.pbMessage(nerta("Your \\v[3] should be feeling new power surging through them right about now!"))
              Kernel.pbMessage(nerta("Thanks for the Heart Scale. Call again!\\wtnp[20]"))
              selected = true
            else
              Kernel.pbMessage(nerta("Well, come back when you're feeling more decisive.\\wtnp[20]"))
              selected = true
            end
          end
        end
      end
    end
  end
end

ServicePCList.registerSubService(:Consultants, HiddenPowerPCService.new)
