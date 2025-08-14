begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Route2MysteryEgg] = 741
Variables[:Route3MysteryEgg] = 228
Variables[:CrawliMysteryEgg] = 787
Variables[:AevianMysteryEgg] = 776

InjectionHelper.defineMapPatch(321, 28) { |event| # Crawli megg
  event.patch(:CrawliMeggChoices) { |page|
    choices = page.lookForSequence([:ShowText, "\\PN, as my thanks, please take this!"])

    if choices
      page.insertAfter(choices, 
        [:ShowText, "(Do you want to choose which Pokémon you'll get?)"],
        [:ShowChoices, ["Random", "Choice"], 1],
        [:When, 0, "Random"],
        :Done,
        [:When, 1, "Choice"],
          [:ShowText, "(Which Pokémon do you want?)\\ch[#{Variables[:CrawliMysteryEgg]},0,Sizzlipede,Joltik,Blipbug]"],
          [:ControlVariable, :CrawliMysteryEgg, :Add, :Constant, 1], # Because 0 is "unchosen", shift by 1
        :Done)
    end

    next choices
  }
}

InjectionHelper.defineMapPatch(69, 3) { |event| # Route 3 megg
  event.patch(:Route3MeggChoices) { |page|
    choices = page.lookForSequence([:ShowText, "Oh man, thanks! Here, you can have this."])

    if choices
      page.insertAfter(choices, 
        [:ShowText, "(Do you want to choose which Pokémon you'll get?)"],
        [:ShowChoices, ["Random", "Choice"], 1],
        [:When, 0, "Random"],
        :Done,
        [:When, 1, "Choice"],
          [:ShowText, "(Which Pokémon do you want?)\\ch[#{Variables[:Route3MysteryEgg]},0,Azurill,Aron,Absol,Togepi,Sneasel,Dhelmise,A-Litwick,Axew,Mienfoo,Pawniard,Trapinch,Hippopotas,Cottonee,Darumaka,Hatenna,Starly,Tyrunt,Larvesta,Mareanie,Stufful,Rookidee]"],
        :Done)
    end

    next choices
  }
}

InjectionHelper.defineMapPatch(69, 3) { |event| # Aevian megg
  event.patch(:AevianMeggChoices) { |page|
    choices = page.lookForSequence([:ShowTextContinued, "Maybe it could be of use to you?"])

    if choices
      page.insertAfter(choices, 
        [:ShowText, "(Do you want to choose which Pokémon you'll get?)"],
        [:ShowChoices, ["Random", "Choice"], 1],
        [:When, 0, "Random"],
        :Done,
        [:When, 1, "Choice"],
          [:ShowText, "(Which Pokémon do you want?)\\ch[#{Variables[:AevianMysteryEgg]},0,A-Magikarp,A-Budew,A-Wimpod,A-Shroomish,A-Larvesta,A-Bronzor,A-Feebas,A-Sigilyph]"],
          [:ControlVariable, :AevianMysteryEgg, :Add, :Constant, 1], # Because 0 is "unchosen", shift by 1
        :Done)
    end

    next choices
  }
}

InjectionHelper.defineMapPatch(199, 75) { |event| # Route 2 megg
  event.patch(:Route2MeggChoices) { |page|
    choices = page.lookForSequence(
      [:ShowChoices, ["Yes", "No"], 2],
      [:When, 0, "Yes"],
      [:When, 1, "No"],
      :BranchEndChoices)

    if choices
      choices[0].parameters[0].push("Change Egg")
      page.insertBefore(choices[3],
        [:When, 2, "Change Egg"],
          [:ShowText, "Which Pokémon do you want?\\ch[#{Variables[:Route2MysteryEgg]},#{page.condition.variable_value + 1},Skiddo,Mudbray,G-Ponyta]"],
        :Done)
    end

    next choices
  }
}
