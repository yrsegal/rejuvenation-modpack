begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

$vendorquantitydisplay_activewindows = []

module VendorQuantityDisplay
  def self.quantityWindow(item, viewport=nil, z=99999)
    textProc = proc {
      itemName = getItemName(item) + 's'
      itemQuantity = $PokemonBag.pbQuantity(item)
      quantityString = pbCommaNumber(itemQuantity)
      next _INTL("{1}:\n<ar>{2}</ar>", itemName, quantityString)
    }
    return createCornerWindow(textProc, viewport, z)
  end
  def self.quantityWindowVariable(descriptor, variable, viewport=nil, z=99999)
    textProc = proc {
      itemQuantity = $game_variables[variable]
      quantityString = pbCommaNumber(itemQuantity)
      next _INTL("{1}\n<ar>{2}</ar>", descriptor, quantityString)
    }
    return createCornerWindow(textProc, viewport, z)
  end

  def self.quantityWindowTwoVariable(descriptor1, variable1, descriptor2, variable2, viewport=nil, z=99999)
    textProc = proc {
      itemQuantity1 = $game_variables[variable1]
      quantityString1 = pbCommaNumber(itemQuantity1)
      itemQuantity2 = $game_variables[variable2]
      quantityString2 = pbCommaNumber(itemQuantity2)
      next _INTL("{1}\n<ar>{2}</ar>\n{3}\n<ar>{4}</ar>", descriptor1, quantityString1, descriptor2, quantityString2)
    }
    return createCornerWindow(textProc, viewport, z)
  end

  def self.quantityWindowVariableWithOptional(descriptor, variable, optDescriptor, optVariable, viewport=nil, z=99999)
    return quantityWindowVariable(descriptor, variable, viewport, z) if $game_variables[optVariable] <= 0
    return quantityWindowTwoVariable(descriptor, variable, optDescriptor, optVariable, viewport, z)
  end

  def self.shardQuantityWindow(viewport=nil, z=99999)
    textProc = proc {
      redQuantity = $PokemonBag.pbQuantity(:REDSHARD)
      blueQuantity = $PokemonBag.pbQuantity(:BLUESHARD)
      greenQuantity = $PokemonBag.pbQuantity(:GREENSHARD)
      yellowQuantity = $PokemonBag.pbQuantity(:YELLOWSHARD)
      next _INTL("Shards:             \n<ar>{5}{1}</c3>  {6}{2}</c3>  {7}{3}</c3>  {8}{4}</ar>",
        redQuantity, blueQuantity, greenQuantity, yellowQuantity,
        getSkinColor(nil, 2, true), getSkinColor(nil, 1, true), getSkinColor(nil, 3, true), getSkinColor(nil, 6, true))
    }
    return createCornerWindow(textProc, viewport, z)
  end

  def self.createCornerWindow(textProc, viewport=nil, z=99999, windowAbove: nil)
    window=Window_AdvancedTextPokemon.new(textProc.call())
    window.resizeToFit(window.text,Graphics.width)
    window.width=160 if window.width<=160
    window.y=(windowAbove) ? windowAbove.y + windowAbove.height : 0
    window.viewport=viewport
    window.visible=true
    window.z = z
    $vendorquantitydisplay_activewindows.push([window, textProc])
    return window
  end

  def self.inject(eventlike, script)
    eventlike.patch(:VendorQuantityDisplay) { |page|
      textMatches = page.lookForAll([:ShowText, /\\ch\[/]) + 
                    page.lookForAll([:ShowTextContinued, /\\ch\[/])

      choiceMatches = page.lookForAll([:ShowChoices, nil, nil])

      for insn in textMatches
        targetIdx = page.idxOf(insn)
        while targetIdx > 0 && page[targetIdx].command == :ShowTextContinued
          targetIdx -= 1
        end
        page.insertBefore(targetIdx, [:Script, script])
      end

      anyChoice = false

      for insn in choiceMatches
        choiceIdx = page.idxOf(insn)
        insertIdx = choiceIdx - 1
        while insertIdx > 0 && page[insertIdx].command == :ShowTextContinued
          insertIdx -= 1
        end
        if insertIdx >= 0 && page[insertIdx].command == :ShowText
          page.insertBefore(insertIdx, [:Script, script])
          anyChoice = true
        end
      end

      next textMatches.length > 0 || anyChoice
    }
    injectCleanup(eventlike)
  end

  def self.injectForEvent(events, key, script)
    if key.is_a?(Array)
      inject(events[key[0]].pages[key[1] - 1], script)
    else
      inject(events[key], script)
    end
  end

  def self.injectAtStart(event, script)
    event.patch(:VendorQuantityDisplay) { |page|
      page.insertAtStart([:Script, script])
      next true
    }
    injectCleanup(event)
  end

  def self.injectCairo(event)
    event.patch(:VendorQuantityDisplay) { |page|
      showMoney = page.lookForAll([:ShowText, /^CAIRO: Very well\./])

      showRE = page.lookForAll([:ShowText, /^CAIRO: I see that you have Red Essence\./]) +
               page.lookForAll([:ShowText, /^CAIRO: Darkness need not hide from me\./])

      for insn in showMoney
        insn.parameters[0] = "\\G" + insn.parameters[0]
      end

      for insn in showRE
        page.insertBefore(insn, InjectionHelper.parseEventCommand(insn.indent, :Script, 'vendorquantity_show_redessence_window'))
      end

      next showRE.length > 0 || showMoney.length > 0
    }
    injectCleanup(event)
  end

  def self.injectEnsureChoices(event)
    event.patch(:VendorQuantityDisplay_AddText) { |page|
      choices = page.lookForAll([:ShowChoices, ["Yes", "No"], 2])

      doneAny = false

      for insn in choices
        targetIdx = page.idxOf(insn)

        textStart = -1
        textEnd = -1
        while targetIdx > 0
          targetIdx -= 1
          break if page[targetIdx].indent != insn.indent
          if textEnd == -1 && page[targetIdx].command == :ShowTextContinued
            textEnd = targetIdx
          elsif page[targetIdx].command == :ShowText
            textEnd = targetIdx if textEnd == -1
            textStart = targetIdx
            break
          end
        end

        if textStart != -1
          dialogue = page[textStart..textEnd]
          page[textStart..textEnd] = []

          targetIdx = page.index(insn)
          page.insert(targetIdx, *dialogue)
          doneAny = true
        end
      end

      next doneAny
    }
  end

  def self.injectNerta(event)
    event.patch(:VendorQuantityDisplay_AddText) { |page|
      spiffen = page.lookForAll([:ShowText, "Let's spiffen them up, shall we?"])
      choices = page.lookForAll([:ShowChoices, ["Yes", "No"], 2])

      for insn in spiffen
        page.delete(insn)
      end

      for insn in choices
        page.insertBefore(insn, [:ShowText, "Let's spiffen them up, shall we?"])
      end

      next choices.size > 0 || spiffen.size > 0
    }
  end


  def self.injectBeldumRaidDen(event)
    event.patch(:VendorQuantityDisplay) { |page|
      showRE = page.lookForAll([:ShowText, /^Throw in some Red Essence\?/])

      for insn in showRE
        page.insertBefore(insn,[:Script, 'vendorquantity_show_redessence_window'])
      end

      next showRE.length > 0
    }
    injectCleanup(event)
  end

  def self.injectCleanup(eventlike)
    eventlike.patch(:VendorQuantityCleanup) { |page|
      ends = page.lookForAll(:ExitEventProcessing) + [page[-1]]

      for insn in ends
        page.insertBefore(insn, [:Script, 'vendorquantity_disposefully'])
      end

      next true
    }
  end

  HEARTSCALES = {
    28 => [25], # Festival Plaza
    329 => [90], # Kristiline Town
    388 => [34], # Underground Interiors
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

  ENSURECHOICES = {
    388 => [35, 36, 37, 38, 39]
  }
end

$vendorquantity_window.dispose if defined?($vendorquantity_window) && $vendorquantity_window
$vendorquantity_window = nil

class Interpreter
  def vendorquantity_show_item_window(item)
    $vendorquantity_window.dispose if $vendorquantity_window
    $vendorquantity_window = VendorQuantityDisplay.quantityWindow(item)
  end

  def vendorquantity_show_shard_window
    $vendorquantity_window.dispose if $vendorquantity_window
    $vendorquantity_window = VendorQuantityDisplay.shardQuantityWindow
  end

  def vendorquantity_show_redessence_window
    $vendorquantity_window.dispose if $vendorquantity_window
    $vendorquantity_window = VendorQuantityDisplay.quantityWindowVariable(
      getSkinColor(nil, 2, true) + _INTL("Red Essence:") + '</c3>', :RedEssence)
  end

  def vendorquantity_show_zcell_window
    $vendorquantity_window.dispose if $vendorquantity_window
    $vendorquantity_window = VendorQuantityDisplay.quantityWindowVariableWithOptional(
      getSkinColor(nil, 3, true) + _INTL("Zygarde Cells:") + '</c3>', :Z_Cells,
      getSkinColor(nil, 3, true) + _INTL("Zygarde Cores:") + '</c3>', :Z_Cores)
  end

  def vendorquantity_disposefully
    $vendorquantity_window.dispose if $vendorquantity_window
    $vendorquantity_window = nil
  end
end

Kernel.instance_eval do
  alias :vendorquantity_old_pbMessageDisplay :pbMessageDisplay

  def pbMessageDisplay(*args, **kwargs, &block)
    windows = $vendorquantitydisplay_activewindows.clone
    for window, textProc in windows
      if window.disposed?
        $vendorquantitydisplay_activewindows.delete([window, textProc])
        next
      end

      window.text = textProc.call()
      window.resizeToFit(window.text,Graphics.width)
      window.width=160 if window.width<=160
    end

    return vendorquantity_old_pbMessageDisplay(*args, **kwargs, &block)
  end
end

# Patch movetutors

InjectionHelper.defineMapPatch(-1) { |map, mapid| # Apply to all maps
  if VendorQuantityDisplay::ENSURECHOICES[mapid]
    for vendor in VendorQuantityDisplay::ENSURECHOICES[mapid]
      VendorQuantityDisplay.injectEnsureChoices(map.events[vendor])
    end
  end

  if VendorQuantityDisplay::VENDORS[mapid]
    for vendor in VendorQuantityDisplay::VENDORS[mapid]
      if vendor.is_a?(Array)
        VendorQuantityDisplay.injectForEvent(map.events, vendor[0], "vendorquantity_show_item_window(:#{vendor[1]})")
      else
        VendorQuantityDisplay.injectForEvent(map.events, vendor, "vendorquantity_show_shard_window")
      end
    end
  end

  if VendorQuantityDisplay::HEARTSCALES[mapid]
    for vendor in VendorQuantityDisplay::HEARTSCALES[mapid]
      VendorQuantityDisplay.injectAtStart(map.events[vendor], "vendorquantity_show_item_window(:HEARTSCALE)")
    end
  end
}

InjectionHelper.defineMapPatch(168, 16, &VendorQuantityDisplay.method(:injectCairo)) # Route 4, Cairo

InjectionHelper.defineMapPatch(201, 5, &VendorQuantityDisplay.method(:injectBeldumRaidDen)) # Helojak Island, Beldum Den

InjectionHelper.defineMapPatch(117, 9) { |event| # Help Plaza (Gearen), Ayuda
  VendorQuantityDisplay.injectAtStart(event, 'vendorquantity_show_zcell_window')
}

InjectionHelper.defineMapPatch(329, 90, &VendorQuantityDisplay.method(:injectNerta)) # Kristiline Town, Nerta
