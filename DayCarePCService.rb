begin
  missing = ['0000.formattedchoices.rb', '0000.textures.rb', '0001.pcservices.rb', 'ServiceIcons'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:V2Story] = 359
Switches[:EarlyIncubator] = 1776

TextureOverrides.registerServiceSprites('DayCareLady', 'DayCareMan')

if defined?(InjectionHelper)
  InjectionHelper.defineMapPatch(425, 1) { |event| # Sheridan Interiors, Day Care Lady
    event.patch(:daycarepc_preferBreedablePokemon) { |page|
      matched = page.lookForAll([:Script, "pbChooseNonEggPokemon(1,3)"])
      for insn in matched
        insn[0] = "daycarepc_selectPokemon(1,3)"
      end
    }
  }
  InjectionHelper.defineMapPatch(282, 13) { |event| # Dream District Interiors, pseudo-Day Care Lady
    event.patch(:daycarepc_preferBreedablePokemon) { |page|
      matched = page.lookForAll([:Script, "pbChooseNonEggPokemon(1,3)"])
      for insn in matched
        insn[0] = "daycarepc_selectPokemon(1,3)"
      end
    }
  }
end

def daycarepc_selectPokemon(resultvar,namevar)
  loop do
    pbChoosePokemon(resultvar,namevar,proc {|poke|
      !poke.isEgg? &&
      !(poke.isShadow? rescue false) &&
      daycarepc_compatCheck(poke)
    }, true)
    result = pbGet(resultvar)
    return if result < 0 # Handled by event

    poke = $Trainer.party[result]
    if poke.isEgg?
      Kernel.pbMessage(_INTL("That Pokémon hasn't even hatched yet!"))
      next
    else
      if !pbCheckAble(result)
        return # Handled by event
      else
        issueWithMon = false
        if (poke.isShadow? rescue false)
          Kernel.pbMessage(_INTL("Oh, my. That Pokémon... I don't think it'll get along with anything at all.\1"))
          issueWithMon = true
        elsif DayCarePCService::BABIES.include?(poke.species)
          Kernel.pbMessage(_INTL("Ah, what a cute little Pokémon! It isn't ready to have Eggs, though.\1"))
          issueWithMon = true
        elsif poke.eggGroups.include?(:Undiscovered)
          Kernel.pbMessage(_INTL("This Pokémon can't have Eggs at all.\1"))
          issueWithMon = true
        else
          variabletouse = 4
          variabletouse = 2 if resultvar == variabletouse || namevar == variabletouse
          variabletouse = 5 if resultvar == variabletouse || namevar == variabletouse
          if !daycarepc_compatCheck(poke,variabletouse)
            Kernel.pbMessage(_INTL("I don't think \\v[{1}] and \\v[{2}] will get along.\1", variabletouse, namevar))
            issueWithMon = true
          end
        end

        return unless issueWithMon && !Kernel.pbConfirmMessage(_INTL("Do you want to deposit \\v[{1}] anyway?", namevar))
      end
    end
  end
end

