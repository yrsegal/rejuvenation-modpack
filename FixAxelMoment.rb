begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

def axelfixes_fix_stormsprite(event)
  event.patch(:axelfixes_fix_stormsprite) {
    matched = lookForAll([:SetMoveRoute, nil, nil])

    submatcher = InjectionHelper.parseMatcher([:SetCharacter, 'PlayerHeadachet_3', nil, nil, nil], InjectionHelper::MOVE_INSNS)

    for insn in matched
      insn.parameters[1].list.each { |movecommand|
        movecommand[0] = 'PlayerHeadache_3' if submatcher.matches?(movecommand)
      }
    end
  }
end

InjectionHelper.defineMapPatch(53) { # I Nightmare Realm
  # Mirror match
  axelfixes_fix_stormsprite(self.events[66])
  axelfixes_fix_stormsprite(self.events[76])
  axelfixes_fix_stormsprite(self.events[86])
  axelfixes_fix_stormsprite(self.events[94])
}
InjectionHelper.defineMapPatch(31, 39) { # SS Oceana, Crescent
  # Crescent
  axelfixes_fix_stormsprite(self)
}

