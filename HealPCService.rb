begin
  missing = ['0000.textures.rb', '0001.pcservices.rb'].select { |f| !File.exist?(File.join(File.dirname(__FILE__), f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

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
        Kernel.pbMessage(sec("SEC: Hi! You've reached SEC! Were you expecting someone else?\1"))
        Kernel.pbMessage(secAnnoyed("You know that putting your Pokemon into the PC will heal them, right?\1"))
        secAnnoyedWait(30)
        lockOn(&method(:secAnnoyedWait))
        Kernel.pbMessage(sec("Oh, well. You're in my sights. Here's your easy and convenient heal. Enjoy."))
        heal(&method(:secWait))
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
      Kernel.pbMessage(_INTL("<ac>Activating remote healing."))
      ServicePCList.restoreScreen(10)

      $game_system.message_position = 2 # Bottom
      $game_system.message_frame = 0 # Show
      lockOn
      pbWait(20)
      heal
      return
    end

    if ServicePCList.bladestarTerritory?
      Kernel.pbMessage(bladestarJoy("JOY: Hi! You've reached the Bladestar Field Healing Service.\1"))
      Kernel.pbMessage(bladestarJoy("Yes, I work for Bladestar. What of it? They need healing too!\1"))
      if Kernel.pbConfirmMessage(bladestarJoy("Would you like me to heal your Pokemon?\1"))
        bladestarJoyWait(30)
        lockOn(&method(:bladestarJoyWait))
        if ServicePCList.darchlightCaves?
          Kernel.pbMessage(bladestarJoy("Ok, Smeargle, adjust for Darchlight interference...\1"))
        else
          Kernel.pbMessage(bladestarJoy("Ok, Smeargle, ready, aim...\1"))
        end
        heal(&method(:bladestarJoyWait))
        ServicePCList.happySound
        Kernel.pbMessage(bladestarJoy("JOY: Thank you for waiting, \\PN.\1"))
        Kernel.pbMessage(bladestarJoy("Your Pokemon have been healed. Go Bladestar!"))
      else
        Kernel.pbMessage(bladestarJoy("Eh, whatever. Easier for me anyway."))
      end
      return
    end

    if (!inPast? && ServicePCList.offMap?) || ServicePCList.inRift? || ServicePCList.distantTime?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(nurseJoy("JOY: Hi! You've reached the Joy Field Healing Service!\1"))
    if !inPast? && !$game_screen.healpc_used
      Kernel.pbMessage(nurseJoy("We've been in service since before the Calamity, delivering healing wherever you go.\1"))
      Kernel.pbMessage(nurseJoy("Our Smeargle are powerful enough to Lock On to you from anywhere in the region!\1"))
      $game_screen.healpc_used = true
    end

    if Kernel.pbConfirmMessage(nurseJoy("Would you like me to heal your Pokemon?"))
      Kernel.pbMessage(nurseJoy("We'll restore your Pokemon to full health! Just wait a few seconds...\1"))
      nurseJoyWait(30)
      lockOn(&method(:nurseJoyWait))
      Kernel.pbMessage(nurseJoy("Our specially trained Smeargle have a bead on your location. Now, Heal Pulse!\1"))
      heal(&method(:nurseJoyWait))
      ServicePCList.happySound if !inPast?
      Kernel.pbMessage(nurseJoy("JOY: Thank you for waiting, \\PN!\1"))
      Kernel.pbMessage(nurseJoy("We've successfully restored your Pokemon to full health.\1"))
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
