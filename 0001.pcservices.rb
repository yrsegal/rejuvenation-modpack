Variables[:Post11thBadge] = 456
Variables[:Karma] = 129

$pcservices_using_rotomphone = false
$game_temp.menu_calling = false if defined?($pcservices_in_menu) && $pcservices_in_menu
$pcservices_in_menu = false

class Game_Screen
  attr_accessor :pcservices_lastCommand
  attr_accessor :pcservices_lastCommandsCategories

  # Existing field
  attr_accessor :tone_target
end

class Game_Character
  attr_accessor :step_anime
end

class CallServicePC
  def shouldShow?
    return false if ServicePCList.getCommandList()[0].size == 0
    return false if ServicePCList.isNotPlayer?
    return true
  end

  def name
    return _INTL("Service Directory")
  end

  def access
    Kernel.pbMessage(_INTL("\\se[accesspc]Accessed the Service Directory."))
    command=ServicePCList.prevCommand
    loop do
      commands=ServicePCList.getCommandList
      command=Kernel.pbShowCommandsWithHelp(nil, commands[0], commands[1], -1, command)
      if !ServicePCList.callCommand(command)
        break
      end
    end
  end
end

class SubCategoryPCService

  attr_reader :help

  def initialize(categoryKey, categoryName, help=nil)
    @categoryKey = categoryKey
    @categoryName = categoryName
    @help = help
  end

  def shouldShow?
    return false if ServicePCList.getCommandList(@categoryKey)[0].size == 0
    return true
  end

  def name
    return "- " + _INTL(@categoryName)
  end

  def access
    command=ServicePCList.prevCommand(@categoryKey)
    loop do
      commands=ServicePCList.getCommandList(@categoryKey)
      command=Kernel.pbShowCommandsWithHelp(nil, commands[0], commands[1], -1, command)
      if !ServicePCList.callCommand(command, @categoryKey)
        break
      end
    end
  end
end

