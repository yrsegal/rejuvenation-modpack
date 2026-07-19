
Switches[:NewTownOrdinance] = 155

module StatusConditionItems
  ITEMS = {
    TOXINCAPSULE: {
      name: "Toxin Capsule",
      desc: "A capsule containing a dilute dose of Toxic. It poisons a Pokémon.",
      afflict: "poisoned",
      status: :POISON,
      battlerCheck: :pbCanPoison?,
      battlerApply: proc { |b| b.pbPoison(b) },
      statusCount: 0,
      immuneAbilities: [:PASTELVEIL, :IMMUNITY],
      immuneTypes: [:POISON, :STEEL]
    },
    FLAREPOWDER: {
      name: "Flare Powder",
      unit: "pile of Flare Powder",
      desc: "A volatile powder that ignites on contact. It burns a Pokémon.",
      afflict: "burned",
      status: :BURN,
      battlerCheck: :pbCanBurn?,
      battlerApply: proc { |b| b.pbBurn(b) },
      statusCount: 0,
      immuneAbilities: [:WATERVEIL, :WATERBUBBLE],
      immuneTypes: [:FIRE]
    },
    PARALYTICCAPSULE: {
      name: "Paralytic Capsule",
      desc: "A capsule containing a mild paralytic. It paralyzes a Pokémon.",
      afflict: "paralyzed",
      status: :PARALYSIS,
      battlerCheck: :pbCanParalyze?,
      battlerApply: proc { |b| b.pbParalyze(b) },
      statusCount: 0,
      immuneAbilities: [:LIMBER],
      immuneTypes: [:ELECTRIC]
    },
    CRYSTALFRAGMENT: {
      name: "Crystal Fragment",
      desc: "A strange shard of NeverMeltIce. It freezes a Pokémon.",
      afflict: "frozen",
      status: :FROZEN,
      battlerCheck: :pbCanPoison?,
      battlerApply: proc { |b| b.pbFreeze },
      statusCount: 0,
      immuneAbilities: [:MAGMAARMOR],
      immuneTypes: [:ICE]
    },
    SLEEPINGDRAUGHT: {
      name: "Sleeping Draught",
      unit: "bottle of Sleeping Draught",
      desc: "A small dose of sedatives. It puts a Pokémon to sleep.",
      afflict: "put to sleep",
      status: :SLEEP,
      battlerCheck: :pbCanSleep?,
      battlerApply: proc { |b| b.pbSleepSelf(3) },
      statusCount: 3,
      immuneAbilities: [:SWEETVEIL, :INSOMNIA, :VITALSPIRIT],
      immuneTypes: [:ICE]
    }
  }

  def self.itemUse(data, item, pokemon, checkTarget, scene)
    checkTarget = pokemon if !checkTarget && pokemon
    if checkTarget.hp<=0 || !checkTarget.status.nil? || data[:immuneAbilities].include?(checkTarget.ability) || data[:immuneTypes].any?(&checkTarget.method(:hasType?)) ||
      (checkTarget.species == :MINIOR && checkTarget.ability == :SHIELDSDOWN && checkTarget.form == 7) || (checkTarget != pokemon && !checkTarget.send(data[:battlerCheck], false))
      scene.pbDisplay(_INTL("It won't have any effect."))
      return false
    else
      pokemon.status=data[:status]
      pokemon.statusCount=data[:statusCount]
      unless [:GUTS, :QUICKFEET, :MARVELSCALE].include?(checkTarget.ability)
        case data[:status]
        when :POISON
          unless [:MAGICGUARD, :TOXICBOOST].include?(checkTarget.ability)
            if checkTarget.ability == :POISONHEAL
              pokemon.changeHappiness("candy")
            else
              pokemon.changeHappiness("powder")
            end
          end
        when :BURN then pokemon.changeHappiness("powder") unless [:MAGICGUARD, :FLAREBOOST].include?(checkTarget.ability)
        else pokemon.changeHappiness("powder")
        end
      end
      data[:battlerApply].call(checkTarget) if checkTarget != pokemon
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} was {2}.", pokemon.name, data[:afflict]))
      return true
    end
  end

  def self.createItems
    ITEMS.each do |item, data| 
      data[:immuneAbilities].push(:COMATOSE, :PURIFYINGSALT)

      $cache.items[item] = ItemData.new(item, {
        name: data[:name],
        unit: data[:unit],
        desc: data[:desc],
        medicine: {},
        price: 200,
      })

      ItemHandlers::UseOnPokemon.add(item,proc{|item, pokemon, scene|
        next itemUse(data, item, pokemon, pokemon, scene)
      })

      ItemHandlers::BattleUseOnPokemon.add(item,proc{|item, pokemon, battler, scene|
        next itemUse(data, item, pokemon, battler, scene)
      })
    end
  end

  def self.createSomniamSeller(map)
    map.createSinglePageEvent(37, 24, "Status Item seller") {
      setGraphic "NPC 22"
      interact {
        branch(variables[:Stamps], :>=, 1) {
          script "showmallstamps_show_window('Status Items',1) if defined?(ShowSomniamMallStamps)"
          script "pbPokemonMart([" + ITEMS.keys.map { |item| ":#{item}" }.join(",") + "])"
          script "showmallstamps_disposefully if defined?(ShowSomniamMallStamps)"
        }
      }
    }
  end

  def self.createGoldenleafSeller(map)
    map.createSinglePageEvent(60, 49, "Status Item seller") {
      setGraphic "trchar072Dark"
      interact {
        script "pbPokemonMart([" + ITEMS.keys.map { |item| ":#{item}" }.join(",") + "],
        $game_switches[:NewTownOrdinance] ?
        _INTL('Sorry about before. I\\'m still selling the items, though.') :
        _INTL('Hey, kid. You should use these on your Pokémon.'))"
      }
    }
  end
end

class PokeBattle_Scene
  alias :conditionitems_old_pbCanUseBattleItem :pbCanUseBattleItem
  def pbCanUseBattleItem(ownerIndex, pkmnid, item, pkmnscreen)
    pokemon = @battle.party1[ownerIndex][pkmnid]
    battler = false
    for i in @battle.battlers
      moncheck = i.pokemon
      if pokemon == moncheck
        battler=i
      end
    end
    return false if battler && (battler.effects[:SkyDrop] || battler.effects[:Embargo]>0)

    if StatusConditionItems::ITEMS[item]
      data = StatusConditionItems::ITEMS[item]
      unless pokemon.hp<=0 || !pokemon.status.nil? || data[:immuneAbilities].include?(pokemon.ability) || data[:immuneTypes].any?(&pokemon.method(:hasType?)) ||
        (pokemon.species == :MINIOR && pokemon.ability == :SHIELDSDOWN && pokemon.form == 7)
        return true
      end
    end

    return conditionitems_old_pbCanUseBattleItem(ownerIndex, pkmnid, item, pkmnscreen)
  end
end

InjectionHelper.defineMapPatch(231) { # Somniam Mall
  StatusConditionItems.createSomniamSeller(self)
}
InjectionHelper.defineMapPatch(82) { # Goldenleaf Town
  StatusConditionItems.createGoldenleafSeller(self)
}

ModCacheInjection.hook(:items) {
  StatusConditionItems.createItems
}
