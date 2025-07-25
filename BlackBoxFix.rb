
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
