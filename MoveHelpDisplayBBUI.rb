

# TODO
# More comprehensive field boost displays
# Replace selection with [002] selection menu
# Replace inspect with [003] battler info ui
# Possibly make background image less opaque?

module MoveHelpDisplay
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
  BASE_RAISED    = Color.new(50, 205, 50)
  SHADOW_RAISED  = Color.new(9, 32, 32)
  #-----------------------------------------------------------------------------
  # Red text. Used to display penalties.
  #-----------------------------------------------------------------------------
  BASE_LOWERED   = Color.new(248, 72, 72)
  SHADOW_LOWERED = Color.new(48, 32, 32)

  FLAGS_TO_CHECK = [
    :beammove, 
    [:pulsemove, [:AURASPHERE,:DRAGONPULSE,:DARKPULSE,:WATERPULSE,:ORIGINPULSE,:TERRAINPULSE]],
    [:bitemove, PBStuff::BITEMOVE], 
    [:bulletmove, PBStuff::BULLETMOVE], 
    :bypassprotect, :contact, 
    [:dancemove, PBStuff::DANCEMOVE], 
    [:defrost, PBStuff::UNFREEZEMOVE], 
    [:healingmove, [], PBStuff::HEALFUNCTIONS], 
    :highcrit, 
    :nonmirror, 
    :punchmove, 
    :sharpmove, 
    :soundmove, 
    [:tramplemove, [:BODYSLAM, :MALICIOUSMOONSAULT], [0x10, 0x137, 0x9B]], 
    :windmove, :intercept, :zmove]

  USES_SMART_DAMAGE_CATEGORY = [0x309, 0x20D, 0x80A, 0x80B] # Shell Side Arm, Super UMD Move, Unleashed Power, Blinding Speed

  @@currentIndex = -1
  @@lastTargetIndex = -1

  def self.currentIndex=(value)
    @@currentIndex=value
  end

  def self.currentIndex
    @@currentIndex
  end

  def self.lastTargetIndex=(value)
    @@lastTargetIndex=value
  end

  def self.lastTargetIndex
    @@lastTargetIndex
  end
end

