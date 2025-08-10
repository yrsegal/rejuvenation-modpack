module ShowPosition
  @@lastText = ''

  def self.ensureBox
    if !defined?(@@displaybox) || @@displaybox.contents.disposed?
      @@displaybox = Window_UnformattedTextPokemon.new() # Unformatted for speed
      positionBox
      @@displaybox.z = 99999
    end

    @@displaybox.visible = Input.press?(Input::CTRL)
  end

  def self.positionBox
    @@displaybox.resizeToFit(@@displaybox.text,Graphics.width)
    @@displaybox.x = Graphics.width - @@displaybox.width
    @@displaybox.y = Graphics.height - @@displaybox.height
  end

  def self.update
    return if !$game_player || !$game_player
    ensureBox
    if @@displaybox.visible
      position = "Map #{$game_map.map_id}\n(#{$game_player.x},#{$game_player.y})"

      if @@lastText != position
        @@lastText = position
        @@displaybox.text=position
        positionBox
      end
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
