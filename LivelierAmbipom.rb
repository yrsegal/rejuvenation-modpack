begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

InjectionHelper.defineMapPatch(199) { # Route 2
  self.events.values.each { |ev|
    if ev.name == "Aip1"
      ev.pages.each { |page|
        page.move_type = InjectionHelper::EVENT_MOVE_TYPES[:Random]
        InjectionHelper.declarePatched
      }
    end
  }
}
