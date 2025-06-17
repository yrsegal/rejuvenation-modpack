# QoL Passwords (not just the "qol" password)
BULK_PASSWORDS["wirepack"] = BULK_PASSWORDS["qol"] + [
  "freeremotepc", 
  "fullivs",
  "powerpack",
  "mintyfresh",
  "eeveepls"]
BULK_PASSWORDS["truewirepack"] = BULK_PASSWORDS["wirepack"] + [
  "9494",
  "nointro",
  "hello eizen."]

module ModPasswordOptions
  @@passwordOptions = []

  PASSWORD_DESCRIPTIONS = {
    "mintyfresh" => ["Mint Pack", "Start with a pack of 5 of each Nature Mint."],
    "freeexpall" => ["EXP All", "Start with the EXP All (which is toggleable)."],
    "shinycharm" => ["Shiny Charm", "Start with the Shiny Charm."],
    "freemegaz" => ["Mega-Z Ring", "Start with the Mega-Z Ring."],
    "easyhms" => ["Golden Pack", "Start with all Golden Tools."],
    "powerpack" => ["Power Pack", "Start with the EV Training cards and a Macho Brace."],
    "earlyincu" => ["Incubator", "Get the Incubator, speeding up the Day-Care significantly."],
    "freeremotepc" => ["Remote PC", "Get the Remote PC. (Does not require Cell Batteries.)"],
    "nopoisondam" => ["No Overworld Poison", "Poison damage in the overworld is disabled."],
    "nodamageroll" => ["No Rolls", "Damage rolls are always consistent at 92%."],
    "pinata" => ["Pinata", "Repeatable Breeder trainers just give you candy directly instead."],
 
    "litemode" => ["Lite Mode", "All opposing trainers have 0 EVs/IVs."],
    "nopenny" => ["Penniless", "Money gain is reduced by 80%."],
    "fullevs" => ["Pulse-2", "All opposing trainers have 252 EVs and 31 IVs in ALL stats."],
    "noitems" => ["No Items", "Prevents you from using items from the bag besides Pokeballs in battle."],
    "moneybags" => ["Rich Mode", "Doubles money gain."],
    "fullivs" => ["Full IVs", "All Pokemon you catch automatically have perfect IVs."],
    "emptyivs" => ["Empty IVs", "All Pokemon you catch automatically are set to 0IV."],
    "leveloffset" => ["Level Offset", "Apply a flat offset to all enemy Pokemon levels."],
    "percentlevel" => ["Level Percent", "Apply a percentage modifier to all enemy Pokemon levels."],
    "stopitems" => ["No Enemy Items", "Enemy trainers cannot use items from the bag in battle."],
    "stopgains" => ["No EVs", "Your Pokemon cannot gain EVs."],
    "noexp" => ["No EXP", "Your Pokemon cannot gain EXP."],
    "flatevs" => ["Flat EVs", "All opposing Pokemon have exactly 85 EVs in every stat."],
    "noevcap" => ["Gen 2 EVs", "Disables the 510 cap on EVs, allowing you to get 255 in all stats."],
 
    "gen5weather" => ["Gen 5 Weather", "Weather set by abilities lasts indefinitely."],
    "unrealtime" => ["Unreal Time", "Game time can be separate from clock time, configurable to pass up to 60x faster."],
    "eeveepls" => ["Eevee Pls", "Lets an Eevee into the Starter selection room."],
    "fieldfrenzy" => ["Field Frenzy", "Doubles the multipliers applied by Field Effects."],
    "nointro" => ["Skip S.S. Oceana", "Skips the intro on the S.S. Oceana."],
    "9494" => ["9494", "To our dear friend, Ana. May you rest peacefully forever."],
    "terajuma" => ["Skip to Terajuma", "Skip directly to Terajuma, getting a premade team."],
    "hello eizen." => ["hello eizen.", "it's only polite"],

    "wirepack" => ["Wire's Pack", "The mod dev's pack. QoL, Remote PC, Full IVs, Power Pack, Mint Pack, Eevee Pls."],
    "truewirepack" => ["Wire's (Actual) Pack", "The mod dev's actual pack. Wire's Pack, 9494, nointro, hello eizen."],
    "casspack" => ["Cass's Pack", "A Reborn/Rejuv dev's pack. No Items, Full IVs, Golden Pack, No Rolls."],
    "easymode" => ["Easy Mode", "Full IVs, Rich Mode, Lite Mode, No Enemy Items."],
    "hardmode" => ["Hard Mode", "No Items, Penniless, Pulse-2, Empty IVs."],
    "qol" => ["QoL", "Golden Pack, No Overworld Poison, EXP All, Incubator, Pinata, Unreal Time."]
  }

  PASSWORDS_BADGE_DATA = {
    'hello eizen.' => -1,
    '9494' => -1,
    'truewirepack' => -1,
    'nointro' => 1,
    'terajuma' => 5
  }

  def self.passwords
    buildPasswords if @@passwordOptions.size == 0
    return @@passwordOptions 
  end

  def self.buildPasswords
    passwordOrder = []
    variableMapping = {}
    bulkMapping = {}
    output = []

    for pw,bulk in BULK_PASSWORDS
      bulkMapping[bulk] = [] if !bulkMapping[bulk]
      bulkMapping[bulk].push(pw)
    end

    for bulk, pw in bulkMapping
      output.push({
        type: :bulk,
        password: pw[0],
        bulk: bulk
      })
    end

    for pw,id in PASSWORD_HASH
      id = Switches[id] if Switches[id]

      if !variableMapping[id]
        passwordOrder.push(id) 
        variableMapping[id] = []
      end

      variableMapping[id].push(pw)
    end

    for id in passwordOrder
      output.push({
        type: :password,
        password: variableMapping[id][0],
        id: id
      })
    end

    @@passwordOptions = output
  end

  def self.shouldPasswordShow(pw, idsChecked={})
    return true if !PASSWORDS_BADGE_DATA[pw]

    knownPasswords = $Unidata[:knownPasswords] ? $Unidata[:knownPasswords] : []
    
    return true if !BULK_PASSWORDS[pw] && knownPasswords.include?(pw)
    return true if BULK_PASSWORDS[pw] && BULK_PASSWORDS[pw].none? { |subPw| !knownPasswords.include?(subPw) }

    badgeCount = $Unidata[:BadgeCount] ? $Unidata[:BadgeCount] : 0

    return true if PASSWORDS_BADGE_DATA[pw] >= 0 && PASSWORDS_BADGE_DATA[pw] <= badgeCount
    return false
  end

  def self.bulkState(bulk)
    anyFalse = false
    anyTrue = false

    for pw in bulk
      if PASSWORD_HASH[pw]
        anyFalse = true if !$game_switches[PASSWORD_HASH[pw]]
        anyTrue = true if $game_switches[PASSWORD_HASH[pw]]
      end
    end

    return '> ' if !anyFalse
    return '     ' if !anyTrue
    return '~ '
  end

  def self.passwordList
    pws=[]
    choices=[]
    helps=[]

    for password in self.passwords
      next if password[:type] != :password
      pw=password[:password]
      next if !shouldPasswordShow(pw)
      descs = PASSWORD_DESCRIPTIONS[pw] ? PASSWORD_DESCRIPTIONS[pw] : [pw, nil]
      mark = $game_switches[password[:id]] ? '> ' : '    '

      pws.push(String.new(pw))
      choices.push(mark + descs[0])
      helps.push(descs[1])
    end
    
    return pws,choices,helps
  end

  def self.passwordPacks
    pws=[]
    choices=[]
    helps=[]

    for password in self.passwords
      next if password[:type] != :bulk
      pw=password[:password]
      next if !shouldPasswordShow(pw)
      descs = PASSWORD_DESCRIPTIONS[pw] ? PASSWORD_DESCRIPTIONS[pw] : [pw, password[:bulk].join(", ")]
      mark = bulkState(password[:bulk])

      pws.push(String.new(pw))
      choices.push(mark + descs[0])
      helps.push(descs[1])
    end
    
    return pws,choices,helps
  end

  def self.addPasswordAndLearn(password)
    addPassword(password)
    if password == "truewirepack"
      $game_variables[472] = 3 # Do the eizen greetings
    end

    passwords=pbGetKnownOrActivePasswords()
    password=password.downcase
    ids=pbGetPasswordIds(password)

    for id,pw in ids
      alreadyKnown=alreadyKnown && passwords[id] ? true : false
      # Toggle the password
      active=$game_switches[id] ? true : false
      passwords[id]={
        'password': pw,
        'active': active
      }
    end

    pbUpdateKnownPasswords(passwords) if !alreadyKnown
  end

  def self.presentChoices(choices, helps)
    msgwindow = Kernel.pbCreateMessageWindow(nil)
    msgwindow.opacity = 0 if $game_system && $game_system.respond_to?("message_frame") && $game_system.message_frame != 0
    subcommand = Kernel.pbShowCommandsWithHelp(msgwindow, choices, helps, -1)
    Kernel.pbDisposeMessageWindow(msgwindow)
    return subcommand
  end