module ServicePCList

  @@pclisttop=[]
  @@pclistsub={}
  @@pclistcategories=[]
  @@pclist=[]

  @@cleanupSprites=[]
  @@toneTemp=nil

  def self.registerService(pc)
    @@pclist.push(pc)
  end

  # Heh.
  def self.registerServiceTop(pc)
    @@pclisttop.push(pc)
  end

  def self.registerSubCategory(categoryKey, categoryName, help=nil)
    if !@@pclistsub[categoryKey]
      @@pclistsub[categoryKey] = []
      @@pclistcategories.push(SubCategoryPCService.new(categoryKey, categoryName, help))
    end
  end

  # Jokes just write themselves.
  def self.registerSubService(category, pc)
    @@pclistsub[category].push(pc)
  end

  def self.getCommandList(subList=nil)
    commands=[]
    help=[]
    if subList
      cmdList = @@pclistsub[subList]
    else
      cmdList = @@pclisttop + @@pclistcategories + @@pclist
    end

    for pc in cmdList
      if pc.shouldShow?
        commands.push(pc.name)
        help.push(pc.help)
      end
    end
    return [commands, help]
  end

  def self.prevCommand(subList=nil)
    if subList
      $game_screen.pcservices_lastCommandsCategories = {} if !$game_screen.pcservices_lastCommandsCategories
      return 0 if !$game_screen.pcservices_lastCommandsCategories[subList]
      lastCommand = $game_screen.pcservices_lastCommandsCategories[subList]
      cmdList = @@pclistsub[subList]
    else
      return 0 if !$game_screen.pcservices_lastCommand
      lastCommand = $game_screen.pcservices_lastCommand
      cmdList = @@pclisttop + @@pclistcategories + @@pclist
    end

    i=0
    for pc in cmdList
      if pc.shouldShow?
        return i if lastCommand == pc.name
        i += 1
      end
    end
    return 0
  end

  def self.callCommand(cmd, subList=nil)
    if subList
      cmdList = @@pclistsub[subList]
    else
      cmdList = @@pclisttop + @@pclistcategories + @@pclist
    end

    if cmd<0 || cmd>=cmdList.length
      return false
    end
    i=0
    for pc in cmdList
      if pc.shouldShow?
        if i==cmd
          if !pc.is_a?(SubCategoryPCService)
            if $pcservices_using_rotomphone
              pbSEPlay('SFX - RotomPhone_1')
            else
              pbSEPlay('SFX - Phone Call')
            end
          else
            pbSEPlay('dexselect', 100, 120)
          end

          if subList
            $game_screen.pcservices_lastCommandsCategories = {} if !$game_screen.pcservices_lastCommandsCategories
            $game_screen.pcservices_lastCommandsCategories[subList] = pc.name
          else
            $game_screen.pcservices_lastCommand = pc.name
          end


          pc.access()
          cleanupLeftoverSprites
          pbSEPlay('dexselect')
          return true
        end
        i+=1
      end
    end
    return false
  end

  def self.cleanupLeftoverSprites
    @@cleanupSprites.each { |sprite|
      sprite.dispose if !sprite.disposed?
    }
    @@cleanupSprites = []
  end

  ### Commonly used sounds/events

  def self.exclaimSound
    pbSEPlay('PRSFX- Trainer', 80, 100)
  end

  def self.happySound
    pbSEPlay('MiningAllFound', 100, 120)
  end

  def self.buzzer
    pbSEPlay('buzzer', 80, 75)
  end

  def self.playerTalk
    $game_player.step_anime = true
    for i in 0...34
      $game_player.update_stop
      $game_player.update_pattern
      pbWait(1)
    end
    $game_player.step_anime = false
    $game_player.update_stop
    $game_player.update_pattern
  end

  def self.fadeScreen(tone, frames)
    @@toneTemp = $game_screen.tone_target if @@toneTemp.nil?
    $game_screen.start_tone_change(tone, frames * 2)
  end

  def self.restoreScreen(frames)
    target = @@toneTemp || Tone.new(0,0,0,0)
    @@toneTemp = nil
    $game_screen.start_tone_change(target, frames * 2)
  end


  ### Utility functions for creating various kinds of windows

  def self.quantityWindow(item, viewport=nil, z=99999, windowAbove: nil)
    return createCornerWindow(quantityText(item), viewport, z, windowAbove: windowAbove)
  end

  def self.createCornerWindow(text, viewport=nil, z=99999, windowAbove: nil)
    window=Window_AdvancedTextPokemon.new(text)
    @@cleanupSprites.push(window)
    window.resizeToFit(window.text,Graphics.width)
    window.width=160 if window.width<=160
    window.y=(windowAbove) ? windowAbove.y + windowAbove.height : 0
    window.viewport=viewport
    window.visible=true
    window.z = z
    return window
  end

  def self.quantityText(item)
    itemName = getItemName(item) + 's'
    itemQuantity = $PokemonBag.pbQuantity(item)
    quantityString = pbCommaNumber(itemQuantity)
    return _INTL("{3}{1}:</c3>\n<ar>{2}</ar>",itemName, quantityString, getSkinColor(nil, 1, true))
  end

  def self.updateWindowQuantity(window, item)
    updateWindow(window, quantityText(item))
  end

  def self.updateWindow(window, text)
    window.text=text
    window.resizeToFit(window.text,Graphics.width)
  end
  def self.updateWindowHeirarchy(window, windowAbove)
    window.y=(windowAbove) ? windowAbove.y + windowAbove.height : 0
  end

  ### Tools to check if a service should be enabled

  def self.distantTime?
    return $game_variables[:Post11thBadge] >= 34 && $game_variables[:Post11thBadge] < 78
  end

  def self.inNightmare?
    mapid = $game_map.map_id
    while mapid != 0
      return true if [85,94].include?(mapid)
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.nightmareCleansed?
    return $game_variables[:V13Story] >= 100
  end

  def self.bladestarTerritory?
    mapid = $game_map.map_id
    while mapid != 0
      return true if [371,384,387,466,494,40].include?(mapid)
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.darchlightCaves?
    mapid = $game_map.map_id
    while mapid != 0
      return true if mapid == 494
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.dreadDream?
    mapid = $game_map.map_id
    while mapid != 0
      return true if mapid == 525
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.inZeight?
    mapid = $game_map.map_id
    while mapid != 0
      return true if [442,251].include?(mapid)
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.denOfSouls?
    mapid = $game_map.map_id
    while mapid != 0
      return true if mapid == 126
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.inRift?
    mapid = $game_map.map_id
    while mapid != 0
      return true if [346,62,78,572,559,96,474,434,390,392,72,393,519,272,535].include?(mapid)
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.blacksteeple?
    mapid = $game_map.map_id
    while mapid != 0
      return true if mapid == 128
      mapid = $cache.mapinfos[mapid].parent_id
    end
    return false
  end

  def self.offMap?
    return true if blacksteeple?
    if $cache.mapdata[$game_map.map_id].MapPosition.is_a?(Hash)
      region = pbUnpackMapHash[0]
    else
      region=$cache.mapdata[$game_map.map_id].MapPosition[0]
    end
    return region == 5
  end

  def self.goodKarma?
    return $game_variables[:Karma] >= 0
  end

  def self.isNotPlayer?
    return Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
  end
