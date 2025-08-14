Switches[:BikeVoucher] = 1699
Switches[:NoctowlCrest] = 1698
Switches[:PansageCrest] = 1697
Switches[:PansearCrest] = 1696
Switches[:PanpourCrest] = 1695
Switches[:LuxrayCrest] = 1701
Switches[:DruddigonCrest] = 1702
Switches[:ThievulCrest] = 1703
Switches[:SamurottCrest] = 1704
Switches[:BoltundCrest] = 1771
Switches[:ProbopassCrest] = 1774
Switches[:SwalotCrest] = 1772
Switches[:CinccinoCrest] = 1773
Switches[:DelcattyCrest] = 1775

Switches[:Gym_13] = 295

class CairoRedEssenceMartAdapter < PokemonMartAdapter
  def initialize(inventory)
    @inventory = inventory
  end

  def getMoney
    return $game_variables[:RedEssence]
  end

  def setMoney(value)
    $game_variables[:RedEssence]=value
  end

  def getPrice(item,selling=false)
    return @inventory[item][0] if @inventory[item]
    return 0
  end

  def getDisplayPrice(item,selling=false)
    price=getPrice(item,selling)
    return _ISPRINTF("{1:d} RE",price)
  end

  def showQuantity?(item)
    return false
  end
end

class CairoBulkMartAdapter < PokemonMartAdapter
  def initialize(quantities)
    @quantities = quantities
  end

  def getDisplayName(item)
    disp = super(item)
    disp = _INTL("{1}x {2}", @quantities[item], disp) if @quantities[item]
    return disp
  end
end

class CairoRedEssenceMartScreen
  def initialize(scene,inventory)
    @scene=scene
    @inventory=inventory
    @adapter = CairoRedEssenceMartAdapter.new(inventory)
  end

  def pbConfirm(msg)
    return @scene.pbConfirm(msg)
  end

  def pbDisplay(msg)
    return @scene.pbDisplay(msg)
  end

  def pbDisplayPaused(msg)
    return @scene.pbDisplayPaused(msg)
  end

  def pbBuyScreen
    stock = @inventory.keys
    @scene.pbStartBuyScene(stock,@adapter)
    item=nil
    loop do
      item=@scene.pbChooseBuyItem
      quantity=0
      break if item.nil?
      itemname=@adapter.getDisplayName(item)
      price=@adapter.getPrice(item)
      if @adapter.getMoney()<price
        pbDisplayPaused(_INTL("CAIRO: Not enough! I can't do anything with this amount."))
        next
      end

      if !pbConfirm(_INTL("CAIRO: Very well. That will be {2} Red Essence.",itemname,price))
        next
      end
      quantity=1
      if @adapter.getMoney()<price
        pbDisplayPaused(_INTL("CAIRO: Not enough! I can't do anything with this amount."))
        next
      end

      added=0
      quantity.times do
        if !@adapter.addItem(item)
          break
        end
        added+=1
      end
      if added!=quantity
        added.times do
          if !@adapter.removeItem(item)
            raise _INTL("Failed to delete stored items")
          end
        end
        pbDisplayPaused(_INTL("CAIRO: How did you even manage to fill up your bag?"))  
      else
        @adapter.setMoney(@adapter.getMoney()-price)
        $game_switches[@inventory[item][1]] = true

        for i in 0...stock.length
          if $game_switches[@inventory[stock[i]][1]]
            stock[i]=nil
          end
        end
        stock.compact!

        pbDisplayPaused(_INTL("CAIRO: You've earned it."))
        if Rejuv && $Trainer.achievements
          $Trainer.achievements.progress(:itemsBought, quantity)
        end
      end
    end
    @scene.pbEndBuyScene
  end
end

