class PokemonMapFactory
  alias :kingleriteHotfix_old_getTerrainTag :getTerrainTag

  def getTerrainTag(mapid,x,y)
    return 0 if mapid.nil?
    return kingleriteHotfix_old_getTerrainTag(mapid,x,y)
  end
end
