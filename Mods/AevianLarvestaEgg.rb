Switches[:Gym_13] = 295

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