class CairoRedEssenceMartScene < PokemonMartScene
  def pbRefresh
    if !@subscene
      itemwindow=@sprites["itemwindow"]
      filename=@adapter.getItemIcon(itemwindow.item)
      @sprites["icon"].setBitmap(filename)
      @sprites["icon"].src_rect=@adapter.getItemIconRect(itemwindow.item)   
      @sprites["itemtextwindow"].text=(itemwindow.item.nil?) ? _INTL("Quit shopping.") :
         @adapter.getDescription(itemwindow.item)
      itemwindow.refresh
    end
    @sprites["moneywindow"].text=_INTL("<c3=C93828,d1c0be>Red Essence:</c3>\n<r>{1}",@adapter.getMoney())
  end

  def pbStartBuyOrSellScene(buying,stock,adapter)
    # Scroll right before showing screen
    pbScrollMap(6,5,5)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @stock=stock
    @adapter=adapter
    @sprites={}
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/martScreen")
    @sprites["icon"]=IconSprite.new(12,Graphics.height-74,@viewport)
    winAdapter=buying ? BuyAdapter.new(adapter) : SellAdapter.new(adapter)
    @sprites["itemwindow"]=Window_PokemonMart.new(stock,winAdapter,
       Graphics.width-316-16,12,330+16,Graphics.height-126)
    @sprites["itemwindow"].viewport=@viewport
    @sprites["itemwindow"].index=0
    @sprites["itemwindow"].refresh
    @sprites["itemtextwindow"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["itemtextwindow"])
    @sprites["itemtextwindow"].x=64
    @sprites["itemtextwindow"].y=Graphics.height-96-16
    @sprites["itemtextwindow"].width=Graphics.width-64
    @sprites["itemtextwindow"].height=128
    @sprites["itemtextwindow"].baseColor=Color.new(248,248,248)
    @sprites["itemtextwindow"].shadowColor=Color.new(0,0,0)
    @sprites["itemtextwindow"].visible=true
    @sprites["itemtextwindow"].viewport=@viewport
    @sprites["itemtextwindow"].windowskin=nil
    @sprites["helpwindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["helpwindow"])
    @sprites["helpwindow"].visible=false
    @sprites["helpwindow"].viewport=@viewport
    pbBottomLeftLines(@sprites["helpwindow"],1)
    @sprites["moneywindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["moneywindow"])
    @sprites["moneywindow"].setSkin("Graphics/Windowskins/goldskin")
    @sprites["moneywindow"].visible=true
    @sprites["moneywindow"].viewport=@viewport
    @sprites["moneywindow"].x=0
    @sprites["moneywindow"].y=Graphics.height-96-96-8
    @sprites["moneywindow"].width=190
    @sprites["moneywindow"].height=96
    @sprites["moneywindow"].baseColor=Color.new(88,88,80)
    @sprites["moneywindow"].shadowColor=Color.new(168,184,184)
    pbDeactivateWindows(@sprites)
    @buying=buying
    pbRefresh
    Graphics.frame_reset
  end
end

class CairoBulkMartScene < PokemonMartScene
  def pbChooseNumber(helptext,item,maximum,purchaseQuantity=1)
    curnumber=1
    ret=0
    helpwindow=@sprites["helpwindow"]
    itemprice=@adapter.getPrice(item,!@buying)
    itemprice/=2 if !@buying
    pbDisplay(helptext,true)
    using_block(numwindow=Window_AdvancedTextPokemon.new("")){ # Showing number of items
       qty=@adapter.getQuantity(item)
       using_block(inbagwindow=Window_AdvancedTextPokemon.new("")){ # Showing quantity in bag
          pbPrepareWindow(numwindow)
          pbPrepareWindow(inbagwindow)
          numwindow.viewport=@viewport
          numwindow.width=224
          numwindow.height=64
          numwindow.baseColor=Color.new(88,88,80)
          numwindow.shadowColor=Color.new(168,184,184)
          inbagwindow.visible=@buying
          inbagwindow.viewport=@viewport
          inbagwindow.width=190
          inbagwindow.height=64
          inbagwindow.baseColor=Color.new(88,88,80)
          inbagwindow.shadowColor=Color.new(168,184,184)
          inbagwindow.text=_ISPRINTF("In Bag:<r>{1:d}  ",qty)
          numwindow.text=_INTL("x{1}<r>$ {2}",curnumber*purchaseQuantity,pbCommaNumber(curnumber*itemprice))
          pbBottomRight(numwindow)
          numwindow.y-=helpwindow.height
          pbBottomLeft(inbagwindow)
          inbagwindow.y-=helpwindow.height
          loop do
            Graphics.update
            Input.update
            numwindow.update
            inbagwindow.update
            self.update
            if Input.repeat?(Input::LEFT)
              pbPlayCursorSE()
              curnumber-=10
              curnumber=1 if curnumber<1
              numwindow.text=_INTL("x{1}<r>$ {2}",curnumber*purchaseQuantity,pbCommaNumber(curnumber*itemprice))
            elsif Input.repeat?(Input::RIGHT)
              pbPlayCursorSE()
              curnumber+=10
              curnumber=maximum if curnumber>maximum
              numwindow.text=_INTL("x{1}<r>$ {2}",curnumber*purchaseQuantity,pbCommaNumber(curnumber*itemprice))
            elsif Input.repeat?(Input::UP)
              pbPlayCursorSE()
              curnumber+=1
              curnumber=1 if curnumber>maximum
              numwindow.text=_INTL("x{1}<r>$ {2}",curnumber*purchaseQuantity,pbCommaNumber(curnumber*itemprice))
            elsif Input.repeat?(Input::DOWN)
              pbPlayCursorSE()
              curnumber-=1
              curnumber=maximum if curnumber<1
              numwindow.text=_INTL("x{1}<r>$ {2}",curnumber*purchaseQuantity,pbCommaNumber(curnumber*itemprice))
            elsif Input.trigger?(Input::C)
              pbPlayDecisionSE()
              ret=curnumber
              break
            elsif Input.trigger?(Input::B)
              pbPlayCancelSE()
              ret=0
              break
            end     
          end
       }
    }
    helpwindow.visible=false
    return ret
  end

  def pbStartBuyOrSellScene(buying,stock,adapter)
    # Scroll right before showing screen
    pbScrollMap(6,5,5)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @stock=stock
    @adapter=adapter
    @sprites={}
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/martScreen")
    @sprites["icon"]=IconSprite.new(12,Graphics.height-74,@viewport)
    winAdapter=buying ? BuyAdapter.new(adapter) : SellAdapter.new(adapter)
    @sprites["itemwindow"]=Window_PokemonMart.new(stock,winAdapter,
       Graphics.width-316-16,12,330+16,Graphics.height-126)
    @sprites["itemwindow"].viewport=@viewport
    @sprites["itemwindow"].index=0
    @sprites["itemwindow"].refresh
    @sprites["itemtextwindow"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["itemtextwindow"])
    @sprites["itemtextwindow"].x=64
    @sprites["itemtextwindow"].y=Graphics.height-96-16
    @sprites["itemtextwindow"].width=Graphics.width-64
    @sprites["itemtextwindow"].height=128
    @sprites["itemtextwindow"].baseColor=Color.new(248,248,248)
    @sprites["itemtextwindow"].shadowColor=Color.new(0,0,0)
    @sprites["itemtextwindow"].visible=true
    @sprites["itemtextwindow"].viewport=@viewport
    @sprites["itemtextwindow"].windowskin=nil
    @sprites["helpwindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["helpwindow"])
    @sprites["helpwindow"].visible=false
    @sprites["helpwindow"].viewport=@viewport
    pbBottomLeftLines(@sprites["helpwindow"],1)
    @sprites["moneywindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["moneywindow"])
    @sprites["moneywindow"].setSkin("Graphics/Windowskins/goldskin")
    @sprites["moneywindow"].visible=true
    @sprites["moneywindow"].viewport=@viewport
    @sprites["moneywindow"].x=0
    @sprites["moneywindow"].y=Graphics.height-96-96-8
    @sprites["moneywindow"].width=190
    @sprites["moneywindow"].height=96
    @sprites["moneywindow"].baseColor=Color.new(88,88,80)
    @sprites["moneywindow"].shadowColor=Color.new(168,184,184)
    pbDeactivateWindows(@sprites)
    @buying=buying
    pbRefresh
    Graphics.frame_reset
  end
end

class CairoBulkMartScreen
  def initialize(scene,stock,quantities)
    @scene=scene
    @stock=stock
    @quantities=quantities
    @adapter=CairoBulkMartAdapter.new(quantities)
  end

  def pbConfirm(msg)
    return @scene.pbConfirm(msg)
  end

  def pbDisplay(msg)
    return @scene.pbDisplay(msg)
  end

  def pbDisplayPaused(msg)
    return @scene.pbDisplayPaused(msg)
  end

  def pbBuyScreen
    @scene.pbStartBuyScene(@stock,@adapter)
    item=nil
    loop do
      item=@scene.pbChooseBuyItem
      quantity=0
      break if item.nil?
      itemname=@adapter.getDisplayName(item)
      truename=@adapter.getItemName(item)
      purchaseQuantity = @quantities[item]
      price=@adapter.getPrice(item)
      if @adapter.getMoney()<price
        pbDisplayPaused(_INTL("CAIRO: No money."))
        next
      end
      maxafford=(price<=0) ? BAGMAXPERSLOT : @adapter.getMoney()/price
      maxafford=BAGMAXPERSLOT if maxafford>BAGMAXPERSLOT
      packQuantity=@scene.pbChooseNumber(
         _INTL("CAIRO: {1}? How many?",truename),item,maxafford, purchaseQuantity)
      if packQuantity==0
        next
      end
      price*=packQuantity
      quantity = purchaseQuantity * packQuantity
      if !pbConfirm(_INTL("CAIRO: {1} {2}s.\nThat will be ${3}.",quantity,truename,pbCommaNumber(price)))
        next
      end
      if @adapter.getMoney()<price
        pbDisplayPaused(_INTL("CAIRO: No money."))
        next
      end
      added=0
      quantity.times do
        if !@adapter.addItem(item)
          break
        end
        added+=1
      end
      if added!=quantity
        added.times do
          if !@adapter.removeItem(item)
            raise _INTL("Failed to delete stored items")
          end
        end
        pbDisplayPaused(_INTL("CAIRO: Your bag is full. Absurd."))  
      else
        @adapter.setMoney(@adapter.getMoney()-price)
        for i in 0...@stock.length
          if !$PokemonBag.pbQuantity(@stock[i]).nil? && pbIsImportantItem?(@stock[i]) && $PokemonBag.pbQuantity(@stock[i])>0
            @stock[i]=nil
          end
        end
        @stock.compact!
        pbDisplayPaused(_INTL("CAIRO: Hmph."))
        if Rejuv && $Trainer.achievements
          $Trainer.achievements.progress(:itemsBought, quantity)
        end
      end
    end
    @scene.pbEndBuyScene
  end
end

module CairoAsShopInterface
  def self.purchaseItems
    $game_temp.mart_buy[:JOYSCENT]=5000
    $game_temp.mart_buy[:EXCITESCENT]=8500
    $game_temp.mart_buy[:VIVIDSCENT]=11000
    $game_temp.mart_buy[:RIFTFRAGMENT]=4956
    items = {
      JOYSCENT: 10,
      EXCITESCENT: 10,
      VIVIDSCENT: 10,
      RIFTFRAGMENT: 5
    }
    return items.keys, items
  end

  def self.redEssenceItems
    items = {}

    shoptier = 5
    shoptier = 8  if $game_switches[:Gym_8]
    shoptier = 13 if $game_switches[:Gym_13]
    shoptier = 15 if $game_switches[:Gym_15]

    items[:BIKEV] = [shoptier >= 15 ? 500 : 250, :BikeVoucher] # Dunno why but it's like that

    items[:NOCCREST] = [2000, :NoctowlCrest]
    items[:SAGECREST] = [2000, :PansageCrest]
    items[:SEARCREST] = [2000, :PansearCrest]
    items[:POURCREST] = [2000, :PanpourCrest]

    if shoptier >= 8
      items[:LUXCREST] = [5000, :LuxrayCrest]
      items[:DRUDDICREST] = [5000, :DruddigonCrest]
      items[:THIEVCREST] = [5000, :ThievulCrest]
      items[:SAMUCREST] = [5000, :SamurottCrest]
    end

    if shoptier >= 13
      items[:BOLTCREST] = [9000, :BoltundCrest]
      items[:PROBOCREST] = [9000, :ProbopassCrest]
      items[:SWACREST] = [9000, :SwalotCrest]
      items[:CINCCREST] = [9000, :CinccinoCrest]
    end

    if shoptier >= 15
      items.push[:DELCREST] = [14000, :DelcattyCrest]
    end

    return items
  end

  def self.pbCairoMart
    inventory = redEssenceItems

    needsDeleting = []
    for item, (price, switch) in inventory
      needsDeleting.push(item) if $game_switches[switch]
    end
    needsDeleting.each(&inventory.method(:delete))

    moneystock, moneyquantities = purchaseItems

    commands=[]
    cmdBuy=-1
    cmdMoneyShop=-1
    cmdQuit=-1
    commands[cmdBuy=commands.length]=_INTL("Red Essence Shop")
    commands[cmdMoneyShop=commands.length]=_INTL("Money Shop")
    commands[cmdQuit=commands.length]=_INTL("Quit")
    message = $game_variables[:RedEssence] > 0 ? _INTL("CAIRO: I see that you have Red Essence.\nLet's see what we got.") : _INTL("CAIRO: Well met. I see you made it to my humble abode.")
    cmd=Kernel.pbMessage(message, commands,cmdQuit+1)
    loop do
      if cmdBuy>=0 && cmd==cmdBuy
        scene=CairoRedEssenceMartScene.new
        screen=CairoRedEssenceMartScreen.new(scene,inventory)
        screen.pbBuyScreen
      elsif cmdMoneyShop>=0 && cmd==cmdMoneyShop
        scene=CairoBulkMartScene.new
        screen=CairoBulkMartScreen.new(scene,moneystock,moneyquantities)
        screen.pbBuyScreen
      else
        Kernel.pbMessage(_INTL("CAIRO: Darkness need not hide from me. I will find it no matter what."))
        break
      end
      cmd=Kernel.pbMessage(_INTL("CAIRO: Is that all?"),commands,cmdQuit+1)
    end
  end
end

InjectionHelper.defineMapPatch(168, 16) { |event| # Cairo
  event.patch(:cairo_shop_interface) { |page|
    if page.condition.self_switch_valid && page.condition.self_switch_ch == "A"
      matched = page.lookForSequence([:ShowText, /^CAIRO: Well met\./])

      if matched
        page.insertBefore(matched,
          [:Script, 'CairoAsShopInterface.pbCairoMart'],
          [:JumpToLabel, 'Exit shop'])
        next true
      end
    end
  }
}

