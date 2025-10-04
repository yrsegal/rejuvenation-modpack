
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
    TimerOff: 124, # Handled specially
    TimerOn: 124, # Handled specially
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
    Gold: 7, # Alias
    Item: 8,
    Weapon: 9,
    Armor: 10,
    Button: 11,
    Script: 12,
  }

  CONDITIONAL_MODES = {
    Equals: 0,
    :== => 0, 
    GreaterOrEquals: 1,
    :>= => 1, 
    LessOrEquals: 2,
    :<= => 2, 
    Greater: 3,
    :> => 3, 
    Less: 4,
    :< => 4,
    NotEquals: 5, # No equivalent for !=
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
    :[]= => 0,
    Add: 1,
    :+ => 1,
    Subtract: 2,
    :- => 2,
    Multiply: 3,
    :* => 3,
    Divide: 4,
    :/ => 4,
    Modulus: 5,
    :% => 5,
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

  SUBTRACT_MODE = {
    Add: 0,
    :+ => 0,
    Subtract: 1,
    :- => 1,
  }

  MORE_OR_LESS = {
    OrMore: 0,
    :>= => 0,
    OrLess: 1,
    :<= => 1,
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
      event.pages = []
      configure.call(event)
      event.pages.push(RPG::Event::Page.new) if event.pages.empty? # No pages is a bad thing!
    end
    return !@@eventsToLoad.empty? || @@anyMapChange
  end

  def self.processEventBuilders
    result = applyEventBuilders
    clearEventBuilders
    return result
  end

  def self.createSinglePageEvent(map, x, y, name, savetag=nil, &block)
    createNewEvent(map, x, y, name, savetag) { |event|
      event.newPage(&block)
    }
  end

  def self.createNewEvent(map, x, y, name, savetag=nil, &block)
    newEvent = RPG::Event.new(x, y)
    newEvent.name = name
    newEvent.id = (map.events.keys.max || 0) + 1
    map.events[newEvent.id] = newEvent

    if savetag && @@currentmapid
      INJECTED_MAP_EVENT_IDS[@@currentmapid] = {} unless INJECTED_MAP_EVENT_IDS[@@currentmapid]
      INJECTED_MAP_EVENT_IDS[@@currentmapid][newEvent.id] = savetag
    end

    if map.is_a?(RPG::Map)
      map.events[newEvent.id] = newEvent
      @@eventsToLoad.push([newEvent, block]) if block_given?
    elsif map.is_a?(Game_Map)
      gameev = Game_Event.new(map.map_id, newEvent, map)
      map.events[newEvent.id] = gameev
      newEvent.pages = [] if block_given?
      block.call(newEvent) if block_given?
      newEvent.pages.push(RPG::Event::Page.new) if newEvent.pages.empty? # No pages is a bad thing!
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
      if insn.command == :Comment && insn.parameters[0] == 'InjectionHelper-Patches'
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

  def self.declarePatched
    @@anyPatches = true
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
        yield # Declare patches explicitly now
        markPatched(insns, tag) if @@anyPatches
      end
    rescue
      pbPrintException($!)
      @@anyPatches = true
    end
  end

  def self.routeMatcher(matchers)
    return matchers.map { |matcher| parseMatcher(matcher, MOVE_INSNS) }
  end

  def self.parseMatcher(matcher, mapper=EVENT_INSNS)
    if matcher.is_a?(Array)
      return InsnMatcher.new(matcher[0], mapper, matcher[1..])
    elsif matcher.is_a?(Symbol)
      return InsnMatcher.new(matcher, mapper)
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

  def self.mapSwitch(params, idx)
    param = params[idx]
    params[idx] = SCRIPT_SWITCHES[param] if param.is_a?(String) && SCRIPT_SWITCHES[param]
    return mapValue(params, idx, Switches)
  end

  def self.mapVariable(params, idx)
    param = params[idx]
    params[idx] = SCRIPT_VARIABLES[param] if param.is_a?(String) && SCRIPT_VARIABLES[param]
    return mapValue(params, idx, Variables)
  end

  def self.handleComplexParameters(sym, params, matcher=false)
    case sym
      when :SetSwitch, :UnsetSwitch
        mapSwitch(params, 0)
      when :SetCharacter
        mapValue(params, 2, FACING_DIRECTIONS)
      when :ConditionalBranch
        case mapValue(params, 0, CONDITIONAL_BRANCH_TYPES)
          when :Switch
            mapSwitch(params, 1)
            mapValue(params, 2, TRUTH)
          when :SelfSwitch
            mapValue(params, 2, TRUTH)
          when :Variable
            mapVariable(params, 1)
            if mapValue(params, 2, APPOINTMENT_METHODS) == :Variable
              mapVariable(params, 3)
            end
            mapValue(params, 4, CONDITIONAL_MODES)
          when :Character
            mapValue(params, 1, SPECIAL_EVENT_IDS)
            mapValue(params, 2, FACING_DIRECTIONS)
          when :Money, :Gold
            mapValue(params, 2, MORE_OR_LESS)
        end
      when :InputNumber
        mapVariable(params, 0)
      when :ShowAnimation
        mapValue(params, 0, SPECIAL_EVENT_IDS)
      when :SetEventLocation
        mapValue(params, 0, SPECIAL_EVENT_IDS)
        case mapValue(params, 1, APPOINTMENT_METHODS) 
        when :Variable
          mapVariable(params, 2)
          mapVariable(params, 3)
        when :Constant
        else
          mapValue(params, 2, SPECIAL_EVENT_IDS)
        end
        mapValue(params, 4, FACING_DIRECTIONS)
      when :SetMoveRoute
        mapValue(params, 0, SPECIAL_EVENT_IDS)
        if matcher
          params[1] = routeMatcher(params[1][1..]) if !params[1].nil? && params[1].is_a?(Array)
        else
          params[1] = parseMoveRoute(*params[1][1..], repeat: params[1][0]) if !params[1].nil? && params[1].is_a?(Array)
        end
      when :ControlSwitch, :ControlSwitches
        params.unshift(params[0]) if sym == :ControlSwitch
        mapSwitch(params, 0)
        mapSwitch(params, 1)
        mapValue(params, 2, TRUTH)
      when :ControlVariable, :ControlVariables
        params.unshift(params[0]) if sym == :ControlVariable

        mapVariable(params, 0)
        mapVariable(params, 1)
        mapValue(params, 2, SET_MODES)
        case mapValue(params, 3, SET_VAR_NAMES)
          when :Variable
            mapVariable(params, 4)
          when :Character
            mapValue(params, 4, SPECIAL_EVENT_IDS)
            mapValue(params, 5, SET_CHARACTER_VAR_NAMES)
          when :Other
            mapValue(params, 4, SET_OTHER_VAR_NAMES)
        end
      when :ControlSelfSwitch
        mapValue(params, 1, TRUTH)
      when :ChangeGold
        if params.size == 2 && params[1].is_a?(Numeric)
          amount = params[1]
          params[1] = amount.abs
          params.unshift(amount.negative? ? :- : :+)
        end

        mapValue(params, 0, SUBTRACT_MODE)
        if mapValue(params, 1, APPOINTMENT_METHODS) == :Variable
          mapVariable(params, 2)
        end
      when :TransferPlayer
        if mapValue(params, 0, APPOINTMENT_METHODS) == :Variable
          mapVariable(params, 1)
          mapVariable(params, 2)
          mapVariable(params, 3)
        end
        mapValue(params, 4, FACING_DIRECTIONS)
        mapValue(params, 5, TRUTH)
      when :SetEventLocation
        if mapValue(params, 1, APPOINTMENT_METHODS) == :Variable
          mapVariable(params, 2)
          mapVariable(params, 3)
        end
      when :ScrollMap
        mapValue(params, 0, FACING_DIRECTIONS)
      when :ShowPicture, :MovePicture
        if mapValue(params, 3, APPOINTMENT_METHODS) == :Variable
          mapVariable(params, 4)
          mapVariable(params, 5)
        end
      when :ControlTimer, :TimerOn, :TimerOff
        params.unshift(true) if sym == :TimerOn && params.size == 1
        params.unshift(false) if sym == :TimerOff && params.size == 0
        mapValue(params, 0, TRUTH)
      when :PlaySoundEvent, :PlayMusicEvent, :PlayBackgroundMusic, :PlayBackgroundSound, :ChangeBattleBackgroundMusic, :ChangeBattleEndME, :PlaySound
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
    return RPG::MoveCommand.new(MOVE_INSNS[sym], handleComplexParameters(sym, params))
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
    return RPG::EventCommand.new(EVENT_INSNS[sym], indent, handleComplexParameters(sym, params))
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
        sym = EVENT_INSNS.invert[insn.code]
        params = insn.parameters
      end


      if sym
        if sym == :Else
          builtInsns.push(parseEventCommand(currIndent, :Done))
          currIndent -= 1
        end

        builtInsns.push(parseEventCommand(currIndent, sym, *params))

        if sym == :Done && !blockstack.empty?
          currIndent -= 1
          builtInsns.push(parseEventCommand(currIndent, blockstack.pop()))
        end

        if BLOCK_TYPES[sym]
          currIndent += 1
          blockstack.push(BLOCK_TYPES[sym])
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

  ### Map Creation

  CREATE_MAPS = {}
  MAP_ID_ASSIGNMENTS = {}

  def self.mapIdForSavetag(savetag)
    MAP_ID_ASSIGNMENTS[savetag]
  end

  def self.defineNewMap(savetag, width, height, name, parent, meta, &block)
    CREATE_MAPS[savetag] = [width, height, name, parent, meta, block]
  end

  def self.assignMapIDs
    return if CREATE_MAPS.empty?

    openids = []
    for i in 1..999
      openids.push(i) if !pbRgssExists?(sprintf("Data/Map%03d.rxdata",i))
      break if openids.size >= CREATE_MAPS.size
    end

    if openids.size < CREATE_MAPS.size
      raise "Not enough free Map IDs! Needed #{CREATE_MAPS.size}, found #{openids.size}"
    end

    for savetag in CREATE_MAPS.keys
      mapid = openids.shift
      MAP_ID_ASSIGNMENTS[savetag] = mapid

      width, height, name, parent, meta, block = CREATE_MAPS[savetag]
      newmapinfo = RPG::MapInfo.new
      newmapinfo.parent_id = parent if parent.is_a?(Numeric)
      newmapinfo.parent_id = MAP_ID_ASSIGNMENTS[parent] if parent.is_a?(String)
      newmapinfo.name = name
      newmapmeta = MapMetadata.new(mapid, meta, meta) # Encounters and meta merged

      $cache.mapinfos[mapid] = newmapinfo
      $cache.mapdata[mapid] = newmapmeta
    end
  end

  def self.createMap(mapid)
    begin
      savetag = MAP_ID_ASSIGNMENTS.invert[mapid]
      INJECTED_MAP_IDS[mapid] = savetag
      $PREVIOUS_APPLIED_PATCHES.push(mapid)
      APPLIED_PATCHES.push(mapid)

      width, height, name, parent, meta, block = CREATE_MAPS[savetag]
      newmap = RPG::Map.new(width, height)

      clearEventBuilders
      block.call(newmap)
      processEventBuilders

      if meta[:FlyData]
        mappos = newmap.MapPosition
        if mappos
          loc = mappos[1...]
          if $cache.town_map[loc].region == mappos[0]
            $cache.town_map[loc].flyData = [mapid, x, y]
            $cache.mapdata[map].HealingSpot = [mapid, x, y]
          end
        end
      end
      return newmap
    rescue
      clearEventBuilders
      raise $!
    end
  end

  ### Alternate selfswitch format storage

  INJECTED_MAP_IDS = {}
  INJECTED_MAP_EVENT_IDS = {}

  ### Script-switch and script-variable registration

  SCRIPT_SWITCHES = {}
  SCRIPT_VARIABLES = {}

  def self.registerScriptSwitch(code)
    unless SCRIPT_SWITCHES[code]
      SCRIPT_SWITCHES[code] = -1
    end
  end

  def self.registerScriptVariable(code)
    unless SCRIPT_VARIABLES[code]
      SCRIPT_VARIABLES[code] = -1
    end
  end

  def self.getScriptSwitch(code)
    return SCRIPT_SWITCHES[code]
  end

  def self.getScriptVariable(code)
    return SCRIPT_VARIABLES[code]
  end

  def self.assignScriptSwitches
    return if SCRIPT_SWITCHES.empty?

    openids = []
    for i in 1...$cache.RXsystem.switches.size
      switchname = $cache.RXsystem.switches[i]
      openids.push(i) if !switchname || switchname.empty?
      if switchname && switchname[/^s\:/]
        code = $~.post_match
        if SCRIPT_SWITCHES[code] == -1
          SCRIPT_SWITCHES[code] = i
        end
      end
      break if openids.size >= SCRIPT_SWITCHES.size
    end

    if openids.size < SCRIPT_SWITCHES.size
      raise "Not enough free switches! Needed #{SCRIPT_SWITCHES.size}, found #{openids.size}"
    end

    for code, sw in SCRIPT_SWITCHES
      if sw == -1
        sw = openids.shift
        $cache.RXsystem.switches[sw] = "s:#{code}"
        SCRIPT_SWITCHES[code] = sw
      end
    end
  end

  def self.assignScriptVariables
    return if SCRIPT_VARIABLES.empty?

    openids = []
    for i in 1...$cache.RXsystem.variables.size
      varname = $cache.RXsystem.variables[i]
      openids.push(i) if !varname || varname.empty?
      if varname && varname[/^s\:/]
        code = $~.post_match
        if SCRIPT_VARIABLES[code] == -1
          SCRIPT_VARIABLES[code] = i
        end
      end
      break if openids.size >= SCRIPT_VARIABLES.size
    end

    if openids.size < SCRIPT_VARIABLES.size
      raise "Not enough free variables! Needed #{SCRIPT_VARIABLES.size}, found #{openids.size}"
    end

    for code, vr in SCRIPT_VARIABLES
      if vr == -1
        vr = openids.shift
        $cache.RXsystem.variables[vr] = "s:#{code}"
        SCRIPT_VARIABLES[code] = vr
      end
    end
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

      if INJECTED_MAP_IDS[mapid] && PATCHES[INJECTED_MAP_IDS[mapid]]
        for mappatch in PATCHES[INJECTED_MAP_IDS[mapid]]
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
      InjectionHelper.clearEventBuilders
      InjectionHelper.beginPatch
      ret = @proc.call(map, mapid)
      endPatch = InjectionHelper.endPatch
      return true if InjectionHelper.processEventBuilders
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end

    def applyToEvent(event)
      InjectionHelper.clearEventBuilders
      InjectionHelper.beginPatch
      ret = @proc.call(event)
      endPatch = InjectionHelper.endPatch
      return true if InjectionHelper.processEventBuilders
      return endPatch unless endPatch.nil? || ret == true
      return ret
    end

    def applyToPage(page)
      InjectionHelper.clearEventBuilders
      InjectionHelper.beginPatch
      ret = @proc.call(page)
      endPatch = InjectionHelper.endPatch
      return true if InjectionHelper.processEventBuilders
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

Events.onMapChange+=proc {
  mapid = $game_map.map_id
  mapevs = InjectionHelper::INJECTED_MAP_EVENT_IDS[mapid]
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
    if defined?(@injectionhelper_injected_data) && key.is_a?(Array) && key.size == 3 && 
       ((key[0].is_a?(String) || key[1].is_a?(String)) ||
        (InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]] && InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]) ||
        InjectionHelper::INJECTED_MAP_IDS[key[0]])
      mappedkey = [*key]
      if InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]] && InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]
        mappedkey[1] = InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]
      end
      if InjectionHelper::INJECTED_MAP_IDS[key[0]]
        mappedkey[0] = InjectionHelper::INJECTED_MAP_IDS[key[0]]
      end
      return @injectionhelper_injected_data[mappedkey] ? true : false
    else
      return injectionhelper_old_index(key)
    end
  end

  alias :injectionhelper_old_set :[]=
  def []=(key, value)
    if key.is_a?(Array) && key.size == 3 && 
       ((key[0].is_a?(String) || key[1].is_a?(String)) ||
        (InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]] && InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]) ||
        InjectionHelper::INJECTED_MAP_IDS[key[0]])
      @injectionhelper_injected_data = {} if !defined?(@injectionhelper_injected_data)

      mappedkey = [*key]
      if InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]] && InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]
        mappedkey[1] = InjectionHelper::INJECTED_MAP_EVENT_IDS[key[0]][key[1]]
      end
      if InjectionHelper::INJECTED_MAP_IDS[key[0]]
        mappedkey[0] = InjectionHelper::INJECTED_MAP_IDS[key[0]]
      end
      @injectionhelper_injected_data[mappedkey] = value
    else
      return injectionhelper_old_set(key, value)
    end
  end
