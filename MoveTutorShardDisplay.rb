
module TutorQuantityDisplays
  def self.quantityWindow(item, viewport=nil, z=99999)
    itemName = getItemName(item) + 's'
    itemQuantity = $PokemonBag.pbQuantity(item)
    quantityString = pbCommaNumber(itemQuantity)
    return createCornerWindow(_INTL("{1}:\n<ar>{2}</ar>", itemName, quantityString), viewport, z)
  end
  def self.shardQuantityWindow(viewport=nil, z=99999)
    redQuantity = $PokemonBag.pbQuantity(:REDSHARD)
    blueQuantity = $PokemonBag.pbQuantity(:BLUESHARD)
    greenQuantity = $PokemonBag.pbQuantity(:GREENSHARD)
    yellowQuantity = $PokemonBag.pbQuantity(:YELLOWSHARD)
    return createCornerWindow(_INTL("Shards:\n<ar>  {5}{1}</c3>  {6}{2}</c3>  {7}{3}</c3>  {8}{4}</ar>",
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
      insns = page.list
      InjectionHelper.patch(insns, :TutorQuantityDisplays) {
        textMatches = InjectionHelper.lookForAll(insns,
          [:ShowText, /\\ch\[/])

        choiceMatch = InjectionHelper.lookForSequence(insns,
          [:ShowText, nil],
          [:ShowChoices, nil, nil])

        for insn in textMatches
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, script))
        end

        if choiceMatch
          insn = choiceMatch[0]
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, script))
        end


        next textMatches.length > 0 || choiceMatch
      }
    end
  end

  TUTORS = {
      19 => [14, 15, 43], # Neo East Gearen
      28 => [37, 38, 39], # Festival Plaza
      103 => [7, 8, 24], # Akuwa Interiors
      330 => [94], # Hiyoshi City
      434 => [38, 39, 40, 41, 42, 43, 46], # Luck's Tent
      601 => [[2, :BALMMUSHROOM], [25, :BIGMUSHROOM]] # Goomidra Interiors
    }
end

class Interpreter
  if !defined?(tutorquantity_old_command_end)
    alias :tutorquantity_old_command_end :command_end
  end

  def tutorquantity_show_item_window(item)
    @tutorquantity_windows = [] if !@tutorquantity_windows
    @tutorquantity_windows.push(TutorQuantityDisplays.quantityWindow(item))
  end

  def tutorquantity_show_shard_window
    @tutorquantity_windows = [] if !@tutorquantity_windows
    @tutorquantity_windows.push(TutorQuantityDisplays.shardQuantityWindow)
  end

  def command_end
    @tutorquantity_windows.each {|window| window.dispose if !window.disposed? } if @tutorquantity_windows
    tutorquantity_old_command_end
  end
end

# Patch movetutors

class Cache_Game
  if !defined?(tutorquantity_old_map_load)
    alias :tutorquantity_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return tutorquantity_old_map_load(mapid)
    end

    ret = tutorquantity_old_map_load(mapid)

    if TutorQuantityDisplays::TUTORS[mapid]
      for tutor in TutorQuantityDisplays::TUTORS[mapid]
        if tutor.is_a?(Array)
          TutorQuantityDisplays.inject(ret.events[tutor[0]], "tutorquantity_show_item_window(:#{tutor[1]})")
        else
          TutorQuantityDisplays.inject(ret.events[tutor], "tutorquantity_show_shard_window")
        end
      end
    end
    return ret
  end
end