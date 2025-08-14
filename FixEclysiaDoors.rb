begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load"
end

Variables[:LocationData] = 681

InjectionHelper.defineMapPatch(581, 20) { |event| # Eclysia, door in hallway to Garufa Inc door
  event.patch(:fixEclysiaDoors) { |page|
    page.changeTrigger(:PlayerTouch)
    next true
  }
}

[ 1,  2,  3, # Doors outside
 11, 12, 13, # Spring doors
 22, 39, 40, # Big sealed door
 51 # Warp to skyview
].each { |i|
  InjectionHelper.defineMapPatch(581, i) { |event| # Eclysia, 
    event.patch(:fixEclysiaDoors) { |page|
      if page.lookForSequence([:TransferPlayer, nil, nil, nil, nil, nil, nil])
        if !page.lookForSequence([:ControlVariable, :LocationData, :Set, :Constant, 3], 
                                 [:ControlVariable, :LocationData, :Set, :Constant, 0])
          page.insertAtStart([:ControlVariable, :LocationData, :Set, :Constant, 3])
          page.insertBeforeEnd([:ControlVariable, :LocationData, :Set, :Constant, 0])
          next true
        end
      end
    }
  }
}

InjectionHelper.defineMapPatch(584, 36) { |event| # Eclysia Garufa, door to hallway
  event.patch(:fixEclysiaDoors) { |page|
    matched = page.lookForAll([:TransferPlayer, :Constant, 581, 24, 57, nil, nil]) # Transfer player to (24,47)
    for insn in matched
      insn.parameters[2..3] = [128, 22]
    end
    next !matched.empty?
  }
}