end

$mod_passwordoptions_lastcommand = 0 if !defined?($mod_passwordoptions_lastcommand)

def mod_passwordoptions_scene
  allPasswords=pbGetKnownOrActivePasswords()
  loop do 
    command = Kernel.pbMessage(_INTL("Which kind of password do you want to enter?"), [_INTL("Bulk"), _INTL("From List"), _INTL("Manual")], -1, nil, $mod_passwordoptions_lastcommand)

    if command < 0
      next if !Kernel.pbConfirmMessageSerious(_INTL("You're done entering passwords?"))
      return true
    end

    $mod_passwordoptions_lastcommand = command if command >= 0
    if command == 0
      pws, choices, helps = ModPasswordOptions.passwordPacks
      subcommand = ModPasswordOptions.presentChoices(choices, helps)
      if subcommand >= 0
        ModPasswordOptions.addPasswordAndLearn(pws[subcommand])
        return false
      end
    elsif command == 1
      pws, choices, helps = ModPasswordOptions.passwordList
      subcommand = ModPasswordOptions.presentChoices(choices, helps)
      if subcommand >= 0
        ModPasswordOptions.addPasswordAndLearn(pws[subcommand])
        return false
      end
    else
      $trainpass = pbEnterText(_INTL("Enter password."),0,12)
      if $trainpass && $trainpass != ""
        ModPasswordOptions.addPasswordAndLearn($trainpass)
        return false
      end
    end
  end
