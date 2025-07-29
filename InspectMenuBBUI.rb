begin
  missing = ['BetterBattleUI.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

# Based on https://eeveeexpo.com/threads/7796/
module InspectMenuDisplay
  #-----------------------------------------------------------------------------
  # White text.
  #-----------------------------------------------------------------------------
  BASE_LIGHT     = Color.new(248, 248, 248)
  SHADOW_LIGHT   = Color.new(32, 32, 32)
  #-----------------------------------------------------------------------------
  # Black text.
  #-----------------------------------------------------------------------------
  BASE_DARK      = Color.new(56, 56, 56)
  SHADOW_DARK    = Color.new(184, 184, 184)
  #-----------------------------------------------------------------------------
  # Green text. Used to display bonuses.
  #-----------------------------------------------------------------------------
  BASE_RAISED    = Color.new(40, 201, 48)
  SHADOW_RAISED  = Color.new(9, 32, 32)
  #-----------------------------------------------------------------------------
  # Red text. Used to display penalties.
  #-----------------------------------------------------------------------------
  BASE_LOWERED   = Color.new(201, 56, 40)
  SHADOW_LOWERED = Color.new(48, 32, 32)


  def self.counterEffect(name, desc, &value)
    [name, 0, desc, value]
  end
  def self.durationEffect(name, desc, maxVal, &value)
    [name, maxVal, desc, value]
  end
  def self.effect(name, desc, &value)
    [name, nil, desc, value]
  end
  def self.targetedEffect(name, desc, &value)
    [name, "target", desc, value]
  end
  EFFECTS = [
    effect("Aqua Ring", "The Pokémon regains some HP at the end of each turn.") { |battler| battler.effects[:AquaRing] },
    effect("Ingrain", "The Pokémon regains some HP every turn, but cannot switch out.") { |battler| battler.effects[:Ingrain] },
    effect("Burned Up", "The Pokémon has used up its fire.") { |battler| battler.effects[:BurnUp] },
    targetedEffect("Leech Seed", "The Pokémon's HP is leeched every turn to heal {1}.") { |battler| next battler.effects[:LeechSeed] },
    effect("Curse", "The Pokémon takes damage at the end of each turn.") { |battler| battler.effects[:Curse] },
    effect("Nightmare", "The Pokémon takes damage each turn it spends asleep.") { |battler| battler.effects[:Nightmare] },
    effect("Rage", "The Pokémon's Attack stat increases whenever it's hit.") { |battler| battler.effects[:Rage] },
    effect("Biding", "The Pokémon is storing damage to return to the opponent.") { |battler| battler.effects[:Bide] > 0 },
    effect("Helping Hand", "The Pokémon's damage output is being increased.") { |battler| battler.effects[:HelpingHand] },
    effect("Power Trick", "The Pokémon's Atk and Def are swapped.") { |battler| battler.effects[:PowerTrick] },
    effect("Torment", "The Pokémon can't use the same move twice in a row.") { |battler| next battler.effects[:Torment] if battler.effects[:ChtonicMalady] <= 0 },
    durationEffect("Torment", "The Pokémon can't use the same move twice in a row.", 5) { |battler| next battler.effects[:ChtonicMalady] if battler.effects[:Torment] },
    effect("Charged", "On the next turn, the Pokémon's Electric moves will double in power.") { |battler| battler.effects[:Charge] > 0 },
    effect("Curled Up", "The Pokémon has curled up into a ball.") { |battler| battler.effects[:DefenseCurl] },
    effect("Electrified", "The Pokémon's next move will be Electric type.") { |battler| battler.effects[:Electrify] },
    effect("Ion Deluge", "The Pokémon's Normal type moves become Electric type.") { |battler| battler.battle.state.effects[:IonDeluge] },
    effect("Minimize", "The Pokémon shrunk and now takes more damage when squished.") { |battler| battler.effects[:Minimize] },
    effect("Sky Drop", "The Pokémon is being lifted in the air.") { |battler| battler.effects[:SkyDrop] },
    effect("Tar Shot", "The Pokémon has been made weaker to Fire type moves.") { |battler| battler.effects[:TarShot] },
    effect("Desert's Mark", "The Pokémon has no defense against the desert sands.") { |battler| battler.effects[:DesertsMark] },
    effect("Powdered", "The Pokémon takes damage when it uses a Fire type move.") { |battler| battler.effects[:Powder] },
    effect("Wish", "The Pokémon in this spot restores HP on the next turn.") { |battler| battler.effects[:Wish] > 0 },
    effect("Healing Wish", "Fully heals a Pokémon switching into this spot.") { |battler| battler.effects[:HealingWish] },
    effect("Lunar Dance", "Fully heals a Pokémon switching into this spot.") { |battler| battler.effects[:LunarDance] },
    effect("Endure", "The Pokémon will survive all incoming attacks with 1 HP.") { |battler| battler.effects[:Endure] },
    effect("Substitute", "The Pokémon's substitute will take any incoming moves.") { |battler| battler.effects[:Substitute] > 0 },
    effect("Magic Coat", "The Pokémon bounces back any incoming status moves.") { |battler| battler.effects[:MagicCoat] },
    effect("Crafty Shield", "The Pokémon is protected from all status moves.") { |battler| battler.effects[:CraftyShield] },
    effect("Quick Guard", "The Pokémon is protected from all priority moves.") { |battler| battler.effects[:QuickGuard] },
    effect("Wide Guard", "The Pokémon is protected from all spread moves.") { |battler| battler.pbOwnSide.effects[:WideGuard] },
    effect("Identified", "The Ghost type's immunities and evasion boosts are ignored.") { |battler| battler.effects[:Foresight] },
    effect("Miracle Eye", "The Dark type's immunities and evasion boosts are ignored.") { |battler| battler.effects[:MiracleEye] },
    effect("Smacked Down", "The Flying type's immunities are ignored, and the Pokémon has been grounded.") { |battler| battler.effects[:SmackDown] },
    counterEffect("Stockpile", "Stockpiling increases the Pokémon's defensive stats.") { |battler| battler.effects[:Stockpile] },
    counterEffect("Spikes", "Grounded Pokémon that switch into battle will take damage.") { |battler| battler.pbOwnSide.effects[:Spikes] },
    counterEffect("Toxic Spikes", "Grounded Pokémon that switch into battle will be poisoned.") { |battler| battler.pbOwnSide.effects[:ToxicSpikes] },
    effect("Stealth Rocks", "Pokémon that switch into battle will take damage.") { |battler| battler.pbOwnSide.effects[:StealthRock] },
    effect("Sticky Web", "Pokémon that switch into battle will have their Speed lowered.") { |battler| battler.pbOwnSide.effects[:StickyWeb] },
    effect("Laser Focus", "The Pokémon's next attack is a guaranteed critical hit.") { |battler| battler.effects[:LaserFocus] > 0 },
    targetedEffect("Locked On", "Next turn, the move the Pokémon uses against {1} will be sure to hit.") { |battler| next battler.effects[:LockOnPos] if battler.effects[:LockOn] > 0 },
    effect("Prismatic", "The Pokémon has been filled with a mysterious power.") { |battler| battler.pokemon.prismPower },
    durationEffect("Throat Chop", "The Pokémon can't use any sound-based moves.", 2) { |battler| battler.effects[:ThroatChop] },
    effect("Fairy Lock", "No Pokémon can flee.") { |battler| battler.battle.state.effects[:FairyLock] > 0 },
    durationEffect("Telekinesis", "The Pokémon has been made airborne, but it cannot evade attacks.", 3) { |battler| battler.effects[:Telekinesis] },
    durationEffect("Encore", "The Pokémon is forced to continue using the same move.", 3) { |battler| battler.effects[:Encore] },
    durationEffect("Taunt", "The Pokémon can only use moves that deal damage.", 4) { |battler| battler.effects[:Taunt] },
    durationEffect("Tailwind", "The Pokémon's Speed stat is doubled.", 4) { |battler| battler.pbOwnSide.effects[:Tailwind] },
    durationEffect("Magnet Rise", "The Pokémon is airborne and immune to Ground moves.", 5) { |battler| battler.effects[:MagnetRise] },
    durationEffect("Heal Block", "The Pokémon's HP cannot be restored by healing effects.", 5) { |battler| battler.effects[:HealBlock] },
    durationEffect("Embargo", "Items cannot be used on or by the Pokémon.", 5) { |battler| battler.effects[:Embargo] },
    durationEffect("Mud Sport", "The power of Electric moves is reduced.", 5) { |battler| battler.battle.state.effects[:MudSport] },
    durationEffect("Water Sport", "The power of Fire moves is reduced.", 5) { |battler| battler.battle.state.effects[:WaterSport] },
    durationEffect("Aurora Veil", "The Pokémon takes half damage from damaging moves.", 5) { |battler| battler.pbOwnSide.effects[:AuroraVeil] },
    durationEffect("Reflect", "The Pokémon takes half damage from physical moves.", 5) { |battler| battler.pbOwnSide.effects[:Reflect] },
    durationEffect("Light Screen", "The Pokémon takes half damage from special moves.", 5) { |battler| battler.pbOwnSide.effects[:LightScreen] },
    durationEffect("Arenite Wall", "The Pokémon takes half damage from super effective moves.", 5) { |battler| battler.pbOwnSide.effects[:AreniteWall] },
    durationEffect("Safeguard", "The Pokémon is protected from status conditions.", 5) { |battler| battler.pbOwnSide.effects[:Safeguard] },
    durationEffect("Mist", "The Pokémon's stats cannot be lowered.", 5) { |battler| battler.pbOwnSide.effects[:Mist] },
    durationEffect("Lucky Chant", "The Pokémon is immune to critical hits.", 5) { |battler| battler.pbOwnSide.effects[:LuckyChant] },
    durationEffect("Gravity", "Grounds Pokémon. Prevents midair actions. Increases accuracy.", 5) { |battler| battler.battle.state.effects[:Gravity] },
    durationEffect("Magic Room", "No Pokémon can use their held items.", 5) { |battler| battler.battle.state.effects[:MagicRoom] },
    durationEffect("Wonder Room", "All Pokémon swap their Def and Sp. Def stats.", 5) { |battler| battler.battle.state.effects[:WonderRoom] },
    durationEffect("Trick Room", "Slower Pokémon get to move first.", 5) { |battler| battler.battle.state.effects[:TrickRoom] },
    durationEffect("Bound", "The Pokémon is bound and takes damage every turn.", 5) { |battler| battler.effects[:MultiTurn] },
    effect("Destiny Bound", "The Pokémon will take its attacker down with it.") { |battler| battler.effects[:DestinyBond] },
    effect("Quicksilver Spear", "This Pokémon takes damage and is trapped in place.") { |battler| battler.effects[:Quicksilver] },
    counterEffect("Badly Poisoned", "Damage the Pokémon takes from its poison worsens every turn.") { |battler| next battler.effects[:Toxic] if battler.status == :POISON && battler.statusCount == 1 },
    effect("Confusion", "The Pokémon may hurt itself in its confusion.") { |battler| battler.effects[:Confusion] > 0 },
    effect("Rampaging", "The Pokémon rampages for 2-3 turns. It then becomes confused.") { |battler| battler.effects[:Outrage] > 0 },
    durationEffect("Rolling", "The Pokémon gains momentum as it rolls.", 5) { |battler| next 5 - battler.effects[:Rollout] if battler.effects[:Rollout] > 0 },
    effect("No Ability", "The Pokémon's Ability loses its effect.") { |battler| battler.effects[:GastroAcid] },
    targetedEffect("Infatuation", "The Pokémon is less likely to attack {1}.") { |battler| next battler.effects[:Attract] },
    effect("Weight Increased", "The Pokémon is heavier.") { |battler| battler.effects[:WeightModifier] > 0 },
    effect("Weight Decreased", "The Pokémon is lighter.") { |battler| battler.effects[:WeightModifier] < 0 },
    targetedEffect("No Escape", "The Pokémon can't escape because of {1}.") { |battler| battler.effects[:MeanLook] },
    effect("No Retreat", "The Pokémon has forfeited its chance to escape.") { |battler| battler.effects[:NoRetreat] },
    effect("Protected", "The Pokémon is protected from incoming moves.") { |battler| battler.effects[:Protect] },
    effect("Z-Healing", "A Pokémon switching into this spot will recover its HP.") { |battler| battler.effects[:ZHeal] },
    effect("Semi-Invulnerable", "The Pokémon cannot be hit by most attacks.") { |battler| PBStuff::TWOTURNMOVE.include?(battler.effects[:TwoTurnAttack]) },
    durationEffect("Perish Count", "This Pokémon will faint when the count reaches 0.", 3) { |battler| battler.effects[:PerishSong] },
    durationEffect("Future Attack", "The Pokémon in this spot will be attacked in 2 turns.", 2) { |battler| battler.effects[:FutureSight] },
    durationEffect("Slow Start", "The Pokémon gets its act together in 5 turns.", 5) { |battler| next battler.turncount if battler.ability == (:SLOWSTART) && battler.turncount<=5 && (battler == battler.battle.battlers[0] || battler == battler.battle.battlers[2]) },
    effect("Drowsy", "The Pokémon will fall asleep at the end of the next turn.") { |battler| battler.effects[:Yawn] > 0 },
    effect("Recharging", "The Pokémon cannot move until it recharges from its last attack.") { |battler| battler.effects[:HyperBeam] > 0 },
    durationEffect("Move Disabled", "A move has been disabled and cannot be used.", 4) { |battler| battler.effects[:Disable] },
    effect("Floating", "The Pokémon is floating on its Air Balloon.") { |battler| battler.hasWorkingItem(:AIRBALLOON) },
    effect("Sheltered", "The Pokémon takes less damage from the field's type.") { |battler| battler.effects[:Shelter] },
    effect("Flash Fire", "The Pokémon's Fire moves are strengthened.") { |battler| battler.effects[:FlashFire] },
    effect("Follow Me", "Attacks will target this Pokémon.") { |battler| battler.effects[:FollowMe] || battler.effects[:RagePowder] },
    effect("Loafing Around", "The Pokémon refuses to move this turn.") { |battler| battler.effects[:Truant] },
    durationEffect("Uproar", "This Pokémon is making an uproar.", 3) { |battler| battler.effects[:Uproar] }, # Uproar direct
    targetedEffect("Uproar", "This Pokémon cannot fall asleep due to {1}'s uproar.") { |battler| # Uproar indirect
      result = -1
      unless battler.effects[:Uproar]
        for i in 0...4
          if battler.battle.battlers[i].effects[:Uproar] > 0
            result = i
          end
        end
      end
      next result
    },
    effect("Imprison", "Pokémon can't use moves known by an opposing Imprison user.") {
      |battler| (0...4).any? { |i| battler.battle.battlers[i].effects[:Imprison] }
    }
  ]
end

def drawFormattedTextEx_lh(bitmap,x,y,width,text,baseColor=nil,shadowColor=nil,lh=32)
  base=!baseColor ? Color.new(12*8,12*8,12*8) : baseColor.clone
  shadow=!shadowColor ? Color.new(26*8,26*8,25*8) : shadowColor.clone
  text="<c2="+colorToRgb16(base)+colorToRgb16(shadow)+">"+text
  chars=getFormattedText(bitmap,x,y,width,-1,text,lh)
  drawFormattedChars(bitmap,chars)
end


class PokeBattle_Scene
  #-----------------------------------------------------------------------------
  # Handles the controls for the Battle Info UI.
  #-----------------------------------------------------------------------------
  def pbShowBattleStats(battler)
    @sprites["bbui_canvas"].visible = true
    @bbui_displaymode = :battler
    idx = battler.index
    allBattlers = @battle.battlers.select { |b| b && b.pokemon }
    maxSize = allBattlers.length - 1
    idxEffect = 0
    effects = bbui_pbGetDisplayEffects(battler)
    effctSize = effects.length - 1
    bbui_pbUpdateBattlerInfo(battler, effects, idxEffect)
    cw = @sprites["fightwindow"]
    @sprites["bbui_leftarrow"].x = -2
    @sprites["bbui_leftarrow"].y = 71
    @sprites["bbui_leftarrow"].visible = true
    @sprites["bbui_rightarrow"].x = Graphics.width - 38
    @sprites["bbui_rightarrow"].y = 71
    @sprites["bbui_rightarrow"].visible = true
    loop do
      pbGraphicsUpdate
      Input.update
      pbFrameUpdate(cw)
      bbui_pbUpdateInfoSprites
      break if Input.trigger?(Input::B)
      if Input.trigger?(Input::LEFT)
        idx -= 1
        idx = maxSize if idx < 0
        doFullRefresh = true
      elsif Input.trigger?(Input::RIGHT)
        idx += 1
        idx = 0 if idx > maxSize
        doFullRefresh = true
      elsif Input.repeat?(Input::UP) && effects.length > 1
        idxEffect -= 1
        idxEffect = effctSize if idxEffect < 0
        doRefresh = true
      elsif Input.repeat?(Input::DOWN) && effects.length > 1
        idxEffect += 1
        idxEffect = 0 if idxEffect > effctSize
        doRefresh = true
      end
      if doFullRefresh
        battler = allBattlers[idx]
        effects = bbui_pbGetDisplayEffects(battler)
        effctSize = effects.length - 1
        idxEffect = 0
        doRefresh = true
      end
      if doRefresh
        pbPlayCursorSE
        bbui_pbUpdateBattlerInfo(battler, effects, idxEffect)
        doRefresh = false
        doFullRefresh = false
      end
    end
    @bbui_displaymode = nil
    @sprites["bbui_leftarrow"].visible = false
    @sprites["bbui_rightarrow"].visible = false
    @sprites["bbui_canvas"].visible = false
    @battle.battlers.each do |b|
      @sprites["bbui_info_icon#{b.index}"].visible = false
    end
  end

  #-----------------------------------------------------------------------------
  # Draws the Battle Info UI.
  #-----------------------------------------------------------------------------
  def bbui_pbUpdateBattlerInfo(battler, effects, idxEffect = 0)
    @sprites["bbui_canvas"].bitmap.clear
    bbui_pbUpdateBattlerIcons
    xpos = 28
    ypos = 24
    iconX = xpos + 28
    iconY = ypos + 62
    panelX = xpos + 240
    #---------------------------------------------------------------------------
    # General UI elements.
    poke = battler.pokemon
    name = battler.name

    if @battle.pbIsOpposing?(battler.index)
      poke = battler.effects[:Illusion] ? battler.effects[:Illusion] : poke
      name = poke.name if battler.effects[:Illusion]
    elsif battler.effects[:Illusion]
      name = poke.name
    end
    name = name[0..12] + "..." if name.length > 16
    
    level = (battler.isbossmon) ? "???" : battler.level.to_s
    movename = $cache.moves[battler.lastMoveUsed] ? $cache.moves[battler.lastMoveUsed].name : "---"
    movename = movename[0..12] + "..." if movename.length > 16
    imagePos = [
      ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/bg", 0, 0, 0, 0, -1, -1],
      ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/bg_data", 0, 0, 0, 0, -1, -1],
      ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/level", xpos + 16, ypos + 106, 0, 0, -1, -1]
    ]
    unless poke.form > 0 && $cache.pkmn[poke.species].formData.keys[poke.form - 1] == 'Amalgamation'
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/gender", xpos + 148, ypos + 22, poke.gender * 22, 0, 22, 22])
    end
    textPos  = [
      [_INTL("{1}", name), iconX + 82, iconY - 20, 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK],
      [_INTL("{1}", level), xpos + 38, ypos + 104, 0, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT],
      [_INTL("Used: {1}", movename), xpos + 349, ypos + 104, 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT],
      [_INTL("Turn {1}", @battle.turncount), Graphics.width - xpos - 32, ypos + 8, 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK]
    ]
    #---------------------------------------------------------------------------
    # Battler icon.
    @battle.battlers.each do |b|
      @sprites["bbui_info_icon#{b.index}"].x = iconX - 28
      @sprites["bbui_info_icon#{b.index}"].y = iconY - 40
      @sprites["bbui_info_icon#{b.index}"].visible = (b.index == battler.index)
    end
    #---------------------------------------------------------------------------
    # Owner
    if @battle.pbGetOwner(battler.index)
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/owner", xpos - 34, ypos + 6, 0, 20, 128, 20])
      textPos.push([@battle.pbGetOwner(battler.index).name, xpos + 32, ypos + 8, 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK])
    end
    # Battler HP.
    if battler.hp > 0
      w = battler.hp * 96 / battler.totalhp.to_f
      w = 1 if w < 1
      w = ((w / 2).round) * 2
      hpzone = 0
      hpzone = 1 if battler.hp <= (battler.totalhp / 2).floor
      hpzone = 2 if battler.hp <= (battler.totalhp / 4).floor
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/hp", 86, 86, 0, hpzone * 6, w, 6])
    end
    # Battler status.
    if battler.status
      imagePos.push([sprintf("Graphics/Pictures/Party/status%s",battler.status), xpos + 86, ypos + 104, 0, 0, 44, 16])
    end
    # Shininess
    imagePos.push(["Graphics/Pictures/shiny", xpos + 138, ypos + 102, 0, 0, -1, -1]) if poke.isShiny?
    #---------------------------------------------------------------------------
    # Battler info for player-owned Pokemon.
    if @battle.pbOwnedByPlayer?(battler.index)
      imagePos.push(
        ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/owner", xpos + 36, iconY + 10, 0, 0, 128, 20],
        ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/effects", panelX, 86, 0, 0, 218, 26]
      )
      textPos.push(
        [_INTL("Item"), xpos + 272, ypos + 68, 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT],
        [_INTL("{1}", battler.item ? getItemName(battler.item) : _INTL("No item")), xpos + 376, ypos + 68, 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK],
        [sprintf("%d/%d", battler.hp, battler.totalhp), iconX + 74, iconY + 12, 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT]
      )
    end

    # Gets display types (considers Illusion)
    if battler.effects[:Illusion] && !@battle.pbOwnedByPlayer?(battler.index)
      # Zorua
      type1=battler.effects[:Illusion].type1
      type2=battler.effects[:Illusion].type2
      ability = battler.effects[:Illusion].ability
    else
      type1=battler.type1
      type2=battler.type2
      ability = battler.ability
    end

    imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/effects", panelX, 62, 0, 0, 218, 26])
    textPos.push([_INTL("Abil."), xpos + 272, ypos + 44, 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT],
                 [_INTL("{1}", ability ? getAbilityName(ability) : _INTL("No ability")), xpos + 376, ypos + 44, 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK])
    #---------------------------------------------------------------------------


    typeY = ypos + 34

    imagePos.push([sprintf("Graphics/Icons/type%s", type1), xpos + 170, typeY, 0, 0, 64, 28])
    if type2 && type2 != type1
      imagePos.push([sprintf("Graphics/Icons/type%s", type2), xpos + 170, typeY + 30, 0, 0, 64, 28])
    end

    #---------------------------------------------------------------------------
    bbui_pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos)
    pbDrawImagePositions(@sprites["bbui_canvas"].bitmap, imagePos)
    pbDrawTextPositions(@sprites["bbui_canvas"].bitmap, textPos)
    bbui_pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
  end

  #-----------------------------------------------------------------------------
  # Draws the battler's stats and stat stages.
  #-----------------------------------------------------------------------------
  def bbui_pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos)
    [[PBStats::ATTACK,   _INTL("Attack")],
     [PBStats::DEFENSE,  _INTL("Defense")],
     [PBStats::SPATK,    _INTL("Sp. Atk")],
     [PBStats::SPDEF,    _INTL("Sp. Def")],
     [PBStats::SPEED,    _INTL("Speed")],
     [PBStats::ACCURACY, _INTL("Accuracy")],
     [PBStats::EVASION,  _INTL("Evasion")],
     _INTL("Crit. Hit")
    ].each_with_index do |stat, i|
      if stat.is_a?(Array)
        color = InspectMenuDisplay::SHADOW_LIGHT
        if @battle.pbOwnedByPlayer?(battler.index)
          nature = $cache.natures[battler.pokemon.nature]
          natup=nature.incStat
          natdn=nature.decStat
          if natup != natdn
            color = Color.new(136, 96, 72)  if natup == i + 1 # Red Nature text.
            color = Color.new(64, 120, 152) if natdn == i + 1 # Blue Nature text.
          end
        end
        textPos.push([stat[1], xpos + 16, ypos + 138 + (i * 24), 0, InspectMenuDisplay::BASE_LIGHT, color])
        stage = battler.stages[stat[0]]
      else
        textPos.push([stat, xpos + 16, ypos + 138 + (i * 24), 0, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT])
        stage = [battler.effects[:FocusEnergy], 3].min
      end
      if stage != 0
        arrow = (stage > 0) ? 0 : 18
        stage.abs.times do |t|
          imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/stats", xpos + 110 + (t * 18), ypos + 136 + (i * 24), arrow, 0, 18, 18])
        end
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Draws the effects in play that are affecting the battler.
  #-----------------------------------------------------------------------------
  def bbui_pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
    return if effects.empty?
    idxLast = effects.length - 1
    offset = idxLast - 1
    if idxEffect < 4
      idxDisplay = idxEffect
    elsif [idxLast, offset].include?(idxEffect)
      idxDisplay = idxEffect
      idxDisplay -= 1 if idxDisplay == offset && offset < 5
    else
      idxDisplay = 3
    end
    idxStart = (idxEffect > 3) ? idxEffect - 3 : 0
    if idxLast - idxEffect > 0
      idxEnd = idxStart + 4
    else
      idxStart = (idxLast - 4 > 0) ? idxLast - 4 : 0
      idxEnd = idxLast
    end
    textPos = []
    imagePos = [
      ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/effectdesc", xpos + 240, ypos + 256, 0, 0, -1, -1],
      ["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider_base", panelX + 222, ypos + 132, 0, 0, -1, -1]
    ]
    #---------------------------------------------------------------------------
    # Draws the slider.
    #---------------------------------------------------------------------------
    if effects.length > 5
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider", panelX + 222, ypos + 132, 0, 0, 18, 19]) if idxEffect > 3
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider", panelX + 222, ypos + 233, 0, 19, 18, 19]) if idxEffect < idxLast - 1
      sliderheight = 82
      boxheight = (sliderheight * 4 / idxLast).floor
      boxheight += [(sliderheight - boxheight) / 2, sliderheight / 4].min
      boxheight = [boxheight.floor, 18].max
      y = ypos + 152
      y += ((sliderheight - boxheight) * idxStart / (idxLast - 4)).floor
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider", panelX + 222, y, 18, 0, 18, 4])
      i = 0
      while i * 7 < boxheight - 2 - 7
        height = [boxheight - 2 - 7 - (i * 7), 7].min
        offset = y + 2 + (i * 7)
        imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider", panelX + 222, offset, 18, 2, 18, height])
        i += 1
      end
      imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/slider", panelX + 222, y + boxheight - 6 - 7, 18, 9, 18, 12])
    end
    #---------------------------------------------------------------------------
    # Draws each effect and the cursor.
    #---------------------------------------------------------------------------
    effects[idxStart..idxEnd].each_with_index do |effect, i|
      real_idx = effects.find_index(effect)
      if i == idxDisplay || idxEffect == real_idx
        imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/effects", panelX, ypos + 132 + (i * 24), 0, 52, 218, 26])
        textPos.push([effect[0], xpos + 322, ypos + 138 + (i * 24), 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT, true])
      else
        imagePos.push(["#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/Inspect/effects", panelX, ypos + 132 + (i * 24), 0, 26, 218, 26])
        textPos.push([effect[0], xpos + 322, ypos + 138 + (i * 24), 2, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK])
      end
      textPos.push([effect[1], xpos + 426, ypos + 138 + (i * 24), 2, InspectMenuDisplay::BASE_LIGHT, InspectMenuDisplay::SHADOW_LIGHT])
    end
    pbDrawImagePositions(@sprites["bbui_canvas"].bitmap, imagePos)
    pbDrawTextPositions(@sprites["bbui_canvas"].bitmap, textPos)
    desc = effects[idxEffect][2]
    drawFormattedTextEx_lh(@sprites["bbui_canvas"].bitmap, xpos + 246, ypos + 264, 208, desc, InspectMenuDisplay::BASE_DARK, InspectMenuDisplay::SHADOW_DARK, 18)
  end

  #-----------------------------------------------------------------------------
  # Utility for getting an array of all effects that may be displayed.
  #-----------------------------------------------------------------------------
  def bbui_pbGetDisplayEffects(battler)
    display_effects = []
    #---------------------------------------------------------------------------
    # Damage gates for scripted battles.
    if battler.isbossmon
      if battler.shieldCount > 0
        if battler.shieldCount == 1
          desc = _INTL("The Pokémon is protected by the unbroken shield.")
        else
          desc = _INTL("The Pokémon is protected by the {1} unbroken shields.", battler.shieldCount)
        end
        display_effects.push([_INTL("Shielded"), "--", desc])
      end

      if battler.immunities[:moves].include?(:DESTINYBOND)
        desc = _INTL("The Pokémon's destiny is already bound.")
        display_effects.push([_INTL("Resist Destiny"), "--", desc])
      end
    end
    #---------------------------------------------------------------------------
    # Weather
    weather = @battle.pbWeather
    if weather != 0
      case weather
      when :SUNNYDAY
        name, desc = _INTL("Sun"), _INTL("Boosts Fire moves and weakens Water moves.")
        name, desc = _INTL("Scorching Sun"), _INTL("Boosts Fire moves and negates Water moves.") if @battle.state.effects[:HarshSunlight]
      when :RAINDANCE
        name, desc = _INTL("Rain"), _INTL("Boosts Water moves and weakens Fire moves.")
        name, desc = _INTL("Torrential Rain"), _INTL("Boosts Water moves and negates Fire moves.") if @battle.state.effects[:HeavyRain]
      when :SANDSTORM   then name, desc = _INTL("Sandstorm"), _INTL("Boosts Rock Sp. Def. Chip damage unless Rock/Ground/Steel.")
      when :HAIL        then name, desc = _INTL("Hail"), _INTL("Non-Ice types take damage each turn. Blizzard always hits.")
      when :STRONGWINDS then name, desc = _INTL("Strong Winds"), _INTL("Flying types have no weaknesses.")
      when :SHADOWSKY   then name, desc = _INTL("Shadow Sky"), _INTL("Boosts Shadow moves. Non-Shadow Pokémon damaged each turn.")
      else                   name, desc = nil, nil
      end
      if !name.nil?
        tick = (weather == @weatherbackup) ? @battle.field.weatherDuration : 0
        tick = (tick > 0) ? sprintf("%d/%d", tick, 5) : "--"
        display_effects.push([name, tick, desc])
      end
    end
    #---------------------------------------------------------------------------
    # Terrain
    if @battle.field.isFieldEffect?
      name = PokeBattle_Field.getFieldName(@battle.field.effect)
      tick = @battle.field.duration
      tick = (tick > 0) ? sprintf("%d/%d", tick, 5) : "--"
      case @battle.field.effect
      # I do not claim these are comprehensive.
      when :ELECTERRAIN       then desc = _INTL("Grounded Pokémon immune to sleep. Boosts Electric moves.")
      when :GRASSY            then desc = _INTL("Grounded Pokémon recover HP each turn. Boosts Grass moves.")
      when :PSYTERRAIN        then desc = _INTL("Priority moves fail on grounded targets. Boosts Psychic moves.")
      when :MISTY             then desc = _INTL("Status can't be changed when grounded. Weakens Dragon moves.")
      when :DARKCRYSTALCAVERN then desc = _INTL("Darkness and light-based moves are strengthened.")
      when :CHESS             then desc = _INTL("Pokémon are assigned Chess roles.")
      when :BIGTOP            then desc = _INTL("Show off for the crowd!")
      when :VOLCANIC          then desc = _INTL("Fire is boosted and Grass and Ice are weakened.")
      when :SWAMP             then desc = _INTL("Bug, Water, and Grass are boosted. Grounded Pokémon lose speed.")
      when :RAINBOW           then desc = _INTL("The additional effects of moves are more likely to occur.")
      when :CORROSIVE         then desc = _INTL("Grounded Poison-vulnerable Pokémon take damage on switch in.")
      when :CORROSIVEMIST     then desc = _INTL("Poison-vulnerable grounded Pokémon are poisoned each turn.")
      when :DESERT            then desc = _INTL("Water and Electric are weakened.")
      when :ICY               then desc = _INTL("Ice is boosted. Priority contact moves raise speed.")
      when :ROCKY             then desc = _INTL("Rock is boosted.")
      when :FOREST            then desc = _INTL("Special Bug and all Grass moves are boosted.")
      when :VOLCANICTOP       then desc = _INTL("Fire is boosted and Water and Ice are weakened.")
      when :FACTORY           then desc = _INTL("Electric and mechanical moves are boosted.")
      when :SHORTCIRCUIT      then desc = _INTL("Electric moves are erratic and light-based moves are boosted.")
      when :WASTELAND         then desc = _INTL("Entry hazards occur immediately. Certain moves are dangerous.")
      when :ASHENBEACH        then desc = _INTL("Focus is rewarded and mud-based moves are boosted.")
      when :WATERSURFACE      then desc = _INTL("Ground is negated and Water and Electric are boosted.")
      when :UNDERWATER        then desc = _INTL("Hope you can swim!")
      when :CAVE              then desc = _INTL("Pokémon are grounded, and Rock is boosted.")
      when :GLITCH            then desc = _INTL("Fairy doesn't exist. Category is based on type.")
      when :CRYSTALCAVERN     then desc = _INTL("Light, gemstone, Rock, and Dragon moves are boosted.")
      when :MURKWATERSURFACE  then desc = _INTL("Ground is negated. Water, Electric, and Poison are boosted.")
      when :MOUNTAIN          then desc = _INTL("Wind, Rock, and Flying are boosted.")
      when :SNOWYMOUNTAIN     then desc = _INTL("Wind, Rock, Ice, and Flying are boosted. Fire is weakened.")
      when :HOLY              then desc = _INTL("Hail to the true Type of Types.")
      when :MIRROR            then desc = _INTL("Beam moves cannot miss.")
      when :FAIRYTALE         then desc = _INTL("Knights, Dragons, and the fae thrive.")
      when :DRAGONSDEN        then desc = _INTL("Dragons are overwhelming.")
      when :FLOWERGARDEN1     then desc = _INTL("The field has room to grow.")
      when :FLOWERGARDEN2     then desc = _INTL("The field boosts Grass a little.")
      when :FLOWERGARDEN3     then desc = _INTL("Fire, Bug, and Grass are boosted.")
      when :FLOWERGARDEN4     then desc = _INTL("Fire, Bug, and Grass are boosted.")
      when :FLOWERGARDEN5     then desc = _INTL("Fire, Bug, and Grass are boosted.")
      when :STARLIGHT         then desc = @battle.pbCheckGlobalAbility(:WORLDOFNIGHTMARES) ? _INTL("A new dawn peels away at the firmament.") : _INTL("Dark, Fairy, and Psychic are boosted.")
      when :NEWWORLD          then desc = _INTL("All that remains is potential.")
      when :INVERSE           then desc = _INTL("Type interactions are reversed.")
      when :DIMENSIONAL       then desc = _INTL("Darkness surrounds you.")
      when :FROZENDIMENSION   then desc = _INTL("Frozen darkness is all you can see.")
      when :HAUNTED           then desc = _INTL("Ghost is boosted and hits Normal types.")
      when :CORRUPTED         then desc = _INTL("Poison-vulnerable grounded Pokémon are poisoned each turn.")
      when :BEWITCHED         then desc = _INTL("Poison is neutral to Grass. Dark and Fairy reign.")
      when :SKY               then desc = _INTL("Flying is boosted.")
      when :COLOSSEUM         then desc = _INTL("There is no retreat.")
      when :INFERNAL          then desc = _INTL("Dark and Fire are boosted.")
      when :CONCERT1          then desc = _INTL("Moves always do the minimum damage.")
      when :CONCERT2          then desc = _INTL("The party is getting hyped.")
      when :CONCERT3          then desc = _INTL("The party is really hyped!")
      when :CONCERT4          then desc = _INTL("Moves always do the maximum damage.")
      when :DEEPEARTH         then desc = _INTL("The Core is close...")
      when :BACKALLEY         then desc = _INTL("Dark is boosted and Fairy is weakened.")
      when :CITY              then desc = _INTL("Normal is boosted and Fairy is weakened.")
      else                    desc = _INTL("The battle is occurring on {1}.", name)
      end
      display_effects.push([name, tick, desc])

      for terrain in [:ELECTERRAIN,:GRASSY,:MISTY,:PSYTERRAIN]
        next if @battle.state.effects[terrain] == 0
        name = PokeBattle_Field.getFieldName(terrain)
        tick = @battle.state.effects[terrain]
        tick = (tick > 0) ? sprintf("%d/%d", tick, 5) : "--"
        case terrain
        when :ELECTERRAIN then desc = _INTL("Grounded Pokémon immune to sleep. Boosts Electric moves.")
        when :GRASSY      then desc = _INTL("Grounded Pokémon recover HP each turn. Boosts Grass moves.")
        when :PSYTERRAIN  then desc = _INTL("Priority moves fail on grounded targets. Boosts Psychic moves.")
        when :MISTY       then desc = _INTL("Status can't be changed when grounded. Weakens Dragon moves.")
        end
        display_effects.push([name, tick, desc])
      end

      if @battle.field.effect == :CHESS
        case battler.pokemon.piece
          when :PAWN then name, desc = _INTL("Piece: Pawn"), _INTL("The Pokémon cannot be knocked out in one hit.")
          when :KING then name, desc = _INTL("Piece: King"), _INTL("The Pokémon's moves gain +1 Priority.")
          when :KNIGHT then name, desc = _INTL("Piece: Knight"), _INL("The Pokémon gains advantage with spread moves and against Queens.")
          when :BISHOP then name, desc = _INTL("Piece: Bishop"), _INTL("The Pokémon specializes in doing damage.")
          when :ROOK then name, desc = _INTL("Piece: Rook"), _INTL("The Pokémon specializes in surviving damage.")
          when :QUEEN then name, desc = _INTL("Piece: Queen"), _INTL("The Pokémon's damage is increased.")
        end
        display_effects.push([name, "--", desc])
      end
    end

    for effectName, effectType, effectDesc, effectProc in InspectMenuDisplay::EFFECTS
      if effectType == "target"
        target = effectProc.call(battler)
        if target && target > -1
          name = _INTL(effectName)
          desc = _INTL(effectDesc, @battle.battlers[target].pbThis(true))
          display_effects.push([name, "--", desc])
        end
      elsif effectType.is_a?(Numeric)
        tick = effectProc.call(battler)
        if tick && tick != 0
          name = _INTL(effectName)
          desc = _INTL(effectDesc)
          if tick > 0
            tick = sprintf("%d/%d", tick, effectType) if effectType > 0
          else
            tick = "--"
          end
          display_effects.push([name, tick, desc])
        end
      else
        if effectProc.call(battler)
          name = _INTL(effectName)
          desc = _INTL(effectDesc)
          display_effects.push([name, "--", desc])
        end
      end
    end

    display_effects.uniq!
    return display_effects
  end
end
