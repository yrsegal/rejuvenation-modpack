begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

Variables[:GDCReputation] = 745

$GDC_REPUTATION_PILLARS = true

InjectionHelper.defineMapPatch(294) { |map| # GDC Central
  doneAny = false
  for event in map.events.values
    if event.pages[0].graphic.character_name == 'object_centerpillar' && event.pages[0].graphic.direction == 2
      event.pages[0].direction_fix = true
      event.pages[0].interact(
        [:ShowText, "Check your reputation standings?"],
        [:ShowChoices, ["Yes", "No"], 2],
        [:When, 0, "Yes"],
          [:PlaySoundEvent, "accesspc"],
          [:ShowText, "*CHECKING...*"],
          [:ShowText, "Current reputation standings for \\PN: \\v[#{Variables[:GDCReputation]}]."],
          [:ShowText, "Creating evaluation..."],
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 700, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]GOLD STAR!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 600, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]GOLD STAR!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 500, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]SILVER STAR!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 400, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]RISING STAR!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 300, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]STAR!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 200, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]BRONZE!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 100, :LessOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]DUST!"],
            :ExitEventProcessing,
          :Done,
          [:ConditionalBranch, :Variable, :GDCReputation, :Constant, 100, :GreaterOrEquals],
            [:ShowText, "Your reputation ranking is: \\c[1]STONE!"],
            :ExitEventProcessing,
          :Done,
        :Done,
        [:When, 1, "No"],
          # Noop
        :Done)
      doneAny = true
    end
  end
  next doneAny
}
