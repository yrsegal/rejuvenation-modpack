begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(File.dirname(__FILE__), f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

### MODDED/
Events.onMapChange+=proc {
  $game_screen.itemRadar_updateItemRadar
}

ItemHandlers::UseInField.add(:ITEMFINDER,proc{|item|
  $game_screen.itemRadar_toggleRadar
})

class ItemData < DataObject
  attr_writer :desc
end

$cache.items[:ITEMFINDER].desc = "A device used for finding items. Makes hidden items visible when activated."

class PokemonMartAdapter
  alias :itemradar_old_getDisplayName :getDisplayName

  def getDisplayName(item)
    old = itemradar_old_getDisplayName(item)
    if item == :ITEMFINDER
      if $game_screen && defined?($game_screen.itemRadar_itemRadarIsOn) && $game_screen.itemRadar_itemRadarIsOn
        old += ' (On)'
      else
        old += ' (Off)'
      end
    end
    return old
  end
end

### /MODDED

class Game_Screen
  ### MODDED/
  attr_accessor   :itemRadar_itemRadarIsOn

  def itemRadar_updateItemRadar
    foundz = false
    biggestid = 0
    for event in $game_map.events.values
      biggestid = event.id if event.id > biggestid

      next if event.name != 'HiddenItem' && event.character_name != 'Zygarde Cell' && event.character_name != 'Object Cell'
      next if $game_self_switches[[$game_map.map_id, event.id, 'A']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'B']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'C']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'D']]

      if event.name == 'HiddenItem'
        if itemRadar_checkIsItemRadarOn?
          event.itemRadar_green_ball
        else
          event.itemRadar_revert_ball
        end
      else
        foundz = true
      end
    end

    if foundz && itemRadar_checkIsItemRadarOn?
      InjectionHelper.createSinglePageEvent($game_map, 0, 0, "ping") { |page|
        page.autorun([:PlaySoundEvent, 'MiningPing', 60, 80], :EraseEvent)
      }
    end
  end

  def itemRadar_checkIsItemRadarOn?
    return false if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    return false if $PokemonBag.pbQuantity(:ITEMFINDER) == 0
    @itemRadar_itemRadarIsOn=false if !defined?(@itemRadar_itemRadarIsOn)
    return @itemRadar_itemRadarIsOn
  end

  def itemRadar_toggleRadar
    @itemRadar_itemRadarIsOn=!@itemRadar_itemRadarIsOn
    itemRadar_updateItemRadar
    if itemRadar_checkIsItemRadarOn?
      Kernel.pbMessage(_INTL('The Itemfinder is now \c[1]ON\c[0].'))
    else
      Kernel.pbMessage(_INTL('The Itemfinder is now \c[2]OFF\c[0].'))
    end
  end
  ### /MODDED
end

class Game_Event < Game_Character
  def itemRadar_green_ball
    if @tile_id < 384 # Dunno why, but this is the threshold for "will override the sprite"
      @character_name = "Object ball_3"
      @opacity = 128
      @character_hue = -100
      @through = false
    else  # This branch is only reached, in current maps, for the Darchlight purple nectar
      @character_name = "invisible"
      @through = false
    end
  end

  def itemRadar_revert_ball
    if @tile_id < 384 # Dunno why, but this is the threshold for "will override the sprite"
      if @page == nil
        @tile_id = 0
        @character_name = ""
        @character_hue = 0
        @move_type = 0
        @through = true
        @trigger = nil
        @list = nil
        @interpreter = nil
        return
      end
      @character_name = @page.graphic.character_name
      @character_hue = @page.graphic.character_hue
      @opacity = @page.graphic.opacity
    else # This branch is only reached, in current maps, for the Darchlight purple nectar
      @character_name = "invisible"
      @through = false
    end
  end
end


