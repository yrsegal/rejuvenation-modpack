$stored_encounterrate_modifier = -1

class Game_Player < Game_Character
  alias :stored_encounterrate_oldupdate :update

  def update(*args, **kwargs)
    ret = stored_encounterrate_oldupdate(*args, **kwargs)
    if $scene && $scene.is_a?(Scene_Map)
      hasRateStored = $stored_encounterrate_modifier != -1
      if Input.press?(Input::SHIFT) != hasRateStored
        if hasRateStored
          $game_variables[:EncounterRateModifier] = $stored_encounterrate_modifier
          $stored_encounterrate_modifier = -1
          if defined?($game_map.map_id)
              $PokemonEncounters.setup($game_map.map_id)
          end
        else
          if !defined?($game_variables[:EncounterRateModifier]) || $game_switches[:FirstUse]!=true
            $game_variables[:EncounterRateModifier]=1
          end
          $stored_encounterrate_modifier = $game_variables[:EncounterRateModifier]
          $game_variables[:EncounterRateModifier] = 2
          if defined?($game_map.map_id)
              $PokemonEncounters.setup($game_map.map_id)
          end
        end
      end
    end
    return ret
  end
end
