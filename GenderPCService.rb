Switches[:PrincessOdessaFriend] = 1626
Switches[:PlayerMale] = 1058
Switches[:PlayerFemale] = 1059
Switches[:PlayerEnby] = 1060
Variables[:MissingChildren] = 429

GRUMPY_ANIMATION_ID = 20

HEART_SWAP_ANIMATION_ID = 138
ELIPSES_ANIMATION_ID = 16
PINK_FLASH_ANIMATION_ID = 83

TextureOverrides.registerServiceSprites('Odessa', 'OdessaBlush', 'OdessaAngry', 'OdessaConfused', 'Manaphy')

class Game_Screen
  attr_accessor :genderpc_used
  attr_accessor :genderpc_askedForSwap
  attr_accessor :genderpc_doneSwap
  attr_accessor :genderpc_triedToFeed
  attr_accessor :genderpc_angy
end

class GenderPCService

  def shouldShow?
    return $game_switches[:PrincessOdessaFriend]
  end

  def name
    return _INTL("Heart Swap")
  end

  def help
    return _INTL("Change the gender of your Pokemon or yourself.")
  end

  def odessa(text, *args) 
    return _INTL("\\f[service_Odessa]" + text, *args)
  end

  def blush(text, *args) 
    return _INTL("\\f[service_OdessaBlush]" + text, *args)
  end

  def angry(text, *args) 
    return _INTL("\\f[service_OdessaAngry]" + text, *args)
  end

  def confused(text, *args) 
    return _INTL("\\f[service_OdessaConfused]" + text, *args)
  end

  def manaphy(text, *args)
    return _INTL("\\f[service_Manaphy]" + text, *args)
  end

  def manaphySound
    pbSEPlay('490Cry')
  end

  def manaphySad
    pbSEPlay('490Cry', 80, 85)
  end

  def color(num)
    return getSkinColor(nil, num, true)
  end

  def femaleColor
    return color(2)
  end

  def maleColor
    return color(1)
  end

  def enbyColor
    return color(5)
  end

  def grayColor
    return color(7)
  end

  def playerReferent
    return "young man" if $game_switches[:PlayerMale]
    return "young woman" if $game_switches[:PlayerFemale]
    return "individual"
  end

  def playerGender
    return "male" if $game_switches[:PlayerMale]
    return "female" if $game_switches[:PlayerFemale]
    return "nonbinary"
  end

  CANNOT_SWAP_RATIOS = [:Genderless, :MaleZero, :FemZero]

  def odessaAssumedGender
    return "female" if $game_switches[:Ana]
    return "male" if $game_switches[:Aevis] || $game_switches[:Axel] || $game_switches[:Alain] # She assumed Alain was female during ToTH
    return "female" if $game_switches[:Aevia] || $game_switches[:Ariana] || $game_switches[:Aero] # She assumed Aero was male during ToTH
    return "nonbinary" # Shouldn't be possible without debug
  end

  def access
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    odessaAngy = $game_variables[:MissingChildren] >= 60 && $game_variables[:MissingChildren] < 64
    
    skipFirstLine = false

    if $game_screen.genderpc_angy
      if odessaAngy
        Kernel.pbMessage(_INTL("..."))
        Kernel.pbMessage(_INTL("(She sent you to voicemail...)"))
        return
      else
        Kernel.pbMessage(odessa("ODESSA: Ah. \\PN."))
        Kernel.pbMessage(odessa("... My apologies. I had been irate at you over your leaving Ana alone."))
        Kernel.pbMessage(odessa("I have calmed down and forgiven you."))
        Kernel.pbMessage(blush("(Are you satisfied, you insatiable gremlin?)"))
        manaphySound
        Kernel.pbMessage(manaphy("MANAPHY: (Mana!)"))
        $game_screen.genderpc_angy = false
        if !$game_screen.genderpc_used
          Kernel.pbMessage(odessa("ODESSA: Apologies aside, what is it you wanted to call me for?"))
          skipFirstLine = true
        end
      end
    elsif !$game_screen.genderpc_used
      Kernel.pbMessage(odessa("ODESSA: H-hello? I'm sorry, this phone is new. I haven't used it much."))
      ServicePCList.playerTalk
      ServicePCList.exclaimSound
      if odessaAngy
        Kernel.pbMessage(angry("ODESSA: ..."))
        Kernel.pbMessage(_INTL("(She hung up?)"))
        $game_screen.genderpc_angy = true
        return
      end
      Kernel.pbMessage(odessa("ODESSA: Ah! Hello, \\PN!"))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana!"))
      ServicePCList.happySound
      Kernel.pbMessage(odessa("ODESSA: He says hello too!"))
    end

    if !$game_screen.genderpc_used
      Kernel.pbMessage(odessa("So, why are you calling?")) if !skipFirstLine
      ServicePCList.playerTalk
      Kernel.pbMessage(confused("ODESSA: I\\..\\..\\..\\. see? You... wanted me to use Heart Swap again? Whyever for?"))
      ServicePCList.playerTalk
      Kernel.pbMessage(odessa("ODESSA: To change the gender of your Pokemon? I... suppose that is possible."))

      if odessaAssumedGender != "female"
        ServicePCList.happySound
        Kernel.pbMessage(odessa("After all, in your body, I was for all intents and purposes {1}!", odessaAssumedGender))
      else
        Kernel.pbMessage(blush("I... know Heart Swap works on those who aren't female, too."))
      end

      if playerGender != odessaAssumedGender
        pbExclaim($game_player, GRUMPY_ANIMATION_ID)
        ServicePCList.playerTalk
        ServicePCList.exclaimSound
        Kernel.pbMessage(blush("ODESSA: Oh? I-I'm sorry! You're {1}? I had assumed...", playerGender))
        Kernel.pbMessage(blush("No, that's no excuse. I'm sorry, \\PN."))
      end

      Kernel.pbMessage(odessa("The move is more versatile than that, of course..."))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana! Man-na!"))
      Kernel.pbMessage(odessa("ODESSA: We have been practicing, true."))
      Kernel.pbMessage(odessa("I believe I know how we'd use it to \\c[6]change someone's gender directly."))
      Kernel.pbMessage(odessa("So, that being said..."))
      $game_screen.genderpc_used = true
    else
      Kernel.pbMessage(odessa("ODESSA: Hello, \\PN. How are you?"))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana!"))
      ServicePCList.happySound
      Kernel.pbMessage(odessa("ODESSA: Manaphy assures you <i>he's</i> feeling fine."))
      Kernel.pbMessage(odessa("That being said..."))
    end

    choice = 0
    while choice >= 0
      choice = Kernel.pbMessage(odessa("What can we do for you?"),[_INTL("Heart Swap"),_INTL("Feed Manaphy")],-1,nil,0)
      if choice < 0
        Kernel.pbMessage(odessa("ODESSA: Talk to you soon."))
      elsif choice == 0
        subChoice = Kernel.pbMessage(odessa("On who?"),[_INTL("A Pokemon"), _INTL("Me")], -1, nil, 0)
        if subChoice == 0
          result = 0
          while result != -1
            pbChoosePokemon(1,3,proc{|p| !p.isEgg? && p.gender != 2 && !CANNOT_SWAP_RATIOS.include?($cache.pkmn[p.species].GenderRatio) },true)
            result = pbGet(1)
            if result != -1
              pkmn = $Trainer.party[result]
              if pkmn.isEgg?
                Kernel.pbMessage(confused("ODESSA: ...\\PN? I don't think an Egg is a valid target."))
              elsif (pkmn.isShadow? rescue false)
                Kernel.pbMessage(confused("ODESSA: ... What is this, and why are you showing it to me?"))
                Kernel.pbMessage(confused("Poor {1} looks like it's in agony...", getMonName(pkmn.species)))
              else
                if pkmn.gender == 2
                  Kernel.pbMessage(confused("ODESSA: Do {1} even have a gender?", getMonName(pkmn.species)))
                  next
                end

                case $cache.pkmn[pkmn.species].GenderRatio
                  when :Genderless
                    Kernel.pbMessage(confused("ODESSA: Do {1} even have a gender?", getMonName(pkmn.species)))
                    next
                  when :MaleZero
                    Kernel.pbMessage(confused("ODESSA: I don't believe {1} <i>can</i> be male.", getMonName(pkmn.species)))
                    next
                  when :FemZero
                    Kernel.pbMessage(confused("ODESSA: I don't believe {1} <i>can</i> be female.", getMonName(pkmn.species)))
                    next
                end

                Kernel.pbMessage(odessa("ODESSA: Alright. That will require a Heart Scale as a catalyst."))
                if $PokemonBag.pbQuantity(:HEARTSCALE) <= 0
                  Kernel.pbMessage(odessa("Ah, unfortunate, you don't have any. Another time, then."))
                  break
                end

                pkmnGender = pkmn.gender == 1 ? femaleColor + 'female' : maleColor + 'male'
                targetGender = pkmn.gender == 1 ? maleColor + 'male' : femaleColor + 'female'

                if Kernel.pbConfirmMessage(odessa("ODESSA: Then you want to change \\v[3] from {1}\\c[0] into {2}\\c[0]?", pkmnGender, targetGender))
                  $PokemonBag.pbDeleteItem(:HEARTSCALE)
                  Kernel.pbMessage(odessa("ODESSA: Then so it shall be! Manaphy..."))
                  $game_screen.start_tone_change(Tone.new(0,0,0,255),80)
                  manaphySound
                  Kernel.pbMessage(odessa("ODESSA: HEART SWAP!"))
                  pbExclaim($game_player, HEART_SWAP_ANIMATION_ID)
                  pkmn.setGender(1 - pkmn.gender)
                  $game_screen.start_tone_change(Tone.new(0,0,0,0),20)
                  Kernel.pbMessage(odessa("ODESSA: It is done."))
                  break
                end
              end
            end
          end
        elsif subChoice == 1
          Kernel.pbMessage(blush("ODESSA: Y-you?"))
          if !$game_screen.genderpc_askedForSwap
            Kernel.pbMessage(blush("You really trust me, after..."))
            Kernel.pbMessage(blush("\\..\\..\\..\\."))
            Kernel.pbMessage(odessa("I appreciate it."))
            Kernel.pbMessage(odessa("Ah, but is that even possible without physical presence?"))
            Kernel.pbMessage(odessa("For a Pokemon, you can send it to me through the PC, but..."))
            manaphySound
            Kernel.pbMessage(manaphy("MANAPHY: Mana ma!"))
            Kernel.pbMessage(odessa("ODESSA: Apparently, it is within Manaphy's capabilities."))
            Kernel.pbMessage(blush("So..."))
            $game_screen.genderpc_askedForSwap = true
          end

          Kernel.pbMessage(odessa("I suppose I can do that... It will cost two Heart Scales as catalysts, though."))
          if $PokemonBag.pbQuantity(:HEARTSCALE) <= 0
            Kernel.pbMessage(odessa("Ah, you don't have any? I suppose that's not an option, then."))
          elsif $PokemonBag.pbQuantity(:HEARTSCALE) == 1
            Kernel.pbMessage(odessa("Ah, you only have one? I suppose that's not an option, then."))
          else
            playerGenderNum = 0
            playerGenderNum = 1 if $game_switches[:PlayerFemale]
            playerGenderNum = 2 if $game_switches[:PlayerEnby]

            choice = Kernel.advanced_pbMessage(odessa("ODESSA: What would you like me to make you?"), [
              $game_switches[:PlayerMale] ? grayColor + 'Male' : maleColor + 'Male',
              $game_switches[:PlayerFemale] ? grayColor + 'Female' : femaleColor + 'Female',
              $game_switches[:PlayerEnby] ? grayColor + 'Enby' : enbyColor + 'Enby'
            ], -1, nil, playerGenderNum)

            if choice < 0
              Kernel.pbMessage(blush("\\sh\\c[7]ODESSA: D-don't ask me for th-that, then just blow it off!"))
              pbWait(20)
            elsif choice == playerGenderNum
              Kernel.pbMessage(confused("ODESSA: Are you not already {1}?", playerGender))
              Kernel.pbMessage(confused("Is this... are you insecure about that?"))
              Kernel.pbMessage(odessa("If so, I apologize. I meant no offense. You are already a quite lovely {1}.", playerReferent))
            elsif choice <= 2
              $PokemonBag.pbDeleteItem(:HEARTSCALE, 2)
              Kernel.pbMessage(odessa("ODESSA: V-very well then! Manaphy..."))
              $game_screen.start_tone_change(Tone.new(0,0,0,255),80)
              manaphySound
              Kernel.pbMessage(odessa("ODESSA: HEART SWAP!"))
              pbExclaim($game_player, HEART_SWAP_ANIMATION_ID)
              $game_switches[:PlayerMale] = choice == 0
              $game_switches[:PlayerFemale] = choice == 1
              $game_switches[:PlayerEnby] = choice == 2
              $game_screen.start_tone_change(Tone.new(0,0,0,0),20)
              Kernel.pbMessage(odessa("ODESSA: It is done."))
              pbExclaim($game_player,ELIPSES_ANIMATION_ID)
              if !$game_screen.genderpc_doneSwap
                Kernel.pbMessage(confused("ODESSA: You were expecting something flashier?"))
                Kernel.pbMessage(confused("I changed your gender, not anything physical."))
                Kernel.pbMessage(confused("If that wasn't what you wanted, you should have been more specific."))
                Kernel.pbMessage(odessa("I don't believe I could even do that without a willing person to swap with."))
                $game_screen.genderpc_doneSwap = true
              else
                Kernel.pbMessage(odessa("ODESSA: Yes, yes, it wasn't flashy. <i>You</i> asked for me to do it again."))
              end
            end
          end
        end
      elsif choice == 1
        Kernel.pbMessage(confused("ODESSA: You want to..."))
        if !$game_screen.genderpc_triedToFeed
          Kernel.pbMessage(angry("\\sh\\c[7]Absolutely not!"))
          Kernel.pbMessage(angry("\\sh\\c[7]The little glutton eats too much as it is!"))
          $game_screen.genderpc_triedToFeed = true
        else
          Kernel.pbMessage(angry("You already know how I feel about that, \\PN."))
        end

        if $PokemonBag.pbQuantity(:GOURMETTREAT) > 0
          manaphySound
          if $Settings.photosensitive==0
            $game_screen.start_flash(Color.new(255,120,100,200),80)
          else
            pbExclaim($game_player, PINK_FLASH_ANIMATION_ID)
          end
          pbSEPlay('PRSFX- Teleport')
          $PokemonBag.pbDeleteItem(:GOURMETTREAT)
          pbWait(20)
          pbHealAll()
          pbSEPlay('PRSFX- Healing Pulse')
          pbExclaim($game_player)

          ServicePCList.happySound
          Kernel.pbMessage(manaphy("MANAPHY: Mana phyyy!"))
          Kernel.pbMessage(odessa("ODESSA: Did he just... Teleport to you..."))
          Kernel.pbMessage(odessa("And you gave him a Gourmet Treat?!"))
          Kernel.pbMessage(angry("\\sh\\c[7]Don't enable the little rascal!"))

          for i in 0...5
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(2)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbSEPlay('PRSFX- Play Rough3', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough4', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough3', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbSEPlay('PRSFX- Play Rough4', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough3', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough4', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough2', 20, 100)
            pbWait(1)
            pbSEPlay('PRSFX- Play Rough3', 20, 100)
            pbSEPlay('PRSFX- Play Rough4', 20, 100)
            pbSEPlay('PRSFX- Play Rough4', 20, 100)
          end
          Kernel.pbMessage(_INTL("(It sounds like there's a scuffle on the other end. Better give them some space.)"))
          return
        else
          manaphySad
          Kernel.pbMessage(manaphy("MANAPHY: Manaa..."))
          Kernel.pbMessage(odessa("ODESSA: I say it's a good thing you don't have a treat to give him!"))
          Kernel.pbMessage(odessa("Manaphy, you eat too many of those as it is."))
          manaphySad
          Kernel.pbMessage(manaphy("MANAPHY: Manaaaaaa..."))
        end
      end
    end

  end

end

ServicePCList.registerSubService(:Consultants, GenderPCService.new)
