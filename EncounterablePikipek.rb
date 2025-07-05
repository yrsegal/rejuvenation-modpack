def encounterablepikipek_patchEncounter(event, needsCollision=true) 
  event.pages[0].trigger = 0 # 0 is Action Button
  event.pages[0].through = false unless needsCollision
  event.pages[0].list = InjectionHelper.parseEventCommands(
    [:PlaySoundEvent, '731Cry', 100, 100],
    [:ShowText, 'PIKIPEK: Pikko!'],
    [:ControlVariable, :WildMods, :Set, :Constant, 57], # Chatot - Boomburst is in pikipek egg pool
    [:Script, 'pbWildBattle(:PIKIPEK,5,100)'],
    [:ControlVariable, :WildMods, :Set, :Constant, 0],
    :WaitForMovement, 
    :EraseEvent,
  :Done)
end

InjectionHelper.defineMapPatch(208, 83) { |event| # Deep Terajuma Jungle, Pikipek
  encounterablepikipek_patchEncounter(event, false)
}

InjectionHelper.defineMapPatch(301, 94, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
InjectionHelper.defineMapPatch(301, 95, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
InjectionHelper.defineMapPatch(301, 96, &method(:encounterablepikipek_patchEncounter)) # Route 5, Pikipek
