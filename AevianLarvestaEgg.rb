begin
  missing = ['0000.injection.rb', '0000.textures.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load"
end

# Credit to moonpaw for creating this 

Switches[:Gym_13] = 295

TextureOverrides.registerTextureOverride(TextureOverrides::CHARS + "egg_aevian_larvesta", TextureOverrides::MODBASE + "LarvestaEgg")

InjectionHelper.defineMapPatch(315) { |map| # Rose Theatre
  map.createNewEvent(4, 25, "Larvesta Egg", "aevianlarvestaegg_egg") { |event|
    event.newPage { |page|
      page.setGraphic("egg_aevian_larvesta")
      page.requiresSwitch(:Gym_13)
      page.interact(
        [:ShowText, "The egg is nestled here, as if waiting for you to return for it."],
        [:ShowText, "Take it?"],
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
        :Done)
    }

    event.newPage { |page|
      page.requiresSelfSwitch("A")
    }
  }
}
