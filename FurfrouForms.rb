begin
  missing = ['0000.textures.rb', '0000.injection.rb','Furfrou'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

# Sprites based on Reborn's
TextureOverrides.registerTextureOverrides({
  TextureOverrides::BATTLER + '676' => TextureOverrides::MODBASE + 'Furfrou/Sprite',
  TextureOverrides::ICONS + 'icon676' => TextureOverrides::MODBASE + 'Furfrou/Icon'
})

["Natural Form",  "Heart Trim",   "Star Trim",     "Diamond Trim", "Debutante Trim", 
 "Matron Trim",   "Dandy Trim",   "La Reine Trim", "Kabuki Trim",  "Pharaoh Trim"  ].each_with_index do |trim, idx|
  $cache.pkmn[:FURFROU].formData[trim] = { EggMoves: $cache.pkmn[:FURFROU].EggMoves } if idx > 0
  $cache.pkmn[:FURFROU].forms[idx] = trim
end

alias :furfrouforms_old_pbGetPreviousForm :pbGetPreviousForm

def pbGetPreviousForm(species,form=0)
  form = 0 if species == :FURFROU
  return furfrouforms_old_pbGetPreviousForm(species,form)
end

LYRICAL_ANIMATION_ID = 18

def furfrouforms_trimvendor(event, startdialogue = "Do you have a Furfrou who needs trimming? It'll cost $2500.", chartag = '')
  event.patch(:furfrouforms_trimvendor) {
    insertBeforeEnd {
      show_choices("\\G#{chartag}#{startdialogue}") {
        choice("Yes") {
          branch(player.gold, :>=, 2500) {
            script 'pbChoosePokemon(1,3,
                    proc {|poke|
                     !poke.egg? &&
                     !(poke.isShadow? rescue false) &&
                     poke.species == :FURFROU
                    })'
            branch(variables[1], :==, -1) {
              text "\\G#{chartag}Changed your mind? Have a nice day!"
              exit_event_processing
            }

            text "\\G#{chartag}And how should I trim your \\v[3]?\\ch[2,11,Natural Trim,Heart Trim,Star Trim,Diamond Trim,Debutante Trim,Matron Trim,Dandy Trim,La Reine Trim,Kabuki Trim,Pharaoh Trim,Cancel]"
            branch(variables[2], :==, 10) {
              text "\\G#{chartag}Changed your mind? Have a nice day!"
              exit_event_processing
            }

            script "$game_variables[4] = $cache.pkmn[:FURFROU].forms[pbGet(2)]"
            
            branch('$game_variables[2] == pbGetPokemon(1).form') {
              show_choices("\\G#{chartag}Your \\v[3] is already in its \\v[4]. Want me to touch it up?") {
                choice("Yes") {}
                default_choice("No") {
                  text "\\G#{chartag}Okay! Have a nice day!"
                  exit_event_processing
                }
              }
            }.else {
              branch(variables[2], :==, 0) {
                text "\\G#{chartag}Back to basics, then? Alright!"
              }.else {
                text "\\G#{chartag}\\v[4]? Alright!"
              }
            }
            player.gold -= 2500

            text "\\G#{chartag}Okay, this will only take a moment..."
            change_tone -255, -255, -255, frames: 10
            script 'poke=pbGetPokemon(1)
                    poke.changeHappiness("Regular")
                    poke.form=pbGet(2)'
            wait 22
            play_se 'Cut', 80, 120
            wait 10
            play_se 'Cut', 80, 150
            wait 6
            play_se 'Cut', 80, 150
            wait 22
            change_tone 0, 0, 0, frames: 10
            wait 10
            this.show_animation(LYRICAL_ANIMATION_ID)
            text "#{chartag}Done! Your \\v[3] is so adorable in its \\v[4]!"
            text "#{chartag}Come back soon!"

          }.else {
            text "\\G#{chartag}Sorry, you don't have enough money."
          }
        }

        default_choice("No") {
          text "\\G#{chartag}Changed your mind? Have a nice day!"
        }
      }
    }
  }
end

InjectionHelper.defineMapPatch(187) { # Everglade Mall
  createSinglePageEvent(13, 33, "Furfrou Trimmer") {
    setGraphic "trchar020"
    interact {
      text "We'll give your Pokemon the best haircut imaginable!"
    }
    furfrouforms_trimvendor(self)
  }
}

InjectionHelper.defineMapPatch(61, 6) { # East Gearen interiors, Sasha post-quest
  furfrouforms_trimvendor(self, "I'm also training to trim Furfrou! It'll cost $2500 for a session.", "SASHA: ") 
}
InjectionHelper.defineMapPatch(287, 51, &method(:furfrouforms_trimvendor)) # Dream District Interiors, salon employee


# 61, 6 # 
# 187, 41 # 
# 287, 51 # 

