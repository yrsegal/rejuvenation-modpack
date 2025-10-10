begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

### Fix misnamed events

InjectionHelper.defineMapPatch(58, 8) { |evt| evt.name = "HiddenItem" } # East Gearen, pokeball
InjectionHelper.defineMapPatch(119, 17) { |evt| evt.name = "HiddenItem" } # Carotos Mountain, blast powder
InjectionHelper.defineMapPatch(250, 70) { |evt| evt.name = "HiddenItem" } # Marble Mansion, silk scarf
InjectionHelper.defineMapPatch(230, 86) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, Chrisola Hotel
InjectionHelper.defineMapPatch(230, 87) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, Chrisola Hotel
InjectionHelper.defineMapPatch(230, 88) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, Chrisola Hotel
InjectionHelper.defineMapPatch(230, 89) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, Chrisola Hotel
InjectionHelper.defineMapPatch(260, 20) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, GDC Arcade
InjectionHelper.defineMapPatch(260, 21) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, GDC Arcade
InjectionHelper.defineMapPatch(260, 22) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, GDC Arcade
InjectionHelper.defineMapPatch(260, 23) { |evt| evt.name = "HiddenCoins" } # Hidden Coins, GDC Arcade


InjectionHelper.defineMapPatch(48, 9) { |evt| evt.name = "EV009" } # East Gearen interiors, poison barb misnamed as hidden
InjectionHelper.defineMapPatch(75, 13) { |evt| evt.name = "EV013" } # Evergreen Island, primarium misnamed as hidden

### Done with misnamed events

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

      hiName = event.name.gsub(/\s/, '')

      next if hiName != 'HiddenItem' && !(hiName == 'HiddenCoins' && $PokemonBag.pbQuantity(:COINCASE)>0) && 
        event.character_name != 'Zygarde Cell' && event.character_name != 'Object Cell'
      next if $game_self_switches[[$game_map.map_id, event.id, 'A']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'B']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'C']]
      next if $game_self_switches[[$game_map.map_id, event.id, 'D']]

      if hiName == 'HiddenItem'
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
      @always_on_top = true
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
      @always_on_top = @page.always_on_top
      @through = @page.through
    else # This branch is only reached, in current maps, for the Darchlight purple nectar
      @character_name = "invisible"
      @through = false
    end
  end
end


