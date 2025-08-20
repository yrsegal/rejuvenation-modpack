ItemHandlers::UseOnPokemon.add(:REINSOFUNITY,proc{|item,pokemon,scene|
   if (pokemon.species == :CALYREX) && pokemon.hp>=0
     if pokemon.fused!=nil
       if $Trainer.party.length>=6
         scene.pbDisplay(_INTL("Your party is full! You can't unfuse {1}.",pokemon.name))
         next false
       else
         $Trainer.party[$Trainer.party.length]=pokemon.fused
         pokemon.fused=nil
         pokemon.form=0
         pokemon.initAbility
         pokemon.calcStats
         scene.pbHardRefresh
         scene.pbDisplay(_INTL("{1} transformed!",pokemon.name))
         next true
       end
     else
       chosen=scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
       if chosen>=0
         poke2=$Trainer.party[chosen]
         if (poke2.species == :GLASTRIER || poke2.species == :SPECTRIER) && poke2.hp>=0
           pokemon.form=1 if poke2.species == :GLASTRIER
           pokemon.form=2 if poke2.species == :SPECTRIER
           pokemon.initAbility
           pokemon.calcStats
           pokemon.fused=poke2
           pbRemovePokemonAt(chosen)
           scene.pbHardRefresh
           scene.pbDisplay(_INTL("{1} transformed!",pokemon.name))
           next true
         elsif pokemon==poke2
           scene.pbDisplay(_INTL("{1} can't be fused with itself!",pokemon.name))
         else
           scene.pbDisplay(_INTL("{1} can't be fused with {2}.",poke2.name,pokemon.name))
         end
       else
         next false
       end
     end
   else
     scene.pbDisplay(_INTL("It had no effect."))
     next false
   end
})

$cache.items[:REINSOFUNITY].flags[:legendary] = true
$cache.items[:REINSOFUNITY].flags.delete(:noUse)


$cache.pkmn[:URSHIFU].formData["Rapid Giga Form"][:Type2] = :WATER


$cache.pkmn[:CALYREX].formData["Ice Rider"][:Type1] = :ICE
$cache.pkmn[:CALYREX].formData["Ice Rider"][:Type2] = :PSYCHIC
$cache.pkmn[:CALYREX].formData["Shadow Rider"][:Type1] = :GHOST
$cache.pkmn[:CALYREX].formData["Shadow Rider"][:Type2] = :PSYCHIC
