Variables[:V2Story] = 359
Switches[:EarlyIncubator] = 1776 

class Game_Screen
  attr_accessor :daycarepc_used
  attr_accessor :daycarepc_lastCommand
end

class DayCarePCService
  def shouldShow?
    return $game_variables[:V2Story] >= 14
  end

  def name
    return _INTL("DayCare Delivers")
  end

  def help
    return _INTL("Remotely access the Day Care.")
  end

  def lady(text, *args) 
    return _INTL("\\f[service_DayCareLady]" + text, *args)
  end

  def man(text, *args) 
    return _INTL("\\f[service_DayCareMan]" + text, *args)
  end

  def color(num)
    return getSkinColor(nil, num, true)
  end

  def grayColor
    return color(7)
  end

  def disabledIfNot(text, condition)
    if condition
      return _INTL(text)
    else
      return grayColor + _INTL(text)
    end
  end

  def hasEggNeedIncubating?
    for pokemon in $Trainer.party
      return true if pokemon.isEgg? && pokemon.eggsteps > 1
    end
    return false
  end

  def buildCommands
    options = []
    egg = Kernel.pbEggGenerated?
    options.push(disabledIfNot("Deposit Pokemon", Kernel.pbDayCareDeposited < 2 && !egg))
    options.push(disabledIfNot("Withdraw Pokemon", Kernel.pbDayCareDeposited > 0 && !egg))
    options.push(disabledIfNot("Collect Egg", egg))
    if incubator?
      options.push(disabledIfNot("Wait for Egg", !egg && pbDayCareDeposited==2))
      options.push(disabledIfNot("Incubate Eggs", hasEggNeedIncubating?))
    end
    return options
  end

  def incubator?
    return $game_switches[:EarlyIncubator] # Currently, no other way to unlock the Incubator exists
  end

  def access
    if ServicePCList.offMap? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if !$game_screen.daycarepc_used
      Kernel.pbMessage(lady("Hello, you've reached the Day-Care Lady. How may I..."))
      Kernel.pbMessage(lady("Ah, you're new to DayCare Delivers? It's no problem. We let you access the Day-Care through your PC."))
      $game_screen.daycarepc_used = true
    else
      Kernel.pbMessage(lady("Hello, you've reached the Day-Care Lady!"))
    end

    Kernel.pbMessage(lady("It's good to see you. Now, about your Pokemon..."))
    Kernel.pbMessage(lady("By level, your \\v[3] has grown by about \\v[4].")) if pbDayCareGetLevelGain(0,3,4) && pbGet(4)>0
    Kernel.pbMessage(lady("By level, your \\v[3] has grown by about \\v[4].")) if pbDayCareGetLevelGain(1,3,4) && pbGet(4)>0

    command = $game_screen.daycarepc_lastCommand || 0
    command = 0 if !incubator? && command > 2
    while command >= 0
      command = Kernel.advanced_pbMessage(lady("Here are our services."), buildCommands, -1, nil, command)

      if command < 0
        Kernel.pbMessage(lady("Oh, fine, then.\nCall again."))
        break
      end

      $game_screen.daycarepc_lastCommand=command

      if command == 0 # Deposit
        if Kernel.pbDayCareDeposited>=2
          pbSEPlay('buzzer', 80, 75)
          next
        end
        Kernel.pbMessage(lady("Which Pokémon should we raise for you?"))
        loop do
          pbChooseNonEggPokemon(1,3)
          result = pbGet(1)
          break if result < 0
          if !pbCheckAble(result)
            Kernel.pbMessage(lady("If you leave me that Pokémon, what are you gonna battle with?"))
          else
            pbDayCareDeposit(result)
            Kernel.pbMessage(lady("Fine, we'll raise your \\v[3] for a while."))
            break
          end
        end
      elsif command == 1 # Withdraw
        if Kernel.pbDayCareDeposited==0
          pbSEPlay('buzzer', 80, 75)
          next
        end
        loop do
          pbDayCareChoose(lady("Which one do you want back?"),1)
          result = pbGet(1)
          break if result < 0
          pbDayCareGetDeposited(pbGet(1),3,4)
          cost = pbGet(4)
          if Kernel.pbConfirmMessage(lady("\\GIf you want your \\v[3] back, it will cost $\\v[4]."))
            if $Trainer.money < cost
              Kernel.pbMessage(_INTL("You don't have enough money..."))
              break
            else
              $Trainer.money -= cost
              Kernel.pbMessage(lady("\\GExcellent.\nHere's your Pokemon."))
              pbDayCareWithdraw(pbGet(1))
              Kernel.pbMessage(_INTL("\\PN got \\v[3] back from the Day-Care Lady."))
              break
            end
          else
            break
          end
        end
      elsif command == 2 # Collect Egg
        if !Kernel.pbEggGenerated?
          pbSEPlay('buzzer', 80, 75)
          next
        end

        Kernel.pbMessage(lady("Dear?"))
        Kernel.pbMessage(man("Ah, yes!"))
        Kernel.pbMessage(man("We were raising your Pokémon, and my goodness, were we surprised!"))
        Kernel.pbMessage(man("Your Pokémon was holding an Egg!"))
        Kernel.pbMessage(man("We don't know how it got there, but your Pokémon had it."))
        if Kernel.pbConfirmMessage(man("You do want it, don't you?")) ||
            Kernel.pbConfirmMessage(man("I really will keep it. You do want this Egg, yes?"))
          pbDayCareGenerateEgg
          Kernel.pbMessage(_INTL("\\PN was sent the Egg from the Day-Care Man."))
          Kernel.pbMessage(man("You take good care of it."))
        else
          Kernel.pbMessage(man("Well all right then, I'll take it. Thank you."))
          Kernel.pbMessage(man("That is, I don't think we'll ever find another..."))
          Kernel.pbMessage(man("No, no, I'm sure we'll find another one. I'm definitely sure of it!"))
        end
        $PokemonGlobal.daycareEgg=0
        $PokemonGlobal.daycareEggSteps=0
        if incubator?
          command = 3
          $game_screen.daycarepc_lastCommand=command
        end
      elsif command == 3 # Wait for Egg
        if !incubator? || Kernel.pbEggGenerated? || pbDayCareDeposited < 2
          pbSEPlay('buzzer', 80, 75)
          next
        end
        if pbDayCareGetCompat == 0
          Kernel.pbMessage(lady("Your pokemon don't seem to be paying that much attention to each other, dear."))
        else
          $game_screen.start_tone_change(Tone.new(-255,-255,-255,0),10)
          pbWait(10)
          pbMEPlay('Pokemon Healing', 100, 55)
          pbWait(50)
          $game_screen.start_tone_change(Tone.new(0,0,0,0),10)
          $PokemonGlobal.daycareEgg=1
          Kernel.pbMessage(lady("Well, would you look at that!"))
          Kernel.pbMessage(lady("My husband will probably want to see you."))
          command = 2
          $game_screen.daycarepc_lastCommand=command
        end
      elsif command == 4 # Incubate Eggs
        if !incubator? || !hasEggNeedIncubating?
          pbSEPlay('buzzer', 80, 75)
          next
        end
        Kernel.pbMessage(lady("Let me just take those Eggs, and..."))
        $game_screen.start_tone_change(Tone.new(-255,-255,-255,0),10)
        pbWait(10)
        pbMEPlay('Pokemon Healing', 100, 55)
        pbWait(50)
        $game_screen.start_tone_change(Tone.new(0,0,0,0),10)
        for pokemon in $Trainer.party
          pokemon.eggsteps=1 if pokemon.isEgg?
        end
        Kernel.pbMessage(lady("Your eggs are all warm and ready to hatch!"))
        $game_screen.daycarepc_lastCommand=command
      end
    end
  end
end

ServicePCList.registerService(DayCarePCService.new)
