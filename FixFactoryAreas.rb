
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
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :patchOceanaPierFieldEffect) {
        setShorted = InjectionHelper.lookForAll(insns,
            [:ControlSwitch, :ShortedOut, nil])

        for insn in setShorted
          if resetter
            insns.insert(insns.index(insn), InjectionHelper.parseEventCommand(insn.indent, :ControlVariable, :Forced_BaseField, :Set, :Constant, 0))
          else
            insns.insert(insns.index(insn), InjectionHelper.parseEventCommand(insn.indent, :Script, "$game_variables[:Forced_BaseField] = '#{insn.parameters[2] ? 'ShortCircuit' : 'Factory' }'"))
          end
        end

        next setShorted.length > 0
      }
    end
  end

  def self.patchResetCelgearnFieldEffect(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :patchResetCelgearnFieldEffect) {
        resetSwitches = InjectionHelper.lookForAll(insns,
            [:ControlSwitches, :ReusableSwitch1, nil, false]) # Indicates light state
        flipLightsOn = InjectionHelper.lookForAll(insns,
            [:ControlSwitches, :ReusableSwitch1, nil, true])

        for insn in resetSwitches
          insns.insert(insns.index(insn), *InjectionHelper.parseEventCommands(
            [:ControlVariable, :Forced_BaseField, :Set, :Constant, 0],
            [:ControlSwitch, :ShortedOut, false],
            baseIndent: insn.indent))
        end

        for insn in flipLightsOn
          insns.insert(insns.index(insn), *InjectionHelper.parseEventCommands(
            [:ControlSwitch, :ShortedOut, true],
            baseIndent: insn.indent))
        end

        next resetSwitches.length > 0 || flipLightsOn.length > 0
      }
    end
  end

  def self.patchCelgearnEntranceRiftBrightness(event)
    page = event.pages[1] # second page
    insns = page.list
    InjectionHelper.patch(insns, :patchCelgearnEntranceRiftBrightness) {
      setLighting = InjectionHelper.lookForAll(insns,
          [:ChangeScreenColorTone, Tone.new(0,0,0,0), 40])
      flipLightsOn = InjectionHelper.lookForAll(insns,
          [:ControlSwitch, :ReusableSwitch1, true])

      for insn in setLighting
        insn.parameters[0] = Tone.new(-136,-136,-136,0)
        insn.parameters[1] = 0
      end

      for insn in flipLightsOn
        insns.insert(insns.index(insn), *InjectionHelper.parseEventCommands(
          [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
          baseIndent: insn.indent))
      end

      next setLighting.length > 0 || flipLightsOn.length > 0
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
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :patchFieldDamage) {
        fieldDamage = InjectionHelper.lookForAll(insns,
            [:Script, 'pbFieldDamage'])

        for insn in fieldDamage
          insn.parameters[0] = 'FixFactoryAreas.pbFieldDamage' + type
        end

        next fieldDamage.length > 0
      }
    end
  end

  def self.createFactoryMessageEvent(map, x, y)
    maxid = 0
    for id, evt in map.events
      maxid = id if id > maxid
    end

    rawev = RPG::Event.new(x, y)
    rawev.id = maxid + 1
    rawev.pages[0].list = InjectionHelper.parseEventCommands(
      [:ConditionalBranch, :Variable, :QuestStolenCargo, :Constant, 3, :GreaterOrEquals],
        [:Wait, 20],
      :Done,
      [:ShowText, 'The factory is humming away...'],
      [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
      :EraseEvent,
      :Done)
    rawev.pages[0].trigger = 2 # event touch

    map.events[maxid + 1] = rawev
  end

  def self.createCelgearnFieldMessageEvent(map, x, y)
    maxid = 0
    for id, evt in map.events
      maxid = id if id > maxid
    end

    rawev = RPG::Event.new(x, y)
    rawev.pages.push(RPG::Event::Page.new, RPG::Event::Page.new, RPG::Event::Page.new)
    rawev.id = maxid + 1

    # If unshorted and lights are off, short
    rawev.pages[0].list = InjectionHelper.parseEventCommands(
      [:Script, '$game_variables[:Forced_BaseField] = "ShortCircuit"'],
      [:ShowText, 'The factory went quiet...'],
      [:ControlSwitch, :ShortedOut, true],
      :Done)
    rawev.pages[0].trigger = 3 # autorun

    # If shorted out and lights are off, don't do anything
    rawev.pages[1].condition.switch1_valid = true
    rawev.pages[1].condition.switch1_id = Switches[:ShortedOut]

    # If unshorted and lights are on, don't do anything
    rawev.pages[2].condition.switch1_valid = true
    rawev.pages[2].condition.switch1_id = Switches[:ReusableSwitch1]

    # If shorted out and lights are on, unshort
    rawev.pages[3].condition.switch1_valid = true
    rawev.pages[3].condition.switch1_id = Switches[:ReusableSwitch1]
    rawev.pages[3].condition.switch2_valid = true
    rawev.pages[3].condition.switch2_id = Switches[:ShortedOut]
    rawev.pages[3].list = InjectionHelper.parseEventCommands(
      [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
      [:ShowText, 'The factory hummed to life...'],
      [:ControlSwitch, :ShortedOut, false],
      :Done)
    rawev.pages[3].trigger = 3 # autorun

    map.events[maxid + 1] = rawev
  end

  def self.createCelgearnFieldToggleEvent(map, x, y)
    maxid = 0
    for id, evt in map.events
      maxid = id if id > maxid
    end

    rawev = RPG::Event.new(x, y)
    rawev.pages.push(RPG::Event::Page.new)
    rawev.id = maxid + 1
    rawev.pages[0].list = InjectionHelper.parseEventCommands(
      [:Wait, 5],
      [:ConditionalBranch, :Script, '$game_variables[:Field_Effect_End_Of_Battle] == :FACTORY'],
        [:PlaySoundEvent, 'SlotsCoin', 100, 150],
        [:ChangeScreenColorTone, Tone.new(0, 0, 0), 5],
        [:PlaySoundEvent, 'Exit Door', 80, 60],
        [:ControlSwitch, :ReusableSwitch1, true],
        [:Wait, 9],
        [:ShowText, 'The factory sparked to life!'],
        [:Script, '$game_variables[:Forced_BaseField] = "Factory"'],
        [:ControlSwitch, :ShortedOut, true],
      :Done,
      :Done)
    rawev.pages[0].trigger = 4 # parallel process

    rawev.pages[1].condition.switch1_valid = true
    rawev.pages[1].condition.switch1_id = Switches[:ReusableSwitch1]
    rawev.pages[1].list = InjectionHelper.parseEventCommands(
      [:Wait, 5],
      [:ConditionalBranch, :Script, '$game_variables[:Field_Effect_End_Of_Battle] == :SHORTCIRCUIT'],
        [:PlaySoundEvent, 'PRSFX- Thunderbolt2', 100, 150],
        [:ChangeScreenColorTone, Tone.new(-136, -136, -136), 10],
        [:PlaySoundEvent, 'Exit Door', 80, 60],
        [:ControlSwitch, :ReusableSwitch1, false],
        [:Wait, 9],
        [:ShowText, 'The factory shorted out!'],
        [:Script, '$game_variables[:Forced_BaseField] = "ShortCircuit"'],
        [:ControlSwitch, :ShortedOut, true],
      :Done,
      :Done)
    rawev.pages[1].trigger = 4 # parallel process

    map.events[maxid + 1] = rawev
  end

  def self.killEvent(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :EventIsKill) {
        insns.unshift(InjectionHelper.parseEventCommand(0, :ExitEventProcessing))
        next true
      }
    end
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


class Cache_Game
  alias :fixfactoryareas_old_map_load :map_load

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return fixfactoryareas_old_map_load(mapid)
    end

    ret = fixfactoryareas_old_map_load(mapid)

    if mapid == 79 # Oceana Pier Interiors
      FixFactoryAreas.patchOceanaPierFieldEffect(ret.events[23], false) # Field toggler
      FixFactoryAreas.patchOceanaPierFieldEffect(ret.events[47], true) # Exit door
      FixFactoryAreas.createFactoryMessageEvent(ret, 32, 32)
    elsif mapid == 616 # Celgearn Manufactory
      FixFactoryAreas.patchResetCelgearnFieldEffect(ret.events[51]) # The rift
      FixFactoryAreas.createCelgearnFieldToggleEvent(ret, 6, 4)
      FixFactoryAreas.createCelgearnFieldMessageEvent(ret, 6, 3)
      for evtid in FixFactoryAreas::CELGEARN_AUTOSHUTOFF
        FixFactoryAreas.killEvent(ret.events[evtid])
      end
    elsif mapid == 111 # Axis Factory
      FixFactoryAreas.patchResetCelgearnFieldEffect(ret.events[120]) # The rift
      FixFactoryAreas.patchCelgearnEntranceRiftBrightness(ret.events[120])
    elsif mapid == 21 || mapid == 134 # Oceana Pier, Neo Oceana Pier
      FixFactoryAreas.patchOceanaPierFieldEffect(ret.events[40], true) # Entrance to warehouse
    end

    if FixFactoryAreas::ELECTRICAL_FIELD_DAMAGE_EVENTS[mapid]
      for evtid in FixFactoryAreas::ELECTRICAL_FIELD_DAMAGE_EVENTS[mapid]
        FixFactoryAreas.patchFieldDamage(ret.events[evtid], 'Electric')
      end
    end

    if FixFactoryAreas::FIGHTING_FIELD_DAMAGE_EVENTS[mapid]
      for evtid in FixFactoryAreas::FIGHTING_FIELD_DAMAGE_EVENTS[mapid]
        FixFactoryAreas.patchFieldDamage(ret.events[evtid], 'Fighting')
      end
    end

    if FixFactoryAreas::POISON_FIELD_DAMAGE_EVENTS[mapid]
      for evtid in FixFactoryAreas::POISON_FIELD_DAMAGE_EVENTS[mapid]
        FixFactoryAreas.patchFieldDamage(ret.events[evtid], 'Poison')
      end
    end

    return ret
  end
end
