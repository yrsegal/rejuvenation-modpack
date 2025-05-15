class MonData < DataObject
  attr_accessor :flags
end

{
  nil => :REDNECTAR,
  "Pom-Pom Style" => :YELLOWNECTAR,
  "Pa'u Style" => :PINKNECTAR,
  "Sensu Style" => :PURPLENECTAR,
}.each do |key,value|
  oricorio = $cache.pkmn[:ORICORIO]
  oricorio = oricorio.formData[key] if key
  oricorio = oricorio.flags if !key
  
  oricorio[:WildItemCommon] = value
  oricorio[:WildItemUncommon] = value
  oricorio[:WildItemRare] = value
end
