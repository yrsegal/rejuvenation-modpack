class Cache_Game
  if !defined?(labyrinthfix_old_map_load)
    alias :labyrinthfix_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return labyrinthfix_old_map_load(mapid)
    end

    ret = labyrinthfix_old_map_load(mapid)

    if mapid == 537 # Zorrialyn Labyrinth Floor 3
      for page in ret.events[85].pages # Rock/Water checker
        insns = page.list 
        InjectionHelper.patch(insns, :labyrinthfix) {
          matched = InjectionHelper.lookForAll(insns,
            [:ScriptContinued, 'poke.hasType?(:ROCK)'])

          for insn in matched
            insn.parameters[0] += ' &&'
          end

          next matched.length > 0
        }
      end
    end

    return ret
  end
end
