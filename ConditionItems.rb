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
        desc: data[:desc],
        medicine: true,
        price: 200,
        status: true
      })

      TextureOverrides.registerTextureOverride(TextureOverrides::ICONS + "#{item.to_s.downcase!}", TextureOverrides::MODBASE + "ConditionItems/#{item.to_s.downcase!}")

      ItemHandlers::UseOnPokemon.add(item,proc{|item,pokemon,scene|
        itemUse(data, item, pokemon, pokemon, scene)
      })

      ItemHandlers::BattleUseOnPokemon.add(item,proc{|item,pokemon,battler,scene|
        itemUse(data, item, pokemon, battler, scene)
      })
    end
  end

  def self.createSomniamSeller(map)
    rawev = RPG::Event.new(37, 24)
    rawev.name = "Status Item seller"
    rawev.id = map.events.keys.max + 1

    rawev.pages[0].graphic.direction = 2
    rawev.pages[0].graphic.character_name = "NPC 22"
    rawev.pages[0].trigger = 0 # Action button
    rawev.pages[0].list = InjectionHelper.parseEventCommands(
      [:ConditionalBranch, :Variable, :Stamps, :Constant, 1, :GreaterOrEquals],
        [:Script, "showmallstamps_show_window('Status Items',1) if defined?(ShowSomniamMallStamps)"],
        [:Script, "pbPokemonMart(["],
        *ITEMS.keys.map { |item| [:ScriptContinued, ":#{item},"] },
        [:ScriptContinued, "])"],
        [:Script, 'showmallstamps_disposefully if defined?(ShowSomniamMallStamps)'],
        :Done,
      :Done)

    map.events[rawev.id] = rawev
  end

  def self.createGoldenleafSeller(map)
    rawev = RPG::Event.new(60, 49)
    rawev.name = "Status Item seller"
    rawev.id = map.events.keys.max + 1

    rawev.pages[0].graphic.direction = 2
    rawev.pages[0].graphic.character_name = "trchar072Dark"
    rawev.pages[0].trigger = 0 # Action button
    rawev.pages[0].list = InjectionHelper.parseEventCommands(
      [:ConditionalBranch, :Switch, :NewTownOrdinance, true],
        [:ShowText, "Sorry about before. I'm still selling the items, though."],
      :Else,
        [:ShowText, "Hey, kid. You should use these on your Pokémon."],
      :Done,
      [:Script, "pbPokemonMart(["],
      *ITEMS.keys.map { |item| [:ScriptContinued, ":#{item},"] },
      [:ScriptContinued, "])"],
      :Done)

    map.events[rawev.id] = rawev
  end
end

class PokeBattle_Scene
  alias :conditionitems_old_pbCanUseBattleItem :pbCanUseBattleItem
  def pbCanUseBattleItem(pkmnid, item, pkmnscreen)
    pokemon = @battle.party1[pkmnid]
    battler = false
    for i in @battle.battlers
      moncheck = i.pokemon
      if pokemon == moncheck
        battler=i
      end
    end
    return true if battler && !battler.effects[:SkyDrop] && battler.effects[:Embargo]<=0 && StatusConditionItems::ITEMS[item]
    return conditionitems_old_pbCanUseBattleItem(pkmnid, item, pkmnscreen)
  end
end

InjectionHelper.defineMapPatch(231) { |map| # Somniam Mall
  StatusConditionItems.createSomniamSeller(map)
}
InjectionHelper.defineMapPatch(82) { |map| # Goldenleaf Town
  StatusConditionItems.createGoldenleafSeller(map)
}

StatusConditionItems.createItems
