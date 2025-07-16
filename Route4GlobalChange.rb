RT4GLOBAL_ROUTE4EVENTS = [[166,31],[167,25],[130,9],[132,1],[129,32],[115,21]]

Events.onMapChanging+=proc {
  if $PokemonGlobal.eventvars
    mostRecentReset = nil
    switchState = false
    RT4GLOBAL_ROUTE4EVENTS.each {|event|
      eventTime = $PokemonGlobal.eventvars[event]

      if !eventTime.nil? && (mostRecentReset.nil? || eventTime > mostRecentReset)
        mostRecentReset = eventTime
        switchState = $game_self_switches[event + ['A']]
      end
    }

    if !mostRecentReset.nil?

      mostRecentReset = [Time.now.to_i, mostRecentReset].min

      RT4GLOBAL_ROUTE4EVENTS.each {|event|
        $PokemonGlobal.eventvars[event] = mostRecentReset
        $game_self_switches[event + ['A']] = switchState
      }
    end
  end
}
