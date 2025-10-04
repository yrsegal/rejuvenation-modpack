begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

InjectionHelper.defineMapPatch(99, 58) { |event| # School of Nightmares, Make Anything Within Reason Machine
  event.patch(:blackboxfixes_patchBlackBoxRemoval) { |page|
    matched = page.lookForAll([:Script, '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2)'])

    for insn in matched
      insn[0] = '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2,3)'
    end
  }
}
