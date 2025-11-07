begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Variables[:GDCReputation] = 745

$GDC_REPUTATION_PILLARS = true

InjectionHelper.defineMapPatch(294) { # GDC Central
  doneAny = false
  for event in self.events.values
    if event.pages[0].graphic.character_name == 'object_centerpillar' && event.pages[0].graphic.direction == 2
      event.pages[0].direction_fix = true
      event.pages[0].interact {
        show_choices("Check your reputation standings?") {
          choice("Yes") {
            play_se "accesspc"
            text "*CHECKING...*"
            text "Current reputation standings for \\PN: \\v[745]."
            text "Creating evaluation..."
            branch(variables[:GDCReputation], :>=, 700) {
              text "Your reputation ranking is: \\c[1]GOLD STAR!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 600) {
              text "Your reputation ranking is: \\c[1]GOLD STAR!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 500) {
              text "Your reputation ranking is: \\c[1]SILVER STAR!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 400) {
              text "Your reputation ranking is: \\c[1]RISING STAR!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 300) {
              text "Your reputation ranking is: \\c[1]STAR!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 200) {
              text "Your reputation ranking is: \\c[1]BRONZE!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :<=, 100) {
              text "Your reputation ranking is: \\c[1]DUST!"
              exit_event_processing 
            }
            branch(variables[:GDCReputation], :>=, 100) {
              text "Your reputation ranking is: \\c[1]STONE!"
              exit_event_processing 
            }
          }
          default_choice("No") {}
        }
      }
    end
  end
}
