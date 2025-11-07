begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:Happiness] = 199

def friendshipcheckers_friendshipchecker(event, startdialogue="Hello! Can I see how well you and your Pokemon are doing?")
  event.patch(:friendshipcheckers_friendshipchecker) {
    insertBeforeEnd {
      text startdialogue
      script "pbChooseNonEggPokemon(1,2)"
      script "poke=pbGetPokemon(1)
              $game_variables[:Happiness] = poke.happiness"
      branch(variables[1], :<, 0) {
        text "Ah, you're busy. Another time then?"
        exit_event_processing 
      }

      branch(variables[:Happiness], :>=, 250) {
        text "Oh... wow. You two are inseparable...!"
      }.else {
        branch(variables[:Happiness], :>=, 220) {
          text "It really trusts you. You must be a great trainer!"
          
        }.else {
          branch(variables[:Happiness], :>=, 150) {
            text "It seems to be liking you more each and every day. Keep at it!"
            
          }.else {
            branch(variables[:Happiness], :>=, 100) {
              text "I think you need to spend more time with it, but I can definitely see this going somewhere!"
              
            }.else {
              branch(variables[:Happiness], :>=, 70) {
                text "This Pokemon... it seems unsure of itself. Please take good care of it."
                
              }.else {
                branch(variables[:Happiness], :>=, 35) {
                  text "Oh my... it seems... worried. Is something the matter?"
                  
                }.else {
                  text "Oh no... it's completely scared. You must cheer it up somehow!"
                }
              }
            }
          }
        }
      }
    }
  }
end

InjectionHelper.defineMapPatch(287, 55) { # Dream District Interiors, salon employee
  friendshipcheckers_friendshipchecker(self, "Want to see if your Pokemon think you're the best of the best?") 
}

InjectionHelper.defineMapPatch(187) { # Everglade Mall
  createSinglePageEvent(7, 33, "Friendship Checker") {
    setGraphic "trchar020 (2)"
    interact
    friendshipcheckers_friendshipchecker(self)
  }
}
