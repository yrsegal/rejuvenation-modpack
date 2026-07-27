
ModCacheInjection.hook(:abil) {
  $cache.abil[:BATTLEBOND] = AbilityData.new(:BATTLEBOND, {
    name: "Battle Bond",
    desc: "Raises stats after knocking out a foe...",
    fullDesc: "When the Pokémon knocks out a target, its bond with its Trainer is strengthened, and its Attack, Sp. Atk, and Speed stats are boosted.",
    buildAMonCost: 2
  })
}

ModCacheInjection.hook(:pkmn) {
  addFormDataAtRuntime(:GRENINJA, "Battle Bond Form", {
    :Abilities => [:BATTLEBOND],
    :HiddenAbility => nil,
  })
}

class PokemonLoad
  wiremods_wrap_method(:checkConversions) do |m|
    m.call
    allpokemon = findAllPokemon
    allpokemon.each { |mon|
      # Battle Bond Greninja's form number was changed from 1 to accomodate Mega Greninja
      mon.form = $cache.pkmn[:GRENINJA].forms.invert["Battle Bond Form"] if mon.species == :GRENINJA && mon.form == 1 && mon.ability == :BATTLEBOND
    }
  end
end
