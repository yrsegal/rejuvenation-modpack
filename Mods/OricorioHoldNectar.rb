class MonData
  attr_writer :flags
end
class ItemData
  attr_writer :flags
end

class PokemonLoad
  alias :wires_startPlayingSaveFile_old :startPlayingSaveFile

  def startPlayingSaveFile(*args, **kwargs)
    ret = wires_startPlayingSaveFile_old(*args, **kwargs)
    
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

    puts "Loaded OricorioHoldNectar."

    return ret
  end
end