end

class Cache_Game
  alias :passwordoptions_old_map_load :map_load

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return passwordoptions_old_map_load(mapid)
    end

    ret = passwordoptions_old_map_load(mapid)

    if mapid == 1 # Intro
      for page in ret.events[1].pages
        insns = page.list
        InjectionHelper.patch(insns, :PasswordOptions) {
          matched = InjectionHelper.lookForSequence(insns,
            [:Script,          'pbFadeOutIn(99999){'],
            [:ScriptContinued, '    sscene=PokemonEntryScene.new'],
            [:ScriptContinued, '    sscreen=PokemonEntry.new(sscene)'],
            [:ScriptContinued, '    $trainpass=sscreen.pbStartScreen(_INTL("Enter password."),1,12,"")'],
            [:ScriptContinued, '  }'],
            [:Script,          'addPassword($trainpass)'])

          if matched
            labelPoint = InjectionHelper.lookForAll(insns,
              [:ShowPicture, 1, 'introOak2', 0, 0, 0, 0, 100, 100, 255, 0])

            next false if labelPoint.size == 0
            insns.insert(insns.index(labelPoint[0]), InjectionHelper.parseEventCommand(labelPoint[0].indent, :Label, 'passwordoptions_pwend'))

            replacement = InjectionHelper.parseEventCommands(
                [:ConditionalBranch, :Script, 'mod_passwordoptions_scene'],
                  [:JumpToLabel, 'passwordoptions_pwend'],
                :Done,
              baseIndent: matched[0].indent)

            while replacement.size < matched.size
              replacement.push(InjectionHelper.parseEventCommand(matched[0].indent, :Comment, '////'))
            end

            for i in 0...replacement.length
              insns[insns.index(matched[i])] = replacement[i]
            end
          end


          next matched
        }
      end
    end

    return ret
  end
end
