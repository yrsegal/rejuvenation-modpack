begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

InjectionHelper.defineMapPatch(199) { |map| # Route 2
  map.events.values.each { |ev|
    if ev.name == "Aip1"
      ev.pages.each { |page|
        page.move_type = InjectionHelper::EVENT_MOVE_TYPES[:Random]
      }
    end
  }
  next true
}
