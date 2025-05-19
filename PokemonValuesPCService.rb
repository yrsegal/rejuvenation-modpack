
Variables[:StarterChoice] = 7
Variables[:Post10thBadge] = 353
Variables[:QuestCrossover] = 573

class Game_Screen
  attr_accessor :pokemonvaluespc_used
  attr_accessor :pokemonvaluespc_called_gearen_in_gdc
  attr_accessor :pokemonvaluespc_use_gdc
  attr_accessor :pokemonvaluespc_neo
  attr_accessor :pokemonvaluespc_unlocked_iv
  attr_accessor :pokemonvaluespc_unlocked_ev
  attr_accessor :pokemonvaluespc_unlocked_ability
  attr_accessor :pokemonvaluespc_unlocked_nature
end

class PokemonValuesPCService

  def shouldShow?
    return $game_variables[:StarterChoice] >= 1
  end

  def name
    return _INTL("GDC Central Labs") if $game_screen.pokemonvaluespc_use_gdc
    return _INTL("Neo Gearen Labs") if $game_screen.pokemonvaluespc_neo
    return _INTL("Gearen Labs")
  end

  def help
    return _INTL("Tune the stats and abilities of a Pokemon.")
  end

  def gearen(text, *args) 
    return _INTL("\\f[service_GearenLabs]" + text, *args)
  end

  def gdc(text, *args) 
    return _INTL("\\f[service_GDCCentral]" + text, *args)
  end

  def lab(text, *args)
    return gdc(text, *args) if $game_screen.pokemonvaluespc_use_gdc
    return gearen(text, *args)
  end

  EV_CARDS = [:HPCARD, :ATKCARD, :DEFCARD, :SPATKCARD, :SPDEFCARD, :SPEEDCARD]
  STAT_NAMES = ["HP", "Attack", "Defense", "Special Attack", "Special Defense", "Speed"]
  STAT_NAMES_SHORT = [nil, "ATK", "DEF", "SPATK", "SPDEF", "SPEED"]
  FLAVORS_TO_STATS = [nil, 'spicy', 'sour', 'sweet', 'dry', 'bitter']

  def color(num)
    return getSkinColor(nil, num, true)
  end

  def disabledIfNot(text, condition)
    if condition
      return _INTL(text)
    else
      return grayColor + _INTL(text)
    end
  end

  def makeOptions
    options = []
    options.push(disabledIfNot("IVs", $game_screen.pokemonvaluespc_unlocked_iv))
    options.push(disabledIfNot("EVs", $game_screen.pokemonvaluespc_unlocked_ev))
    options.push(disabledIfNot("Natures", $game_screen.pokemonvaluespc_unlocked_nature))
    options.push(disabledIfNot("Abilities", $game_screen.pokemonvaluespc_unlocked_ability))
    return options
  end

  def makeStatOptions(needCards, mapper, maxValue)
    options = []
    for i in 0...6
      options.push(_INTL(STAT_NAMES[i] + " {2}({1})", mapper[i], colorForStat(mapper[i], maxValue))) if !needCards || $PokemonBag.pbQuantity(EV_CARDS[i]) > 0
      options.push(grayColor + _INTL(STAT_NAMES[i] + " ({1})", mapper[i])) if needCards && $PokemonBag.pbQuantity(EV_CARDS[i]) <= 0
    end
    return options
  end

  def colorForStat(value, maxValue)
    if value >= maxValue
      return positiveColor # red, positive here
    elsif value == 0
      return negativeColor # blue, negative here
    else
      return grayColor
    end
  end

  def positiveColor
    return color(2)
  end

  def negativeColor
    return color(1)
  end

  def grayColor
    return color(7)
  end

  def tweaking(pkmn)
    command = 0
    anyChange = false
    while command >= 0
      commands=makeOptions
      command=Kernel.advanced_pbMessage(_INTL("Tweak which?"), commands, -1, nil, command)
      case command
        when 0
          anyChange = ivs(pkmn) || anyChange if $game_screen.pokemonvaluespc_unlocked_iv
          ServicePCList.buzzer if !$game_screen.pokemonvaluespc_unlocked_iv
        when 1
          anyChange = evs(pkmn) || anyChange if $game_screen.pokemonvaluespc_unlocked_ev
          ServicePCList.buzzer if !$game_screen.pokemonvaluespc_unlocked_ev
        when 2
          anyChange = natures(pkmn) || anyChange if $game_screen.pokemonvaluespc_unlocked_nature
          ServicePCList.buzzer if !$game_screen.pokemonvaluespc_unlocked_nature
        when 3
          anyChange = abilities(pkmn) || anyChange if $game_screen.pokemonvaluespc_unlocked_ability
          ServicePCList.buzzer if !$game_screen.pokemonvaluespc_unlocked_ability
      end

      if command < 0 && anyChange
        command = 0 if !Kernel.pbConfirmMessage(lab("Are you satisfied with your changes?"))
      end

    end
    return anyChange
  end

  def ivs(pkmn)
    command = 0
    anyChange = false

    while command >= 0
      commands=makeStatOptions(false, pkmn.iv, 31)
      if pkmn.iv != [31, 31, 31, 31, 31, 31]
        commands.push(color(2) + _INTL("Maximize all"))
      end
      command=Kernel.advanced_pbMessage(_INTL("Change which IV?"), commands, -1, nil, command)
      if command == 6
        for i in 0...6
          pkmn.iv[i] = 31
        end
        anyChange = true
      elsif command >= 0
        params=ChooseNumberParams.new
        params.setRange(0,99)
        params.setDefaultValue(pkmn.iv[command])
        params.setCancelValue(pkmn.iv[command])
        newValue = [31, Kernel.pbMessageChooseNumber(
           _INTL("Set the IV for {1} (max. 31).",STAT_NAMES[command]),params)].min
        anyChange = true if newValue != pkmn.iv[command]
        pkmn.iv[command] = newValue
      end
    end
    return anyChange
  end


  def evs(pkmn)
    command = 0
    anyChange = false
    evMax = $game_switches[:No_Total_EV_Cap] ? 255 : 252
    evTotalMax = $game_switches[:No_Total_EV_Cap] ? 255 * 6 : 510

    for i in 0...6
      if pkmn.ev[i] > evMax
        pkmn.ev[i] = evMax
      end
    end

    unlockedEvs = EV_CARDS.map { |item| $PokemonBag.pbQuantity(item) > 0 }

    while command >= 0
      commands=makeStatOptions(true, pkmn.ev, evMax)
      currentTotal = pkmn.ev.sum
      command=Kernel.advanced_pbMessage(_INTL("Change which EV? (Total: {1}, max. {3}{2}</c3>)", 
        currentTotal, evTotalMax, colorForStat(currentTotal, evTotalMax)), commands, -1, nil, command)
      if command >= 0
        if !unlockedEvs[command]
          ServicePCList.buzzer
          next
        end

        currentMax = [evMax, evTotalMax - currentTotal + pkmn.ev[command]].min
        params=ChooseNumberParams.new
        params.setRange(0,999)
        params.setDefaultValue(pkmn.ev[command])
        params.setCancelValue(pkmn.ev[command])
        newValue = [currentMax, Kernel.pbMessageChooseNumber(
           _INTL("Set the EV for {1} (max. {2}).",STAT_NAMES[command],currentMax),params)].min
        anyChange = true if newValue != pkmn.iv[command]
        pkmn.ev[command]=newValue
      end
    end

    return anyChange
  end

  if !defined?($builtCommands) || !defined?($builtNatures)
    $builtCommands = nil
    $builtNatures = nil
  end

  def natures(pkmn)
    command = 0
    anyChange = false
    if !$builtNatures || !$builtCommands
      $builtCommands = []
      $buildNatures = []
      $cache.natures.each_with_index { |(natureKey, nature), idx|
        command = idx if pkmn.nature == natureKey
        if !nature.incStat && !nature.decStat
          $builtCommands.push(_INTL("{1}  {3}±{2}", nature.name, STAT_NAMES_SHORT[FLAVORS_TO_STATS.index(nature.like)], grayColor))
        else
          $builtCommands.push(_INTL("{1}  {4}+{2}</c3> {5}-{3}</c3>", nature.name, STAT_NAMES_SHORT[nature.incStat], STAT_NAMES_SHORT[nature.decStat],
            positiveColor, negativeColor))
        end
        $buildNatures.push(natureKey)
      }
    else
      command = $builtNatures.index(pkmn.nature)
      command = 0 if command.nil?
    end


    while command >= 0
      msg=_INTL("{1} is {2}'s current nature.",getNatureName(pkmn.nature),pkmn.name)
      command=Kernel.advanced_pbMessage(msg,$builtCommands, -1, nil, command)
      if command >= 0 && command < $builtNatures.size
        anyChange = true if pkmn.nature != $builtNatures[command]
        pkmn.setNature(nil)
        pkmn.nature = $builtNatures[command]
      end
    end

    return anyChange
  end

  def abilities(pkmn)
    abils=pkmn.getAbilityList || [] # Dedupe
    command = abils.index(pkmn.ability)
    command = 0 if command.nil?
    anyChange = false

    commands=[]
    for i in 0..abils.length-1
      commands.push(((i < abils.length-1 || !$cache.pkmn[pkmn.species].checkFlag?(:HiddenAbilities)) ? "" : "(H) ")+getAbilityName(abils[i]))
    end

    while command >= 0
      msg=_INTL("{1} is {2}'s current ability.",getAbilityName(abils[command]),pkmn.name)
      command=Kernel.pbMessage(msg,commands,-1, nil, command)
      if command >= 0 && command < commands.length
        newAbility = abils[command]
        anyChange = true if newAbility != pkmn.ability
        pkmn.setAbility(newAbility)
      end
    end

    return anyChange
  end

  def wait(length)
    Kernel.pbMessage(lab("\\wtnp[{1}]", length))
  end

  def checkUnlocks
    unlockedAny = false

    if !$game_screen.pokemonvaluespc_unlocked_iv && $PokemonBag.pbQuantity(:CELLIMPRINT) > 0
      ServicePCList.exclaimSound
      wait(5)
      if (Kernel.pbConfirmMessage(lab("If I'm not mistaken, that's a Cell Imprint! If you want to hand one over, we can get you set up with IV Tweaking!"))) ||
        !Kernel.pbConfirmMessageSerious(lab("... Are you sure? I'm required to keep asking you every time you call..."))
        $PokemonBag.pbDeleteItem(:CELLIMPRINT)
        wait(25)
        ServicePCList.happySound
        Kernel.pbMessage(lab("Done! You're now registered for IV Tweaking."))
        $game_screen.pokemonvaluespc_unlocked_iv = true
        unlockedAny = true
      else
        Kernel.pbMessage(lab("Alright..."))
      end
    end

    if !$game_screen.pokemonvaluespc_unlocked_ev
      cards = 0
      for card in EV_CARDS
        if $PokemonBag.pbQuantity(card) > 0
          cards += 1
        end
      end

      if cards == 6
        ServicePCList.exclaimSound
        wait(5)
        Kernel.pbMessage(lab("If I'm not mistaken, those are all of the EV Cards! Let me get you set up with EV Tweaking!"))
        wait(25)
        ServicePCList.happySound
        Kernel.pbMessage(lab("Done! You're now registered for EV Tweaking, in every stat!"))
        $game_screen.pokemonvaluespc_unlocked_ev = true
        unlockedAny = true
      elsif cards > 0
        ServicePCList.exclaimSound
        wait(5)
        Kernel.pbMessage(lab("If I'm not mistaken, those are EV Cards! Let me get you set up with EV Tweaking!"))
        wait(25)
        ServicePCList.happySound
        Kernel.pbMessage(lab("Done! You're now registered for EV Tweaking. You can only tweak EVs you have the cards for, so get that AP!"))        
        $game_screen.pokemonvaluespc_unlocked_ev = true  
        unlockedAny = true
      end
    end

    naturePower = getTMFromMove(:NATUREPOWER)
    if !$game_screen.pokemonvaluespc_unlocked_nature && $PokemonBag.pbQuantity(naturePower.item) > 0
      ServicePCList.exclaimSound
        wait(5)
      Kernel.pbMessage(lab("If I'm not mistaken, that's {1} \\c[6]{2}\\c[0]! Let me get you set up with Nature Tweaking!", 
      naturePower.name,getMoveName(:NATUREPOWER)))
      wait(25)
      ServicePCList.happySound
      Kernel.pbMessage(lab("Done! You're now registered for Nature Tweaking."))
      $game_screen.pokemonvaluespc_unlocked_nature = true
      unlockedAny = true
    end

    if !$game_screen.pokemonvaluespc_unlocked_ability && $PokemonBag.pbQuantity(:ABILITYCAPSULE) > 0
      ServicePCList.exclaimSound
      wait(5)
      if (Kernel.pbConfirmMessage(lab("If I'm not mistaken, that's an Ability Capsule! If you want to hand one over, we can get you set up with Ability Tweaking!"))) ||
        !Kernel.pbConfirmMessageSerious(lab("... Are you sure? I'm required to keep asking you every time you call..."))
        $PokemonBag.pbDeleteItem(:ABILITYCAPSULE)
        wait(25)
        ServicePCList.happySound
        Kernel.pbMessage(lab("Done! You're now registered for Ability Tweaking."))
        $game_screen.pokemonvaluespc_unlocked_ability = true
        unlockedAny = true
      else
        Kernel.pbMessage(lab("Alright..."))
      end
    end

    Kernel.pbMessage(lab("Now, with that sorted!")) if unlockedAny

    return $game_screen.pokemonvaluespc_unlocked_iv || $game_screen.pokemonvaluespc_unlocked_ev || 
      $game_screen.pokemonvaluespc_unlocked_ability || $game_screen.pokemonvaluespc_unlocked_nature
  end

  def access
    if ServicePCList.offMap? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if $game_variables[:QuestCrossover] >= 1 
      if $game_screen.pokemonvaluespc_use_gdc
        Kernel.pbMessage(_INTL("(Since Gearen Labs is back up and running, you call them instead!)"))
        $game_screen.pokemonvaluespc_use_gdc = false
        $game_screen.pokemonvaluespc_neo = true
      elsif !$game_screen.pokemonvaluespc_used
        $game_screen.pokemonvaluespc_neo = true
      end
    end

    if $game_variables[:Post10thBadge] >= 1 && !$game_screen.pokemonvaluespc_use_gdc && !$game_screen.pokemonvaluespc_neo
      if !$game_screen.pokemonvaluespc_called_gearen_in_gdc
        Kernel.pbMessage(_INTL("..."))
        Kernel.pbMessage(_INTL("\\ts[5]Hello. We are not available. Please leave your name and number-"))
        Kernel.pbMessage(_INTL("(You hang up. What was that about?)"))
        $game_screen.pokemonvaluespc_called_gearen_in_gdc = true
      elsif $game_variables[:Post10thBadge] < 3
        Kernel.pbMessage(_INTL("..."))
        Kernel.pbMessage(_INTL("\\ts[5]Hello. We are not available-"))
        Kernel.pbMessage(_INTL("(Still?)"))
      else $game_variables[:Post10thBadge] >= 3
        Kernel.pbMessage(_INTL("..."))
        Kernel.pbMessage(_INTL("\\ts[5]Hello. We are not-"))
        Kernel.pbMessage(_INTL("(Still no response.)"))
      end

      if $game_variables[:Post10thBadge] >= 3
        pbExclaim($game_player)
        Kernel.pbMessage(_INTL("(...)"))
        Kernel.pbMessage(_INTL("(Does GDC Central have this service?)"))
        Kernel.pbMessage(_INTL("(It does! Seems Rhodea registered you for that, too!)"))
        $game_screen.pokemonvaluespc_use_gdc = true
      end
    end

    Kernel.pbMessage(lab("This is {1}, how may I help you?", name))

    if !$game_screen.pokemonvaluespc_used
      Kernel.pbMessage(lab("Oh! Is this the first time you're using this service? Let me explain."))
      Kernel.pbMessage(lab("For one Heart Scale, you can tune the EVs, IVs, Nature, and Ability of a Pokemon."))
      Kernel.pbMessage(lab("You can do all of these at once, but..."))
      Kernel.pbMessage(lab("You do have to get certain things to unlock each of those services."))
      $game_screen.pokemonvaluespc_used = true
    end

    if !checkUnlocks
      wait(40)
      Kernel.pbMessage(lab("It doesn't seem like you have any of our services unlocked. Try finding items related to IVs, EVs, Nature, or Abilities!"))
      return
    end

    if $PokemonBag.pbQuantity(:HEARTSCALE) <= 0
      Kernel.pbMessage(lab("Pokemon Tweaking? Sorry, but we need a Heart Scale to make the process work. Please come back with one!"))
      return
    end

    Kernel.pbMessage(lab("Pokemon Tweaking? Certainly! Which Pokemon would you like to tweak the values of?"))
    pbChooseNonEggPokemon(1,3)
    result = pbGet(1)
    if result < 0
      Kernel.pbMessage(lab("Changed your mind then? Have a nice day!"))
      return
    end

    pkmn = $Trainer.party[result]
    if Kernel.pbConfirmMessage("And you'd like to spend a Heart Scale to tweak \\v[3]?")
      if tweaking(pkmn)
        $PokemonBag.pbDeleteItem(:HEARTSCALE)
        Kernel.pbMessage(lab("And...\\| Done! Thank you for your business! Have a nice day!"))
      else
        Kernel.pbMessage(lab("Changed your mind then? Have a nice day!"))
      end
    else
      Kernel.pbMessage(lab("Changed your mind then? Have a nice day!"))
    end
  end
end

ServicePCList.registerSubService(:Consultants, PokemonValuesPCService.new)

