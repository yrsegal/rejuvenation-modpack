Variables[:IceCream] = 245
Variables[:Random1] = 216

def fixbluemic_patchShop(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :fixbluemic) {
      checks = InjectionHelper.lookForAll(insns,
        [:ConditionalBranch, :Variable, :Random1, :Constant, nil, :Equals])

      for insn in checks
        insn.parameters[1] = Variables[:IceCream]
      end

      next checks.length > 0
    }
  end
end

InjectionHelper.defineMapPatch(28, 26, &method(:fixbluemic_patchShop)) # Festival Plaza, Ice Cream Seller
InjectionHelper.defineMapPatch(69, 5, &method(:fixbluemic_patchShop)) # Route 3, Ice Cream Seller
