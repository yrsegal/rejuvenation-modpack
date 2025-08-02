
module InjectionHelper
  EVENT_INSNS = {
    Done: 0,
    ShowText: 101,
    ShowTextContinued: 401,
    ShowChoices: 102,
    When: 402,
    WhenCancel: 403,
    BranchEndChoices: 404,
    InputNumber: 103,
    ChangeTextOptions: 104,
    ButtonInputProcessing: 105,
    Wait: 106,
    Comment: 108,
    ConditionalBranch: 111,
    BranchEndConditional: 412,
    Else: 411,
    Loop: 112,
    RepeatAbove: 413,
    BreakLoop: 113,
    ExitEventProcessing: 115,
    EraseEvent: 116,
    CallCommonEvent: 117,
    Label: 118,
    JumpToLabel: 119,
    ControlSwitch: 121, # Handled specially
    ControlSwitches: 121,
    ControlVariable: 122, # Handled specially
    ControlVariables: 122,
    ControlSelfSwitch: 123,
    ControlTimer: 124,
    ChangeGold: 125,
    ChangeItems: 126,
    ChangeWeapons: 127,
    ChangeArmor: 128,
    ChangePartyMember: 129,
    ChangeWindowskin: 131,
    ChangeBattleBackgroundMusic: 132,
    ChangeBattleEndME: 133,
    ChangeSaveAccess: 134,
    ChangeMenuAccess: 135,
    ChangeEncounter: 136,
    TransferPlayer: 201,
    SetEventLocation: 202,
    ScrollMap: 203,
    ChangeMapSettings: 204,
    ChangeFogColorTone: 205,
    ChangeFogOpacity: 206,
    ShowAnimation: 207,
    ChangeTransparentFlag: 208,
    SetMoveRoute: 209,
    SetMoveRouteComment: 509,
    WaitForMovement: 210,
    PrepareForTransition: 221,
    ExecuteTransition: 222,
    ChangeScreenColorTone: 223,
    ScreenFlash: 224,
    ScreenShake: 225,
    ShowPicture: 231,
    MovePicture: 232,
    RotatePicture: 233,
    ChangePictureColorTone: 234,
    ErasePicture: 235,
    SetWeatherEffects: 236,
    PlayBackgroundMusic: 241,
    FadeOutBackgroundMusic: 242,
    PlayBackgroundSound: 245,
    FadeOutBackgroundSound: 246,
    MemorizeBackgroundSound: 247,
    RestoreBackgroundSound: 248,
    PlayMusicEvent: 249,
    PlaySoundEvent: 250,
    StopSoundEvent: 251,
    HealParty: 314,
    IfWin: 601,
    IfEscape: 602,
    IfLose: 603,
    BranchEndBattle: 604,
    CallMenuScreen: 351,
    CallSaveScreen: 352,
    GameOver: 353,
    ReturnToTitleScreen: 354,
    Script: 355,
    ScriptContinued: 655
  }

  MOVE_INSNS = {
    Done: 0,
    MoveDown: 1,
    MoveLeft: 2,
    MoveRight: 3,
    MoveUp: 4,
    MoveDownLeft: 5,
    MoveDownRight: 6,
    MoveUpLeft: 7,
    MoveUpRight: 8,
    MoveRandomly: 9,
    MoveTowardPlayer: 10,
    MoveAwayFromPlayer: 11,
    MoveForward: 12,
    MoveBackward: 13,
    Jump: 14,
    Wait: 15,
    FaceDown: 16,
    FaceLeft: 17,
    FaceRight: 18,
    FaceUp: 19,
    TurnRight: 20,
    TurnLeft: 21,
    TurnAround: 22,
    TurnRandomly: 23,
    FaceRandomly: 24,
    FaceTowardsPlayer: 25,
    FaceAwayFromPlayer: 26,
    SetSwitch: 27,
    UnsetSwitch: 28,
    MoveSpeed: 29,
    MoveFrequency: 30,
    AnimateWalking: 31,
    DontAnimateWalking: 32,
    AnimateSteps: 33,
    DontAnimateSteps: 34,
    FixDirection: 35,
    DontFixDirection: 36,
    SetIntangible: 37,
    SetTangible: 38,
    SetAlwaysForeground: 39,
    UnsetAlwaysForeground: 40,
    SetCharacter: 41,
    SetOpacity: 42,
    BlendType: 43,
    PlaySound: 44,
    Script: 45
  }


  CONDITIONAL_BRANCH_TYPES = {
    Switch: 0,
    Variable: 1,
    SelfSwitch: 2,
    Timer: 3,
    Actor: 4,
    Enemy: 5,
    Character: 6,
    Money: 7,
    Item: 8,
    Weapon: 9,
    Armor: 10,
    Button: 11,
    Script: 12,
  }

  CONDITIONAL_MODES = {
    Equals: 0,
    GreaterOrEquals: 1,
    LessOrEquals: 2,
    Greater: 3,
    Less: 4,
    NotEquals: 5,
  }

  SET_VAR_NAMES = {
    Constant: 0,
    Variable: 1,
    RandomBetween: 2,
    Item: 3,
    Actor: 4,
    Enemy: 5,
    Character: 6,
    Other: 7,
  }

  SET_CHARACTER_VAR_NAMES = {
    x: 0,
    y: 1,
    direction: 2,
    screen_x: 3,
    screen_y: 4,
    terrain_tag: 5,
  }

  SET_OTHER_VAR_NAMES = {
    map_id: 0,
    party_size: 1,
    gold: 2,
    steps: 3,
    play_time: 4,
    timer: 5,
    save_count: 6,
  }

  SET_MODES = {
    Set: 0,
    Add: 1,
    Subtract: 2,
    Multiply: 3,
    Divide: 4,
    Modulus: 5,
  }

  SET_MODES = {
    Set: 0,
    Add: 1,
    Subtract: 2,
    Multiply: 3,
    Divide: 4,
    Modulus: 5,
  }

  FACING_DIRECTIONS = {
    Down: 2,
    Left: 4,
    Right: 6,
    Up: 8,
  }

  APPOINTMENT_METHODS = {
    Constant: 0,
    Variable: 1,
    ExchangeWithEvent: 2
  }

  SPECIAL_EVENT_IDS = {
    Player: -1,
    This: 0
  }

  MORE_OR_LESS = {
    OrMore: 0,
    OrLess: 1
  }

  TRUTH = {
    true => 0,
    false => 1
  }

  EVENT_TRIGGER_TYPES = {
    Interact: 0,
    PlayerTouch: 1,
    EventTouch: 2,
    Autorun: 3,
    RunInParallel: 4
  }

  EVENT_MOVE_TYPES = {
    Fixed: 0,
    Random: 1,
    Approach: 2,
    Custom: 3
  }

  BLEND_TYPES = {
    Normal: 0,
    Additive: 1,
    Subtractive: 2
  }

  BLOCK_TYPES = {
    When: :BranchEndChoices,
    WhenCancel: :BranchEndChoices,
    ConditionalBranch: :BranchEndConditional,
    IfWin: :BranchEndBattle,
    IfEscape: :BranchEndBattle,
    IfLose: :BranchEndBattle,
    Loop: :RepeatAbove
  }

  module EventUtilMixin
    def newPage
      page = RPG::Event::Page.new
      page.extend(PageUtilMixin)
      yield page
      self.pages.push(page)
    end
  end

  module PageUtilMixin
    def setTile(tileid, hueShift: 0, direction: :Down, pattern: 0, opacity: 255, blendType: :Normal)
      self.graphic.tile_id = tileid
      self.graphic.character_hue = hueShift
      self.graphic.direction = InjectionHelper::FACING_DIRECTIONS[direction] || direction
      self.graphic.pattern = pattern
      self.graphic.opacity = opacity
      self.graphic.blend_type = InjectionHelper::BLEND_TYPES[blendType] || blendType
      return self
    end

    def setGraphic(name, hueShift: 0, direction: :Down, pattern: 0, opacity: 255, blendType: :Normal)
      self.graphic.character_name = name
      self.graphic.character_hue = hueShift
      self.graphic.direction = InjectionHelper::FACING_DIRECTIONS[direction] || direction
      self.graphic.pattern = pattern
      self.graphic.opacity = opacity
      self.graphic.blend_type = InjectionHelper::BLEND_TYPES[blendType] || blendType
      return self
    end

    def setMoveType(movetype)
      self.move_type = InjectionHelper::EVENT_MOVE_TYPES[movetype] || movetype
      return self
    end

    def setMoveRoute(*params, repeat: false, skippable: false, wait: false)
      setMoveType(:Custom)
      self.move_route = InjectionHelper.parseMoveRoute(*params, repeat: repeat)
      self.move_route.skippable = skippable
      self.move_route.wait = wait
      return self
    end

    def requiresVariable(varid, value)
      self.condition.variable_valid = true
      self.condition.variable_id = Variables[varid] || varid
      self.condition.variable_value = value
      return self
    end

    def requiresSwitch(switch, switch2=nil)
      self.condition.switch1_valid = true
      self.condition.switch1_id = Switches[switch] || switch
      if switch2
        self.condition.switch2_valid = true
        self.condition.switch2_id = Switches[switch2] || switch2
      end
      return self
    end

    def requiresSelfSwitch(selfswitch)
      self.condition.self_switch_valid = true
      self.condition.self_switch_ch = selfswitch
      return self
    end

    def code(triggerType, *params)
      self.trigger = InjectionHelper::EVENT_TRIGGER_TYPES[triggerType] || triggerType
      self.list = InjectionHelper.parseEventCommands(*params, :Done)
      return self
    end

    def interact(*params)
      code(:Interact, *params)
    end

    def playerTouch(*params)
      code(:PlayerTouch, *params)
    end

    def eventTouch(*params)
      code(:EventTouch, *params)
    end

    def autorun(*params)
      code(:Autorun, *params)
    end

    def runInParallel(*params)
      code(:RunInParallel, *params)
    end
  end

  class InsnMatcher
    def initialize(code, mapper, params=[]) # Param does partial matches - nil is ignored
      @code = code
      @params = params
      @mappedCode = mapper[code]
      @mappedParams = InjectionHelper.handleComplexParameters(code, params, true)
    end

    def matches?(insn)
      return false if insn.code != @mappedCode
      return false if insn.parameters.length != @mappedParams.length

      insn.parameters.each_with_index { |param, idx|
        against = @mappedParams[idx]
        if !against.nil?
          if against.is_a?(Regexp) && param.is_a?(String)
            return false if !against.match?(param)
          elsif against.is_a?(Proc)
            return false if !against.call(param)
          elsif against.is_a?(InsnMatcher)
            return false if !against.matches?(param)
          elsif against.is_a?(Array) && against.size > 0 && against[0].is_a?(InsnMatcher)
            return false if !param.is_a?(RPG::Event::Page) && !param.is_a?(RPG::MoveRoute)
            return false if against.size != param.list.size
            against.each_with_index { |matcher,matcherIdx|
              return false if !matcher.matches?(param.list[matcherIdx])
            }
          else
            return false if against != param
          end
        end
      }

      return true
    end
  end

  @@eventsToLoad = []
  @@anyMapChange = false

  def self.clearEventBuilders
    @@eventsToLoad = []
    @@anyMapChange = false
  end

  def self.applyEventBuilders
    for event, configure in @@eventsToLoad
      configure.call(event)
      event.push(RPG::Event::Page.new) if event.pages.empty? # No pages is a bad thing!
    end
    return !@@eventsToLoad.empty? || @@anyMapChange
  end

  def self.createSinglePageEvent(map, x, y, name, savetag=nil, &block)
    createNewEvent(map, x, y, name, savetag) { |event|
      event.newPage(&block)
    }
  end

  def self.createNewEvent(map, x, y, name, savetag=nil, &block)
    newEvent = RPG::Event.new(x, y)
    newEvent.pages = [] if block_given?
    newEvent.extend(EventUtilMixin)
    newEvent.name = name
    newEvent.id = (map.events.keys.max || 0) + 1
    map.events[newEvent.id] = newEvent

    if savetag && @@currentmapid
      $INJECTED_MAP_EVENTS[@@currentmapid] = {} unless $INJECTED_MAP_EVENTS[@@currentmapid]
      $INJECTED_MAP_EVENTS[@@currentmapid][newEvent.id] = savetag
    end

    if map.is_a?(RPG::Map)
      map.events[newEvent.id] = newEvent
      @@eventsToLoad.push([newEvent, block]) if block_given?
    elsif map.is_a?(Game_Map)
      gameev = Game_Event.new(map.map_id, newEvent, map)
      map.events[newEvent.id] = gameev
      block.call(newEvent) if block_given?
    end

    return newEvent
  end

  def self.fillArea(map, x, y, fill, mapping={})
    fill.each_with_index { |row, rowY|
      row = row.chars if row.is_a?(String)
      row.each_with_index { |value, colX|
        value = mapping[value] if mapping[value]
        if value && value.is_a?(Array) && value.length == 3
          setTile(map, x + colX, y + rowY, *value)
        end
      }
    }
  end    

  def self.fillAreaWithTile(map, x, y, width, height, layer0, layer1, layer2)
    height.times do |rowY|
      width.times do |colX|
        setTile(map, x + colX, y + rowY, layer0, layer1, layer2)
      end
    end
  end

  def self.setTile(map, x, y, layer0, layer1, layer2)
    @@anyMapChange = true
    map.data[x, y, 0] = layer0 if layer0
    map.data[x, y, 1] = layer1 if layer1
    map.data[x, y, 2] = layer2 if layer2
  end

  def self.getPatchComment(insns, create)
    insns.each { |insn|
      if insn.code == InjectionHelper::EVENT_INSNS[:Comment] && insn.parameters[0] == 'InjectionHelper-Patches'
        return insn
      end
    }

    insn = parseEventCommand(0, :Comment, 'InjectionHelper-Patches')
    insns.unshift(insn) if create
    return insn
  end

  def self.markPatched(insns, tag)
    self.getPatchComment(insns, true).parameters.push(tag)
  end

  @@anyPatches = nil

  def self.beginPatch
    @@anyPatches = nil
  end

  def self.endPatch
    @@anyPatches
  end

  def self.patched?(insns, tag)
    return self.getPatchComment(insns, false).parameters.include?(tag)
  end

  def self.patch(insns, tag)
    @@anyPatches = false if @@anyPatches.nil?
    begin
      if !patched?(insns, tag)
        if yield
          @@anyPatches = true
          markPatched(insns, tag)
        end
      end
    rescue
      pbPrintException($!)
      @@anyPatches = true
    end
  end

  def self.routeMatcher(matchers)
    return matchers.map { |matcher| parseMatcher(matcher, InjectionHelper::MOVE_INSNS) }
  end

  def self.parseMatcher(matcher, mapper=InjectionHelper::EVENT_INSNS)
    if matcher.is_a?(Array)
      return InjectionHelper::InsnMatcher.new(matcher[0], mapper, matcher[1..])
    elsif matcher.is_a?(Symbol)
      return InjectionHelper::InsnMatcher.new(matcher, mapper)
    else
      return matcher
    end
  end

  def self.matches?(insn, matcher)
    matcher = parseMatcher(matcher)
    return matcher.matches?(insn)
  end

  def self.lookForSequence(insns, *insnMatchers)
    return [] if !insnMatchers

    insnMatchers = insnMatchers.map(&method(:parseMatcher))

    matches = insnMatchers.map { |matcher| -1 }
    currentTargetIdx = 0
    currentTarget = insnMatchers[0]
    indentLevel = -1

    for insn in insns
      if currentTarget.matches?(insn)
        indentLevel = insn.indent if indentLevel == -1
        next if insn.indent != indentLevel
        matches[currentTargetIdx] = insn

        currentTargetIdx += 1
        break if insnMatchers.length == currentTargetIdx
        currentTarget = insnMatchers[currentTargetIdx]
      end
    end

    return nil if matches.any? { |matched| matched == -1 }
    return matches[0] if matches.length == 1
    return matches
  end

  def self.lookForAll(insns, matcher)
    matcher = parseMatcher(matcher)

    matches = []

    for idx in 0...insns.size
      insn = insns[idx]
      if matcher.matches?(insn)
        matches.push(insn)
      end
    end

    return matches
  end

  def self.mapValue(params, idx, mapper)
    param = params[idx]
    ret = param
    if param.is_a?(Symbol) || [true,false].include?(param)
      params[idx] = mapper[param] if !mapper[param].nil?
    elsif param.is_a?(Numeric)
      ret = mapper.invert[param]
    end

    return ret
  end

  def self.handleComplexParameters(sym, params, matcher=false)
    case sym
      when :SetSwitch, :UnsetSwitch
        mapValue(params, 0, Switches)
      when :SetCharacter
        mapValue(params, 2, InjectionHelper::FACING_DIRECTIONS)
      when :ConditionalBranch
        case mapValue(params, 0, InjectionHelper::CONDITIONAL_BRANCH_TYPES)
          when :Switch
            mapValue(params, 1, Switches)
            mapValue(params, 2, InjectionHelper::TRUTH)
          when :SelfSwitch
            mapValue(params, 2, InjectionHelper::TRUTH)
          when :Variable
            mapValue(params, 1, Variables)
            if mapValue(params, 2, InjectionHelper::APPOINTMENT_METHODS) == :Variable
              mapValue(params, 3, Variables)
            end
            mapValue(params, 4, InjectionHelper::CONDITIONAL_MODES)
          when :Character
            mapValue(params, 1, InjectionHelper::SPECIAL_EVENT_IDS)
            mapValue(params, 2, InjectionHelper::FACING_DIRECTIONS)
          when :Gold
            mapValue(params, 2, InjectionHelper::MORE_OR_LESS)
        end
      when :InputNumber
        mapValue(params, 0, Variables)
      when :ShowAnimation
        mapValue(params, 0, InjectionHelper::SPECIAL_EVENT_IDS)
      when :SetEventLocation
        mapValue(params, 0, InjectionHelper::SPECIAL_EVENT_IDS)
        case mapValue(params, 1, InjectionHelper::APPOINTMENT_METHODS) 
        when :Variable
          mapValue(params, 2, Variables)
          mapValue(params, 3, Variables)
        when :Constant
        else
          mapValue(params, 2, InjectionHelper::SPECIAL_EVENT_IDS)
        end
        mapValue(params, 4, InjectionHelper::FACING_DIRECTIONS)
      when :SetMoveRoute
        mapValue(params, 0, InjectionHelper::SPECIAL_EVENT_IDS)
        if matcher
          params[1] = routeMatcher(params[1][1..]) if !params[1].nil? && params[1].is_a?(Array)
        else
          params[1] = parseMoveRoute(*params[1][1..], repeat: params[1][0]) if !params[1].nil? && params[1].is_a?(Array)
        end
      when :ControlSwitch, :ControlSwitches
        params.unshift(params[0]) if sym == :ControlSwitch
        mapValue(params, 0, Switches)
        mapValue(params, 1, Switches)
        mapValue(params, 2, InjectionHelper::TRUTH)
      when :ControlVariable, :ControlVariables
        params.unshift(params[0]) if sym == :ControlVariable

        mapValue(params, 0, Variables)
        mapValue(params, 1, Variables)
        mapValue(params, 2, InjectionHelper::SET_MODES)
        case mapValue(params, 3, InjectionHelper::SET_VAR_NAMES)
          when :Variable
            mapValue(params, 4, Variables)
          when :Character
            mapValue(params, 4, InjectionHelper::SPECIAL_EVENT_IDS)
            mapValue(params, 5, InjectionHelper::SET_CHARACTER_VAR_NAMES)
          when :Other
            mapValue(params, 4, InjectionHelper::SET_OTHER_VAR_NAMES)
        end
      when :ControlSelfSwitch
        mapValue(params, 1, InjectionHelper::TRUTH)
      when :TransferPlayer
        if mapValue(params, 0, InjectionHelper::APPOINTMENT_METHODS) == :Variable
          mapValue(params, 1, Variables)
          mapValue(params, 2, Variables)
          mapValue(params, 3, Variables)
          mapValue(params, 4, Variables)
        else
          mapValue(params, 4, InjectionHelper::FACING_DIRECTIONS)
        end
        mapValue(params, 5, InjectionHelper::TRUTH)
      when :SetEventLocation
        if mapValue(params, 1, InjectionHelper::APPOINTMENT_METHODS) == :Variable
          mapValue(params, 2, Variables)
          mapValue(params, 3, Variables)
        end
      when :ShowPicture, :MovePicture
        if mapValue(params, 3, InjectionHelper::APPOINTMENT_METHODS) == :Variable
          mapValue(params, 4, Variables)
          mapValue(params, 5, Variables)
        end
      when :PlaySoundEvent, :PlayMusicEvent, :PlayBackgroundMusic, :PlayBackgroundSound, :ChangeBattleBackgroundMusic, :ChangeBattleEndME
        if params[0].is_a?(String)
          audio = params[0]
          volume = 100
          volume = params[1] if params[1].is_a?(Numeric)
          pitch = 100
          pitch = params[2] if params[2].is_a?(Numeric)
          params[0] = RPG::AudioFile.new(audio, volume, pitch)
          params.delete_at(2) if params[2].is_a?(Numeric)
          params.delete_at(1) if params[1].is_a?(Numeric)
        end
    end
    return params
  end

  def self.parseMoveCommand(sym, *params)
    return RPG::MoveCommand.new(InjectionHelper::MOVE_INSNS[sym], handleComplexParameters(sym, params))
  end

  def self.parseMoveRoute(*insns, repeat: false)
    builtInsns = []
    for insn in insns
      sym = nil
      params = []
      if insn.is_a?(Symbol)
        sym = insn
      elsif insn.is_a?(Array)
        sym = insn[0]
        params = insn[1..]
      end

      if sym
        builtInsns.push(parseMoveCommand(sym, *params))
      else
        raise sprintf('Invalid move instruction %s',insn)
      end
    end

    route = RPG::MoveRoute.new
    route.repeat = repeat
    route.list = builtInsns
    return route
  end

  def self.parseEventCommand(indent, sym, *params)
    return RPG::EventCommand.new(InjectionHelper::EVENT_INSNS[sym], indent, handleComplexParameters(sym, params))
  end

  def self.parseEventCommands(*insns, baseIndent: 0)
    builtInsns = []
    currIndent = baseIndent
    blockstack = []
    for insn in insns
      sym = nil
      params = []
      if insn.is_a?(Symbol)
        sym = insn
      elsif insn.is_a?(Array)
        sym = insn[0]
        params = insn[1..]
      elsif insn.is_a?(RPG::EventCommand)
        sym = InjectionHelper::EVENT_INSNS.invert[insn.code]
        params = insn.parameters
      end


      if sym
        if sym == :Else
          builtInsns.push(parseEventCommand(currIndent, :Done))
          currIndent -= 1
        end

        builtInsns.push(parseEventCommand(currIndent, sym, *params))

        if sym == :Done && blockstack.length > 0
          currIndent -= 1
          builtInsns.push(parseEventCommand(currIndent, blockstack.pop()))
        end

        if InjectionHelper::BLOCK_TYPES[sym]
          currIndent += 1
          blockstack.push(InjectionHelper::BLOCK_TYPES[sym])
        elsif sym == :Else
          currIndent += 1
        end
      else
        raise sprintf('Invalid event instruction %s', insn)
      end
    end

    if baseIndent != builtInsns[-1].indent
      raise sprintf('Indents did not line up: expected to end on indent %d, ended on %d',baseIndent,builtInsns[-1].indent)
    end

    return builtInsns
  end

  ### Autopatcher

  APPLIED_PATCHES = []

  PATCHES = {}
  COMMON_PATCHES = {}

  def self.defineMapPatch(mapid, eventid=nil, pageid=nil, &block)
    PATCHES[mapid] = [] unless PATCHES[mapid]
    PATCHES[mapid].push(MapPatch.new(mapid, eventid, pageid, &block))
  end

  def self.defineCommonPatch(eventid, &block)
    COMMON_PATCHES[eventid] = [] unless COMMON_PATCHES[eventid]
    COMMON_PATCHES[eventid].push(CommonEventPatch.new(eventid, &block))
  end

  def self.applyCommonPatches
    $cache.RXevents.each_with_index { |event, eventid|
      if event.is_a?(RPG::CommonEvent)
        event.injectionhelper_restore_list

        if COMMON_PATCHES[eventid]
          for cepatch in COMMON_PATCHES[eventid]
            cepatch.apply(event)
          end
        end
        if COMMON_PATCHES[-1]
          for cepatch in COMMON_PATCHES[-1]
            cepatch.apply(event)
          end
        end
      end
    }
  end

  def self.applyMapPatches(mapid, map)
    begin
      clearEventBuilders
      doneAny = false
      @@currentmapid = mapid
      if PATCHES[mapid]
        for mappatch in PATCHES[mapid]
          if !mappatch.eventid
            doneAny |= mappatch.applyToMap(map, mapid)
          elsif !mappatch.pageid
            doneAny |= mappatch.applyToEvent(map.events[mappatch.eventid])
          else
            doneAny |= mappatch.applyToPage(map.events[mappatch.eventid].pages[mappatch.pageid])
          end
        end
      end

      if PATCHES[-1]
        for mappatch in PATCHES[-1]
          if !mappatch.eventid
            doneAny |= mappatch.applyToMap(map, mapid)
          elsif !mappatch.pageid
            doneAny |= mappatch.applyToEvent(map.events[mappatch.eventid])
          else
            doneAny |= mappatch.applyToPage(map.events[mappatch.eventid].pages[mappatch.pageid])
          end
        end
      end
      doneAny |= applyEventBuilders
    rescue
      pbPrintException($!)
      doneAny = true
    end

    @@currentmapid = nil
    clearEventBuilders

    if doneAny
      APPLIED_PATCHES.push(mapid)
      $PREVIOUS_APPLIED_PATCHES.push(mapid)
    end
  end

  @@currentmapid = nil

  class MapPatch
    attr_reader :mapid, :eventid, :pageid

    def initialize(mapid, eventid, pageid, &block)
      @mapid = mapid
      @eventid = eventid
      @pageid = pageid
      @proc = Proc.new(&block)
    end

    def applyToMap(map, mapid)
      InjectionHelper.beginPatch
      ret = @proc.call(map, mapid)
      endPatch = InjectionHelper.endPatch
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end

    def applyToEvent(event)
      InjectionHelper.beginPatch
      ret = @proc.call(event)
      endPatch = InjectionHelper.endPatch
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end

    def applyToPage(page)
      InjectionHelper.beginPatch
      ret = @proc.call(page)
      endPatch = InjectionHelper.endPatch
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end
  end

  class CommonEventPatch
    attr_reader :eventid

    def initialize(eventid, &block)
      @eventid = eventid
      @proc = Proc.new(&block)
    end

    def apply(event)
      InjectionHelper.beginPatch
      ret = @proc.call(event)
      endPatch = InjectionHelper.endPatch
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end
  end

