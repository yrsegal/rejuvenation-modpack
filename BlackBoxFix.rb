


class Cache_Game
  if !defined?(blackboxfixes_old_map_load)
    alias :blackboxfixes_old_map_load :map_load
  end

  def blackboxfixes_patchBlackBoxRemoval(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :blackboxfixes_patchBlackBoxRemoval) {
        matched = InjectionHelper.lookForAll(insns,
          [:Script, '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2)'])

        for insn in matched
          insn.parameters[0] = '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2,3)'
        end

        next matched.length > 0
      }
    end
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return blackboxfixes_old_map_load(mapid)
    end

    ret = blackboxfixes_old_map_load(mapid)

    if mapid == 99 # School of Nightmares
      blackboxfixes_patchBlackBoxRemoval(ret.events[58])
    end
    return ret
  end
end