end

# Utils for creating/injecting into maps and events

module EventListHolder
  def patch(tag, &block)
    InjectionHelper.patch(self.list, tag) { block.call(self) }
  end

  def patched?(tag)
    InjectionHelper.patched?(self.list, tag)
  end

  def lookForSequence(*insnMatchers)
    InjectionHelper.lookForSequence(self.list, *insnMatchers)
  end

  def lookForAll(matcher)
    InjectionHelper.lookForAll(self.list, matcher)
  end

  def idxOf(insn)
    self.list.index(insn)
  end

  def [](*args, **kwargs)
    self.list[*args, **kwargs]
  end

  def []=(*args, **kwargs)
    InjectionHelper.declarePatched
    self.list.send(:[]=, *args, **kwargs)
  end

  def insertAtStart(*commands)
    InjectionHelper.declarePatched
    self.unshift(*InjectionHelper.parseEventCommands(*commands))
  end

  def insertBefore(insn, *commands)
    InjectionHelper.declarePatched
    insn = self[insn] if insn.is_a?(Numeric)

    self.insert(self.idxOf(insn), *InjectionHelper.parseEventCommands(*commands, baseIndent: insn.indent))
  end

  def insertBeforeEnd(*commands)
    InjectionHelper.declarePatched
    locations = self.lookForAll(:ExitEventProcessing) + [self[-1]]
    for location in locations
      self.insertBefore(location, *commands)
    end
  end

  def insertAfter(insn, *commands)
    InjectionHelper.declarePatched
    insn = self[insn] if insn.is_a?(Numeric)

    blockdepth = insn.indent
    blockdepth += 1 if InjectionHelper::BLOCK_TYPES[InjectionHelper::EVENT_INSNS.invert[insn.code]]
    blockdepth += 1 if InjectionHelper::EVENT_INSNS.invert[insn.code] == :Else
    self.insert(self.idxOf(insn) + 1, *InjectionHelper.parseEventCommands(*commands, baseIndent: blockdepth))
  end

  def replace(insn, *commands)
    InjectionHelper.declarePatched
    insn = self[insn] if insn.is_a?(Numeric)
    self.insertBefore(insn, *commands)
    self.delete(insn)
    return self
  end

  def replaceRange(insn1, insn2, *commands)
    InjectionHelper.declarePatched
    insn1 = self[insn1] if insn1.is_a?(Numeric)
    insn2 = self[insn2] if insn1.is_a?(Numeric)
    self[self.idxOf(insn1)..self.idxOf(insn2)] = InjectionHelper.parseEventCommands(*commands, baseIndent: insn1.indent)
  end

  def swap(rangeA1, rangeA2, rangeB1, rangeB2)
    InjectionHelper.declarePatched
    rangeA1 = self[rangeA1] if rangeA1.is_a?(Numeric)
    rangeA2 = self[rangeA2] if rangeA2.is_a?(Numeric)
    rangeB1 = self[rangeB1] if rangeB1.is_a?(Numeric)
    rangeB2 = self[rangeB2] if rangeB2.is_a?(Numeric)

    sectionA = self[self.idxOf(rangeA1)..self.idxOf(rangeA2)]
    sectionB = self[self.idxOf(rangeB1)..self.idxOf(rangeB2)]
    tempMrk = "Temporary Marker"

    self[self.idxOf(rangeB1)..self.idxOf(rangeB2)] = [tempMrk]
    self[self.idxOf(rangeA1)..self.idxOf(rangeA2)] = sectionB
    self[self.idxOf(tempMrk)..self.idxOf(tempMrk)] = sectionA
  end

  def reformat(*commands)
    InjectionHelper.declarePatched
    self.list.clear()
    self.list.push(*InjectionHelper.parseEventCommands(*commands, :Done))
  end

  def insert(*args, **kwargs)
    InjectionHelper.declarePatched
    self.list.insert(*args, **kwargs)
  end

  def unshift(*args, **kwargs)
    InjectionHelper.declarePatched
    self.list.unshift(*args, **kwargs)
  end

  def delete(*args, **kwargs)
    InjectionHelper.declarePatched
    self.list.delete(*args, **kwargs)
  end

  def delete_at(*args, **kwargs)
    InjectionHelper.declarePatched
    self.list.delete_at(*args, **kwargs)
  end

  def size
    self.list.size
  end

  def length
    self.list.length
  end
