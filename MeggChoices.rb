begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Route2MysteryEgg] = 741
Variables[:Route3MysteryEgg] = 228
Variables[:CrawliMysteryEgg] = 787
Variables[:AevianMysteryEgg] = 776

InjectionHelper.defineMapPatch(321, 28) { # Crawli megg
  patch(:CrawliMeggChoices) {
    choices = lookForSequence([:ShowText, "\\PN, as my thanks, please take this!"])

    if choices
      insertAfter(choices) {
        show_choices("(Do you want to choose which Pokémon you'll get?)") {
          default_choice("Random") {}
          choice("Choice") {
            text "(Which Pokémon do you want?)\\ch[#{Variables[:CrawliMysteryEgg]},0,Sizzlipede,Joltik,Blipbug]"
            variables[:CrawliMysteryEgg] += 1 # Because 0 is "unchosen", shift by 1
          }
        }
      }
    end
  }
}

InjectionHelper.defineMapPatch(69, 3) { # Route 3 megg
  patch(:Route3MeggChoices) {
    choices = lookForSequence([:ShowText, "Oh man, thanks! Here, you can have this."])

    if choices
      insertAfter(choices) {
        show_choices("(Do you want to choose which Pokémon you'll get?)") {
          # cancel is 1
          default_choice("Random") {}
          choice("Choice") {
            text "(Which Pokémon do you want?)\\ch[#{Variables[:Route3MysteryEgg]},0,Azurill,Aron,Absol,Togepi,Sneasel,Dhelmise,A-Litwick,Axew,Mienfoo,Pawniard,Trapinch,Hippopotas,Cottonee,Darumaka,Hatenna,Starly,Tyrunt,Larvesta,Mareanie,Stufful,Rookidee]"
          }
        }
      }
    end
  }
}

InjectionHelper.defineMapPatch(26, 14) { # Aevian megg
  patch(:AevianMeggChoices) {
    choices = lookForSequence([:ShowTextContinued, "Maybe it could be of use to you?"])

    if choices
      insertAfter(choices) {
        show_choices("(Do you want to choose which Pokémon you'll get?)") {
          default_choice("Random") {}
          choice("Choice") {
            text "(Which Pokémon do you want?)\\ch[#{Variables[:AevianMysteryEgg]},0,A-Magikarp,A-Budew,A-Wimpod,A-Shroomish,A-Larvesta,A-Bronzor,A-Feebas,A-Sigilyph]"
            variables[:AevianMysteryEgg] += 1 # Because 0 is "unchosen", shift by 1
          }
        }
      }
    end
  }
}

InjectionHelper.defineMapPatch(199, 75) { # Route 2 megg
  patch(:Route2MeggChoices) {
    choices = lookForSequence(
      [:ShowChoices, ["Yes", "No"], 2],
      [:When, 0, "Yes"],
      [:When, 1, "No"],
      :BranchEndChoices)

    if choices
      choices[0].parameters[0].push("Change Egg")
      insertBefore(choices[3], # DSL does not support orphaned When
        [:When, 2, "Change Egg"],
          [:ShowText, "Which Pokémon do you want?\\ch[#{Variables[:Route2MysteryEgg]},#{condition.variable_value + 1},Skiddo,Mudbray,G-Ponyta]"],
        :Done)
    end
  }
}
