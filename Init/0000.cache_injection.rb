class Object
  def wiremods_wrap_method(sym, &block)
    self.class.wiremods_wrap_method(sym, &block)
  end
end

class Module
  
  def wiremods_wrap_method(sym, &block)
    m = instance_method(sym)
    define_method(sym) do |*args, **kwargs|
      instance_exec(m.bind(self), *args, **kwargs, &block)
    end
  end
end

module ModCacheInjection
  @@loaded = []
  @@hooks = {}

  def self.runtimeHook(&block)
    hook(:runtime, &block)
  end

  def self.hook(kind, &block)
    @@hooks[kind] = [] unless @@hooks[kind]
    @@hooks[kind].push(block)
    block.call if @@loaded.include?(kind)
  end

  def self.cacheLoaded(kinds)
    kinds = [kinds] if !kinds.is_a?(Array)
    kinds.each do |kind|
      begin
        @@hooks[kind]&.each(&:call)
        @@loaded.push(kind)
      rescue
        pbPrintException($!)
      end
    end
  end

  def self.createNewForm(mon, formname, idx, form)
    cacheobj = $cache.pkmn[mon]
    if form[:baseForm]
      basedata = cacheobj[form[:baseForm]]
    else
      basedata = cacheobj[0]
    end

    [:species, :form, :name, :dexnum, :Type1, :Type2, :BaseStats, :EVs, :Abilities, 
      :HiddenAbility, :GrowthRate, :GenderRatio, :BaseEXP, :CatchRate, :Happiness, 
      :EggSteps, :EggMoves, :Moveset, :compatiblemoves, :moveexceptions, :shadowmoves, 
      :Color, :EggGroups, :Height, :Weight, :kind, :dexentry, :BattlerPlayerX, 
      :BattlerPlayerY, :BattlerEnemyX, :BattlerEnemyY, :BattlerShadowSize, :BattlerShadowX, 
      :preevo, :evolutions, :MegaEvolutions, :RelearnerMoves, :baseForm, :reward, :shape, 
      :genderDifferences].each do |defKey|
      next if EXCLUSIVE_ATTRS.include?(defKey)
      next if EXCLUSIVE_FLAGS.include?(defKey)
      defValue = basedata.instance_variable_get("@#{defKey}")
      form[defKey] = defValue unless form.has_key?(defKey)
    end

    basedata.flags.each do |defKey, defValue|
      next if EXCLUSIVE_ATTRS.include?(defKey)
      next if EXCLUSIVE_FLAGS.include?(defKey)
      form[defKey] = defValue unless form.has_key?(defKey)
    end

    $cache.pkmn[mon].pokemonData[formname] = MonData.new(mon, formname, form, cacheobj)

    $cache.pkmn[mon].forms[idx] = formname
  end
end

Cache_Game.wiremods_wrap_method(:mainFunction) do |m|
  ModCacheInjection.cacheLoaded(:runtime)
  m.call
end

{
  cacheDex: :pkmn,
  cacheMoves: :moves,
  cacheItems: :items,
  cacheTrainerTypes: :trainertypes,
  cacheTrainers: :trainers,
  cacheAbilities: :abil,
  cacheTypes: :types,
  cacheFields: :FEData,
  cacheFieldNotes: :FENotes,
  cacheBosses: :bosses,
  cacheMapInfos: :mapinfos,
  cacheMapData: :mapdata,
  cacheTownMap: :townmap,
  cacheNatures: :natures,
  cacheConnections: :connections,
  cacheMetadata: :metadata,
  cacheMarts: :marts,
  cacheBTMons: :btmons,
  cacheBTTrainers: :bttrainers,
  cachePokedexes: :pokedexes,
  cacheCurrencies: :currencies,
  cachePasswords: :passwords,
  loadRuntimeData: [:RXanimations, :RXevents, :runtime],
  cacheTilesets: :RXtilesets,
  cacheAnims: [:move2anim, :animations],
}.each do |cacheMethod, cacheKind|
  Cache_Game.wiremods_wrap_method(cacheMethod) do |m|
    m.call.tap do
      ModCacheInjection.cacheLoaded(cacheKind)
    end
  end
end
