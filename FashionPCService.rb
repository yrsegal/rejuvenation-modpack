Variables[:LuckQuest] = 780

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

    pbCommonEvent(133) # Change clothes
    Kernel.pbMessage(xatu("Have a good day!"))
  end
end

ServicePCList.registerService(FashionPCService.new)