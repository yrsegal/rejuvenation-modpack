class PokemonMapFactory
  if !defined?(kingleriteHotfix_old_getTerrainTag)
    alias :kingleriteHotfix_old_getTerrainTag :getTerrainTag
  end

  def getTerrainTag(mapid,x,y)
    return 0 if mapid.nil?
    return kingleriteHotfix_old_getTerrainTag(mapid,x,y)
  end
end
