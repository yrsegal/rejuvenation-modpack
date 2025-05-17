Variables[:KarmaHealCount] = 739
Variables[:KarmaHurtCount] = 740

LOCK_ON_ANIMATION_ID = 73
PINK_FLASH_ANIMATION_ID = 83
KARMA_HEAL_ANIMATION_ID = 132
KARMA_HURT_ANIMATION_ID = 133

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

  def access
    if ServicePCList.inNightmare?
      Kernel.pbMessage(_INTL("\\se[SFX - Phone Call]SEC: Hi! You've reached SEC! Were you expecting someone else?"))
      Kernel.pbMessage(_INTL("You know that putting your Pokemon into the PC will heal them, right?"))
      pbWait(30)
      lockOn
      Kernel.pbMessage(_INTL("Oh, well. You're in my sights. Here's your easy and convenient heal. Enjoy."))
      heal
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
      Kernel.pbMessage(_INTL("<ac>Activating remote healing.</ac>"))
      lockOn
      pbWait(20)
      heal
      return
    end

    if ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("\\se[SFX - Phone Call]JOY: Hi! You've reached the Bladestar Field Healing Service."))
      Kernel.pbMessage(_INTL("Yes, I work for Bladestar. What of it? They need healing too!"))
      pbWait(30)
      lockOn
      Kernel.pbMessage(_INTL("Ok, Smeargle, adjust for Darchlight interference..."))
      heal
      pbSEPlay('MiningAllFound', 100, 120) if !inPast?
      Kernel.pbMessage(_INTL("JOY: Thank you for waiting, \\PN."))
      Kernel.pbMessage(_INTL("Your Pokemon have been healed. Go Bladestar!"))
      return
    end

    if ServicePCList.offMap? || ServicePCList.distantTime?
      Kernel.pbMessage(_INTL("\\se[SFX - Phone Call]..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(_INTL("\\se[SFX - Phone Call]JOY: Hi! You've reached the Joy Field Healing Service!"))
    if !inPast? && !$game_screen.healpc_used
      Kernel.pbMessage(_INTL("We've been in service since before the Calamity, delivering healing wherever you go.")) 
      Kernel.pbMessage(_INTL("Our Smeargle are powerful enough to Lock On to you from anywhere in the region!")) 
      $game_screen.healpc_used = true
    end
    Kernel.pbMessage(_INTL("We'll restore your Pokemon to full health! Just wait a few seconds..."))
    pbWait(30)
    lockOn
    Kernel.pbMessage(_INTL("Our specially trained Smeargle have a bead on your location. Now, Heal Pulse!"))
    heal
    pbSEPlay('MiningAllFound', 100, 120) if !inPast?
    Kernel.pbMessage(_INTL("JOY: Thank you for waiting, \\PN!"))
    Kernel.pbMessage(_INTL("We've successfully restored your Pokemon to full health."))
    Kernel.pbMessage(_INTL("We look forward to your next call!"))
  end

  def lockOn
    $game_player.animation_id = LOCK_ON_ANIMATION_ID
    pbWait(20)
  end

  def heal
    $game_player.animation_id = PINK_FLASH_ANIMATION_ID
    pbSEPlay('PRSFX- Healing Pulse')
    pbHealAll()
    pbWait(40)
  end

  def karmaheal
    pbHealAll()
    $game_player.animation_id = KARMA_HEAL_ANIMATION_ID
    $game_variables[:KarmaHealCount] += 1
    pbWait(20)
  end

  def karmahurt
    $game_player.animation_id = KARMA_HURT_ANIMATION_ID
    for i in 0...9
      pbFieldDamage
    end
    $game_variables[:KarmaHurtCount] += 1
    pbWait(20)
  end
end

ServicePCList.registerService(HealPCService.new)
