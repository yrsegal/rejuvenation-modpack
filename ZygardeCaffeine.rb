
class Game_Event < Game_Character
  attr_reader :event
end

Events.onMapChange+=proc {
  for event in $game_map.events.values

    for page in event.event.pages
      if page.condition.switch1_valid && page.condition.switch1_id == 795 # Zygarde Cell
        if page.condition.switch2_valid && (page.condition.switch2_id == 15 || page.condition.switch2_id == 14) # Time of day
          page.condition.switch2_valid = false
          page.condition.switch2_id = 1
        end
      end
    end
  end
}