end

module RPG

  class Map
    def setBGS(sound, volume=100, pitch=100, autoplay: true)
      self.bgs = RPG::AudioFile.new(sound, volume, pitch)
      self.autoplay_bgs = autoplay
      return self
    end

    def setBGM(sound, volume=100, pitch=100, autoplay: true)
      self.bgm = RPG::AudioFile.new(sound, volume, pitch)
      self.autoplay_bgm = autoplay
      return self
    end

    def setTileset(tileset_id)
      self.tileset_id = tileset_id
      return self
    end

    def createNewEvent(x, y, name, savetag=nil, &block)
      InjectionHelper.createNewEvent(self, x, y, name, savetag, &block)
    end

    def createSinglePageEvent(x, y, name, savetag=nil, &block)
      InjectionHelper.createSinglePageEvent(self, x, y, name, savetag, &block)
    end

    def fillArea(x, y, fill, mapping={})
      InjectionHelper.fillArea(self, x, y, fill, mapping)
      return self
    end

    def fillAreaWithTile(x, y, width, height, layer0, layer1, layer2)
      InjectionHelper.fillAreaWithTile(self, x, y, width, height, layer0, layer1, layer2)
      return self
    end

    def setTile(x, y, layer0, layer1, layer2)
      InjectionHelper.setTile(self, x, y, layer0, layer1, layer2)
      return self
    end

    def patch(tag, &block)
      for event in self.events.values
        event.patch(tag, &block)
      end
    end
  end

  class CommonEvent
    include EventListHolder
  end

  class EventCommand
    def command
      return InjectionHelper::EVENT_INSNS.invert[@code]
    end

    def [](*args)
      parameters.[] *args
    end

    def []=(*args)
      InjectionHelper.declarePatched
      parameters.[]= *args
    end
  end

  class MoveCommand
    def command
      return InjectionHelper::MOVE_INSNS.invert[@code]
    end

    def [](*args)
      parameters.[] *args
    end

    def []=(*args)
      InjectionHelper.declarePatched
      parameters.[]= *args
    end
  end

  class Event

    def newPage
      page = RPG::Event::Page.new
      yield page
      self.pages.push(page)
    end

    def patch(tag, &block)
      for page in self.pages
        page.patch(tag, &block)
      end
    end

    class Page
      include EventListHolder

      def setTile(tileid, hueShift: 0, direction: :Down, pattern: 0, opacity: 255, blendType: :Normal)
        InjectionHelper.declarePatched
        self.graphic.tile_id = tileid
        self.graphic.character_hue = hueShift
        self.graphic.direction = InjectionHelper::FACING_DIRECTIONS[direction] || direction
        self.graphic.pattern = pattern
        self.graphic.opacity = opacity
        self.graphic.blend_type = InjectionHelper::BLEND_TYPES[blendType] || blendType
        return self
      end

      def setGraphic(name, hueShift: 0, direction: :Down, pattern: 0, opacity: 255, blendType: :Normal)
        InjectionHelper.declarePatched
        self.graphic.character_name = name
        self.graphic.character_hue = hueShift
        self.graphic.direction = InjectionHelper::FACING_DIRECTIONS[direction] || direction
        self.graphic.pattern = pattern
        self.graphic.opacity = opacity
        self.graphic.blend_type = InjectionHelper::BLEND_TYPES[blendType] || blendType
        return self
      end

      def setMoveType(movetype)
        InjectionHelper.declarePatched
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
        InjectionHelper.declarePatched
        self.condition.variable_valid = true
        self.condition.variable_id = Variables[varid] || InjectionHelper.getScriptVariable(varid) || varid
        self.condition.variable_value = value
        return self
      end

      def requiresSwitch(switch, switch2=nil)
        InjectionHelper.declarePatched
        self.condition.switch1_valid = true
        self.condition.switch1_id = Switches[switch] || InjectionHelper.getScriptSwitch(switch) || switch
        if switch2
          self.condition.switch2_valid = true
          self.condition.switch2_id = Switches[switch2] || InjectionHelper.getScriptSwitch(switch2) || switch2
        end
        return self
      end

      def requiresSelfSwitch(selfswitch)
        InjectionHelper.declarePatched
        self.condition.self_switch_valid = true
        self.condition.self_switch_ch = selfswitch
        return self
      end

      def changeTrigger(triggerType)
        InjectionHelper.declarePatched
        self.trigger = InjectionHelper::EVENT_TRIGGER_TYPES[triggerType] || triggerType
        return self
      end

      def code(triggerType, *params)
        self.changeTrigger(triggerType)
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
  end
