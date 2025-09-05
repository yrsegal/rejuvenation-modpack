begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

InjectionHelper.defineMapPatch(474) { |map| # Route Z
  map.createSinglePageEvent(27, 35, "Headbutt Tree") { |page|
    page.interact([:Script, "pbHeadbutt"])
  }
}


InjectionHelper.defineMapPatch(257) { |map| # GDC Scholar's District
  InjectionHelper.fillArea(map, 33, 19, 
    ["   ",
     "___",
     "YGY",
     "RGY",
     "RRG"], 
    {
      ' ' => [nil,  0,    0], # Remove anything above the ground
      '_' => [nil,  3588, 0], # Remove anything above the ground, add a down-facing border
      'R' => [4870, 0,    0], # Remove anything above the ground, replace ground with red flower encounterable grass
      'Y' => [4877, 0,    0], # Remove anything above the ground, replace ground with yellow flower encounterable grass
      'G' => [704,  0,    0], # Remove anything above the ground, replace ground with red flower encounterable grass
    })
}
