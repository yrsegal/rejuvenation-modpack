begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(File.dirname(__FILE__), f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

InjectionHelper.defineMapPatch(99, 58) { |event| # School of Nightmares, Make Anything Within Reason Machine
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :blackboxfixes_patchBlackBoxRemoval) {
      matched = InjectionHelper.lookForAll(insns,
        [:Script, '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2)'])

      for insn in matched
        insn.parameters[0] = '$PokemonBag.pbDeleteItem(:MYSTBLACKBOX2,3)'
      end

      next matched.length > 0
    }
  end
}