end

# Compile after mod load

class Game_System
  alias :injectionhelper_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = injectionhelper_old_initialize(*args, **kwargs)
    InjectionHelper.applyCommonPatches
    InjectionHelper.assignMapIDs
    InjectionHelper.assignScriptSwitches
    InjectionHelper.assignScriptVariables
    return ret
  end
end

class Interpreter
  def set_self_switches(map_id = nil, switch = nil, value = false)
    map_id = $game_map.map_id if map_id.nil?
    switch = ['A','B','C','D','E'] if switch.nil?
    switch = Array(switch)
    
    ### MODDED/ reset added events too
    map = ($cache.map_load(mapid) rescue load_data(sprintf("Data/Map%03d.rxdata", map_id)))
    ### /MODDED
    map.events.keys.each{|event_id|
      switch.each{|switch_type|
        key = [map_id, event_id, switch_type]
        $game_self_switches[key] = value
      }
    }
    $game_map.need_refresh = ($game_map.map_id == map_id)
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

    if InjectionHelper::MAP_ID_ASSIGNMENTS.values.include?(mapid)
      @cachedmaps = [] if !@cachedmaps
      ret = @cachedmaps[mapid] = InjectionHelper.createMap(mapid)
    else
      ret = injectionhelper_old_map_load(mapid)
    end

    InjectionHelper.applyMapPatches(mapid, ret)
    return ret
  end
end


