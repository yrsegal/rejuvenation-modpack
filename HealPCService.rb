Variables[:KarmaHealCount] = 739
Variables[:KarmaHurtCount] = 740

LOCK_ON_ANIMATION_ID = 73
PINK_FLASH_ANIMATION_ID = 83
KARMA_HEAL_ANIMATION_ID = 132
KARMA_HURT_ANIMATION_ID = 133

TextureOverrides.registerServiceSprites('BladestarJoy', 'PastJoy', 'NurseJoy', 'SEC', 'SECAnnoyed')

class Game_Screen
  attr_accessor :healpc_used
end

class HealPCService
  def shouldShow?
    return true
  end

  def name
    return _INTL("Field Healing")
  end

  def help
    return _INTL("Get healed by a long-range sniper Joy.")
  end


  def bladestarJoy(text, *args) 
    return _INTL("\\f[service_BladestarJoy]" + text, *args)
  end

  def nurseJoy(text, *args) 
    return _INTL("\\f[service_PastJoy]" + text, *args) if inPast? 
    return _INTL("\\f[service_NurseJoy]" + text, *args)
  end

  def sec(text, *args) 
    return _INTL("\\f[service_SEC]" + text, *args)
  end

  def secAnnoyed(text, *args) 
    return _INTL("\\f[service_SECAnnoyed]" + text, *args)
  end

  def bladestarJoyWait(length)
    Kernel.pbMessage(bladestarJoy("\\wtnp[{1}]", length))
  end

  def nurseJoyWait(length)
    Kernel.pbMessage(nurseJoy("\\wtnp[{1}]", length))
  end

  def secWait(length)
    Kernel.pbMessage(sec("\\wtnp[{1}]", length))
  end

  def secAnnoyedWait(length)
    Kernel.pbMessage(secAnnoyed("\\wtnp[{1}]", length))
  end

  def access
    if ServicePCList.inNightmare?
      if ServicePCList.nightmareCleansed?
        Kernel.pbMessage(_INTL("The memory of an annoying voice passes you by..."))
        heal
      else
        Kernel.pbMessage(sec("SEC: Hi! You've reached SEC! Were you expecting someone else?"))
        Kernel.pbMessage(secAnnoyed("You know that putting your Pokemon into the PC will heal them, right?"))
        secAnnoyedWait(30) 
        lockOn { |i| secAnnoyedWait(i) }
        Kernel.pbMessage(sec("Oh, well. You're in my sights. Here's your easy and convenient heal. Enjoy."))
        heal { |i| secWait(i) }
      end
      return
    end

    if ServicePCList.inZeight? || ServicePCList.dreadDream?
      if ServicePCList.goodKarma?
        Kernel.pbMessage(_INTL("Something answered your plea..."))
        karmaheal
      else
        Kernel.pbMessage(_INTL("You don't need this."))
        karmahurt
      end

      return
    end

    if ServicePCList.denOfSouls?
      $game_system.message_position = 1 # Middle
      $game_system.message_frame = 1 # Hide

      ServicePCList.fadeScreen(Tone.new(-51,-51,-51,0), 20)
      pbWait(20)
      Kernel.pbMessage(_INTL("<ac>Activating remote healing.</ac>"))
      ServicePCList.restoreScreen(10)
      
      $game_system.message_position = 2 # Bottom
      $game_system.message_frame = 0 # Show
      lockOn
      pbWait(20)
      heal
      return
    end

    if ServicePCList.bladestarTerritory?
      Kernel.pbMessage(bladestarJoy("JOY: Hi! You've reached the Bladestar Field Healing Service."))
      Kernel.pbMessage(bladestarJoy("Yes, I work for Bladestar. What of it? They need healing too!"))
      if Kernel.pbConfirmMessage(bladestarJoy("Would you like me to heal your Pokemon?"))
        bladestarJoyWait(30)
        lockOn { |i| bladestarJoyWait(i)}
        if ServicePCList.darchlightCaves?
          Kernel.pbMessage(bladestarJoy("Ok, Smeargle, adjust for Darchlight interference..."))
        else
          Kernel.pbMessage(bladestarJoy("Ok, Smeargle, ready, aim..."))
        end
        heal { |i| bladestarJoyWait(i)}
        ServicePCList.happySound
        Kernel.pbMessage(bladestarJoy("JOY: Thank you for waiting, \\PN."))
        Kernel.pbMessage(bladestarJoy("Your Pokemon have been healed. Go Bladestar!"))
      else
        Kernel.pbMessage(bladestarJoy("Eh, whatever. Easier for me anyway."))
      end
      return
    end

    if (!inPast? && ServicePCList.offMap?) || ServicePCList.inRift? || ServicePCList.distantTime?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(nurseJoy("JOY: Hi! You've reached the Joy Field Healing Service!"))
    if !inPast? && !$game_screen.healpc_used
      Kernel.pbMessage(nurseJoy("We've been in service since before the Calamity, delivering healing wherever you go.")) 
      Kernel.pbMessage(nurseJoy("Our Smeargle are powerful enough to Lock On to you from anywhere in the region!")) 
      $game_screen.healpc_used = true
    end

    if Kernel.pbConfirmMessage(nurseJoy("Would you like me to heal your Pokemon?"))
      Kernel.pbMessage(nurseJoy("We'll restore your Pokemon to full health! Just wait a few seconds..."))
      nurseJoyWait(30)
      lockOn { |i| nurseJoyWait(i)}
      Kernel.pbMessage(nurseJoy("Our specially trained Smeargle have a bead on your location. Now, Heal Pulse!"))
      heal { |i| nurseJoyWait(i)}
      ServicePCList.happySound if !inPast?
      Kernel.pbMessage(nurseJoy("JOY: Thank you for waiting, \\PN!"))
      Kernel.pbMessage(nurseJoy("We've successfully restored your Pokemon to full health."))
    end
    Kernel.pbMessage(nurseJoy("We look forward to your next call!"))
  end

  def lockOn
    $game_player.animation_id = LOCK_ON_ANIMATION_ID
    yield 20 if block_given?
    pbWait(20) if !block_given? 
  end

  def heal
    $game_player.animation_id = PINK_FLASH_ANIMATION_ID
    pbSEPlay('PRSFX- Healing Pulse')
    pbHealAll()
    yield 40 if block_given?
    pbWait(40) if !block_given?
  end

  def karmaheal
    pbHealAll()
    $game_player.animation_id = KARMA_HEAL_ANIMATION_ID
    $game_variables[:KarmaHealCount] += 1
    yield 20 if block_given?
    pbWait(20) if !block_given?
  end

  def karmahurt
    $game_player.animation_id = KARMA_HURT_ANIMATION_ID
    for i in 0...9
      pbFieldDamage
    end
    $game_variables[:KarmaHurtCount] += 1
    yield 20 if block_given?
    pbWait(20) if !block_given?
  end
end

ServicePCList.registerServiceTop(HealPCService.new)
