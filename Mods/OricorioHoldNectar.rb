class MonData
  attr_writer :flags
end
class ItemData
  attr_writer :flags
end

ModCacheInjection.hook(:pkmn) {
  {
    "Baile Style" => :REDNECTAR,
    "Pom-Pom Style" => :YELLOWNECTAR,
    "Pa'u Style" => :PINKNECTAR,
    "Sensu Style" => :PURPLENECTAR,
  }.each do |key,value|
    oricorio = $cache.pkmn[:ORICORIO, key].flags

    oricorio[:WildItemCommon] = value
    oricorio[:WildItemUncommon] = value
    oricorio[:WildItemRare] = value
  end
}

