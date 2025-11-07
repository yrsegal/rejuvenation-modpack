begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

def encounterablepikipek_patchEncounter(event, needsCollision=true)
  event.pages[0].through = false unless needsCollision
  event.pages[0].interact {
    play_se '731Cry'
    text 'PIKIPEK: Pikko!'
    variables[:WildMods] = 57
    script 'pbWildBattle(:PIKIPEK,5,100)'
    variables[:WildMods] = 0
    wait_for_move_completion
    erase_event
  }
end

InjectionHelper.defineMapPatch(208, 83) { # Deep Terajuma Jungle, Pikipek
  encounterablepikipek_patchEncounter(self, false)
}

InjectionHelper.defineMapPatch(301, 94, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
InjectionHelper.defineMapPatch(301, 95, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
InjectionHelper.defineMapPatch(301, 96, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
