begin
  missing = ['0000.textures.rb', '0001.pcservices.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load"
end

Variables[:PostCarotosQuest] = 373

TextureOverrides.registerServiceSprites('Celebi')

class Game_Screen
  attr_accessor :timeskippc_used
  attr_accessor :timeskippc_darchlight
  attr_accessor :timeskippc_past
  attr_accessor :timeskippc_distant
end

class TimeSkipPCService

  LIME = '<c3=63ED71,1c7a24>'

  def shouldShow?
    return false if $game_variables[:PostCarotosQuest] < 3
    return false if !$game_switches[:Unreal_Time]
    return $Settings.unrealTimeDiverge != 0
  end

  def name
    return _INTL("???") if !$game_screen.timeskippc_used
    return _INTL("Voice of the Forest")
  end

  def help
    return _INTL("When did this get added to your services?") if !$game_screen.timeskippc_used
    return _INTL("Invoke Celebi to advance the flow of time.")
  end

  def celebi(text, *args)
    return _INTL("\\f[service_Celebi]" + text, *args)
  end

  def celebiSound(volume=100, pitch=100)
    pbSEPlay('251Cry', volume, pitch)
  end

  def theGearsShift # Largely copied from common event ForwardTime
    pbSEPlay('PRSFX- Final Gambit1', 100, 150)
    ServicePCList.fadeScreen(Tone.new(-34,-34,-34,221), 20)
    $game_screen.pictures[2].show('TimeGear1', 1, 485, 375, 10, 10, 50, 0)
    $game_screen.pictures[3].show('TimeGear2', 1, 30, 30, 10, 10, 50, 0)
    $game_screen.pictures[4].show('TimeGear3', 1, 480, 230, 10, 10, 50, 0)
    $game_screen.pictures[5].show('TimeGear4', 1, 320, 270, 10, 10, 50, 0)
    $game_screen.pictures[6].show('TimeGear1', 1, 30, 30, 10, 10, 50, 0)
    $game_screen.pictures[7].show('TimeGear1', 1, 255, 188, 100, 100, 50, 0)

    for i in 0...6
      $game_screen.pictures[i + 2].start_tone_change(Tone.new(-255,255,-255,0),0)
    end

    $game_screen.pictures[2].move(20, 1, 485, 375, 100, 100, 255, 0)
    $game_screen.pictures[3].move(20, 1, 30, 30, 100, 100, 255, 0)
    $game_screen.pictures[4].move(20, 1, 480, 230, 100, 100, 255, 0)
    $game_screen.pictures[5].move(20, 1, 320, 270, 100, 100, 255, 0)
    $game_screen.pictures[6].move(20, 1, 30, 30, 150, 150, 50, 1)
    $game_screen.pictures[7].move(20, 1, 255, 188, 200, 200, 50, 1)

    pbWait(20)

    $game_screen.pictures[2].rotate(-5)
    $game_screen.pictures[3].rotate(-5)
    $game_screen.pictures[4].rotate(-8)
    $game_screen.pictures[5].rotate(-3)
    $game_screen.pictures[6].rotate(+3)
    $game_screen.pictures[7].rotate(-6)

    pbWait(10)
  end

  def theGearsStop # Largely copied from common event TimeGone
    $game_screen.pictures[2].move(20, 1, 485, 375, 10, 100, 0, 0)
    $game_screen.pictures[3].move(20, 1, 30, 30, 10, 10, 0, 0)
    $game_screen.pictures[4].move(20, 1, 480, 230, 10, 10, 0, 0)
    $game_screen.pictures[5].move(20, 1, 320, 270, 10, 10, 0, 0)
    $game_screen.pictures[6].move(20, 1, 30, 30, 10, 10, 0, 1)
    $game_screen.pictures[7].move(20, 1, 255, 188, 10, 10, 0, 1)
    pbWait(10)
    $game_screen.pictures[4].erase
    $game_screen.pictures[2].erase
    $game_screen.pictures[3].erase
    $game_screen.pictures[5].erase
    $game_screen.pictures[6].erase
    $game_screen.pictures[7].erase
    ServicePCList.restoreScreen(1)
  end

  def access
    if ServicePCList.inNightmare? || ServicePCList.inZeight? || ServicePCList.inRift?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if ServicePCList.denOfSouls?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      if !$game_screen.timeskippc_used
        Kernel.pbMessage(_INTL("(Someone picked up, but...)\1"))
        celebiSound(40, 50)
        Kernel.pbMessage(_INTL("(They sighed sadly and hung up.)"))
      else
        Kernel.pbMessage(_INTL("(Celebi picked up, but...)\1"))
        celebiSound(40, 50)
        Kernel.pbMessage(_INTL("(It sighed sadly and hung up.)"))
      end
      return
    end

    if ServicePCList.distantTime?
      celebiSound(80, 50)
      Kernel.pbMessage(celebi("CELEBI: Cele- <i>bii...</i> (Hel- Oh.)\1"))
    else
      celebiSound(80, 100)
      Kernel.pbMessage(celebi("CELEBI: Cele bii! (Hello!)\1"))
    end

    if ServicePCList.darchlightCaves? && !$game_screen.timeskippc_darchlight
      Kernel.pbMessage(_INTL("(\\..\\..\\..\\. Isn't there supposed to be some kind of interference in Darchlight Caves?)\1"))
      $game_screen.timeskippc_darchlight = true
    end

    if ServicePCList.distantTime?
      if !$game_screen.timeskippc_distant
        Kernel.pbMessage(celebi("Bicel cel <i>cel!</i>  (Oh, this is a poor timeline...)\1"))
        celebiSound(40, 50)
        $game_screen.timeskippc_distant = true
      end
    elsif inPast? && !$game_screen.timeskippc_past
      Kernel.pbMessage(_INTL("(It makes sense that Celebi would answer even in the past...)\1"))
      $game_screen.timeskippc_past = true
    end

    if !$game_screen.timeskippc_used
      if ServicePCList.distantTime?
        celebiSound(80, 50)
        Kernel.pbMessage(celebi("Lici lee cel ebi. (Normally, I would help you control the flow of time.)\1"))
        celebiSound(80, 50)
        Kernel.pbMessage(celebi("Ebi ceeeel. (You can call me whenever you want... I've got time to spare.)\1"))
        Kernel.pbMessage(_INTL("(Somehow, you understood that...)\1"))
      else
        celebiSound(80, 100)
        Kernel.pbMessage(celebi("Bici lee cel ebi. (I can help you control the flow of time.)\1"))
        celebiSound(80, 100)
        Kernel.pbMessage(celebi("Ceeeeeeeeeeeeeeel. (Call me anytime! Time travelers have all the time in the world.)\1"))
        Kernel.pbMessage(_INTL("(\\..\\..\\..\\.Wait.\\| You understood that?!)\1"))
      end
      $game_screen.timeskippc_used = true
    end

    if ServicePCList.distantTime?
      celebiSound(80, 50)
      Kernel.pbMessage(celebi("Bepri... (Time is all tangled up and cracked here. Might as well be locked in place.)\1"))
      celebiSound(80, 80)
      Kernel.pbMessage(celebi("Cepreci. (I can't do much about that. I'll just leave you be.)"))
      return
    end

    if $game_switches[:Forced_Time_of_Day]
      celebiSound(80, 80)
      Kernel.pbMessage(celebi("Bipri... (Looks like time's been locked in place for a bit. That happens sometimes!)\1"))
      celebiSound(80, 100)
      Kernel.pbMessage(celebi("Cece prici! (So I can't do much about that. I'll be off, then!)"))
      return
    end


    celebiSound(80, 100)
    choice = Kernel.pbMessage(celebi("Pribi! (When do you want to jump forwards to?)"), [_INTL("Morning"), _INTL("Midday"), _INTL("Nightfall"), _INTL("Midnight")], -1, nil, 0)
    if choice == -1
      celebiSound(80, 100)
      Kernel.pbMessage(celebi("CELEBI: Priiil. (If you don't need me, I'll be off then!)"))
      return
    elsif choice < 4
      celebiSound(80, 100)
      Kernel.pbMessage(celebi("CELEBI: Cel... EBI! (Here we GO!)\1"))
      $game_system.message_position = 1 # Middle
      $game_system.message_frame = 1 # Hide

      ServicePCList.fadeScreen(Tone.new(-51,-51,-51,0), 20)
      pbWait(20)

      $game_system.bgm_memorize
      pbBGMPlay('citamginE - gnileeF', 100, 130)
      celebiSound(50, 60)
      Kernel.pbMessage(_INTL("<ac>\\ts[5]#{LIME}<fn=Garufan>O' ersatz flow and flux of time,"))
      celebiSound(200, 60)
      Kernel.pbMessage(_INTL("<ac>\\ts[5]#{LIME}<fn=Garufan>O' queen of zones high and divine,"))
      celebiSound(50, 120)
      Kernel.pbMessage(_INTL("<ac>\\ts[5]#{LIME}<fn=Garufan>The Interceptor calls for change!"))
      celebiSound(200, 120)
      Kernel.pbMessage(_INTL("<ac>\\ts[5]#{LIME}<fn=Garufan>And by their will, we shall obey!"))

      pbWait(20)

      theGearsShift
      pbWait(250)

      now=$game_screen.getTimeCurrent()
      # Morning is 6 AM
      # Midday is Noon
      # Nightfall is 8 PM
      # Midnight is... yeah
      targetHour = [6, 12, 20, 0][choice]

      deltaTime = (targetHour - now.hour) * 60 * 60
      deltaTime -= now.min * 60
      deltaTime -= now.sec

      deltaTime += (24 * 60 * 60) if deltaTime < 0

      deltaTime = deltaTime / $game_screen.getTimeScale().to_f
      $gameTimeLastCheck -= deltaTime
      $game_screen.getTimeCurrent() # Will update the time

      theGearsStop

      pbBGMFade(1)
      $game_screen.start_flash(Color.new(255,255,255,255), 60)
      pbSEPlay('Exit Door', 100, 50)
      pbWait(30)

      ServicePCList.fadeScreen(Tone.new(-51,-51,-51,0), 20)
      pbWait(20)

      Kernel.pbMessage(_INTL("<ac>\\c[3]THE FLOW OF TIME HAS SHIFTED."))

      ServicePCList.restoreScreen(10)
      $game_system.message_position = 2 # Bottom
      $game_system.message_frame = 0 # Show
      celebiSound(80, 100)
      Kernel.pbMessage(celebi("CELEBI: Precel. (That's probably fine. Bye!)"))
      $game_system.bgm_restore
    end
  end
end

ServicePCList.registerService(TimeSkipPCService.new)
