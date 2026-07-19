
ModCacheInjection.hook(:abil) {
  $cache.abil[:BATTLEBOND] = AbilityData.new(:BATTLEBOND, {
    name: "Battle Bond",
    desc: "Raises stats after knocking out a foe...",
    fullDesc: "When the Pokémon knocks out a target, its bond with its Trainer is strengthened, and its Attack, Sp. Atk, and Speed stats are boosted.",
    buildAMonCost: 2
  })
}

ModCacheInjection.hook(:pkmn) {
  ModCacheInjection.createNewForm(:GRENINJA, "Battle Bond Form", 2, {
    :Abilities => [:BATTLEBOND],
    :HiddenAbility => nil,
  })
}

class PokemonLoad
  wiremods_wrap_method(:checkConversions) do |m|
    m.call
    allpokemon = findAllPokemon
    allpokemon.each { |mon|
      # Battle Bond Greninja's form number was changed from 1 to 2 to accomodate Mega Greninja
      mon.form = 2 if mon.species == :GRENINJA && mon.form == 1 && mon.ability == :BATTLEBOND
    }
  end
end
