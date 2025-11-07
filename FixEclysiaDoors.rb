begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:LocationData] = 681

InjectionHelper.defineMapPatch(581, 20) { # Eclysia, door in hallway to Garufa Inc door
  patch(:fixEclysiaDoors) {
    changeTrigger(:PlayerTouch)
  }
}

[ 1,  2,  3, # Doors outside
 11, 12, 13, # Spring doors
 22, 39, 40, # Big sealed door
 51 # Warp to skyview
].each { |i|
  InjectionHelper.defineMapPatch(581, i) { # Eclysia, 
    patch(:fixEclysiaDoors) {
      if lookForSequence([:TransferPlayer, nil, nil, nil, nil, nil, nil])
        if !lookForSequence([:ControlVariable, :LocationData, :[]=, :Constant, 3], 
                            [:ControlVariable, :LocationData, :[]=, :Constant, 0])
          insertAtStart([:ControlVariable, :LocationData, :[]=, :Constant, 3])
          insertBeforeEnd([:ControlVariable, :LocationData, :[]=, :Constant, 0])
        end
      end
    }
  }
}

InjectionHelper.defineMapPatch(584, 36) { # Eclysia Garufa, door to hallway
  patch(:fixEclysiaDoors) {
    matched = lookForAll([:TransferPlayer, :Constant, 581, 24, 57, nil, nil]) # Transfer player to (24,47)
    for insn in matched
      insn[2..3] = [128, 22]
    end
  }
}