end

$PREVIOUS_APPLIED_PATCHES = [] if !defined?($PREVIOUS_APPLIED_PATCHES)

# Restore common events from original source

module RPG
  class CommonEvent
    attr_accessor :injectionhelper_original_list

    def injectionhelper_restore_list
      unless injectionhelper_original_list
        injectionhelper_original_list = list
      end

      list = []

      for insn in injectionhelper_original_list
        list.push(RPG::EventCommand.new(insn.code, insn.indent, insn.parameters.clone))
      end
    end
  end
end

# Map Events injected by this library use a secondary selfswitch format 

$INJECTED_MAP_EVENTS = {}
Events.onMapChange+=proc {
  mapid = $game_map.map_id
  mapevs = $INJECTED_MAP_EVENTS[mapid]
  $game_self_switches.injectionhelper_port_oldselfswitches(mapid, mapevs) if mapevs
}

class Game_SelfSwitches
  attr_accessor :injectionhelper_injected_data

  def injectionhelper_port_oldselfswitches(mapid, eventids)
    @injectionhelper_injected_data = {} if !defined?(@injectionhelper_injected_data)

    keystoport = []
    for key in @data.keys
      if key.is_a?(Array) && key.size == 3 && mapid == key[0] && eventids[key[1]]
        keystoport.push(key)
      end
    end

    for key in keystoport
      mappedkey = [key[0], eventids[key[1]], key[2]]
      @injectionhelper_injected_data[mappedkey] = @data[key]
      @data.delete(key)
    end
  end

  alias :injectionhelper_old_initialize :initialize
  def initialize
    injectionhelper_old_initialize
    @injectionhelper_injected_data = {}
  end

  alias :injectionhelper_old_index :[]
  def [](key)
    if defined?(@injectionhelper_injected_data) && key.is_a?(Array) && key.size == 3 && $INJECTED_MAP_EVENTS[key[0]] && $INJECTED_MAP_EVENTS[key[0]][key[1]]
      mappedkey = [key[0], $INJECTED_MAP_EVENTS[key[0]][key[1]], key[2]]
      return @injectionhelper_injected_data[mappedkey] ? true : false
    else
      return injectionhelper_old_index(key)
    end
  end

  alias :injectionhelper_old_set :[]=
  def []=(key, value)
    if key.is_a?(Array) && key.size == 3 && $INJECTED_MAP_EVENTS[key[0]] && $INJECTED_MAP_EVENTS[key[0]][key[1]]
      @injectionhelper_injected_data = {} if !defined?(@injectionhelper_injected_data)

      mappedkey = [key[0], $INJECTED_MAP_EVENTS[key[0]][key[1]], key[2]]
      @injectionhelper_injected_data[mappedkey] = value
    else
      return injectionhelper_old_set(key, value)
    end
  end
