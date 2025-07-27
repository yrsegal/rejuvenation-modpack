begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

def axelfixes_fix_stormsprite(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :axelfixes_fix_stormsprite) {
      matched = InjectionHelper.lookForAll(insns,
        [:SetMoveRoute, nil, nil])

      submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'PlayerHeadachet_3', nil, nil, nil], InjectionHelper::MOVE_INSNS)

      for insn in matched
        insn.parameters[1].list.each { |movecommand|
          movecommand.parameters[0] = 'PlayerHeadache_3' if submatcher.matches?(movecommand)
        }
      end

      next matched.length > 0
    }
  end
end

InjectionHelper.defineMapPatch(53) { |map| # I Nightmare Realm
  # Mirror match
  axelfixes_fix_stormsprite(map.events[66])
  axelfixes_fix_stormsprite(map.events[76])
}
