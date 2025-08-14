begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load"
end
Variables[:Stamps] = 348

class Window_SomniamMallStamps < Window_AdvancedTextPokemon
  LIME = '<c3=63ED71,1c7a24>'
  BLUE = getSkinColor(nil, 1, true)
  RED = getSkinColor(nil, 2, true)
  INVERSE_LIME = '<c3=28C930,bed1bf>'
  INVERSE_RED = '<c3=C93828,d1c0be>'

  attr_accessor :title
  attr_accessor :showTitle
  attr_accessor :stampsRequired

  def adjust(moneywindow)
    if moneywindow.nil? || !moneywindow.visible
      self.y = 0
      @showTitle = true
      setSkin(MessageConfig.pbGetSystemFrame())
    else
      self.y = moneywindow.y + moneywindow.height
      @showTitle = false
      setSkin("Graphics/Windowskins/goldskin")
    end
    colors=getDefaultTextColors(self.windowskin)
    self.baseColor=colors[0]
    self.shadowColor=colors[1]

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
    return _INTL("<ac>{4}{1}</c3></ac>\nStamps:\n<ar>{5}{2}</c3></ar>\nRequired:\n<ar>{3}</ar>",
      _INTL(title), stamps, stampsRequired, BLUE, stampTextColor(stamps))
  end

  def noTitleText
    stamps = $game_variables[:Stamps]
    return _INTL("Stamps:\n<ar>{3}{1}</c3></ar>\nRequired:\n<ar>{2}</ar>",
      stamps, stampsRequired, stampTextColor(stamps))
  end

  def stampTextColor(stamps)
    return stamps >= stampsRequired ? LIME : RED if isDarkWindowskin(self.windowskin)
    return stamps >= stampsRequired ? INVERSE_LIME : INVERSE_RED
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
    event.patch(:ShowSomniamMallStamps) { |page|
      textMatches = page.lookForAll([:ShowText, nil])

      for insn in textMatches
        targetIdx = page.idxOf(insn)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_show_window('#{title}',#{stampsRequired})"])
        targetIdx += 1
        targetIdx += 1 while [:ShowText,:ShowTextContinued].include?(page[targetIdx].command)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_disposefully"])
      end

      martMatches = page.lookForAll([:Script, /^pbPokemonMart/])

      for insn in martMatches
        targetIdx = page.idxOf(insn)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_show_window('#{title}',#{stampsRequired})"])
        targetIdx += 1
        targetIdx += 1 while [:Script,:ScriptContinued].include?(page[targetIdx].command)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_disposefully"])
      end

      next !textMatches.empty? || !martMatches.empty?
    }
  end

  def self.patchSign(event, stampsRequired)
    event.patch(:ShowSomniamMallStamps) { |page|
      textMatches = page.lookForAll([:ShowText, nil])

      for insn in textMatches
        targetIdx = page.idxOf(insn)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_show_window(nil,#{stampsRequired})"])
        targetIdx += 1
        targetIdx += 1 while [:ShowText,:ShowTextContinued].include?(page[targetIdx].command)
        page.insertBefore(targetIdx, [:Script, "showmallstamps_disposefully"])
      end

      next !textMatches.empty?
    }
  end

  SHOPS = {
    3 =>  [0,  'General Store'],
    38 => [0,  'Move Extenders'],
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
  alias :showmallstamps_old_pbEndBuyScene :pbEndBuyScene
  alias :showmallstamps_old_pbStartBuyScene :pbStartBuyScene

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

InjectionHelper.defineMapPatch(231) { |map| # Somniam Mall
  ShowSomniamMallStamps::SHOPS.each_pair { |evt,info|
    ShowSomniamMallStamps.patchShop(map.events[evt], info[0], info[1])
  }
  ShowSomniamMallStamps::SIGNS.each_pair { |evt,info|
    ShowSomniamMallStamps.patchSign(map.events[evt], info)
  }
}
