Variables[:GDCReputation] = 745

$GDC_REPUTATION_PILLARS = true

InjectionHelper.defineMapPatch(294) { |map| # GDC Central
  doneAny = false
  for event in map.events.values
    if event.pages[0].graphic.character_name == 'object_centerpillar' && event.pages[0].graphic.direction == 2
      event.pages[0].trigger = 0
      event.pages[0].direction_fix = true
      event.pages[0].list = InjectionHelper.parseEventCommands(
        [:ShowText, "Check your reputation standings?"],
        [:ShowChoices, ["Yes", "No"], 2],
        [:When, 0, "Yes"],
          [:PlaySoundEvent, RPG::AudioFile.new("accesspc")],
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
        :Done,
      :Done)
      doneAny = true
    end
  end
  next doneAny
}
