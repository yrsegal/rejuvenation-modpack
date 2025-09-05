begin
  missing = ['0000.textures.rb', '0001.pcservices.rb', 'ServiceIcons'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:TerajumaStory] = 96

TextureOverrides.registerServiceSprites('TeilaStaff')

class Game_Screen
  attr_accessor :friendshippc_used
end

class FriendshipPCService

  def shouldShow?
    return $game_variables[:TerajumaStory] >= 68 # Entered Teila Resort
  end

  def name
    return _INTL("Resort Spa")
  end

  def help
    return _INTL("Send Pokemon to the Spa, or check their friendship.")
  end

  def teila(text, *args)
    return _INTL("\\f[service_TeilaStaff]" + text, *args)
  end

  def access
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(teila("Hello! You've reached the Teila Resort Spa's booking service!\1"))
    if !$game_screen.friendshippc_used
      Kernel.pbMessage(teila("It's more expensive than in-person sessions, but you can book a spa day for your Pokemon here!\1"))
      Kernel.pbMessage(teila("There's a surcharge for every booking beyond the first per day.\1"))
      Kernel.pbMessage(teila("Pokemon tend to be happy as can be after one of our sessions!\1"))
      $game_screen.friendshippc_used = true
    end

    choices = [_INTL("Yes"),_INTL("No"),_INTL("Check Friendship")]

    updateEvent

    if (tsOn?("A"))
      price = 15000
      choice = Kernel.pbMessage(teila("\\gWould you like to book a Pokemon? You've already booked for today, so the price will be ${1}.", pbCommaNumber(price)),
        choices,2,nil,0)
    else
      price = 10000
      choice = Kernel.pbMessage(teila("\\gWould you like to book a Pokemon? The price will be ${1}.", pbCommaNumber(price)),
        choices,2,nil,0)
    end

    if choice == 1
      Kernel.pbMessage(teila("Please call again!"))
    elsif choice == 0
      if $Trainer.money >= price
        pbChooseNonEggPokemon(1,3)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(teila("Call back any time!"))
          return
        end

        $Trainer.money -= price

        Kernel.pbMessage(teila("Okay, I'll give your \\v[3] the deluxe treatment!\1"))
        pkmn = $Trainer.party[result]
        pkmn.changeHappiness("groom3")
        ServicePCList.fadeScreen(Tone.new(-255,-255,-255,0), 10)
        pbWait(25)
        pbSEPlay('Refresh')
        pbWait(6)
        pbSEPlay('Refresh')
        pbWait(6)
        pbSEPlay('Refresh')
        pbWait(40)
        ServicePCList.happySound
        pbWait(25)
        ServicePCList.restoreScreen(10)
        Kernel.pbMessage(teila("Your \\v[3] looks pleased to bits!\1"))
        Kernel.pbMessage(teila("Thank you, and call again soon!"))
        pbSetEventTime
      else
        Kernel.pbMessage(teila("Oh, that's unfortunate. You don't have enough money for this.\1"))
        Kernel.pbMessage(teila("Do call back later!"))
      end
    else
      Kernel.pbMessage(teila("We provide this service for free! Which Pokemon would you like to know about?"))
      pbChooseNonEggPokemon(1,3)
      result = pbGet(1)
      if result < 0
        Kernel.pbMessage(teila("Oh, you're busy? No worries! Call again soon!"))
        return
      end

      pkmn = $Trainer.party[result]
      if pkmn.happiness >= 250
        ServicePCList.happySound
        Kernel.pbMessage(teila("Wow, I can tell your \\v[3] is inseparable from you!\1"))
      elsif pkmn.happiness >= 220
        Kernel.pbMessage(teila("\\v[3] trusts you a lot. You must be a great trainer!\1"))
      elsif pkmn.happiness >= 150
        Kernel.pbMessage(teila("\\v[3] seems to think well of you. Keep at it!\1"))
      elsif pkmn.happiness >= 100
        Kernel.pbMessage(teila("I think you need to spend more time with \\v[3], but it seems to appreciate you!\1"))
      elsif pkmn.happiness >= 70
        Kernel.pbMessage(teila("\\v[3]... seems unsure of itself. Please take good care of it.\1"))
      elsif pkmn.happiness >= 35
        Kernel.pbMessage(teila("\\v[3] seems worried. Is something the matter?\1"))
      else
        Kernel.pbMessage(teila("\\v[3] is terrified, poor thing! You need to cheer it up!\1"))
      end
      Kernel.pbMessage(teila("Call back any time!"))
    end
  end

  def pbSetEventTime
    $PokemonGlobal.eventvars={} if !$PokemonGlobal.eventvars
    time=pbGetTimeNow
    time=time.to_i
    $game_self_switches[[333,16,"A"]] = true
    $PokemonGlobal.eventvars[[333, 16]]=time
  end

  def updateEvent
    if expired?(86400)
      $game_self_switches[[333,16,"A"]] = false
    end
  end

  def expired?(secs=86400)
    ontime=$PokemonGlobal.eventvars[[333, 16]] # Teila Resort Spa
    time=pbGetTimeNow
    return ontime && (time.to_i - ontime).abs > secs
  end

  def tsOn?(c)
    return $game_self_switches[[333,16,c]]
  end
end

ServicePCList.registerService(FriendshipPCService.new)
