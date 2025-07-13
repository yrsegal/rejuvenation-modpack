ItemHandlers::MultipleAtOnce.push(:REVERSECANDY)
ItemHandlers::UseOnPokemon.add(:REVERSECANDY,proc{|item,pokemon,scene,amount=1|
   if pokemon.level==1 || (pokemon.isShadow? rescue false)
     scene.pbDisplay(_INTL("It won't have any effect."))
     next false, 0
   else
     used = [amount,pokemon.level - 1].min
     pbChangeLevel(pokemon,pokemon.level-used,scene)
     pokemon.changeHappiness("badcandy")
     scene.pbHardRefresh
     next true, used
   end
})
