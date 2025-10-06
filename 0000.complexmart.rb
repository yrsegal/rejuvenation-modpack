Variables[:PuppetCoins] = 597

module ComplexMartInterface

  DEFAULT_MESSAGES_INTERACT = {
    speech: "Welcome!\nHow may I serve you?",
    come_again: "Please come again!",
    anything_else: "Is there anything else I can help you with?"
  }

  DEFAULT_MESSAGES_MART = {
    no_money: "You don't have enough money.",
    no_puppet: "You don't have enough Puppet Coins.",
    no_coins: "You don't have enough Coins.",
    no_ap: "You don't have enough AP.",
    no_re: "You don't have enough Red Essence.",
    no_items: "You don't have enough {1}.",

    purchase_important: "Certainly. You want {1}.\nThat will be {2}. OK?",
    choose_quantity: "{1}? Certainly.\nHow many would you like?",
    purchase_quantity: "{1}, and you want {2}.\nThat will be {3}. OK?",

    full_puppet: "You're too full of coins.",
    full_coins: "Your Coin Case is too full.",
    full_item: "You have no more room in the Bag.",

    success_money: "Here you are!\nThank you!",
    success_coins: "Here you are!\nThank you!",
    success_puppet: "Here you are!\nThank you!",
    success_ap: "Here you are!\nThank you!",
    success_re: "Here you are!\nThank you!",
    success_items: "Here you are!\nThank you!",

    premier_one: "I'll throw in a Premier Ball, too.",
    premier_many: "I'll throw in {1} Premier Balls, too."
  }

  DEFAULT_SHORTNAMES = pbHashForwardizer({
    "{1} Shroom" => [:TINYMUSHROOM,:BIGMUSHROOM,:BALMMUSHROOM],
    "{1} Prism" => [:BLKPRISM],
    "{1} Red" => [:REDSHARD],
    "{1} Blue" => [:BLUESHARD],
    "{1} Green" => [:GREENSHARD],
    "{1} Yellow" => [:YELLOWSHARD]
  })

  def self.evaluateConditions(conditions)
    for condition in conditions
      if condition.is_a?(Proc)
        if !condition.call
          return false
        end
      else
        if condition[:var]
          state = $game_variables[condition[:var]]
          if condition[:is].is_a?(Proc) && !condition[:is].call(state)
            return false
          elsif condition[:is].is_a?(Symbol) && !state.send(condition[:is], condition[:than])
            return false
          end
        elsif condition[:switch]
          state = $game_switches[condition[:switch]]
          if state != condition[:is]
            return false
          end
        elsif condition[:selfswitch]
          state = $game_self_switches[[condition[:map],condition[:event],condition[:selfswitch]]]
          if state != condition[:is]
            return false
          end
        end
      end
    end
    return true
  end

  class ComplexPokemonMartAdapter
    def initialize(inventory)
      @baseInventory = inventory

      @baseStock = []
      @priceTypes = []
      @inventory = {}

      for stockInfo in inventory
        conditions = []
        if stockInfo[:condition]
          if stockInfo[:condition].is_a?(Array)
            conditions.push(*stockInfo[:condition])
          else
            conditions.push(stockInfo[:condition])
          end
        end

        conditions.push({ switch: stockInfo[:switch], is: false }) if stockInfo[:switch]
        conditions.push({ var: stockInfo[:var][0], is: :<, than: stockInfo[:var][1] }) if stockInfo[:var]
        if stockInfo[:selfswitch]
          ssw = stockInfo[:selfswitch]
          conditions.push({ map: ssw[0], event: ssw[1], selfswitch: ssw[2], is: false })
        end

        next unless ComplexMartInterface.evaluateConditions(conditions)

        stockItem = nil
        # Pokemon comes after move, because pokemon also uses the "move"
        [:puppet, :coins, :move, :item, :pokemon].each { |it|
          stockItem = [it, stockInfo[it]] if stockInfo[it]
        }
        next unless stockItem

        next if stockItem[0] == :item && pbIsImportantItem?(stockItem[1]) && $PokemonBag.pbHasItem?(stockItem[1])

        stockItem.push(stockInfo.fetch(:quantity, 1)) if stockItem[0] == :item
        stockItem.push(stockInfo.fetch(:level, 10), stockInfo[:move], stockInfo.fetch(:form, 0)) if stockItem[0] == :pokemon

        next if stockItem[0] == :move && $Trainer.tutorlist.length>0 && $Trainer.tutorlist.include?(stockItem[1])

        @inventory[stockItem] = stockInfo
        @baseStock.push(stockItem)
        if stockInfo[:price][:type] == :Item
          if [:REDSHARD,:BLUESHARD,:GREENSHARD,:YELLOWSHARD].include?(stockInfo[:price][:item])
            @priceTypes.push(:Shards)
          else
            @priceTypes.push(stockInfo[:price][:item])
          end
        else
          @priceTypes.push(stockInfo[:price][:type])
        end

        if stockItem[0] == :puppet
          @priceTypes.push(:PuppetCoins)
        elsif stockItem[0] == :coins
          @priceTypes.push(:Coins)
        end
      end

      @priceTypes.uniq!
    end

    # Added for complex
    def getStock
      return @baseStock
    end

    # Added for complex
    def priceTypes
      return @priceTypes
    end

    # Added for complex
    def removeAfterPurchase(item, purchasedItem)
      if @inventory[item][:switch]
        $game_switches[@inventory[item][:switch]] = true if item == purchasedItem
        return $game_switches[@inventory[item][:switch]]
      elsif @inventory[item][:var]
        varid, value = @inventory[item][:var]
        $game_variables[varid] = value if item == purchasedItem && $game_variables[varid] < value
        return $game_variables[varid] >= value
      elsif @inventory[item][:selfswitch]
        key = @inventory[item][:selfswitch]
        $game_self_switches[key] = true if item == purchasedItem
        return $game_self_switches[key]
      elsif item[0] == :item && pbIsImportantItem?(item[1]) && $PokemonBag.pbQuantity(item[1]) > 0
        return true
      elsif item[0] == :move && $Trainer.tutorlist.length>0 && $Trainer.tutorlist.include?(item[1]) # Is added to move tutors
        return true
      end

      return false
    end

    # Added for complex
    def getPriceType(item)
      return @inventory[item][:price][:type]
    end

    # Added for complex
    def getPriceItemName(item)
      return getItemName(@inventory[item][:price][:item])
    end

    # Added for complex
    def getPurchaseMessage(messages, item, price, quantity=0)
      if quantity == 0
        message = @inventory[item].fetch(:purchase_message, messages[:purchase_important])
        return _INTL(message,getDisplayName(item),formatPrice(price, item, true))
      else
        message = @inventory[item].fetch(:purchase_message, messages[:purchase_quantity])
        return _INTL(message,getName(item),quantity,formatPrice(price, item, true))
      end
    end

    # Added for complex
    def getQuantitySelectMessage(messages, item)
      message = @inventory[item].fetch(:quantity_message, messages[:choose_quantity])
      return _INTL(@inventory[item][:quantity_message],getName(item)) if @inventory[item][:quantity_message]
      return _INTL(messages[:choose_quantity],getName(item))
    end

    # Added for complex
    def getSuccessMessage(messages, item)
      return _INTL(@inventory[item][:success_message]) unless !@inventory[item][:success_message] || @inventory[item][:success_message].empty?

      case getPriceType(item)
      when :Money       then return _INTL(messages[:success_money]) unless messages[:success_money].empty?
      when :RedEssence  then return _INTL(messages[:success_re]) unless messages[:success_re].empty?
      when :Coins       then return _INTL(messages[:success_coins]) unless messages[:success_coins].empty?
      when :PuppetCoins then return _INTL(messages[:success_coins]) unless messages[:success_coins].empty?
      when :AP          then return _INTL(messages[:success_ap]) unless messages[:success_ap].empty?
      when :Item        then return _INTL(messages[:success_items], getPriceItemName(item)) unless messages[:success_items].empty?
      end
      return ""
    end

    def getMoney(item)
      case getPriceType(item)
      when :Money       then return $Trainer.money
      when :RedEssence  then return $game_variables[:RedEssence]
      when :Coins       then return $PokemonGlobal.coins
      when :PuppetCoins then return $game_variables[:PuppetCoins]
      when :AP          then return $game_variables[:APPoints]
      when :Item        then return $PokemonBag.pbQuantity(@inventory[item][:price][:item])
      end
      return 0
    end

    def setMoney(value, item)
      case getPriceType(item)
      when :Money       then $Trainer.money = value
      when :RedEssence  then $game_variables[:RedEssence] = value
      when :Coins       then $PokemonGlobal.coins = value
      when :PuppetCoins then $game_variables[:PuppetCoins] = value
      when :AP          then $game_variables[:APPoints] = value
      when :Item
        itemKey = @inventory[item][:price][:item]
        current = $PokemonBag.pbQuantity(itemKey)
        if value < current
          $PokemonBag.pbDeleteItem(itemKey, current - value)
        elsif value > current
          $PokemonBag.pbStoreItem(itemKey, value - current)
        end
      end
    end

    def getPrice(item,selling=false)
      return @inventory[item][:price].fetch(:amount, 1)
    end

    def getItemIcon(item)
      return "Graphics/Icons/itemBack" if !item
      iconitem = nil
      case item[0]
        when :puppet  then return "#{__dir__[Dir.pwd.length+1..]}/ShopIcons/puppetcoin"
        when :coins   then iconitem = :COINCASE
        when :move
          type = $cache.moves[item[1]].type
          return sprintf("#{__dir__[Dir.pwd.length+1..]}/ShopIcons/%s",type.downcase)
        when :item    then iconitem = item[1]
        when :pokemon 
          pkmn = PokeBattle_Pokemon.new(item[1],item[2],$Trainer,false,item[4])
          pkmn.makeNotShiny
          pkmn.makeMale
          return pkmn
      end
      return pbItemIconFile(iconitem)
    end

    def getItemIconRect(item)
      return Rect.new(0,0,48,48)
    end

    def getDisplayName(item)
      return _INTL(@inventory[item][:display_name]) if @inventory[item][:display_name]
      return _INTL(@inventory[item][:name]) if @inventory[item][:name]

      case item[0]
        when :puppet then return _INTL("{1} Puppet Coins", item[1])
        when :coins  then return _INTL("{1} Coins", item[1])
        when :move   then return getMoveName(item[1])
        when :item
          itemname=getItemName(item[1])
          if pbIsTM?(item[1])
            machine=$cache.items[item[1]].checkFlag?(:tm)
            itemname=_INTL("{1} {2}",itemname,getMoveName(machine))
          end

          itemname = _INTL("{1}x {2}", item[2], itemname) if item[2] > 1
          return itemname
        when :pokemon then return getMonName(item[1])
      end
      return ""
    end

    # Added for complex
    def getTrueQuantity(item, quantity=1)
      case item[0]
        when :puppet  then return quantity * item[1]
        when :coins   then return quantity * item[1]
        when :move    then return quantity
        when :item    then return quantity * item[2]
        when :pokemon then return quantity
      end
      return quantity
    end

    # Added for complex
    def getMaxQuantity(item)
      case item[0]
        when :puppet  then return 999999999
        when :coins   then return MAXCOINS
        when :move    then return 1
        when :item    then return BAGMAXPERSLOT
        when :pokemon then return 1
      end
      return 1
    end

    def getName(item)
      return _INTL(@inventory[item][:name]) if @inventory[item][:name]

      case item[0]
        when :puppet  then return _INTL("Puppet Coins")
        when :coins   then return _INTL("Coins")
        when :move    then return getMoveName(item[1])
        when :item    then return getItemName(item[1])
        when :pokemon then return getMonName(item[1])
      end
      return ""
    end

    # Added for complex
    def formatPrice(price, item, fancy = false)
      priceinfo = @inventory[item][:price]
      case priceinfo[:type]
        when :Money       then formatter = fancyformatter = fancyplural = "$ {1}"
        when :RedEssence  then formatter,  fancyformatter,  fancyplural = "{1} RE", "{1} Red Essence", "{1} Red Essence"
        when :Coins       then formatter,  fancyformatter,  fancyplural = "{1} C", "{1} Coin", "{1} Coins"
        when :PuppetCoins then formatter,  fancyformatter,  fancyplural = "{1} PC", "{1} Puppet Coin", "{1} Puppet Coins"
        when :AP          then formatter = fancyformatter = fancyplural = "{1} AP"
        when :Item
          formatter = fancyformatter = "{1} #{getItemName(priceinfo[:item])}"
          fancyplural = fancyformatter + "s"
          formatter = DEFAULT_SHORTNAMES[priceinfo[:item]] if DEFAULT_SHORTNAMES[priceinfo[:item]]
          if price > 1
            formatter += "s"
          end

          formatter = priceinfo[:shortname] if priceinfo[:shortname]
        else
          formatter = fancyformatter = fancyplural = "{1}"
      end
      return _INTL(price == 1 ? fancyformatter : fancyplural, pbCommaNumber(price)) if fancy
      return _INTL(formatter,price)
    end

    def getDisplayPrice(item,selling=false)
      return formatPrice(getPrice(item), item)
    end

    def getDescription(item)
      return "Quit shopping." if !item
      case item[0]
        when :puppet  then return _INTL("Coins obtained from the Puppet Master. Can be exchanged for a question.")
        when :coins   then return _INTL("Coins obtained at the Game Corner. Can be exchanged for prizes.")
        when :move    then return getMoveDesc(item[1])
        when :item    then return $cache.items[item[1]].desc
        when :pokemon 
          if item[3]
            if item[3].is_a?(Array)
              movenames = item[3][0...4].map(&method(:getMoveName))
              if movenames.size > 2
                movename = movenames[0...(movenames.size - 1)].join(", ") + ", and " + movenames[-1]
              elsif movenames.size > 1
                movename = movenames.join(" and ")
              elsif !movenames.empty?
                movename = movenames[0]
              else
                return _INTL("Obtain the {1} Pokémon.", $cache.pkmn[item[1]].kind)
              end
            else
              movename = getMoveName(item[3])
            end
            return _INTL("Obtain the {1} Pokémon. Comes knowing {2}.", $cache.pkmn[item[1]].kind, movename)
          else
            return _INTL("Obtain the {1} Pokémon.", $cache.pkmn[item[1]].kind)
          end

      end
      return ""
    end

    def addItem(item)
      case item[0]
        when :puppet
          return false if getMaxQuantity(item) <= $game_variables[:PuppetCoins]
          $game_variables[:PuppetCoins] += 1
          return true
        when :coins
          return false if getMaxQuantity(item) <= $PokemonGlobal.coins
          $PokemonGlobal.coins += 1
          return true
        #when :move # Handled specially.
        when :item    then return $PokemonBag.pbStoreItem(item[1])
        when :pokemon
          pkmn = PokeBattle_Pokemon.new(item[1],item[2],$Trainer,true,item[4])
          if item[3]
            if item[3].is_a?(Array)
              item[3].each(&pkmn.method(:pbLearnMove))
            else
              pkmn.pbLearnMove(item[3])
            end
          end
          Kernel.pbAddPokemon(pkmn)
      end
    end

    def getQuantity(item)
      case item[0]
        when :puppet  then return $game_variables[:PuppetCoins]
        when :coins   then return $PokemonGlobal.coins
        when :move    then return 0
        when :item    then return $PokemonBag.pbQuantity(item[1])
        when :pokemon then return 0
      end
      return 0
    end

    def removeItem(item)
      case item[0]
        when :puppet then $game_variables[:PuppetCoins] -= 1
        when :coins  then $PokemonGlobal.coins -= 1
        #when :move # This never occurs.
        when :item   then return $PokemonBag.pbDeleteItem(item[1])
        #when :pokemon # This never occurs.
      end
      return true
    end

    def showQuantity?(item)
      case item[0]
        when :puppet  then return true
        when :coins   then return true
        when :move    then return false
        when :item    then return !pbIsImportantItem?(item[1]) && !@inventory[item][:switch]
        when :pokemon then return false
      end
      return false
    end
  end

  class ComplexPokemonMartScreen
    def initialize(scene,adapter,messages={})
      @scene=scene
      @adapter=adapter
      @stock=@adapter.getStock
      @messages = DEFAULT_MESSAGES_MART.merge(messages)
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
      bought = false
      loop do
        item=@scene.pbChooseBuyItem
        quantity=0
        break if item.nil?
        itemname=@adapter.getDisplayName(item)
        price=@adapter.getPrice(item)
        if @adapter.getMoney(item)<price
          case @adapter.getPriceType(item)
          when :Money       then pbDisplayPaused(_INTL(@messages[:no_money])) unless @messages[:no_money].empty?
          when :RedEssence  then pbDisplayPaused(_INTL(@messages[:no_re])) unless @messages[:no_re].empty?
          when :Coins       then pbDisplayPaused(_INTL(@messages[:no_coins])) unless @messages[:no_coins].empty?
          when :PuppetCoins then pbDisplayPaused(_INTL(@messages[:no_coins])) unless @messages[:no_puppet].empty?
          when :AP          then pbDisplayPaused(_INTL(@messages[:no_ap])) unless @messages[:no_ap].empty?
          when :Item        then pbDisplayPaused(_INTL(@messages[:no_items], @adapter.getPriceItemName(item))) unless @messages[:no_items].empty?
          end
          next
        end
        if !@adapter.showQuantity?(item)
          if !pbConfirm(@adapter.getPurchaseMessage(@messages,item,price))
            next
          end
          quantity=1
          trueQuantity = @adapter.getTrueQuantity(item,quantity)
        else
          maxquantity = @adapter.getMaxQuantity(item) - @adapter.getQuantity(item)
          maxquantity /= @adapter.getTrueQuantity(item)
          maxafford=(price<=0) ? maxquantity : @adapter.getMoney(item)/price
          maxafford=maxquantity if maxafford>maxquantity
          if maxafford == 0
            case item[0]
              when :puppet  then pbDisplayPaused(_INTL(@messages[:full_puppet])) unless @messages[:full_puppet].empty?
              when :coins   then pbDisplayPaused(_INTL(@messages[:full_coins])) unless @messages[:full_coins].empty?
              when :item    then pbDisplayPaused(_INTL(@messages[:full_item])) unless @messages[:full_item].empty?
            end
            next
          end
          quantity=@scene.pbChooseNumber(@adapter.getQuantitySelectMessage(@messages,item),item,maxafford)
          if quantity==0
            next
          end
          trueQuantity = @adapter.getTrueQuantity(item,quantity)
          price*=quantity
          if !pbConfirm(@adapter.getPurchaseMessage(@messages,item,price,trueQuantity))
            next
          end
        end
        if @adapter.getMoney(item)<price
          case @adapter.getPriceType(item)
          when :Money       then pbDisplayPaused(_INTL(@messages[:no_money])) unless @messages[:no_money].empty?
          when :RedEssence  then pbDisplayPaused(_INTL(@messages[:no_re])) unless @messages[:no_re].empty?
          when :Coins       then pbDisplayPaused(_INTL(@messages[:no_coins])) unless @messages[:no_coins].empty?
          when :PuppetCoins then pbDisplayPaused(_INTL(@messages[:no_coins])) unless @messages[:no_puppet].empty?
          when :AP          then pbDisplayPaused(_INTL(@messages[:no_ap])) unless @messages[:no_ap].empty?
          when :Item        then pbDisplayPaused(_INTL(@messages[:no_items], @adapter.getPriceItemName(item))) unless @messages[:no_items].empty?
          end
          next
        end

        success = false

        if item[0] != :move
          added=0
          trueQuantity.times do
            if !@adapter.addItem(item)
              break
            end
            added+=1
          end
          if added!=trueQuantity
            added.times do
              if !@adapter.removeItem(item)
                raise _INTL("Failed to delete stored items")
              end
            end
            case item[0]
              when :puppet  then pbDisplayPaused(_INTL(@messages[:full_puppet])) unless @messages[:full_puppet].empty?
              when :coins   then pbDisplayPaused(_INTL(@messages[:full_coins])) unless @messages[:full_coins].empty?
              when :item    then pbDisplayPaused(_INTL(@messages[:full_item])) unless @messages[:full_item].empty?
            end
          else
            success = true
          end
        else
          success = pbMoveTutorChoose(item[1])
        end

        if success
          bought = true
          @adapter.setMoney(@adapter.getMoney(item)-price, item)
          successMessage = @adapter.getSuccessMessage(@messages, item)
          pbDisplayPaused(successMessage) unless successMessage.empty?
          if item[0] == :item
            if Rejuv && $Trainer.achievements
              $Trainer.achievements.progress(:itemsBought, trueQuantity)
            end
            if $PokemonBag && trueQuantity>=10 && pbIsPokeBall?(item[1])
              if trueQuantity < 20 && @adapter.addItem(:PREMIERBALL) 
                pbDisplayPaused(_INTL(@messages[:premier_one])) unless @messages[:premier_one].empty?
              elsif trueQuantity >=20 && $PokemonBag.pbStoreItem(:PREMIERBALL,(trueQuantity/10).floor)
                numballs = (trueQuantity/10).floor # I could put this in the next line but it would probably slow something down
                pbDisplayPaused(_INTL(@messages[:premier_many], numballs)) unless @messages[:premier_many].empty?
              end
            end
          end

          for i in 0...@stock.length
            stockItem = @stock[i]
            if @adapter.removeAfterPurchase(stockItem, item)
              @stock[i]=nil
            end
          end
          @stock.compact!
        end
      end
      @scene.pbEndBuyScene
      return bought
    end
  end

  class ComplexPokemonMartScene < PokemonMartScene
    def initialize(hasPicture, clampBottom)
      @hasPicture = hasPicture
      @clampBottom = clampBottom
    end

    def pbDisplayPaused(msg)
      while msg[/(?:\\[Ss][Ee]\[([^\]]*)\])/i]
        msg = $~.pre_match + $~.post_match
        pbSEPlay(pbStringToAudioFile($1))
      end

      # pbSetSystemFont(@sprites["helpwindow"].contents)
      super(msg)
    end

    def pbConfirm(msg)
      while msg[/(?:\\[Ss][Ee]\[([^\]]*)\])/i]
        msg = $~.pre_match + $~.post_match
        pbSEPlay(pbStringToAudioFile($1))
      end

      # pbSetSystemFont(@sprites["helpwindow"].contents)
      super(msg)
    end

    def pbDisplay(msg,brief=false)
      while msg[/(?:\\[Ss][Ee]\[([^\]]*)\])/i]
        msg = $~.pre_match + $~.post_match
        pbSEPlay(pbStringToAudioFile($1))
      end

      # pbSetSystemFont(@sprites["helpwindow"].contents)
      super(msg,brief)
    end

    def pbStartBuyOrSellScene(buying,stock,adapter)
      # Scroll right before showing screen
      ### MODDED/
      pbScrollMap(6,5,5) unless @hasPicture
      ### /MODDED
      @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z=99999
      @stock=stock
      @adapter=adapter
      @sprites={}
      @sprites["background"]=IconSprite.new(0,0,@viewport)
      @sprites["background"].setBitmap("Graphics/Pictures/martScreen")

      @sprites["pkmnicon"]=PokemonIconSprite.new(nil,@viewport)
      @sprites["pkmnicon"].x = 2
      @sprites["pkmnicon"].y = Graphics.height-86
      @sprites["pkmnicon"].visible = true

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
      ### MODDED/
      @sprites["moneywindow"].y=@clampBottom ? Graphics.height-96-96-8 : 0
      ### /MODDED
      @sprites["moneywindow"].width=190
      @sprites["moneywindow"].height=96
      @sprites["moneywindow"].baseColor=Color.new(88,88,80)
      @sprites["moneywindow"].shadowColor=Color.new(168,184,184)
      pbDeactivateWindows(@sprites)
      @buying=buying
      pbRefresh
      Graphics.frame_reset
    end

    def pbEndBuyScene
      pbDisposeSpriteHash(@sprites)
      @viewport.dispose
      # Scroll left after showing screen
      ### MODDED/
      pbScrollMap(4,5,5) unless @hasPicture
      ### /MODDED
    end

    def pbRefresh
      if !@subscene
        itemwindow=@sprites["itemwindow"]
        filename=@adapter.getItemIcon(itemwindow.item)
        ### MODDED/
        if filename.is_a?(PokeBattle_Pokemon)
          @sprites["pkmnicon"].pokemon = filename
          @sprites["icon"].clearBitmaps
        elsif filename.is_a?(String)
          @sprites["pkmnicon"].pokemon = nil
          @sprites["icon"].setBitmap(filename)
          @sprites["icon"].src_rect=@adapter.getItemIconRect(itemwindow.item)   
        end
        ### /MODDED
        @sprites["itemtextwindow"].text=(itemwindow.item.nil?) ? _INTL("Quit shopping.") :
           @adapter.getDescription(itemwindow.item)
        itemwindow.refresh
      end

      ### MODDED/
      if @sprites["moneywindow"].visible
        moneywindow = []

        priceTypes = @adapter.priceTypes.clone
        
        if priceTypes.include?(:Money)
          moneywindow.push(_INTL("Money:\n<r>${1}", $Trainer.money))
          priceTypes.delete(:Money)
        end

        if priceTypes.include?(:RedEssence)
          moneywindow.push(_INTL("Red Essence:\n<r><c3=C93828,d1c0be>{1}</c3>",$game_variables[:RedEssence]))
          priceTypes.delete(:RedEssence)
        end

        if priceTypes.include?(:Coins)
          moneywindow.push(_INTL("Coins:\n<r>{1}",$PokemonGlobal.coins))
          priceTypes.delete(:Coins)
        end

        if priceTypes.include?(:PuppetCoins)
          moneywindow.push(_INTL("Puppet Coins:\n<r><c3=8B28C9,c9bed1>{1}</c3>",$game_variables[:PuppetCoins]))
          priceTypes.delete(:PuppetCoins)
        end

        if priceTypes.include?(:AP)
          moneywindow.push(_INTL("AP:\n<r>{1}",$game_variables[:APPoints]))
          priceTypes.delete(:AP)
        end

        if priceTypes.include?(:Shards)
          redQuantity = $PokemonBag.pbQuantity(:REDSHARD) # f09088
          blueQuantity = $PokemonBag.pbQuantity(:BLUESHARD) # a8b0f8
          greenQuantity = $PokemonBag.pbQuantity(:GREENSHARD) # 90f088
          yellowQuantity = $PokemonBag.pbQuantity(:YELLOWSHARD) # f8e058
          moneywindow.push(_INTL("Shards:\n<r><c3=BA3654,e8b6b1>{1}</c3>  <c3=6849CD,bdc1ea>{2}</c3>  <c3=11942E,a3dc9e>{3}</c3>  <c3=7D6500,d6c87a>{4}</c3>",
            redQuantity, blueQuantity, greenQuantity, yellowQuantity))
          priceTypes.delete(:Shards)
        end

        for type in priceTypes
          moneywindow.push(_INTL("{1}s:\n<r>{2}", getItemName(type), $PokemonBag.pbQuantity(type)))
        end

        @sprites["moneywindow"].height=32 + 64 * moneywindow.size
        @sprites["moneywindow"].y=Graphics.height-96-@sprites["moneywindow"].height-8 if @clampBottom
        @sprites["moneywindow"].text=moneywindow.join("\n")
        @sprites["moneywindow"].visible = false if moneywindow.empty?
      end
      ### /MODDED
    end

    def pbChooseBuyItem
      itemwindow=@sprites["itemwindow"]
      @sprites["helpwindow"].visible=false
      pbActivateWindow(@sprites,"itemwindow"){
        pbRefresh
        ### CRAWLI PACK/
        if defined?(tts)
          tts(toUnformattedText(@sprites["moneywindow"].text))
          if !itemwindow.item.nil?
            tts(@adapter.getDisplayName(itemwindow.item))
            tts(@adapter.formatPrice(@adapter.getPrice(itemwindow.item), itemwindow.item, true))
            tts(@adapter.getDescription(itemwindow.item))
          else
            tts("CANCEL")
            tts("Quit shopping.")
          end
        end
        ### /CRAWLI PACK
        loop do
          Graphics.update
          Input.update
          olditem=itemwindow.item
          self.update
          if itemwindow.item!=olditem
            filename=@adapter.getItemIcon(itemwindow.item)
            ### MODDED/
            if filename.is_a?(PokeBattle_Pokemon)
              @sprites["pkmnicon"].pokemon = filename
              @sprites["icon"].clearBitmaps
            elsif filename.is_a?(String)
              @sprites["pkmnicon"].pokemon = nil
              @sprites["icon"].setBitmap(filename)
              @sprites["icon"].src_rect=@adapter.getItemIconRect(itemwindow.item)   
            end
            ### /MODDED
            @sprites["itemtextwindow"].text=(itemwindow.item.nil?) ? _INTL("Quit shopping.") :
              @adapter.getDescription(itemwindow.item)
            ### CRAWLI PACK/
            if defined?(tts)
              if !itemwindow.item.nil?
                tts(@adapter.getDisplayName(itemwindow.item))
                tts(@adapter.formatPrice(@adapter.getPrice(itemwindow.item), itemwindow.item, true))
                tts(@adapter.getDescription(itemwindow.item))
              else
                tts("CANCEL")
                tts("Quit shopping.")
              end
            end
            ### /CRAWLI PACK
          end
          if Input.trigger?(Input::B)
            return nil
          end
          if Input.trigger?(Input::C)
            if itemwindow.index<@stock.length
              pbRefresh
              return @stock[itemwindow.index]
            else
              return nil
            end
          end
        end
      }
    end

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

            ### MODDED/
            if item[0] == :item
              inbagwindow.visible=@buying
              inbagwindow.viewport=@viewport
              inbagwindow.width=190
              inbagwindow.height=64
              inbagwindow.baseColor=Color.new(88,88,80)
              inbagwindow.shadowColor=Color.new(168,184,184)

              inbagwindow.text= _INTL("In Bag:<r>{1}  ",qty)
              tts("In Bag: " + qty.to_s) if defined?(tts) ### CRAWLI PACK
            else
              inbagwindow.visible=false
            end
            numwindow.text=_INTL("x{1}<r>{2}",@adapter.getTrueQuantity(item,curnumber), @adapter.formatPrice(curnumber*itemprice, item, false))
            ### /MODDED
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
                ### MODDED/
                numwindow.text=_INTL("x{1}<r>{2}",@adapter.getTrueQuantity(item,curnumber),@adapter.formatPrice(curnumber*itemprice, item, false))
                tts(@adapter.formatPrice(curnumber * itemprice, item, true)) if defined?(tts) ### CRAWLI PACK
                ### /MODDED
              elsif Input.repeat?(Input::RIGHT)
                pbPlayCursorSE()
                curnumber+=10
                curnumber=maximum if curnumber>maximum
                ### MODDED/
                numwindow.text=_INTL("x{1}<r>{2}",@adapter.getTrueQuantity(item,curnumber),@adapter.formatPrice(curnumber*itemprice, item, false))
                tts(@adapter.formatPrice(curnumber * itemprice, item, true)) if defined?(tts) ### CRAWLI PACK
                ### /MODDED
              elsif Input.repeat?(Input::UP)
                pbPlayCursorSE()
                curnumber+=1
                curnumber=1 if curnumber>maximum
                ### MODDED/
                numwindow.text=_INTL("x{1}<r>{2}",@adapter.getTrueQuantity(item,curnumber),@adapter.formatPrice(curnumber*itemprice, item, false))
                tts(@adapter.formatPrice(curnumber * itemprice, item, true)) if defined?(tts) ### CRAWLI PACK
                ### /MODDED
              elsif Input.repeat?(Input::DOWN)
                pbPlayCursorSE()
                curnumber-=1
                curnumber=maximum if curnumber<1
                ### MODDED/
                numwindow.text=_INTL("x{1}<r>{2}",@adapter.getTrueQuantity(item,curnumber),@adapter.formatPrice(curnumber*itemprice, item, false))
                tts(@adapter.formatPrice(curnumber * itemprice, item, true)) if defined?(tts) ### CRAWLI PACK
                ### /MODDED
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
  end

  def self.pbMultiComplexMart(inventories, names, hasPicture=false, clampBottom=false, messages={})
    interactMessages = DEFAULT_MESSAGES_INTERACT.merge(messages)
    commands=[*names, _INTL("Quit")]
    cmd=Kernel.pbMessage(_INTL(interactMessages[:speech]), commands,-1)
    bought = false
    loop do
      if cmd >= 0 && cmd < names.length
        adapter = ComplexPokemonMartAdapter.new(inventories[cmd])
        scene=ComplexPokemonMartScene.new(hasPicture, clampBottom)
        screen=ComplexPokemonMartScreen.new(scene,adapter,messages)
        bought = true if screen.pbBuyScreen
      else
        Kernel.pbMessage(_INTL(interactMessages[:come_again])) unless interactMessages[:come_again].empty?
        break
      end
      cmd=Kernel.pbMessage( _INTL(interactMessages[:anything_else]),commands,-1)
    end
    return bought
  end

  def self.pbComplexMart(inventory,hasPicture=false,clampBottom=false,messages={})
    return self.pbMultiComplexMart([inventory], [_INTL("Buy")], hasPicture, clampBottom, messages)
  end

  def self.vendorComplexMart(vendorInfo, hasPicture=false,clampBottom=false)
    return self.pbComplexMart(vendorInfo[:inventory], hasPicture, clampBottom, vendorInfo.fetch(:messages, {}))
  end
