begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

class MapMetadata
  alias :flyexpansion_old_Outdoor :Outdoor

  def Outdoor
    # Rhodea's Apartment
    return true if mapid == 313 && $game_map && $game_map.map_id == mapid && $game_player && (46..105).include?($game_player.x) && (3..33).include?($game_player.y)
    # Castle of Goomidra
    return true if mapid == 602 && $game_map && $game_map.map_id == mapid && $game_player && (60..119).include?($game_player.x) && (0..59).include?($game_player.y)
    return flyexpansion_old_Outdoor
  end

  attr_accessor :HealingSpot
  attr_accessor :MapPosition
end

class TownMapData
  attr_accessor :flyData
  attr_accessor :pos
end

Switches[:QuestAfterForest] = 248
Switches[:Gym_5] = 8
Switches[:ElevationSwitch] = 476
Variables[:ZubatQuest] = 341
Variables[:QuestRestoration] = 577
Variables[:QuestRiftGyarados] = 401
Variables[:KarmaFilesGood] = 731
Variables[:V12Story] = 602

# Fix weird bridge interactions in goldenleaf
alias :flyexpansion_old_pbEraseEscapePoint :pbEraseEscapePoint

def pbEraseEscapePoint
  flyexpansion_old_pbEraseEscapePoint
  if $game_player.x == 41 && $game_player.y == 36 && [25, 321, 190, 216, 217].include?($game_map.map_id) # Goldenwood Forest
    $game_switches[:ElevationSwitch] = true
    $game_map.need_refresh = true
  elsif $game_player.x == 28 && $game_player.y == 28 && $game_map.map_id == 268 # Deep Terajuma Jungle
    $game_switches[:ElevationSwitch] = false
    $game_map.need_refresh = true
  end
end

InjectionHelper.defineMapPatch(311) { # Axis High University
  createSinglePageEvent(38, 7, "set gdc music") {
    autorun {
      play_bgm "GDC - City of Dreams"
      erase_event
    }
  }
}

class PokemonRegionMapScene
  alias :flyexpansion_old_getFlySpot :getFlySpot
  def getFlySpot(pos)
    ret = flyexpansion_old_getFlySpot(pos)
    if ret && [25, 321, 190, 216, 217].include?(ret[0]) # Goldenwood Forest
      if !$game_switches[:QuestAfterForest]
        ret[0] = 25 # Base goldenwood forest
      else
        return nil if $game_switches[:QuestAfterForest] && !$game_switches[:Gym_5] && $game_variables[:QuestRiftGyarados] <= 0

        restoration = $game_variables[:QuestRestoration]

        if restoration >= 9
          ret[0] = 217 # Goldenwood Park
        elsif restoration >= 7
          ret[0] = 216 # Goldenwood Forest, restoration stage 2
        elsif restoration >= 4
          ret[0] = 190 # Goldenwood Forest, restoration stage 1
        end
      end
    elsif ret && ret[0] == 353 && # Oblitus Town
     $game_variables[:KarmaFilesGood] >= 72 # Day with Alice and Allen
      ret[0] = 263 # Oblitus Town (rebuilding)
    elsif ret && ret[0] == 311 && # Axis High University
     $game_variables[:V13Story] >= 79 && $game_variables[:V13Story] < 100 # Land of Broken Dreams
      return nil
    elsif ret && ret[0] == 606 &&
      $game_variables[:V12Story] < 115
      ret[0] = 580 # Pyramid Grounds (unwatered)
    elsif ret && ret[0] == 149 # Mirage Forest
      return nil unless $game_self_switches[[149,135,'C']] || $game_variables[:ZubatQuest] >= 1
    end

    return ret
  end
end

module FlyExpansion
  MAP_GROUPS = [
    [21, 134], # Oceana Piers
    [25, 321, 190, 216, 217], # Goldenwood Forests
    [58, 19], # East Gearen City (lab area)
    [263, 353], # Oblitus Towns
    [580, 606] # Pyramid Grounds
  ]

  def self.addPoint(map, x, y, name, poi, newloc=nil)
    mappos = $cache.mapdata[map].MapPosition
    mappos = [mappos[0], *newloc] if newloc && mappos
    if mappos
      $cache.mapdata[map].MapPosition = mappos if newloc
      $cache.mapdata[map].HealingSpot = [map, x, y]
      loc = [mappos[1], mappos[2]]
      data = {
        name: name,
        poi: poi,
        flyData: [map,x,y]
      }
      $cache.town_map[loc] = TownMapData.new(loc, data, mappos[0])
    end
  end

  def self.changeFlyPoint(map, x, y)
    mappos = $cache.mapdata[map].MapPosition
    if mappos
      loc = mappos[1...]
      if $cache.town_map[loc].region == mappos[0]
        $cache.town_map[loc].flyData = [map, x, y]
        $cache.mapdata[map].HealingSpot = [map, x, y]
      end
    end
  end

  def self.changeSubFlyPoint(map, x, y, loc)
    mappos = $cache.mapdata[map].MapPosition
    if mappos
      if $cache.town_map[loc].region == mappos[0]
        $cache.town_map[loc].flyData = [map, x, y]
      end
    end
  end
  def self.relocateFlyPoint(from, to)
    orig = $cache.town_map[from]
    orig.pos = to
    $cache.town_map.delete(from)
    $cache.town_map[to] = orig
  end
end

Events.onMapChange+=proc {|sender,e|
  for group in FlyExpansion::MAP_GROUPS
    if group.include?($game_map.map_id)
      group.each do |i|
        $PokemonGlobal.visitedMaps[i] = true
      end
    end
  end
}

FlyExpansion.addPoint(291, 50, 15, "PokeStar Studios", "", [21, 32])
FlyExpansion.addPoint(209, 61, 53, "North Dream District", "Somniam Mall", [35, 23])
FlyExpansion.addPoint(209, 30, 37, "North Dream District", "Viennas Hill", [31, 20])
FlyExpansion.addPoint(555, 52, 20, "GDC Tournament Stadium", "", [12, 18])
FlyExpansion.addPoint(268, 28, 28, "Deep Terajuma Jungle", "Black Shard Excav.", [9, 37])
FlyExpansion.addPoint(299, 26, 67, "Mynori Sea", "Luck's Tent", [11, 34])
FlyExpansion.addPoint(149, 77, 43, "Mirage Town", "Mirage Cave", [28, 22]) # Mirage Town

FlyExpansion.changeFlyPoint(258, 52, 25) # Botanical Garden
FlyExpansion.changeFlyPoint(295, 87, 14) # Mt. Terajuma
FlyExpansion.changeFlyPoint(311, 38, 17) # Axis High University
FlyExpansion.changeFlyPoint(353, 34, 43) # Oblitus Town - more complex dispatch handled above
FlyExpansion.changeFlyPoint(321, 41, 36) # Goldenwood Forest - more complex dispatch handled above
FlyExpansion.changeFlyPoint(201, 49, 86) # Helojak
FlyExpansion.changeFlyPoint(515, 52, 13) # Zorrialyn Coast
FlyExpansion.changeSubFlyPoint(76, 22, 39, [5, 15]) # Strange House
FlyExpansion.changeSubFlyPoint(373, 65, 27, [7, 12]) # Voidal Chasm entrance