end

if !defined?(pcservices_old_shouldShowClock?)
  alias :pcservices_old_shouldShowClock? :shouldShowClock?
end

def shouldShowClock?
  if defined?($Settings.unrealTimeClock)
    setting=$Settings.unrealTimeClock
    return false if setting == 1 && $pcservices_in_menu
  end
  return pcservices_old_shouldShowClock?
end

class PokemonReadyMenu_Scene

  alias :pcservices_old_pbStartScene :pbStartScene

  def pbStartScene(*args, **kwargs)
    $pcservices_in_menu = true
    $game_temp.menu_calling = true
    return pcservices_old_pbStartScene(*args, **kwargs)
  end

  alias :pcservices_old_pbEndScene :pbEndScene

  def pbEndScene(*args, **kwargs)
    $pcservices_in_menu = false
    $game_temp.menu_calling = false
    return pcservices_old_pbEndScene(*args, **kwargs)
  end
end

Kernel.singleton_class.class_eval do
  alias :pcservices_old_pbUseKeyItemInField :pbUseKeyItemInField

  def pbUseKeyItemInField(item)
    wasInMenu = $pcservices_in_menu
    wasMenuCalling = $game_temp.menu_calling
    $pcservices_in_menu = true
    $game_temp.menu_calling = true
    ret = pcservices_old_pbUseKeyItemInField(item)
    $pcservices_in_menu = wasInMenu
    $game_temp.menu_calling = wasMenuCalling
    return ret
  end

end

class ItemData < DataObject
  attr_accessor :flags
  attr_accessor :desc
end

$cache.items[:ROTOMPHONE].flags[:noUse] = false
$cache.items[:ROTOMPHONE].flags[:general] = true
$cache.items[:ROTOMPHONE].desc = "A smartphone that was enhanced with a Rotom! Can access the PC system remotely."

ItemHandlers::UseFromBag.add(:ROTOMPHONE,proc{|item|
  next 2
})
ItemHandlers::UseFromBag.add(:REMOTEPC,proc{|item|
  next 2
})


ItemHandlers::UseInField.add(:ROTOMPHONE,proc{|item|
  if $game_variables[:E4_Tracker] > 0
    Kernel.pbMessage(_INTL("The Rotom Phone's PC function is disabled here."))
    next 0
  end
  if $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    Kernel.pbMessage(_INTL("The Rotom Phone's PC function isn't available now."))
    next 0
  end
  if Rejuv && $game_variables[650] > 0
    Kernel.pbMessage(_INTL("ERIN: {1}, can you get off your phone and get on with the battle?",$Trainer.name))
    next 0
  end

  $pcservices_using_rotomphone = true
  pbPokeCenterPC
  $pcservices_using_rotomphone = false
  next 1
})



PokemonPCList.registerPC(CallServicePC.new)
ServicePCList.registerSubCategory(:Consultants, "Pokemon Consultants", "Services which can tweak basic values of your Pokemon.")

