Variables[:Post11thBadge] = 456
Variables[:Karma] = 129

$pcservices_using_rotomphone = false

class Game_Screen
  attr_accessor :pcservices_lastCommand
  attr_accessor :pcservices_lastCommandsCategories
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
          pbSEPlay('dexselect')
          return true
        end
        i+=1
      end
    end
    return false
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
    pbCommonEvent(97)
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
      return true if [371,384,387,466,494].include?(mapid)
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

  def self.offMap?
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

$pcservices_in_readymenu = false

class PokemonReadyMenu_Scene

  if !defined?(pcservices_old_pbStartScene)
    alias :pcservices_old_pbStartScene :pbStartScene
  end

  def pbStartScene(*args, **kwargs)
    $pcservices_in_readymenu = true
    return pcservices_old_pbStartScene(*args, **kwargs)
  end

  if !defined?(pcservices_old_pbEndScene)
    alias :pcservices_old_pbEndScene :pbEndScene
  end

  def pbEndScene(*args, **kwargs)
    $pcservices_in_readymenu = false
    return pcservices_old_pbEndScene(*args, **kwargs)
  end
end

if !defined?(pcservices_old_pbMapInterpreterRunning?)
  alias :pcservices_old_pbMapInterpreterRunning? :pbMapInterpreterRunning?
end

def pbMapInterpreterRunning?
  return pcservices_old_pbMapInterpreterRunning? || $pcservices_in_readymenu
end


class ItemData < DataObject
  attr_accessor :flags
  attr_accessor :desc
end

$cache.items[:ROTOMPHONE].flags[:noUse] = false
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

