begin
  missing = ['0000.injection.rb', '0000.textures.rb', 'LarvestaEgg.png'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

# Credit to moonpaw for creating this 

Switches[:Gym_13] = 295

TextureOverrides.registerTextureOverride(TextureOverrides::CHARS + "egg_aevian_larvesta", TextureOverrides::MODBASE + "LarvestaEgg")

InjectionHelper.defineMapPatch(315) { # Rose Theatre
  createNewEvent(4, 25, "Larvesta Egg", "aevianlarvestaegg_egg") {
    newPage {
      setGraphic "egg_aevian_larvesta"
      requiresSwitch :Gym_13
      interact {
        text "The egg is nestled here, as if waiting for you to return for it."
        show_choices("Take it?") {
          choice("Yes") {
            script "egg=Kernel.pbGenerateEgg(:LARVESTA,1)
                    egg.pbLearnMove(:HURRICANE)
                    pbAddPokemonSilent(egg)"
            play_se "itemlevel"
            text "\\PN got the egg!"
            self_switch["A"] = true
          }
          default_choice("No") {
            text "You left the egg alone."
          }
        }
      }
    }

    newPage {
      requiresSelfSwitch "A"
    }
  }
}