class PokeBattle_Scene

  def pbToggleMoveInfo(battler, cw)
    @sprites["bbui_moveinfo"].visible = !@sprites["bbui_moveinfo"].visible
    pbUpdateMoveInfoWindow(battler, cw)
  end

  alias :movehelpdisplay_old_pbUpdateSelected :pbUpdateSelected

  def pbUpdateSelected(index)
    movehelpdisplay_old_pbUpdateSelected(index)

    cw = @sprites["fightwindow"]
    if index != -1 && cw.visible && MoveHelpDisplay.currentIndex != -1 && index != MoveHelpDisplay.lastTargetIndex
      pbUpdateMoveInfoWindow(@battle.battlers[MoveHelpDisplay.currentIndex], cw, index)
    end
  end

  alias :movehelpdisplay_old_pbChooseTarget :pbChooseTarget

  def pbChooseTarget(index)
    MoveHelpDisplay.currentIndex = index
    ret = movehelpdisplay_old_pbChooseTarget(index)
    MoveHelpDisplay.currentIndex = -1
    return ret
  end

  alias :movehelpdisplay_old_pbChooseTargetAcupressure :pbChooseTargetAcupressure
  def pbChooseTargetAcupressure(index)
    MoveHelpDisplay.currentIndex = index
    ret = movehelpdisplay_old_pbChooseTargetAcupressure(index)
    MoveHelpDisplay.currentIndex = -1
    return ret
  end

  #-----------------------------------------------------------------------------
  # Draws the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbUpdateMoveInfoWindow(battler, cw, foeindex=-1)
    MoveHelpDisplay.lastTargetIndex = foeindex
    bm = @sprites["bbui_moveinfo"].bitmap
    bm.clear
    return if !@sprites["bbui_moveinfo"].visible
    xpos = 0
    ypos = 76
    move = battler.moves[cw.index].clone
    if cw.zButton == 2 && !battler.zmoves.nil? && !battler.zmoves[cw.index].nil?
      move = battler.zmoves[cw.index]
    end
    powBase   = accBase   = priBase   = effBase   = MoveHelpDisplay::BASE_LIGHT
    powShadow = accShadow = priShadow = effShadow = MoveHelpDisplay::SHADOW_LIGHT
    basePower = calcPower = move.basedamage

    knownFoe = nil

    if @battle.doublebattle
      if foeindex != -1
        knownFoe = @battle.battlers[foeindex]
      end
      knownFoe = battler.pbOpposing2 if battler.pbOpposing1.isFainted?
      knownFoe = battler.pbOpposing1 if battler.pbOpposing2.isFainted?
    else
      knownFoe = battler.pbOpposing1
      knownFoe = battler.pbOpposing2 if knownFoe.isFainted? && !battler.pbOpposing2.isFainted?
    end

    if knownFoe.nil?
      power = defined?(hpSummary_trueDamage) ? hpSummary_trueDamage(move, battler.pokemon) : move.basedamage
    else
      power = move.pbBaseDamage(basePower, battler, knownFoe)
      if move.function == 0x91 && battler.effects[:FuryCutter] < 4 # Fury Cutter
        power *= 2
      end
    end

    category = move.betterCategory
    if MoveHelpDisplay::USES_SMART_DAMAGE_CATEGORY.include?(move.function) # Moves which basically choose category but don't pretend to
      if knownFoe.nil?
        category = PokeBattle_Move.pbFromPBMove(battler.battle, PBMove.new(:PHOTONGEYSER), battler).betterCategory
      else
        tempMove = PokeBattle_Move.pbFromPBMove(battler.battle, PBMove.new(:UNLEASHEDPOWER), battler)
        tempMove.smartDamageCategory(battler, knownFoe)
        category = tempMove.betterCategory
      end
    end

    type = move.pbType(battler)
    secondtype = move.getSecondaryType(battler)

    #---------------------------------------------------------------------------
    cattype = 2
    case category
      when :physical then cattype = 0
      when :special  then cattype = 1
      when :status   then cattype = 2
    end

    # Draws images.
    imagePos = [[sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type), xpos, ypos, 0, 0, 512, 168]]

    if secondtype.nil?
      imagePos.push([sprintf("Graphics/Icons/type%s", type),              xpos + 282, ypos + 8, 0, 0,            64, 28],
                    ["Graphics/Pictures/category",                        xpos + 350, ypos + 8, 0, cattype * 28, 64, 28])
    elsif secondtype.length == 1
      imagePos.push([sprintf("Graphics/Icons/type%s", type),              xpos + 284, ypos + 8, 0, 0,            64, 28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[0]), xpos + 348, ypos + 8, 0, 0,            28, 28],
                    ["Data/Mods/BetterBattleUI/minicategory",              xpos + 384, ypos + 8, 0, cattype * 28, 28, 28])
    else

      imagePos.push([sprintf("Graphics/Icons/minitype%s", type),          xpos + 282, ypos + 8, 0, 0,            28, 28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[0]), xpos + 310, ypos + 8, 0, 0,            28, 28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[1]), xpos + 338, ypos + 8, 0, 0,            28, 28],
                    ["Data/Mods/BetterBattleUI/minicategory",     xpos + 386, ypos + 8, 0, cattype * 28, 28, 28])
    end

    pbDrawMoveFlagIcons(battler, xpos, ypos, move, imagePos)
    pbDrawImagePositions(bm, imagePos)
    #---------------------------------------------------------------------------
    # Final move attribute calculations.
    acc = move.accuracy
    pri = move.priority
    chance = move.effect
    baseChance = chance
    calcPower = power if power > basePower
    if basePower > 1
      if calcPower > basePower
        powBase, powShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
      elsif power < basePower
        powBase, powShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
      end
    end
    # if acc > 0
    #   if acc > move.accuracy
    #     accBase, accShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
    #   elsif acc < move.accuracy
    #     accBase, accShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
    #   end
    # end
    # if pri != 0
    #   if pri > move.priority
    #     priBase, priShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
    #   elsif pri < move.priority
    #     priBase, priShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
    #   end
    # end
    # if chance > 0
    #   if chance > baseChance
    #     effBase, effShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
    #   elsif chance < baseChance
    #     effBase, effShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
    #   end
    # end
    #---------------------------------------------------------------------------
    # Draws text.
    textPos = []
    displayPower    = (power  == 0)                  ? "-" : (power == 1) ? "?" : power.ceil.to_s
    displayAccuracy = (acc    == 0)                  ? "-" : acc.ceil.to_s
    displayPriority = (pri    == 0)                  ? "-" : (pri > 0) ? "+" + pri.to_s : pri.to_s
    displayChance   = (chance == 0 || chance == 100) ? "-" : chance.ceil.to_s + "%"
    textPos.push(
      [move.getMoveUseName, xpos + 10,  ypos + 14, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT, true],
      [_INTL("Pow"),        xpos + 256, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
      [displayPower,        xpos + 309, ypos + 44, 2, powBase,                  powShadow],
      [_INTL("Acc"),        xpos + 348, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
      [displayAccuracy,     xpos + 401, ypos + 44, 2, accBase,                  accShadow],
      [_INTL("Pri"),        xpos + 442, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
      [displayPriority,     xpos + 484, ypos + 44, 2, priBase,                  priShadow],
      [_INTL("Eff"),        xpos + 428, ypos + 14, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
      [displayChance,       xpos + 484, ypos + 14, 2, effBase,                  effShadow]
    )
    # textPos.push([bonus[0], xpos + 8, ypos + 132, 0, bonus[1], bonus[2], true]) if bonus
    pbDrawTextPositions(bm, textPos)

    normtext=getLineBrokenChunks(bm,getMoveDesc(move.move),Graphics.width - 12,nil,true)
    linecount = normtext[-1][2] / 32 + 1
    textheight = 26
    textheight = 21 if linecount > 3
    for i in normtext
      i[2] = (i[2] >> 5) * textheight
    end
    renderLineBrokenChunksWithShadow(bm,xpos + 8,ypos+70,normtext,84,
       MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT)
  end
  
  #-----------------------------------------------------------------------------
  # Draws the move flag icons for each move in the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbDrawMoveFlagIcons(battler, xpos, ypos, move, imagePos)
    flagX = xpos + 6
    flagY = ypos + 40
    icons = 0
    flags = []
    for flag in MoveHelpDisplay::FLAGS_TO_CHECK
      if flag.is_a?(Array)
        if flag.length == 2
          flags.push(flag[0]) if move.hasFlag?(flag[0]) || flag[1].include?(move.move)
        elsif flag.length == 3
          flags.push(flag[0]) if move.hasFlag?(flag[0]) || flag[1].include?(move.move) || flag[2].include?(move.function)
        end
      else
        flags.push(flag) if move.hasFlag?(flag)
      end
    end
    flags.push(:bypassprotect) if move.move == :FIRSTIMPRESSION && battler.battle.FE == :COLOSSEUM
    flags.delete(:zmove) if flags.include?(:intercept)
    flags.each do |flag|
      break if icons > 8
      path = sprintf("Data/Mods/BetterBattleUI/MoveFlags/%s", flag)
      next if !pbResolveBitmap(path)
      imagePos.push([path, flagX + (icons * 26), flagY, 0, 0, 26, 28])
      icons += 1
    end
  end
end