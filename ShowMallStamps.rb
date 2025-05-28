Variables[:Stamps] = 348

class Window_SomniamMallStamps < Window_AdvancedTextPokemon
  LIME = '<c3=63ED71,1c7a24>'
  BLUE = getSkinColor(nil, 1, true)
  RED = getSkinColor(nil, 2, true)
  DARK_BLUE = '<c3=3445DB,080e3f>'

  attr_accessor :title
  attr_accessor :showTitle
  attr_accessor :stampsRequired

  def adjust(moneywindow)
    if moneywindow.nil? || !moneywindow.visible
      self.y = 0
      @showTitle = true
    else
      self.y = moneywindow.y + moneywindow.height
      @showTitle = false
    end
    updateText
    refresh
  end

  def updateText
    setText(showTitle && !title.nil? ? titleText : noTitleText)
    self.resizeToFit(self.text, Graphics.width)
    self.width=160 if self.width<=160
  end

  def titleText
    stamps = $game_variables[:Stamps]
    return _INTL("<ac>{4}{1}</c3></ac>\n{5}Stamps:</c3>\n<ar>{6}{2}</c3></ar>\n{5}Required:</c3>\n<ar>{3}</ar>", 
      _INTL(title), stamps, stampsRequired, DARK_BLUE, BLUE, stamps >= stampsRequired ? LIME : RED)
  end

  def noTitleText
    stamps = $game_variables[:Stamps]
    return _INTL("{3}Stamps:</c3>\n<ar>{4}{1}</c3></ar>\n{3}Required:</c3>\n<ar>{2}</ar>", 
      stamps, stampsRequired, BLUE, stamps >= stampsRequired ? LIME : RED)
  end
end

module ShowSomniamMallStamps

  def self.createStampWindow(title, stampsRequired, viewport=nil, z=99999)
    window=Window_SomniamMallStamps.new("")
    window.title = title
    window.showTitle = true
    window.stampsRequired = stampsRequired
    window.updateText
    window.width=160 if window.width<=160
    window.y=0
    window.viewport=viewport
    window.visible=true
    window.z = z
    return window
  end

  def self.patchShop(event, stampsRequired, title)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :ShowSomniamMallStamps) {
        textMatches = InjectionHelper.lookForAll(insns,
          [:ShowText, nil])

        for insn in textMatches
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_show_window('#{title}',#{stampsRequired})"))
          targetIdx += 1
          targetIdx += 1 while insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:ShowText] || insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_disposefully"))
        end

        martMatches = InjectionHelper.lookForAll(insns,
          [:Script, /^pbPokemonMart/])

        for insn in martMatches
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_show_window('#{title}',#{stampsRequired})"))
          targetIdx += 1
          targetIdx += 1 while insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:Script] || insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:ScriptContinued]
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_disposefully"))
        end

        next textMatches.length > 0
      }
    end
  end

  def self.patchSign(event, stampsRequired)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :ShowSomniamMallStamps) {
        textMatches = InjectionHelper.lookForAll(insns,
          [:ShowText, nil])

        for insn in textMatches
          targetIdx = insns.index(insn)
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_show_window(nil,#{stampsRequired})"))
          targetIdx += 1
          targetIdx += 1 while insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:ShowText] || insns[targetIdx].code == InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          insns.insert(targetIdx, InjectionHelper.parseEventCommand(insn.indent, :Script, "showmallstamps_disposefully"))
        end

        next textMatches.length > 0
      }
    end
  end

  SHOPS = {
    4 =>  [2,  'Evolutionary Stones'],
    5 =>  [2,  'Battle Items'],
    6 =>  [3,  'Vitamins'],
    7 =>  [3,  'Battle Items'],
    8 =>  [4,  'Rare Berries'],
    9 =>  [4,  'Rare Berries'],
    10 => [5,  'Rare Gems'],
    11 => [5,  'Rare Gems'],
    12 => [6,  'Rare Berries'],
    13 => [6,  'Held Items + Extra'],
    14 => [7,  'TMs/HMs'],
    15 => [8,  'Evolutionary Items'],
    16 => [10, 'Candy Store'],
    17 => [9,  'Poke Balls']
  }

  SIGNS = {
    18 => 2,  # Battle Items + Evolutionary Stones
    19 => 4,  # Rare Berries
    20 => 0,  # General Store
    21 => 3,  # Battle Items + Vitamins
    22 => 10, # Candy Store
    54 => 5   # Rare Gems
  }
end

class PokemonMartScene
  if !defined?(showmallstamps_old_pbEndBuyScene)
    alias :showmallstamps_old_pbEndBuyScene :pbEndBuyScene
  end
  if !defined?(showmallstamps_old_pbStartBuyScene)
    alias :showmallstamps_old_pbStartBuyScene :pbStartBuyScene
  end

  def pbEndBuyScene
    $showmallstamps_window.visible = false if $showmallstamps_window
    showmallstamps_old_pbEndBuyScene
    $showmallstamps_window.visible = true if $showmallstamps_window
    $showmallstamps_window.adjust(nil) if $showmallstamps_window
  end

  def pbStartBuyScene(stock,adapter)
    $showmallstamps_window.visible = false if $showmallstamps_window
    showmallstamps_old_pbStartBuyScene(stock,adapter)
    $showmallstamps_window.visible = true if $showmallstamps_window
    $showmallstamps_window.adjust(@sprites["moneywindow"]) if $showmallstamps_window
  end
end

$showmallstamps_window.dispose if defined?($showmallstamps_window) && $showmallstamps_window
$showmallstamps_window = nil

class Interpreter
  def showmallstamps_show_window(title, stampsRequired)
    $showmallstamps_window.dispose if $showmallstamps_window
    $showmallstamps_window = ShowSomniamMallStamps.createStampWindow(title, stampsRequired)
  end

  def showmallstamps_disposefully
    $showmallstamps_window.dispose if $showmallstamps_window
    $showmallstamps_window = nil
  end
end

# Patch

class Cache_Game
  if !defined?(showmallstamps_old_map_load)
    alias :showmallstamps_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return showmallstamps_old_map_load(mapid)
    end

    ret = showmallstamps_old_map_load(mapid)

    if mapid == 231 # Somniam Mall
      ShowSomniamMallStamps::SHOPS.each_pair { |evt,info|
        ShowSomniamMallStamps.patchShop(ret.events[evt], info[0], info[1])
      }
      ShowSomniamMallStamps::SIGNS.each_pair { |evt,info|
        ShowSomniamMallStamps.patchSign(ret.events[evt], info)
      }
    end

    return ret
  end
end