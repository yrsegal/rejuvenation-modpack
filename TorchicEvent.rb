
Variables[:QuestXenogene] = 620

InjectionHelper.defineMapPatch(203) { |map| # Pokestar Studios Interiors
  rawev = RPG::Event.new(86, 10)
  rawev.name = "Torchic"
  rawev.pages.push(RPG::Event::Page.new, RPG::Event::Page.new)
  rawev.id = map.events.keys.max

  rawev.pages[2].condition.self_switch_valid = true
  rawev.pages[2].condition.self_switch_ch = "A"
  rawev.pages[2].trigger = 3 # autorun
  rawev.pages[2].list = InjectionHelper.parseEventCommands(
    [:Script, "$game_map.data[86,9,2] = 0"], # Deletes the torchic
    :EraseEvent,
    :Done) 

  rawev.pages[1].condition.variable_valid = true
  rawev.pages[1].condition.variable_id = Variables[:QuestXenogene]
  rawev.pages[1].condition.variable_value = 72
  rawev.pages[1].trigger = 0 # action button
  rawev.pages[1].list = InjectionHelper.parseEventCommands(
    [:ShowText, "It's a stuffed Torchic doll!"],
    [:ShowText, "It's warm..."],
    [:PlaySoundEvent, '255Cry', 80, 100],
    [:ShowText, "TORCHIC: Torchic Tor!"],
    [:ShowAnimation, :Player, EXCLAMATION_ANIMATION_ID],
    [:ShowAnimation, 18, EXCLAMATION_ANIMATION_ID], # Dyre (visual location)
    [:ShowText,          "DYRE: Oh, yeah. That Torchic loves pretending"],
    [:ShowTextContinued, "to be a doll. Don't know why."],
    [:ShowText,          "I've been meaning to find a home for the fella"],
    [:ShowTextContinued, "anyway. Take it, I insist!"],
    [:Script, "$game_map.data[86,9,2] = 0"], # Deletes the torchic
    [:Script, "Kernel.pbAddPokemon(:TORCHIC,10)"],
    [:ControlSelfSwitch, "A", true],
    :Done)

  rawev.pages[0].trigger = 0 # action button
  rawev.pages[0].list = InjectionHelper.parseEventCommands(
    [:ShowText, "It's a stuffed Torchic doll!"],
    [:ShowText, "It's warm..."],
    :Done)

  map.events[rawev.id] = rawev
  next true
}
