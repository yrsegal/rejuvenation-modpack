def zzren_multiline_patch(event)
  for page in event.pages
    insns = page.list
    InjectionHelper.patch(insns, :zzren_multiline_patch) {
      showTexts = InjectionHelper.lookForAll(insns,
          [:ShowText, nil])
      doneAny = false
      for insn in showTexts
        lines = [insn.parameters[0]]
        crushlines = lines.clone
        crushed = false
        idx = insns.index(insn)
        if insns.size > idx + 1 && insns[idx + 1].code == InjectionHelper::EVENT_INSNS[:ShowText]
          idx += 1
          crushlines.push(insns[idx].parameters[0])
          crushed = true
        end
        while insns.size > idx + 1 && insns[idx + 1].code == InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          idx += 1
          crushlines.push(insns[idx].parameters[0])
          lines.push(insns[idx].parameters[0]) unless crushed
        end


        usinglines = lines
        mapping = $zzren_multiline_patches[usinglines]
        if !mapping && crushed
          usinglines = crushlines
          mapping = $zzren_multiline_patches[usinglines]
        else
          crushed = false
        end

        if mapping
          if mapping.is_a?(Array) && mapping.length == usinglines.length - 1 && crushed
            idx = insns.index(insn)
            insns.delete_at(idx)
            for i in 0...mapping.length
              insns[idx + i].parameters[0] = mapping[i]
            end
            doneAny = true
          elsif mapping.is_a?(Array) && mapping.length == usinglines.length
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
  ["REN: .muminim sruoh 3 naht erom ekat lliw", "ylbaborP .thguoht I naht esrow s'ti ebyaM", "...mmmH"] => 3,
  ["!", "evah I naht regnol raf devil ev'uoY", ".evil em tel tsuJ ...gnol os rof ereh gnirednaw ", "neeb ev'I"] => [
    "\\l[3]!evah I naht regnol raf devil ev'uoY", ".evil em tel tsuJ ...gnol os rof ereh gnirednaw ", "neeb ev'I"]
}


# All ZZ Events where ren speaks backwards with above dialogue
# 576: zz part 2 outside
InjectionHelper.defineMapPatch(576, 14, &method(:zzren_multiline_patch))
InjectionHelper.defineMapPatch(576, 8, &method(:zzren_multiline_patch))
# 574: zz interiors
InjectionHelper.defineMapPatch(574, 88, &method(:zzren_multiline_patch))
InjectionHelper.defineMapPatch(574, 90, &method(:zzren_multiline_patch))
# 83: 3rd Layer 
InjectionHelper.defineMapPatch(83, 14, &method(:zzren_multiline_patch))
