begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

Switches[:ShortedOut] = 60
Switches[:ReusableSwitch1] = 1370
Switches[:ReusableSwitch2] = 1371
Switches[:ReusableSwitch3] = 1372
Switches[:ReusableSwitch4] = 1373
Switches[:ReusableSwitch5] = 1374
Switches[:ReusableSwitch6] = 1375

Variables[:QuestStolenCargo] = 220



module FixFactoryAreas
  def self.patchOceanaPierFieldEffect(event, resetter)
    event.patch(:patchOceanaPierFieldEffect) { |page|
      setShorted = page.lookForAll([:ControlSwitch, :ShortedOut, nil])

      for insn in setShorted
        if resetter
          page.insertBefore(insn, [:ControlVariable, :Forced_BaseField, :Set, :Constant, 0])
        else
          page.insertBefore(insn, [:Script, "$game_variables[:Forced_BaseField] = '#{insn.parameters[2] ? 'ShortCircuit' : 'Factory'}'"])
        end
      end

      next !setShorted.empty?
    }
  end

  def self.patchResetCelgearnFieldEffect(event)
    event.patch(:patchResetCelgearnFieldEffect) { |page|
      resetSwitches = page.lookForAll([:ControlSwitches, :ReusableSwitch1, nil, false]) # Indicates light state
      flipLightsOn = page.lookForAll([:ControlSwitches, :ReusableSwitch1, nil, true])

      for insn in resetSwitches
        page.insertBefore(insn, 
          [:ControlVariable, :Forced_BaseField, :Set, :Constant, 0],
          [:ControlSwitch, :ShortedOut, false])
      end

      for insn in flipLightsOn
        page.insertBefore(insn, 
          [:ControlSwitch, :ShortedOut, true]) # To ensure message sent
      end

      next !resetSwitches.empty? || !flipLightsOn.empty?
    }
  end

  def self.patchCelgearnEntranceRiftBrightness(event)
    event.pages[1].patch(:patchCelgearnEntranceRiftBrightness) { |page|
      setLighting = page.lookForAll([:ChangeScreenColorTone, Tone.new(0,0,0,0), 40])
      flipLightsOn = page.lookForAll([:ControlSwitch, :ReusableSwitch1, true])

      for insn in setLighting
        insn.parameters[0] = Tone.new(-136,-136,-136,0)
        insn.parameters[1] = 0
      end

      for insn in flipLightsOn
        page.insertBefore(insn, [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10])
      end

      next !setLighting.empty? || !flipLightsOn.empty?
    }
  end

  def self.pbFieldDamageElectric
    flashed=false
    for i in $Trainer.party
      if i.hp>0 && !i.isEgg? && !(i.ability == :MAGICGUARD) &&
          !(i.ability == :VOLTABSORB || i.ability == :MOTORDRIVE || i.ability == :LIGHTNINGROD || i.hasType?(:GROUND))
        if !flashed
          $game_screen.start_flash(Color.new(255,0,0,128), 4)
          flashed=true
        end
        next if i.hp==1
        i.hp-=(i.totalhp/8.0).floor
        i.hp=1 if i.hp==0
        pbCheckAllFainted()
      elsif i.ability == :VOLTABSORB
        i.hp+=(i.totalhp/16.0).floor
        i.hp = i.totalhp if i.hp > i.totalhp
      end
    end
  end

  def self.pbFieldDamagePoison
    flashed=false
    for i in $Trainer.party
      if i.hp>0 && !i.isEgg? && !(i.ability == :MAGICGUARD) &&
          !(i.ability == :IMMUNITY || i.ability == :POISONHEAL || i.ability == :PASTELVEIL ||
            (i.species == :ZANGOOSE && i.item == :ZANGCREST) || i.hasType?(:POISON) || i.hasType?(:STEEL))
        if !flashed
          $game_screen.start_flash(Color.new(255,0,0,128), 4)
          flashed=true
        end
        next if i.hp==1
        i.hp-=(i.totalhp/8.0).floor
        i.hp=1 if i.hp==0
        pbCheckAllFainted()
      elsif i.ability == :POISONHEAL
        i.hp+=(i.totalhp/16.0).floor
        i.hp = i.totalhp if i.hp > i.totalhp
      end
    end
  end

  def self.pbFieldDamageFighting
    flashed=false
    for i in $Trainer.party
      if i.hp>0 && !i.isEgg? && !(i.ability == :MAGICGUARD) &&
          !i.hasType?(:GHOST)
        if !flashed
          $game_screen.start_flash(Color.new(255,0,0,128), 4)
          flashed=true
        end
        next if i.hp==1
        i.hp-=(i.totalhp/8.0).floor
        i.hp=1 if i.hp==0
        pbCheckAllFainted()
      end
    end
  end

  def self.patchFieldDamage(event, type)
    event.patch(:patchFieldDamage) { |page|
      fieldDamage = page.lookForAll([:Script, 'pbFieldDamage'])

      for insn in fieldDamage
        insn.parameters[0] = 'FixFactoryAreas.pbFieldDamage' + type
      end

      next !fieldDamage.empty?
    }
  end

  def self.createFactoryMessageEvent(map, x, y)
    map.createSinglePageEvent(x, y, "Factory field event message") { |page|
      page.eventTouch(
        [:ConditionalBranch, :Variable, :QuestStolenCargo, :Constant, 3, :GreaterOrEquals],
          [:Wait, 20],
        :Done,
        [:ShowText, 'The factory is humming away...'],
        [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
        :EraseEvent)
    }
  end

  def self.createCelgearnFieldMessageEvent(map, x, y)
    map.createNewEvent(x, y, "Factory field event message") { |event|
      # If unshorted and lights are off, short
      event.newPage { |page|
        page.autorun(
          [:Script, '$game_variables[:Forced_BaseField] = "ShortCircuit"'],
          [:ShowText, 'The factory went quiet...'],
          [:ControlSwitch, :ShortedOut, true])
      }
      # If shorted out and lights are off, don't do anything
      event.newPage { |page|
        page.requiresSwitch(:ShortedOut)
      }
      # If unshorted and lights are on, don't do anything
      event.newPage { |page|
        page.requiresSwitch(:ReusableSwitch1)
      }
      # If shorted out and lights are on, unshort
      event.newPage { |page|
        page.requiresSwitch(:ReusableSwitch1, :ShortedOut)
        page.autorun(
          [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
          [:ShowText, 'The factory hummed to life...'],
          [:ControlSwitch, :ShortedOut, false])
      }
    }
  end

  def self.createCelgearnFieldToggleEvent(map, x, y)
    map.createNewEvent(x, y, "Field event controller") { |event|
      event.newPage { |page|
        page.runInParallel(
          [:Wait, 5],
          [:ConditionalBranch, :Script, '$game_variables[:Field_Effect_End_Of_Battle] == :FACTORY'],
            [:PlaySoundEvent, 'SlotsCoin', 100, 150],
            [:ChangeScreenColorTone, Tone.new(0, 0, 0), 5],
            [:PlaySoundEvent, 'Exit Door', 80, 60],
            [:ControlSwitch, :ReusableSwitch1, true],
            [:ControlVariable, :Field_Effect_End_Of_Battle, :Set, :Constant, 0],
            [:Wait, 9],
            [:ShowText, 'The factory sparked to life!'],
            [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
            [:ControlSwitch, :ShortedOut, false],
          :Done)
      }

      event.newPage { |page|
        page.requiresSwitch(:ReusableSwitch1)
        page.runInParallel(
          [:Wait, 5],
          [:ConditionalBranch, :Script, '$game_variables[:Field_Effect_End_Of_Battle] == :SHORTCIRCUIT'],
            [:PlaySoundEvent, 'PRSFX- Thunderbolt2', 100, 150],
            [:ChangeScreenColorTone, Tone.new(-136, -136, -136), 10],
            [:PlaySoundEvent, 'Exit Door', 80, 60],
            [:ControlSwitch, :ReusableSwitch1, false],
            [:ControlVariable, :Field_Effect_End_Of_Battle, :Set, :Constant, 0],
            [:Wait, 9],
            [:ShowText, 'The factory shorted out!'],
            [:Script, '$game_variables[:Forced_BaseField] = "ShortCircuit"'],
            [:ControlSwitch, :ShortedOut, true],
          :Done)
      }
    }
  end

  def self.killEvent(event)
    event.patch(:EventIsKill) { |page|
      event.insertAtStart(:ExitEventProcessing)
      next true
    }
  end

  ELECTRICAL_FIELD_DAMAGE_EVENTS = {
    79 => [22, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 49, 56, 57], # Oceana Pier Interiors
    179 => [14], # Tyluric Temple Interiors
    456 => [73, 74, 75, 76, 77, 78, 79, 80, 81], # S.S. Paradise
    616 => [1, 2, 3, 4, 8, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 65, 66, 67, 71, 100, 101, 102] # Celgearn Manufactory
  }

  CELGEARN_AUTOSHUTOFF = [27, 30, 33, 40, 42]

  FIGHTING_FIELD_DAMAGE_EVENTS = {
    461 => [31] # Blacksteeple Playroom
  }
  POISON_FIELD_DAMAGE_EVENTS = {
    484 => [42, 59, 76, 79, 80, 101, 102, 103, 104, 131], # East Gearen Gym
    616 => [10, 23, 24, 29] # Celgearn Manufactory
  }
end

InjectionHelper.defineMapPatch(79) { |map| # Oceana Pier Interiors
  FixFactoryAreas.patchOceanaPierFieldEffect(map.events[23], false) # Field toggler
  FixFactoryAreas.patchOceanaPierFieldEffect(map.events[47], true) # Exit door
  FixFactoryAreas.createFactoryMessageEvent(map, 32, 32)
  next true
}

InjectionHelper.defineMapPatch(616) { |map| # Celgearn Manufactory
  FixFactoryAreas.patchResetCelgearnFieldEffect(map.events[51]) # The rift
  FixFactoryAreas.createCelgearnFieldToggleEvent(map, 6, 4)
  FixFactoryAreas.createCelgearnFieldMessageEvent(map, 6, 3)
  for evtid in FixFactoryAreas::CELGEARN_AUTOSHUTOFF
    FixFactoryAreas.killEvent(map.events[evtid])
  end
}

InjectionHelper.defineMapPatch(111, 120) { |event| # Axis Factory, the rift
  FixFactoryAreas.patchResetCelgearnFieldEffect(event)
  FixFactoryAreas.patchCelgearnEntranceRiftBrightness(event)
}

InjectionHelper.defineMapPatch(21, 40) { |event| # Oceana Pier, entrance to warehouse
  FixFactoryAreas.patchOceanaPierFieldEffect(event, true)
}

InjectionHelper.defineMapPatch(134, 40) { |event| # Neo Oceana Pier, entrance to warehouse
  FixFactoryAreas.patchOceanaPierFieldEffect(event, true)
}

InjectionHelper.defineMapPatch(-1) { |map, mapid| # Apply to all maps
  if FixFactoryAreas::ELECTRICAL_FIELD_DAMAGE_EVENTS[mapid]
    for evtid in FixFactoryAreas::ELECTRICAL_FIELD_DAMAGE_EVENTS[mapid]
      FixFactoryAreas.patchFieldDamage(map.events[evtid], 'Electric')
    end
  end

  if FixFactoryAreas::FIGHTING_FIELD_DAMAGE_EVENTS[mapid]
    for evtid in FixFactoryAreas::FIGHTING_FIELD_DAMAGE_EVENTS[mapid]
      FixFactoryAreas.patchFieldDamage(map.events[evtid], 'Fighting')
    end
  end

  if FixFactoryAreas::POISON_FIELD_DAMAGE_EVENTS[mapid]
    for evtid in FixFactoryAreas::POISON_FIELD_DAMAGE_EVENTS[mapid]
      FixFactoryAreas.patchFieldDamage(map.events[evtid], 'Poison')
    end
  end
}
