Variables[:LuckQuest] = 780
Variables[:Outfit] = 259

Switches[:LegacyOutfit] = 1052
Switches[:XGOutfitAvailable] = 1645

TextureOverrides.registerServiceSprites('XatuFashion')

class Game_Screen
  attr_accessor :fashionpc_used
end

class FashionPCService
  def shouldShow?
    return true
  end

  def name
    return _INTL("Xatu Fashion")
  end

  def help
    return _INTL("Swap your outfits via Teleport.")
  end

  def xatu(text, *args) 
    return _INTL("\\f[service_XatuFashion]" + text, *args)
  end

  def access
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("..."))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    Kernel.pbMessage(xatu("Hello, you've reached the Xatu Fashion Service. How may I help?"))
    if !$game_screen.fashionpc_used
      Kernel.pbMessage(xatu("Oh! Is this your first time using the service? Let me explain."))
      Kernel.pbMessage(xatu("We're a startup operating out of Coral Ward, Reborn City. We stock outfits for you and let you switch them at will!")) 
      Kernel.pbMessage(xatu("We're subsidized by Adrienn, so the service is free to use. We've recently extended our operations to Aevium!")) 
      $game_screen.fashionpc_used = true
    end

    if $game_variables[:LuckQuest] > 0 && $game_variables[:LuckQuest] < 6
      Kernel.pbMessage(xatu("... I'm sorry, there's some sort of Teleport interference around you."))
      Kernel.pbMessage(xatu("Someone seems quite invested in keeping your clothing how it is."))
      Kernel.pbMessage(xatu("Please figure out what's up with that, then call back."))
      return
    end

    if Kernel.pbConfirmMessage(xatu("Would you like to change clothes?"))
      if defined?(outfitoptions_handle_clothing_choices)
        outfitoptions_handle_clothing_choices # Mod compat!
      else
        handle_clothing_choices
      end
    end
    Kernel.pbMessage(xatu("Have a good day!"))
  end

  def handle_clothing_choices
    currVal = $game_variables[:Outfit]

    choices = ["Default outfit", "Secondary outfit"]
    outfits = [0, 1]
    if $game_switches[:LegacyOutfit] # Legacy outtfit
      choices.push(_INTL("Legacy outfit"))
      outfits.push(2)
    end

    if $game_switches[:XGOutfitAvailable] # XG Outfit
      choices.push(_INTL("Xenogene outfit"))
      outfits.push(6)
    end

    default = outfits.find_index(currVal) || 0

    ret = Kernel.pbShowCommands(nil, choices,default+1,-1)
    Input.update

    newOutfit = outfits[ret]
    if newOutfit != -1
      $game_screen.start_tone_change(Tone.new(-255,-255,-255,0), 14 * 2)
      pbWait(20)
      pbSEPlay('Fire1', 80, 80)
      $game_variables[:Outfit] = newOutfit # Outfit
      $Trainer.outfit = newOutfit
      Kernel.pbMessage(_INTL('\\PN changed clothes!'))
      pbWait(10)
      $game_screen.start_tone_change(Tone.new(0,0,0,0), 10 * 2)
    end
  end
end

ServicePCList.registerService(FashionPCService.new)