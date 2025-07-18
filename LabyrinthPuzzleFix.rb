InjectionHelper.defineMapPatch(537, 85) { |event| # Zorrialyn Labyrinth Floor 3, Rock/Water checker
  for page in event.pages #
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
}
