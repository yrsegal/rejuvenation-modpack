RT4GLOBAL_ROUTE4EVENTS = [[166,31],[167,25],[130,9],[132,1],[129,32],[115,21]]

Events.onMapChanging+=proc {
  if $PokemonGlobal.eventvars
    mostRecentReset = nil
    switchState = false
    RT4GLOBAL_ROUTE4EVENTS.each {|event| 
      if mostRecentReset.nil? || $PokemonGlobal.eventvars[event] > mostRecentReset
        mostRecentReset = $PokemonGlobal.eventvars[event]
        switchState = $game_self_switches[event + ['A']]
      end
    }

    mostRecentReset = [Time.now.to_i, mostRecentReset].min

    RT4GLOBAL_ROUTE4EVENTS.each {|event| 
      $PokemonGlobal.eventvars[event] = mostRecentReset
      $game_self_switches[event + ['A']] = switchState
    }
  end
}
