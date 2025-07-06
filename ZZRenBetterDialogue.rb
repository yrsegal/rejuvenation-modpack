def zzren_multiline_patch(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :zzren_multiline_patch) {
      showTexts = InjectionHelper.lookForAll(insns,
          [:ShowText, nil])
      doneAny = false
      for insn in showTexts
        lines = [insn.parameters[0]]
        idx = insns.index(insn)
        while insns.size > idx + 1 && insns[idx + 1].code == InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          idx += 1
          lines.push(insns[idx].parameters[0])
        end

        mapping = $zzren_multiline_patches[lines]
        if mapping
          if mapping.is_a?(Array) && mapping.length == lines.length
            idx = insns.index(insn)
            for i in 0...mapping.length
              insns[idx + i].parameters[0] = mapping[i]
            end
            doneAny = true
          elsif mapping.is_a?(Numeric)
            insn.parameters[0] = "\\l[#{mapping}]" + insn.parameters[0]
            doneAny = true
          end
        end
      end
      next doneAny
    }
  end
end

$zzren_multiline_patches = {
  ["tuoba tahW .onnud I .driew ylemertxe leef I ekiL", "?syug uoy"] => ["?syug uoy tuoba tahW .onnud I", ".driew ylemertxe leef I ekiL"],
  ["REN: !noitcnuflam ot ecived hceeps ym desuac miN", "...fo evol eht rof hO ?sdrawkcab gniklat m'I"] => 3,
  ["REN: .retneC nomekoP a dnif", "nac ew fi flesym riaper nac I ,enif s'tI", "! emit fo dnik taht evah t'nod eW"] => 3,
  ["REN: .derit m'I dna krow hcum oot yaw si", "yltcerroc klat flesym ekam ot sdrawkcab ", "gniklaT"] => 3,
  [".yad ruo niur ot ereh kcor a s'ereht", "esruoc fo tub ,ylisae hguorht teg dluoc ew ", ",yawynA"] => 3,
  ["hahahahahahahahahahahahahahaaahH", ".resal a dah I hsiw YLLAER I won"] => [".resal a dah I hsiw YLLAER I won", "hahahahahahahahahahahahahahaaahH"],
  ["REN: .liava\non ot tub ,reilrae ti gninepo deirt I .saw tI"] => ["REN: .liava on ot tub ,reilrae ti gninepo deirt I .saw tI"],
  ["REN: .era segamad eht evisnetxe woh", "no sdneped tI .etamitse na uoy evig t'ndluoc I"] => 3,
  ["REN: .muminim sruoh 3 naht erom ekat lliw", "ylbaborP .thguoht I naht esrow s'ti ebyaM", "...mmmH"] => 3
}


# All ZZ Events where ren speaks backwards with above dialogue
# 576: zz part 2 outside
InjectionHelper.defineMapPatch(576, 14, &method(:zzren_multiline_patch))
InjectionHelper.defineMapPatch(576, 8, &method(:zzren_multiline_patch))
# 574: zz interiors
InjectionHelper.defineMapPatch(574, 88, &method(:zzren_multiline_patch))
InjectionHelper.defineMapPatch(574, 90, &method(:zzren_multiline_patch))
