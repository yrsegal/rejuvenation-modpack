begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(File.dirname(__FILE__), f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

def deleteendwaits_patchinsns(insns, textmatcher, textcmatcher, nextmatcher)
  InjectionHelper.patch(insns, :deleteendwaits_patchinsns) {
    i = 0
    anypatch = false
    while i < insns.size - 1
      insn = insns[i]

      if (textmatcher.matches?(insn) || textcmatcher.matches?(insn)) && !nextmatcher.matches?(insns[i + 1])
        insn.parameters[0].gsub!(%r"((\\[\.\|])|(</ac>))$", '')
        anypatch = true
      end

      i += 1
    end

    next anypatch
  }
end

InjectionHelper.defineMapPatch(-1) { |map| # Apply to every map
  textmatcher = InjectionHelper.parseMatcher([:ShowText, %r"((\\[\.\|])|(</ac>))$"])
  textcmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, %r"((\\[\.\|])|(</ac>))$"])
  nextmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, nil])

  map.events.each_value { |event|
    event.pages.each { |page|
      deleteendwaits_patchinsns(page.list, textmatcher, textcmatcher, nextmatcher)
    }
  }
}
