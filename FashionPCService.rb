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
    if ServicePCList.offMap?
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
    pbCommonEvent(133) # Change clothes
    Kernel.pbMessage(xatu("Have a good day!\\wtnp[20]"))
  end
end

ServicePCList.registerService(FashionPCService.new)