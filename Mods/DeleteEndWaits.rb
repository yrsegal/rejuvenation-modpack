

InjectionHelper.defineMapPatch(-1) { |map| # Apply to every map
  textmatcher = InjectionHelper.parseMatcher([:ShowText, %r"((\\[\.\|])|(</ac>))$"])
  textcmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, %r"((\\[\.\|])|(</ac>))$"])
  nextmatcher = InjectionHelper.parseMatcher([:ShowTextContinued, nil])

  map.patch(:deleteendwaits_patchinsns) {
    i = 0
    while i < self.size - 1
      insn = self[i]

      if (textmatcher.matches?(insn) || textcmatcher.matches?(insn)) && !nextmatcher.matches?(self[i + 1])
        insn[0] = insn.parameters[0].gsub!(%r"((\\[\.\|])|(</ac>))$", '')
      end

      i += 1
    end
  }
}
