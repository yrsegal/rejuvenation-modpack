Variables[:Post11thBadge] = 456
Variables[:Post9thBadge] = 293
Variables[:Karma] = 129

class CallServicePC
  def shouldShow?
    return false if ServicePCList.isNotPlayer?
    return true
  end

  def name
    return _INTL("Service Directory")
  end

  def access
    Kernel.pbMessage(_INTL("\\se[computeropen]Accessed the Service Directory."))
    loop do
      commands=ServicePCList.getCommandList()
      command=Kernel.pbMessage(_INTL("Which Service should be called?"),
         commands,commands.length)
      if !ServicePCList.callCommand(command)
        break
      end
    end
    pbSEPlay("computerclose")
  end
end

PokemonPCList.registerPC(CallServicePC.new)

module ServicePCList
  @@pclist=[]

  def self.registerService(pc)
    @@pclist.push(pc)
  end

  def self.getCommandList()
    commands=[]
    for pc in @@pclist
      if pc.shouldShow?
        commands.push(pc.name)
      end
    end
    commands.push(_INTL("Cancel"))
    return commands
  end

  def self.callCommand(cmd)
    if cmd<0 || cmd>=@@pclist.length
      return false
    end
    i=0
    for pc in @@pclist
      if pc.shouldShow?
        if i==cmd
           pc.access()
           return true
        end
        i+=1
      end
    end
    return false
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

  def self.darchlightCaves?
    return $game_variables[:Post9thBadge] >= 27 && $game_variables[:Post9thBadge] < 30
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



    # ret = 10000
    # while ret > 0
    #   cmdwin=pbListWindow([],200)
    #   commands = $cache.RXanimations[1..].map {|animation|
    #     [animation.id, animation.name, animation.frame_max]
    #   }
    #   commands.sort! {|a,b| a[1]<=>b[1]}
    #   realcommands=[]
    #   for command in commands
    #     realcommands.push(_ISPRINTF("{1:03d} {2:s}",command[0],command[1]))
    #   end
    #   ret=pbCommands2(cmdwin,realcommands,-1,ret==10000 ? 0 : ret,true)
    #   cmdwin.dispose

    #   if ret > 0
    #     $game_player.animation_id = commands[ret][0]
    #     pbWait([20, commands[ret][2]].max * 2)
    #   end
    # end