end

=begin
 Full format:
  type specifier - one of:
    puppet: amount
    coins: amount
    move: :MOVEID
    item: :ITEMID
    pokemon: :SPECIESID

  if type is item, to have it purchased in bulk:
    quantity: bulkQuantity

  if type is pokemon, to have it start with one or more extra moves:
    move: [:MOVEID...] | :MOVEID
  if type is pokemon, to have it have a different form:
    form: formnum
  if type is pokemon: to have it start at a level
    level: levelnum

  price specifier - one of:
    price: { type: :Money | :RedEssence | :Coins | :AP, amount: amount }
    price: { type: :Item, item: :ITEMID, [amount: amount], [shortname: "name"] }

  condition specifier - one of or array of:
    { switch: :SwitchAlias | switchid, is: targetState }
    { var: :VariableAlias | variableid, is: predicate }
    { var: :VariableAlias | variableid, is: :== | :>= | :> | :<= | :<, than: comparingValue }
    { map: mapid, event: eventid, selfswitch: chr, is: targetState }
    predicate
  as
    condition: [conditions...] | condition

  to have a different message - any of
    name: "Name"
    display_name: "Fancy Name"
    purchase_message: "{1} at price {2}"
    purchase_message: "{1} x {2} at price {3}"
    quantity_message: "select quantity of {1}"
    success_message: "nice"

  to have the item only be purchasable once, tied to a switch or variable or selfswitch - one of:
    switch: :SwitchAlias | switchid
    var: [:VariableAlias | variableid, threshold]
    selfswitch: [map, event, chr]
=end
