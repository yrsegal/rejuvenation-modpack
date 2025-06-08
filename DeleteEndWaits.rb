def deleteendwaits_patchinsns(insns, textmatcher, textcmatcher, nextmatcher)
  InjectionHelper.patch(insns, :deleteendwaits_patchinsns) {
    i = 0
    anypatch = false
    while i < insns.size - 1
      insn = insns[i]

      if (textmatcher.matches?(insn) || textcmatcher.matches?(insn)) && !nextmatcher.matches?(insns[i + 1])
        insn.parameters[0].gsub!(/\\[|\.]$/, '')
        anypatch = true
      end

      i += 1
    end

    next anypatch
  }
end



class Cache_Game
  if !defined?(deleteendwaits_old_map_load)
    alias :deleteendwaits_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return deleteendwaits_old_map_load(mapid)
    end

    ret = deleteendwaits_old_map_load(mapid)

    textmatcher = InjectionHelper.parseMatcher([:ShowText, /\\[|\.]$/])
    textcmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, /\\[|\.]$/])
    nextmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, nil])

    ret.events.each_value { |event|
      event.pages.each { |page|
        deleteendwaits_patchinsns(page.list, textmatcher, textcmatcher, nextmatcher)
      }
    }

    return ret
  end
end
