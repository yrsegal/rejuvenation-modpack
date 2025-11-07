begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
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
    event.patch(:patchOceanaPierFieldEffect) {
      setShorted = lookForAll([:ControlSwitch, :ShortedOut, nil])

      for insn in setShorted
        if resetter
          insertBefore(insn) {
            variables[:Forced_BaseField] = 0
          }
        else
          insertBefore(insn) {
            script "$game_variables[:Forced_BaseField] = '#{insn.parameters[2] ? 'ShortCircuit' : 'Factory'}'"
          }
        end
      end
    }
  end

  def self.patchResetCelgearnFieldEffect(event)
    event.patch(:patchResetCelgearnFieldEffect) {
      resetSwitches = lookForAll([:ControlSwitches, :ReusableSwitch1, nil, false]) # Indicates light state
      flipLightsOn = lookForAll([:ControlSwitches, :ReusableSwitch1, nil, true])

      for insn in resetSwitches
        insertBefore(insn) {
          variables[:Forced_BaseField] = 0
          switches[:ShortedOut] = false
        }
      end

      for insn in flipLightsOn
        insertBefore(insn) {
          switches[:ShortedOut] = true
        }
      end
    }
  end

  def self.patchCelgearnEntranceRiftBrightness(event)
    event.pages[1].patch(:patchCelgearnEntranceRiftBrightness) {
      setLighting = lookForAll([:ChangeScreenColorTone, Tone.new(0,0,0,0), 40])
      flipLightsOn = lookForAll([:ControlSwitch, :ReusableSwitch1, true])

      for insn in setLighting
        insn[0] = Tone.new(-136,-136,-136,0)
        insn[1] = 0
      end

      for insn in flipLightsOn
        insertBefore(insn) {
          change_tone 0, 0, 0, frames: 10
        }
      end
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
    event.patch(:patchFieldDamage) {
      fieldDamage = lookForAll([:Script, 'pbFieldDamage'])

      for insn in fieldDamage
        insn.parameters[0] = 'FixFactoryAreas.pbFieldDamage' + type
      end
    }
  end

  def self.createFactoryMessageEvent(map, x, y)
    map.createSinglePageEvent(x, y, "Factory field event message") {
      eventTouch {
        branch(variables[:QuestStolenCargo], :>=, 3) {
          wait 20
        }
        text "The factory is humming away..."
        script "$game_variables[:Forced_BaseField] = \"Factory\""
        erase_event 
      }
    }
  end

  def self.createCelgearnFieldMessageEvent(map, x, y)
    map.createNewEvent(x, y, "Factory field event message") {
      # If unshorted and lights are off, short
      newPage {
        autorun {
          script '$game_variables[:Forced_BaseField] = "ShortCircuit"'
          text "The factory went quiet..."
          switches[:ShortedOut] = true
        }
      }
      # If shorted out and lights are off, don't do anything
      newPage { requiresSwitch :ShortedOut }
      # If unshorted and lights are on, don't do anything
      newPage { requiresSwitch :ReusableSwitch1 }

      # If shorted out and lights are on, unshort
      newPage { 
        requiresSwitches :ReusableSwitch1, :ShortedOut
        autorun {
          script '$game_variables[:Forced_BaseField] = "Factory"'
          text "The factory hummed to life..."
          switches[:ShortedOut] = false
        }
      }
    }
  end

  def self.createCelgearnFieldToggleEvent(map, x, y)
    map.createNewEvent(x, y, "Field event controller") {
      newPage {
        runInParallel {
          wait 5
          branch("$game_variables[:Field_Effect_End_Of_Battle] == :FACTORY") {
            play_se "SlotsCoin", 150
            change_tone 0, 0, 0, frames: 5
            play_se "Exit Door", 80, 60
            switches[:ReusableSwitch1] = true
            variables[:Field_Effect_End_Of_Battle] = 0
            wait 9
            text "The factory sparked to life!"
            script '$game_variables[:Forced_BaseField] = "Factory"'
            switches[:ShortedOut] = false
          }


        }
      }

      newPage {
        requiresSwitch :ReusableSwitch1
        runInParallel {
          wait 5
          branch("$game_variables[:Field_Effect_End_Of_Battle] == :SHORTCIRCUIT") {
            play_se "PRSFX- Thunderbolt2", 150
            change_tone -136, -136, -136, frames: 10
            play_se "Exit Door", 80, 60
            switches[:ReusableSwitch1] = false
            variables[:Field_Effect_End_Of_Battle] = 0
            wait 9
            text "The factory shorted out!"
            script '$game_variables[:Forced_BaseField] = "ShortCircuit"'
            switches[:ShortedOut] = true
          }
        }
      }
    }
  end

  def self.killEvent(event)
    event.patch(:EventIsKill) {
      insertAtStart {
        exit_event_processing
      }
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

InjectionHelper.defineMapPatch(79) { # Oceana Pier Interiors
  FixFactoryAreas.patchOceanaPierFieldEffect(self.events[23], false) # Field toggler
  FixFactoryAreas.patchOceanaPierFieldEffect(self.events[47], true) # Exit door
  FixFactoryAreas.createFactoryMessageEvent(self, 32, 32)
}

InjectionHelper.defineMapPatch(616) { # Celgearn Manufactory
  FixFactoryAreas.patchResetCelgearnFieldEffect(self.events[51]) # The rift
  FixFactoryAreas.createCelgearnFieldToggleEvent(self, 6, 4)
  FixFactoryAreas.createCelgearnFieldMessageEvent(self, 6, 3)
  for evtid in FixFactoryAreas::CELGEARN_AUTOSHUTOFF
    FixFactoryAreas.killEvent(self.events[evtid])
  end
}

InjectionHelper.defineMapPatch(111, 120) { # Axis Factory, the rift
  FixFactoryAreas.patchResetCelgearnFieldEffect(self)
  FixFactoryAreas.patchCelgearnEntranceRiftBrightness(self)
}

InjectionHelper.defineMapPatch(21, 40) { # Oceana Pier, entrance to warehouse
  FixFactoryAreas.patchOceanaPierFieldEffect(self, true)
}

InjectionHelper.defineMapPatch(134, 40) { # Neo Oceana Pier, entrance to warehouse
  FixFactoryAreas.patchOceanaPierFieldEffect(self, true)
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
