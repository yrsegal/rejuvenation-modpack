Variables[:IceCream] = 245
Variables[:Random1] = 216

class Cache_Game
  if !defined?(fixbluemic_old_map_load)
    alias :fixbluemic_old_map_load :map_load
  end

  def fixbluemic_patchShop(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :fixbluemic) {
        checks = InjectionHelper.lookForAll(insns,
          [:ConditionalBranch, :Variable, :Random1, :Constant, nil, :Equals])

        for insn in checks
          insn.parameters[1] = Variables[:IceCream]
        end

        next checks.length > 0
      }
    end
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return fixbluemic_old_map_load(mapid)
    end

    ret = fixbluemic_old_map_load(mapid)

    if mapid == 28 # Festival Plaza
      fixbluemic_patchShop(ret.events[26])
    elsif mapid == 69 # Route 3
      fixbluemic_patchShop(ret.events[5])
    end

    return ret
  end
end