end

# Compile after mod load

class Game_System
  alias :injectionhelper_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = injectionhelper_old_initialize(*args, **kwargs)
    InjectionHelper.applyCommonPatches
    return ret
  end
end

def createMinimap(mapid)
  ### MODDED/ warp to map minimap display
  map=$cache.map_load(mapid) rescue (load_data(sprintf("Data/Map%03d.rxdata",mapid)) rescue nil)
  ### /MODDED
  return BitmapWrapper.new(32,32) if !map
  bitmap=BitmapWrapper.new(map.width*4,map.height*4)
  black=Color.new(0,0,0)
  tilesets=load_data("Data/Tilesets.rxdata")
  tileset=tilesets[map.tileset_id]
  return bitmap if !tileset
  helper=TileDrawingHelper.fromTileset(tileset)
  for y in 0...map.height
    for x in 0...map.width
      for z in 0..2
        id=map.data[x,y,z]
        id=0 if !id
        helper.bltSmallTile(bitmap,x*4,y*4,4,4,id)
      end
    end
  end
  bitmap.fill_rect(0,0,bitmap.width,1,black)
  bitmap.fill_rect(0,bitmap.height-1,bitmap.width,1,black)
  bitmap.fill_rect(0,0,1,bitmap.height,black)
  bitmap.fill_rect(bitmap.width-1,0,1,bitmap.height,black)
  return bitmap
end

class Cache_Game
  alias :injectionhelper_old_map_load :map_load
  def map_load(mapid)
    if @cachedmaps && $PREVIOUS_APPLIED_PATCHES.include?(mapid) && !InjectionHelper::APPLIED_PATCHES.include?(mapid)
      @cachedmaps[mapid] = nil
      $PREVIOUS_APPLIED_PATCHES.delete(mapid)
    end

    if @cachedmaps && @cachedmaps[mapid]
      return injectionhelper_old_map_load(mapid)
    end

    ret = injectionhelper_old_map_load(mapid)
    InjectionHelper.applyMapPatches(mapid, ret)
    return ret
  end
end


