begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

InjectionHelper.defineMapPatch(-1) { |map| # Apply to every map
  textmatcher = InjectionHelper.parseMatcher([:ShowText, %r"((\\[\.\|])|(</ac>))$"])
  textcmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, %r"((\\[\.\|])|(</ac>))$"])
  nextmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, nil])

  map.patch(:deleteendwaits_patchinsns) { |page|
    i = 0
    while i < page.size - 1
      insn = page[i]

      if (textmatcher.matches?(insn) || textcmatcher.matches?(insn)) && !nextmatcher.matches?(page[i + 1])
        insn[0] = insn.parameters[0].gsub!(%r"((\\[\.\|])|(</ac>))$", '')
      end

      i += 1
    end
  }
}
