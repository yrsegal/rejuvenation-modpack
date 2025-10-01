begin
  missing = ['0000.formattedchoices.rb', '0000.textures.rb', '0001.pcservices.rb', 'ServiceIcons'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

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
  attr_accessor :genderpc_delpha
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

  def delpha(pkmn)
    return pkmn.species == :DELPHOX && pkmn.form == 1
  end

  def ashgreninja(pkmn)
    return pkmn.species == :GRENINJA && pkmn.form >= 1
  end

  def access
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    odessaAngy = $game_variables[:MissingChildren] >= 60 && $game_variables[:MissingChildren] < 64

    skipFirstLine = false

    if $game_screen.genderpc_angy
      if odessaAngy
        Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
        Kernel.pbMessage(_INTL("(She sent you to voicemail...)"))
        return
      else
        Kernel.pbMessage(odessa("ODESSA: Ah. \\PN.\1"))
        Kernel.pbMessage(odessa("... My apologies. I had been irate at you over your leaving Ana alone.\1"))
        Kernel.pbMessage(odessa("I have calmed down and forgiven you.\1"))
        Kernel.pbMessage(blush("(Are you satisfied, you insatiable gremlin?)\1"))
        manaphySound
        Kernel.pbMessage(manaphy("MANAPHY: (Mana!)\1"))
        $game_screen.genderpc_angy = false
        if !$game_screen.genderpc_used
          Kernel.pbMessage(odessa("ODESSA: Apologies aside, what is it you wanted to call me for?\1"))
          skipFirstLine = true
        end
      end
    elsif !$game_screen.genderpc_used
      Kernel.pbMessage(odessa("ODESSA: H-hello? I'm sorry, this phone is new. I haven't used it much.\1"))
      ServicePCList.playerTalk
      ServicePCList.exclaimSound
      if odessaAngy
        Kernel.pbMessage(angry("ODESSA: ...\1"))
        Kernel.pbMessage(_INTL("(She hung up?)"))
        $game_screen.genderpc_angy = true
        return
      end
      Kernel.pbMessage(odessa("ODESSA: Ah! Hello, \\PN!\1"))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana!\1"))
      ServicePCList.happySound
      Kernel.pbMessage(odessa("ODESSA: He says hello too!\1"))
    end

    if !$game_screen.genderpc_used
      Kernel.pbMessage(odessa("So, why are you calling?\1")) if !skipFirstLine
      ServicePCList.playerTalk
      Kernel.pbMessage(confused("ODESSA: I\\..\\..\\..\\. see? You... wanted me to use Heart Swap again? Whyever for?\1"))
      ServicePCList.playerTalk
      Kernel.pbMessage(odessa("ODESSA: To change the gender of your Pokemon? I... suppose that is possible.\1"))

      if odessaAssumedGender != "female"
        ServicePCList.happySound
        Kernel.pbMessage(odessa("After all, in your body, I was for all intents and purposes {1}!\1", odessaAssumedGender))
      else
        Kernel.pbMessage(blush("I... know Heart Swap works on those who aren't female, too.\1"))
      end

      if playerGender != odessaAssumedGender
        pbExclaim($game_player, GRUMPY_ANIMATION_ID)
        ServicePCList.playerTalk
        ServicePCList.exclaimSound
        Kernel.pbMessage(blush("ODESSA: Oh? I-I'm sorry! You're {1}? I had assumed...\1", playerGender))
        Kernel.pbMessage(blush("No, that's no excuse. I'm sorry, \\PN.\1"))
      end

      Kernel.pbMessage(odessa("The move is more versatile than that, of course...\1"))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana! Man-na!\1"))
      Kernel.pbMessage(odessa("ODESSA: We have been practicing, true.\1"))
      Kernel.pbMessage(odessa("I believe I know how we'd use it to \\c[6]change someone's gender directly.\1"))
      Kernel.pbMessage(odessa("So, that being said...\1"))
      $game_screen.genderpc_used = true
    else
      if odessaAngy
        Kernel.pbMessage(angry("ODESSA: ...\1"))
        Kernel.pbMessage(_INTL("(She hung up?)"))
        $game_screen.genderpc_angy = true
        return
      end
      Kernel.pbMessage(odessa("ODESSA: Hello, \\PN. How are you?\1"))
      manaphySound
      Kernel.pbMessage(manaphy("MANAPHY: Mana!\1"))
      ServicePCList.happySound
      Kernel.pbMessage(odessa("ODESSA: Manaphy assures you <i>he's</i> feeling fine.\1"))
      Kernel.pbMessage(odessa("That being said...\1"))
    end

    choice = 0
    while choice >= 0
      choice = Kernel.pbMessage(odessa("What can we do for you?"),[_INTL("Heart Swap"),_INTL("Feed Manaphy")],-1,nil,0)
      if choice < 0
        Kernel.pbMessage(odessa("ODESSA: Talk to you soon."))
      elsif choice == 0
        heartscalewindow = ServicePCList.quantityWindow(:HEARTSCALE)
        subChoice = Kernel.pbMessage(odessa("On who?"),[_INTL("A Pokemon"), _INTL("Me")], -1, nil, 0)
        if subChoice == 0
          result = 0
          while result != -1
            pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && p.gender != 2 && !delpha(p) && !ashgreninja(p) && !CANNOT_SWAP_RATIOS.include?($cache.pkmn[p.species].GenderRatio) },true)
            result = pbGet(1)
            if result != -1
              pkmn = $Trainer.party[result]
              if pkmn.isEgg?
                Kernel.pbMessage(confused("ODESSA: ...\\PN? I don't think an Egg is a valid target."))
              elsif (pkmn.isShadow? rescue false)
                Kernel.pbMessage(confused("ODESSA: ... What is this, and why are you showing it to me?\1"))
                Kernel.pbMessage(confused("Poor {1} looks like it's in agony...", getMonName(pkmn.species)))
              else
                if pkmn.gender == 2
                  Kernel.pbMessage(confused("ODESSA: Do {1} even have a gender?", getMonName(pkmn.species)))
                  next
                end

                if delpha(pkmn)
                  if $game_screen.genderpc_delpha
                    Kernel.pbMessage(angry("ODESSA: She already refused, \\PN. That <i>will</i> be that."))
                  else
                    Kernel.pbMessage(confused("ODESSA: Uh. This {1} can... talk? And she's objecting. Strenuously.\1", getMonName(pkmn.species)))
                    ServicePCList.playerTalk
                    ServicePCList.exclaimSound
                    Kernel.pbMessage(blush("Ah. A history with mind controllers? That makes sense. My apologies, {1}.", pkmn.name))
                    $game_screen.genderpc_delpha = true
                  end
                  next
                elsif ashgreninja(pkmn)
                  ServicePCList.exclaimSound
                  Kernel.pbMessage(odessa("ODESSA: Is this... Ash's Greninja?"))
                  Kernel.pbMessage(odessa("It feels like a trespass to do anything without Ash's permission..."))
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

                Kernel.pbMessage(odessa("ODESSA: Alright. That will require a Heart Scale as a catalyst.\1"))
                if $PokemonBag.pbQuantity(:HEARTSCALE) <= 0
                  Kernel.pbMessage(odessa("Ah, unfortunate, you don't have any. Another time, then."))
                  break
                end

                pkmnGender = pkmn.gender == 1 ? femaleColor + 'female' : maleColor + 'male'
                targetGender = pkmn.gender == 1 ? maleColor + 'male' : femaleColor + 'female'

                if Kernel.pbConfirmMessage(odessa("ODESSA: Then you want to change \\v[3] from {1}\\c[0] into {2}\\c[0]?", pkmnGender, targetGender))
                  $PokemonBag.pbDeleteItem(:HEARTSCALE)
                  ServicePCList.updateWindowQuantity(heartscalewindow, :HEARTSCALE)
                  Kernel.pbMessage(odessa("ODESSA: Then so it shall be! Manaphy...\1"))
                  ServicePCList.fadeScreen(Tone.new(0,0,0,255),20)
                  manaphySound
                  Kernel.pbMessage(odessa("ODESSA: HEART SWAP!"))
                  pbExclaim($game_player, HEART_SWAP_ANIMATION_ID)
                  pkmn.setGender(1 - pkmn.gender)
                  pbWait(2)
                  ServicePCList.restoreScreen(10)
                  Kernel.pbMessage(odessa("ODESSA: It is done."))
                  break
                end
              end
            end
          end
        elsif subChoice == 1
          Kernel.pbMessage(blush("ODESSA: Y-you?\1"))
          if !$game_screen.genderpc_askedForSwap
            Kernel.pbMessage(blush("You really trust me, after...\1"))
            Kernel.pbMessage(blush("\\..\\..\\..\\.\1"))
            Kernel.pbMessage(odessa("I appreciate it.\1"))
            Kernel.pbMessage(odessa("Ah, but is that even possible without physical presence?\1"))
            Kernel.pbMessage(odessa("For a Pokemon, you can send it to me through the PC, but...\1"))
            manaphySound
            Kernel.pbMessage(manaphy("MANAPHY: Mana ma!\1"))
            Kernel.pbMessage(odessa("ODESSA: Apparently, it is within Manaphy's capabilities.\1"))
            Kernel.pbMessage(blush("So...\1"))
            $game_screen.genderpc_askedForSwap = true
          end

          ServicePCList.updateWindowQuantity(heartscalewindow, :HEARTSCALE)
          Kernel.pbMessage(odessa("I suppose I can do that... It will cost two Heart Scales as catalysts, though.\1"))
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
              Kernel.pbMessage(confused("ODESSA: Are you not already {1}?\1", playerGender))
              Kernel.pbMessage(confused("Is this... are you insecure about that?\1"))
              Kernel.pbMessage(odessa("If so, I apologize. I meant no offense. You are already a quite lovely {1}.", playerReferent))
            elsif choice <= 2
              $PokemonBag.pbDeleteItem(:HEARTSCALE, 2)
              ServicePCList.updateWindowQuantity(heartscalewindow, :HEARTSCALE)
              Kernel.pbMessage(odessa("ODESSA: V-very well then! Manaphy...\1"))
              ServicePCList.fadeScreen(Tone.new(0,0,0,255),20)
              manaphySound
              Kernel.pbMessage(odessa("ODESSA: HEART SWAP!"))
              pbExclaim($game_player, HEART_SWAP_ANIMATION_ID)
              $game_switches[:PlayerMale] = choice == 0
              $game_switches[:PlayerFemale] = choice == 1
              $game_switches[:PlayerEnby] = choice == 2
              pbWait(2)
              ServicePCList.restoreScreen(10)
              Kernel.pbMessage(odessa("ODESSA: It is done."))
              pbExclaim($game_player,ELIPSES_ANIMATION_ID)
              if !$game_screen.genderpc_doneSwap
                Kernel.pbMessage(confused("ODESSA: You were expecting something flashier?\1"))
                Kernel.pbMessage(confused("I changed your gender, not anything physical.\1"))
                Kernel.pbMessage(confused("If that wasn't what you wanted, you should have been more specific.\1"))
                Kernel.pbMessage(odessa("I don't believe I could even do that without a willing person to swap with."))
                $game_screen.genderpc_doneSwap = true
              else
                Kernel.pbMessage(odessa("ODESSA: Yes, yes, it wasn't flashy. <i>You</i> asked for me to do it again."))
              end
              break
            end
          end
        end
        heartscalewindow.dispose
      elsif choice == 1
        gourmetwindow = ServicePCList.quantityWindow(:GOURMETTREAT)
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
          ServicePCList.updateWindowQuantity(gourmetwindow, :GOURMETTREAT)
          pbWait(20)
          pbHealAll()
          pbSEPlay('PRSFX- Healing Pulse')
          pbExclaim($game_player)

          ServicePCList.happySound
          Kernel.pbMessage(manaphy("MANAPHY: Mana phyyy!"))
          Kernel.pbMessage(odessa("ODESSA: Did he just... Teleport to you...\1"))
          Kernel.pbMessage(odessa("And you gave him a Gourmet Treat?!\1"))
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
          Kernel.pbMessage(manaphy("MANAPHY: Manaa...\1"))
          Kernel.pbMessage(odessa("ODESSA: I say it's a good thing you don't have a treat to give him!\1"))
          Kernel.pbMessage(odessa("Manaphy, you eat too many of those as it is.\1"))
          manaphySad
          Kernel.pbMessage(manaphy("MANAPHY: Manaaaaaa..."))
        end
        gourmetwindow.dispose
      end
    end

  end

end

ServicePCList.registerSubService(:Consultants, GenderPCService.new)
