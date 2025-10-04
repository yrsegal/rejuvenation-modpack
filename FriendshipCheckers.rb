begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Happiness] = 199

def friendshipcheckers_friendshipchecker(event, startdialogue="Hello! Can I see how well you and your Pokemon are doing?")
  event.patch(:friendshipcheckers_friendshipchecker) {|page|
    page.insertBeforeEnd(
      [:ShowText, startdialogue],
      [:Script,          "pbChooseNonEggPokemon(1,2)"],
      [:Script,          "poke=pbGetPokemon(1)"],
      [:ScriptContinued, "$game_variables[:Happiness] = poke.happiness"],
      [:ConditionalBranch, :Variable, 1, :Constant, 0, :<],
        [:ShowText, "Ah, you're busy. Another time then?"],
        :ExitEventProcessing,
      :Done,
      [:ConditionalBranch, :Variable, :Happiness, :Constant, 250, :>=],
        [:ShowText, "Oh... wow. You two are inseparable...!"],
      :Else,
        [:ConditionalBranch, :Variable, :Happiness, :Constant, 220, :>=],
          [:ShowText,          "It really trusts you. You must be a great"],
          [:ShowTextContinued, "trainer!"],
        :Else,
            [:ConditionalBranch, :Variable, :Happiness, :Constant, 150, :>=],
              [:ShowText,          "It seems to be liking you more each and"],
              [:ShowTextContinued, "every day. Keep at it!"],
            :Else,
              [:ConditionalBranch, :Variable, :Happiness, :Constant, 100, :>=],
                [:ShowText,          "I think you need to spend more time with it,"],
                [:ShowTextContinued, "but I can definitely see this going somewhere!"],
              :Else,
                [:ConditionalBranch, :Variable, :Happiness, :Constant, 70, :>=],
                  [:ShowText, "This Pokemon... it seems unsure of itself."],
                  [:ShowTextContinued, "Please take good care of it."],
                :Else,
                  [:ConditionalBranch, :Variable, :Happiness, :Constant, 35, :>=],
                    [:ShowText, "Oh my... it seems... worried. Is something"],
                    [:ShowTextContinued, "the matter?"],
                  :Else,
                    [:ShowText,          "Oh no... it's completely scared. You must"],
                    [:ShowTextContinued, "cheer it up somehow!"],
                  :Done,
                :Done,
              :Done,
            :Done,
        :Done,
      :Done)
  }
end

InjectionHelper.defineMapPatch(287, 55) { |event| # Dream District Interiors, salon employee
  friendshipcheckers_friendshipchecker(event, "Want to see if your Pokemon think you're the best of the best?") 
}

InjectionHelper.defineMapPatch(187) { |map| # Everglade Mall
  map.createSinglePageEvent(7, 33, "Friendship Checker") { |page|
    page.setGraphic("trchar020 (2)")
    page.interact
    friendshipcheckers_friendshipchecker(page)
  }
}
