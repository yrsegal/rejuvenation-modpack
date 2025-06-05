
Switches[:ShortedOut] = 60

class Cache_Game
  if !defined?(oceanapierfieldmessage_old_map_load)
    alias :oceanapierfieldmessage_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return oceanapierfieldmessage_old_map_load(mapid)
    end

    ret = oceanapierfieldmessage_old_map_load(mapid)

    if mapid == 79 # Oceana Pier Interiors
      maxid = 0
      for id, evt in ret.events
        maxid = id if id > maxid
      end

      rawev = RPG::Event.new(32, 32)
      rawev.id = maxid + 1
      rawev.pages[0].list = InjectionHelper.parseEventCommands(
        [:ShowText, 'The factory is humming away...'],
        :EraseEvent,
        :Done)
      rawev.pages[0].trigger = 2 # event touch

      ret.events[maxid + 1] = rawev
    end

    return ret
  end
end