def daycarepc_compatCheck(poke,nameVariable=nil)
    pokeEggGroups = poke.eggGroups
    return false if pokeEggGroups.include?(:Undiscovered)
    return true if pbDayCareDeposited != 1

    daycarePoke = $PokemonGlobal.daycare[0][0] || $PokemonGlobal.daycare[1][0]
    $game_variables[nameVariable] = daycarePoke.name if nameVariable
    return false if !daycarePoke
    daycareEggGroups = daycarePoke.eggGroups
    return false if daycareEggGroups.include?(:Undiscovered)
    return ((pokeEggGroups & daycareEggGroups) || poke.species == :DITTO || daycarePoke.species == :DITTO) &&
      pbDayCareCompatibleGender(poke, daycarePoke)
  end

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

  BABIES = [
    :PICHU, :CLEFFA, :IGGLYBUFF, :TOGEPI, :TYROGUE, :SMOOCHUM, :ELEKID, :MAGBY, # Gen 2
    :AZURILL, :WYNAUT, # Gen 3
    :BUDEW, :CHINGLING, :BONSLY, :MIMEJR, :HAPPINY, :MUNCHLAX, :RIOLU, :MANTYKE, # Gen 4
    :TOXEL # Gen 8
  ]

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
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if !$game_screen.daycarepc_used
      Kernel.pbMessage(lady("Hello, you've reached the Day-Care Lady. How may I...\1"))
      Kernel.pbMessage(lady("Ah, you're new to DayCare Delivers? It's no problem. We let you access the Day-Care through your PC.\1"))
      $game_screen.daycarepc_used = true
    else
      Kernel.pbMessage(lady("Hello, you've reached the Day-Care Lady!\1"))
    end

    Kernel.pbMessage(lady("It's good to see you. Now, about your Pokemon...\1"))
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
          ServicePCList.buzzer
          next
        end
        Kernel.pbMessage(lady("Which Pokémon should we raise for you?"))
        loop do
          pbChoosePokemon(1,3,proc {|poke|
             !poke.isEgg? &&
             !(poke.isShadow? rescue false) &&
             daycarepc_compatCheck(poke)
          }, true)
          result = pbGet(1)
          break if result < 0

          poke = $Trainer.party[result]

          if poke.isEgg?
            Kernel.pbMessage(lady("That Pokémon hasn't even hatched yet!"))
            next
          end

          if !pbCheckAble(result)
            Kernel.pbMessage(lady("If you leave me that Pokémon, what are you gonna battle with?\1"))
          else
            issueWithMon = false
            if (poke.isShadow? rescue false)
              Kernel.pbMessage(lady("Oh, my. That Pokémon... I don't think it'll get along with anything at all.\1"))
              issueWithMon = true
            elsif BABIES.include?(poke.species)
              Kernel.pbMessage(lady("Ah, what a cute little Pokémon! It isn't ready to have Eggs, though.\1"))
              issueWithMon = true
            elsif poke.eggGroups.include?(:Undiscovered)
              Kernel.pbMessage(lady("This Pokémon can't have Eggs at all.\1"))
              issueWithMon = true
            elsif !daycarepc_compatCheck(poke,4)
              Kernel.pbMessage(lady("I don't think \\v[4] and \\v[3] will get along.\1"))
              issueWithMon = true
            end

            next if issueWithMon && !Kernel.pbConfirmMessage(lady("Do you want to deposit \\v[3] anyway?"))

            pbDayCareDeposit(result)
            Kernel.pbMessage(lady("Fine, we'll raise your \\v[3] for a while."))
            break
          end
        end
      elsif command == 1 # Withdraw
        if Kernel.pbDayCareDeposited==0
          ServicePCList.buzzer
          next
        end
        loop do
          pbDayCareChoose(lady("Which one do you want back?"),1)
          result = pbGet(1)
          break if result < 0
          pbDayCareGetDeposited(pbGet(1),3,4)
          cost = pbGet(4)
          if Kernel.pbConfirmMessage(lady("\\GIf you want your \\v[3] back, it will cost $\\v[4].\1"))
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
          ServicePCList.buzzer
          next
        end

        Kernel.pbMessage(lady("Dear?\1"))
        Kernel.pbMessage(man("Ah, yes!\1"))
        Kernel.pbMessage(man("We were raising your Pokémon, and my goodness, were we surprised!\1"))
        Kernel.pbMessage(man("Your Pokémon was holding an Egg!\1"))
        Kernel.pbMessage(man("We don't know how it got there, but your Pokémon had it.\1"))
        if Kernel.pbConfirmMessage(man("You do want it, don't you?")) ||
            Kernel.pbConfirmMessage(man("I really will keep it. You do want this Egg, yes?"))
          pbDayCareGenerateEgg
          Kernel.pbMessage(_INTL("\\PN was sent the Egg from the Day-Care Man."))
          Kernel.pbMessage(man("You take good care of it."))
        else
          Kernel.pbMessage(man("Well all right then, I'll take it. Thank you.\1"))
          Kernel.pbMessage(man("That is, I don't think we'll ever find another...\1"))
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
          ServicePCList.buzzer
          next
        end
        if pbDayCareGetCompat == 0
          Kernel.pbMessage(lady("Your Pokemon don't seem to be paying that much attention to each other, dear.\1"))
        else
          ServicePCList.fadeScreen(Tone.new(-255,-255,-255,0),10)
          pbWait(10)
          pbMEPlay('Pokemon Healing', 100, 55)
          pbWait(50)
          ServicePCList.restoreScreen(10)
          $PokemonGlobal.daycareEgg=1
          Kernel.pbMessage(lady("Well, would you look at that!\1"))
          Kernel.pbMessage(lady("My husband will probably want to see you."))
          command = 2
          $game_screen.daycarepc_lastCommand=command
        end
      elsif command == 4 # Incubate Eggs
        if !incubator? || !hasEggNeedIncubating?
          ServicePCList.buzzer
          next
        end
        Kernel.pbMessage(lady("Let me just take those Eggs, and...\1"))
        ServicePCList.fadeScreen(Tone.new(-255,-255,-255,0),10)
        pbWait(10)
        pbMEPlay('Pokemon Healing', 100, 55)
        pbWait(50)
        ServicePCList.restoreScreen(10)
        for pokemon in $Trainer.party
          pokemon.eggsteps=1 if pokemon.isEgg?
        end
        Kernel.pbMessage(lady("Your Eggs are all warm and ready to hatch!"))
        $game_screen.daycarepc_lastCommand=command
      end
    end
  end
end

ServicePCList.registerService(DayCarePCService.new)
