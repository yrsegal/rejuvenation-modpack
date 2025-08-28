$cache.pkmn[:VIVILLON].formInit = "proc{rand(10)}" # For serialization reasons, these procs are stored as strings

["Astral Pattern",  "Dream Pattern",   "Tropics Pattern",  "Radiant Pattern",     "Snowy Pattern", 
 "Spotted Pattern", "Garufan Pattern", "Sinister Pattern", "Celebratory Pattern", "Poilethal Pattern"].each_with_index do |pattern, idx|
  $cache.pkmn[:VIVILLON].formData[pattern] = {} if idx > 0
  $cache.pkmn[:VIVILLON].forms[idx] = pattern
end
