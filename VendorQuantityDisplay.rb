
module VendorQuantityDisplay
  def self.quantityWindow(item, viewport=nil, z=99999)
    itemName = getItemName(item) + 's'
    itemQuantity = $PokemonBag.pbQuantity(item)
    quantityString = pbCommaNumber(itemQuantity)
    return createCornerWindow(_INTL("{1}:\n<ar>{2}</ar>", itemName, quantityString), viewport, z)
  end
  def self.quantityWindowVariable(descriptor, variable, viewport=nil, z=99999)
    itemQuantity = $game_variables[variable]
    quantityString = pbCommaNumber(itemQuantity)
    return createCornerWindow(_INTL("{1}:\n<ar>{2}</ar>", descriptor, quantityString), viewport, z)
  end

  def self.shardQuantityWindow(viewport=nil, z=99999)
    redQuantity = $PokemonBag.pbQuantity(:REDSHARD)
    blueQuantity = $PokemonBag.pbQuantity(:BLUESHARD)
    greenQuantity = $PokemonBag.pbQuantity(:GREENSHARD)
    yellowQuantity = $PokemonBag.pbQuantity(:YELLOWSHARD)
    return createCornerWindow(_INTL("Shards:             \n<ar>{5}{1}</c3>  {6}{2}</c3>  {7}{3}</c3>  {8}{4}</ar>",
      redQuantity, blueQuantity, greenQuantity, yellowQuantity, 
      getSkinColor(nil, 2, true), getSkinColor(nil, 1, true), getSkinColor(nil, 3, true), getSkinColor(nil, 6, true)), viewport, z)
  end

  def self.createCornerWindow(text, viewport=nil, z=99999, windowAbove: nil)
    window=Window_AdvancedTextPokemon.new(text)
    window.resizeToFit(window.text,Graphics.width)
    window.width=160 if window.width<=160
    window.y=(windowAbove) ? windowAbove.y + windowAbove.height : 0
    window.viewport=viewport
    window.visible=true
    window.z = z
    return window
  end

  def self.inject(event, script)
    for page in event.pages
      injectPage(page, script)
    end
  end

  def self.injectPage(page, script)
    insns = page.list
    InjectionHelper.patch(insns, :VendorQuantityDisplay) {
      textMatches = InjectionHelper.lookForAll(insns,
        [:ShowText, /\\ch\[/])

      choiceMatches = InjectionHelper.lookForAll(insns,
        [:ShowChoices, nil, nil])

      for insn in textMatches
        targetIdx = insns.index(insn)
        insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, script))
      end

      for insn in choiceMatches
        choiceIdx = insns.index(insn)
        insertIdx = choiceIdx - 1
        while insertIdx > 0 && insns[insertIdx].code == InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          insertIdx -= 1
        end
        if insertIdx > 0 && insns[insertIdx].code == InjectionHelper::EVENT_INSNS[:ShowText]
          insns.insert(insertIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, script))
        end
      end

      next textMatches.length > 0 || choiceMatches.length > 0
    }
  end

  def self.injectForEvent(events, key, script)
    if key.is_a?(Array)
      injectPage(events[key[0]].pages[key[1]], script)
    else
      inject(events[key], script)
    end
  end

  def self.injectAtStart(event, script)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :VendorQuantityDisplay) {
        insns.unshift(InjectionHelper.parseEventCommand(0, :Script, script))
        next true
      }
    end
  end

  def self.injectCairo(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :VendorQuantityDisplay) {
        showMoney = InjectionHelper.lookForAll(insns,
          [:ShowText, /^CAIRO: Very well\./])

        showRE = InjectionHelper.lookForAll(insns,
          [:ShowText, /^CAIRO: I see that you have Red Essence\./])

        for insn in showMoney
          insn.parameters[0] = "\\G" + insn.parameters[0]
        end

        for insn in showRE
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, 'vendorquantity_show_redessence_window'))
        end


        next showRE.length > 0 || showMoney.length > 0 
      }
    end
  end

  def self.injectBeldumRaidDen(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :VendorQuantityDisplay) {
        showRE = InjectionHelper.lookForAll(insns,
          [:ShowText, /^Throw in some Red Essence\?/])

        for insn in showRE
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, 'vendorquantity_show_redessence_window'))
        end

        next showRE.length > 0
      }
    end
  end

  HEARTSCALES = {
    28 => [25], # Festival Plaza
    329 => [90], # Kristiline Town
    388 => [34], # Underground
    425 => [16] # Move Relearner
  }

  VENDORS = {
    19 => [14, 15, 43], # Neo East Gearen
    28 => [27, 37, 38, 39], # Festival Plaza
    103 => [7, 8, 24], # Akuwa Interiors
    176 => [9], # ACDMC Center
    330 => [94], # Hiyoshi City
    388 => [35, 36, 37, 38, 39], # The Underground Interiors
    434 => [38, 39, 40, 41, 42, 43, 46, [36, :BLKPRISM], [28, :BLKPRISM], [[53, 2], :BLKPRISM]], # Luck's Tent
    601 => [[2, :BALMMUSHROOM], [25, :BIGMUSHROOM]] # Goomidra Interiors
  }
end

class Interpreter
  if !defined?(vendorquantity_old_command_end)
    alias :vendorquantity_old_command_end :command_end
  end

  def vendorquantity_show_item_window(item)
    @vendorquantity_window.dispose if @vendorquantity_window
    @vendorquantity_window = VendorQuantityDisplay.quantityWindow(item)
  end

  def vendorquantity_show_shard_window
    @vendorquantity_window.dispose if @vendorquantity_window
    @vendorquantity_window = VendorQuantityDisplay.shardQuantityWindow
  end

  def vendorquantity_show_redessence_window
    @vendorquantity_window.dispose if @vendorquantity_window
    @vendorquantity_window = VendorQuantityDisplay.quantityWindowVariable(_INTL("Red Essence"), :RedEssence)
  end

  def command_end
    @vendorquantity_window.dispose if @vendorquantity_window
    vendorquantity_old_command_end
  end
end

# Patch movetutors

class Cache_Game
  if !defined?(vendorquantity_old_map_load)
    alias :vendorquantity_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return vendorquantity_old_map_load(mapid)
    end

    ret = vendorquantity_old_map_load(mapid)

    if VendorQuantityDisplay::VENDORS[mapid]
      for vendor in VendorQuantityDisplay::VENDORS[mapid]
        if vendor.is_a?(Array)
          VendorQuantityDisplay.injectForEvent(ret.events, vendor[0], "vendorquantity_show_item_window(:#{vendor[1]})")
        else
          VendorQuantityDisplay.injectForEvent(ret.events, vendor, "vendorquantity_show_shard_window")
        end
      end
    end

    if VendorQuantityDisplay::HEARTSCALES[mapid]
      for vendor in VendorQuantityDisplay::HEARTSCALES[mapid]
        VendorQuantityDisplay.injectAtStart(ret.events[vendor], "vendorquantity_show_item_window(:HEARTSCALE)")
      end
    end
    
    if mapid == 168 # Route 4
      VendorQuantityDisplay.injectCairo(ret.events[16])
    elsif mapid == 201 # Helojak Island
      VendorQuantityDisplay.injectBeldumRaidDen(ret.events[5])
    end
    return ret
  end
end