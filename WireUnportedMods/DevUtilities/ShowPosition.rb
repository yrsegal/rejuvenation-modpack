
TextureOverrides.registerTextureOverride(TextureOverrides::CHARS+"Generic Event Sprite", __dir__[Dir.pwd.length+1..] + '/Event') if defined?(TextureOverrides)

module ShowPosition
  @@lastText = ''

  def self.ensureBox
    if !defined?(@@displaybox) || @@displaybox.contents.disposed?
      @@displaybox = Window_UnformattedTextPokemon.new() # Unformatted for speed
      positionBox
      @@displaybox.z = 99999
    end

    @@displaybox.visible = Input.press?(Input::CTRL) || (Input.pressex?(:B) && !!facingEvent)
  end

  def self.positionBox
    @@displaybox.resizeToFit(@@displaybox.text,Graphics.width)
    @@displaybox.x = Graphics.width - @@displaybox.width
    @@displaybox.y = Graphics.height - @@displaybox.height
  end

  def self.facingEvent
    x, y, direction = $game_player.x, $game_player.y, $game_player.direction
    new_x = x + (direction == 6 ? 1 : direction == 4 ? -1 : 0)
    new_y = y + (direction == 2 ? 1 : direction == 8 ? -1 : 0)
    for event in $game_map.events.values
      if event.x == new_x && event.y == new_y
        return event
      end
    end
    if $game_map.counter?(new_x, new_y)
      new_x += (direction == 6 ? 1 : direction == 4 ? -1 : 0)
      new_y += (direction == 2 ? 1 : direction == 8 ? -1 : 0)
      for event in $game_map.events.values
        if event.x == new_x && event.y == new_y
          return event
        end
      end
    end
    return nil
  end

  def self.update
    return if !$game_player
    ensureBox
    if @@displaybox.visible

      position = ""

      showMap = Input.press?(Input::CTRL)

      if Input.pressex?(:B)
        evt = facingEvent
        if evt
          position += sprintf("Map %03d - ", $game_map.map_id) unless showMap
          position += sprintf("Event %03d\n", evt.id)
          evname = evt.name
          evname = "[NO NAME]" if !evname || evname.strip.empty?
          pageid = evt.showpossignpost_page_id
          pagecount = evt.showpossignpost_page_count
          if pagecount > 1 || !pageid || evname != sprintf('EV%03d', evt.id) 
            position += evname
            if pagecount > 1
              position += sprintf(" (Page %d/%d)", pageid + 1, pagecount) if pageid
              position += sprintf(" (Inactive/%d)", pagecount) unless pageid
            else
              position += " (Inactive)" unless pageid
            end
            position += "\n"
          end
          position += sprintf("(%03d,%03d)", evt.x, evt.y)
          switches = ['A', 'B', 'C', 'D'].select { |it| $game_self_switches[[evt.map_id, evt.id, it]] }.join("")
          position += " #{switches}" unless switches.empty?
        end
      end

      if showMap
        position += "\n\n" unless position.empty?
        position += sprintf("Map %03d\n(%03d,%03d)", $game_map.map_id, $game_player.x, $game_player.y)
      end

      if @@lastText != position
        @@lastText = position
        @@displaybox.text=position
        positionBox
      end
    end
  end
end

class Game_Character
  alias :showpossignpost_old_graphical? :graphical?
  def graphical?
    showpossignpost_old_graphical? || Input.pressex?(:B)
  end

  attr_writer :always_on_top
  attr_writer :tile_id
end

class Game_Event
  alias :showpossignpost_old_screen_z :screen_z
  def screen_z(height = 0)
    return 999 if Input.pressex?(:B)
    return showpossignpost_old_screen_z(height)
  end

  def showpossignpost_page_id
    return @event.pages.index(@page)
  end

  def showpossignpost_page_count
    return @event.pages.length
  end

  attr_reader :erased
end

class Sprite_Character
  alias :showpossignpost_old_update :update
  def update
    wrapping = @character && @character != $game_player && Input.pressex?(:B)

    if wrapping
      prevcharname = @character.character_name
      prevtileid = @character.tile_id
      prevopacity = @character.opacity
      if @character.erased
        @character.opacity = 80
      elsif (@character.character_name.empty? && @character.tile_id < 384) || @character.opacity == 0
        @character.opacity = 150
      else
        @character.opacity = 255
      end
      @character.character_name = defined?(TextureOverrides) ? 'Generic Event Sprite' : 'object_artifact'
      @character.tile_id = 0
    end
    showpossignpost_old_update
    if wrapping
      @character.character_name = prevcharname
      @character.tile_id = prevtileid
      @character.opacity = prevopacity
    end
  end
end

class Game_Screen
  alias :showpossignpost_old_update :update

  def update(*args, **kwargs)
    ShowPosition.update
    return showpossignpost_old_update(*args, **kwargs)
  end
end
