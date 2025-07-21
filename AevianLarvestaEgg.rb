# Credit to moonpaw for creating this 

Switches[:Gym_13] = 296

TextureOverrides.registerTextureOverride("Graphics/Characters/egg_aevian_larvesta", "Data/Mods/LarvestaEgg")

InjectionHelper.defineMapPatch(315) { |map| # Rose Theatre
  rawev = RPG::Event.new(4, 25)
  rawev.pages.push(RPG::Event::Page.new)
  rawev.id = map.events.values.max { |a, b| a.id <=> b.id }.id + 1
  rawev.pages[1].condition.self_switch_valid = true
  rawev.pages[1].condition.self_switch_ch = "A"

  rawev.pages[0].graphic.character_name = "egg_aevian_larvesta"
  rawev.pages[0].condition.switch1_valid = true
  rawev.pages[0].condition.switch1_id = Switches[:Gym_13]
  rawev.pages[0].trigger = 0 # action button
  rawev.pages[0].list = InjectionHelper.parseEventCommands(
    [:ShowText,          "This egg is nestled in a corner, almost like you were"],
    [:ShowTextContinued, "expected to come back for it."],
    [:ShowText,          "Take it?"],
    [:ShowChoices, ["Yes", "No"], 2],
    [:When, 0, "Yes"],
      [:Script,          "egg=Kernel.pbGenerateEgg(:LARVESTA,1)"],
      [:ScriptContinued, "egg.pbLearnMove(:HURRICANE)"],
      [:ScriptContinued, "pbAddPokemonSilent(egg)"],
      [:PlaySoundEvent, "itemlevel", 100, 100],
      [:ShowText, "\\PN got the egg!"],
      [:ControlSelfSwitch, "A", true],
      :Done,
    [:When, 1, "No"],
      [:ShowText, "You left the egg alone."],
      :Done,
    :Done)
  map.events[rawev.id] = rawev
  next true
}
