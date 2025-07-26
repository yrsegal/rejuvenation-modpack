class MapMetadata
  alias :flyexpansion_old_Outdoor :Outdoor

  def Outdoor
    # Rhodea's Apartment
    return true if mapid == 313 && $game_map && $game_map.map_id == mapid && $game_player && (46..105).include?($game_player.x) && (3..33).include?($game_player.y)
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
Variables[:QuestRestoration] = 577
Variables[:QuestRiftGyarados] = 401
Variables[:KarmaFilesGood] = 731

class PokemonRegionMapScene
  alias :flyexpansion_old_getFlySpot :getFlySpot
  def getFlySpot(pos)
    ret = flyexpansion_old_getFlySpot(pos)
    if ret && ret[0] == 321 # Goldenwood Forest
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
    end

    return ret
  end
end

module FlyExpansion
  MAP_GROUPS = [
    [21, 134], # Oceana Piers
    [25, 321, 190, 216, 217], # Goldenwood Forests
    [58, 19], # East Gearen City (lab area)
    [263, 353] # Oblitus Towns
  ]

  def self.addPoint(map, x, y, name, poi, newloc=nil)
    mappos = $cache.mapdata[map].MapPosition
    mappos = [mappos[0], *newloc] if newloc && mappos
    if mappos
      $cache.mapdata[map].MapPosition = mappos if newloc
      $cache.mapdata[map].HealingSpot = [map, x, y]
      loc = [mappos[1], mappos[2]]
      data = {
        :name => name,
        :poi => poi,
        :flyData => [map,x,y]
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

FlyExpansion.addPoint(209, 61, 53, "North Dream District", "Somniam Mall", [35, 23])
FlyExpansion.addPoint(209, 30, 37, "North Dream District", "Viennas Hill", [31, 20])
FlyExpansion.addPoint(555, 52, 20, "GDC Tournament Stadium", "", [12, 18])
FlyExpansion.addPoint(268, 27, 28, "Deep Terajuma Jungle", "Black Shard Excav.", [9, 37])
FlyExpansion.addPoint(299, 26, 67, "Mynori Sea", "Luck's Tent", [11, 34])

FlyExpansion.changeFlyPoint(295, 87, 14) # Mt. Terajuma
FlyExpansion.changeFlyPoint(311, 38, 17) # Axis High University
FlyExpansion.changeFlyPoint(353, 34, 43) # Oblitus Town - more complex dispatch handled above
FlyExpansion.changeFlyPoint(321, 41, 36) # Goldenwood Forest - more complex dispatch handled above
FlyExpansion.changeFlyPoint(201, 49, 86) # Helojak
FlyExpansion.changeSubFlyPoint(373, 65, 27, [7, 12]) # Voidal Chasm entrance
