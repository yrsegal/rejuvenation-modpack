begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?("Data/Mods/#{f}") }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end
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
