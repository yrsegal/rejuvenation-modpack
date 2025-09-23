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
  event.patch(:furfrouforms_trimvendor) { |page|
    page.insertBeforeEnd(
      [:ShowText, "\\G" + chartag + startdialogue],
      [:ShowChoices, ["Yes", "No"], 2],
      [:When, 0, "Yes"],
        [:ConditionalBranch, :Money, 2500, :OrMore],
          [:Script,          'pbChoosePokemon(1,3,'],
          [:ScriptContinued, 'proc {|poke|'],
          [:ScriptContinued, ' !poke.egg? &&'],
          [:ScriptContinued, ' !(poke.isShadow? rescue false) &&'],
          [:ScriptContinued, '  poke.species==:FURFROU'],
          [:ScriptContinued, '})'],
          [:ConditionalBranch, :Variable, 1, :Constant, -1, :==],
            [:ShowText, "\\G" + chartag + "Changed your mind? Have a nice day!"],
            :ExitEventProcessing,
          :Else,
            [:ShowText, "\\G" + chartag + "And how should I trim your \\v[3]?\\ch[2,11,Natural Trim,Heart Trim,Star Trim,Diamond Trim,Debutante Trim,Matron Trim,Dandy Trim,La Reine Trim,Kabuki Trim,Pharaoh Trim,Cancel]"],            
            [:ConditionalBranch, :Variable, 2, :Constant, 10, :==],
              [:ShowText, "\\G" + chartag + "Changed your mind? Have a nice day!"],
              :ExitEventProcessing,
            :Done,
            [:Script, "$game_variables[4] = $cache.pkmn[:FURFROU].forms[pbGet(2)]"],
            [:ConditionalBranch, :Script, '$game_variables[2] == pbGetPokemon(1).form'],
              [:ShowText, "\\G" + chartag + "Your \\v[3] is already in its \\v[4]. Want me to touch it up?"],
              [:ShowChoices, ["Yes", "No"], 2],
              [:When, 0, "Yes"],
              :Done,
              [:When, 1, "No"],
                [:ShowText, "\\G" + chartag + "Okay! Have a nice day!"],
                :ExitEventProcessing,
              :Done,
            :Else,
              [:ConditionalBranch, :Variable, 2, :Constant, 0, :==],
                [:ShowText, "\\G" + chartag + "Back to basics, then? Alright!"],
              :Else,
                [:ShowText, "\\G" + chartag + "\\v[4]? Alright!"],
              :Done,
            :Done,
            [:ChangeGold, :Constant, -2500],
            [:ShowText, "\\G" + chartag + "Okay, this will only take a moment..."],
            [:ChangeScreenColorTone, Tone.new(-255, -255, -255, 0), 10],
            [:Script,          'poke=pbGetPokemon(1)'],
            [:ScriptContinued, 'poke.changeHappiness("Regular")'],
            [:ScriptContinued, 'poke.form=pbGet(2)'],
            [:Wait, 22],
            [:PlaySoundEvent, 'Cut', 80, 120],
            [:Wait, 10],
            [:PlaySoundEvent, 'Cut', 80, 150],
            [:Wait, 6],
            [:PlaySoundEvent, 'Cut', 80, 150],
            [:Wait, 22],
            [:ChangeScreenColorTone, Tone.new(0, 0, 0, 0), 10],
            [:Wait, 10],
            [:ShowAnimation, :This, LYRICAL_ANIMATION_ID],
            [:ShowText, chartag + "Done! Your \\v[3] is so adorable in its \\v[4]!"],
            [:ShowText, chartag + "Come back soon!"],
          :Done,
        :Else,
          [:ShowText, "\\G" + chartag + "Sorry, you don't have enough money."],
        :Done,
      :Done,
      [:When, 1, "No"],
        [:ShowText, "\\G" + chartag + "Changed your mind? Have a nice day!"],
      :Done)
    next true
  }
end

InjectionHelper.defineMapPatch(187) { |map| # Everglade Mall
  map.createSinglePageEvent(13, 33, "Furfrou Trimmer") { |page|
    page.setGraphic("trchar020")
    page.interact([:ShowText, "We'll give your Pokemon the best haircut imaginable!"])
    furfrouforms_trimvendor(page)
  }
}

InjectionHelper.defineMapPatch(61, 6) { |event| # East Gearen interiors, Sasha post-quest
  furfrouforms_trimvendor(event, "I'm also training to trim Furfrou! It'll cost $2500 for a session.", "SASHA: ") 
}
InjectionHelper.defineMapPatch(287, 51, &method(:furfrouforms_trimvendor)) # Dream District Interiors, salon employee


# 61, 6 # 
# 187, 41 # 
# 287, 51 # 

