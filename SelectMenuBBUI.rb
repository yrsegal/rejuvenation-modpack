
# Based on https://eeveeexpo.com/threads/7796/
module SelectMenuBBUI
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

  VISUAL_MAPPING = {
    0 => 0, # Player pkmn 1
    1 => 3, # Opp pkmn 1
    2 => 2, # Player pkmn 2
    3 => 1  # Opp pkmn 2
  }

  INPUT_MAPPING = {
    Input::LEFT => [2, 1, 0],
    Input::RIGHT => [2, 3, 2],
    Input::UP => [1, 2, 0],
    Input::DOWN => [1, 3, 2]
  }
end

#===============================================================================
# Battle Info UI - Selection menu.
#===============================================================================
class PokeBattle_Scene

  #-----------------------------------------------------------------------------
  # Draws the selection menu.
  #-----------------------------------------------------------------------------
  def bbui_pbUpdateBattlerSelection(idxPoke, trueBattler, cw, prevselectmode)
    @sprites["bbui_canvas"].bitmap.clear
    ypos = 68
    textPos = []
    imagePos = [["Data/Mods/BetterBattleUI/Inspect/selectbg", 0, ypos, 0, 0, -1, -1]]
    count = 1
    count = 2 if @battle.doublebattle
    oppTrainers = []
    plyTrainers = []

    moveShift = prevselectmode == :move && defined?(bbui_pbDrawPartialMoveInfo)

    for i in 0...(count * 2)
      b = @battle.battlers[i]
      trueidx = i
      case count
      when 1 then iconX, bgX = 202, 173
      when 2
        i = SelectMenuBBUI::VISUAL_MAPPING[i]
        if i == 3 && b && b.isbossmon && (!b.pbPartner || b.pbPartner.isFainted?)
          iconX, bgX = 202, 173
        elsif i == 1 && b && b.isFainted? && b.pbPartner.isbossmon
          next
        else
          iconX, bgX = 96 + (104 * (i & 2)), 68 + (104 * (i & 2))
        end
        iconX -= 48 if moveShift
        bgX -= 48 if moveShift
      end
      iconY = ypos + 38
      iconY += 76 unless @battle.pbIsOpposing?(i)
      nameX = iconX + 82
      if idxPoke == trueidx
        base, shadow = SelectMenuBBUI::BASE_LIGHT, SelectMenuBBUI::SHADOW_LIGHT
        imagePos.push(["Data/Mods/BetterBattleUI/Inspect/cursor", bgX, iconY - 28, 0, 52, 166, 52])
      else
        base, shadow = SelectMenuBBUI::BASE_DARK, SelectMenuBBUI::SHADOW_DARK
        imagePos.push(["Data/Mods/BetterBattleUI/Inspect/cursor", bgX, iconY - 28, 0, 0, 166, 52])
      end
      @sprites["bbui_info_icon#{trueidx}"].x = iconX - 28
      @sprites["bbui_info_icon#{trueidx}"].y = iconY - 40
      @sprites["bbui_info_icon#{trueidx}"].visible = true
      # pbSetWithOutline("info_icon#{b.index}", [iconX, iconY, 300])
      if b && !b.isFainted?
        unless b.form > 0 && $cache.pkmn[b.species].formData.keys[b.form - 1] == 'Amalgamation'
          imagePos.push(["Data/Mods/BetterBattleUI/Inspect/gender", bgX + 148, iconY - 34, b.gender * 22, 0, 22, 22])
        end
        name = b.name
        if b.effects[:Illusion]
          if @battle.pbIsOpposing?(b.index)
            name = b.effects[:Illusion].name
          else
            name = b.pokemon.name
          end
        end
        textPos.push([_INTL("{1}", name), nameX, iconY - 16, 2, base, shadow])
        owner = @battle.pbGetOwner(b.index)
        if owner
          imagePos.push(["Data/Mods/BetterBattleUI/Inspect/owner", bgX + 36, iconY + 12, 0, 0, 128, 20])
          textPos.push([owner.name, nameX - 10, iconY + 14, 2, SelectMenuBBUI::BASE_LIGHT, SelectMenuBBUI::SHADOW_LIGHT])
          if @battle.pbIsOpposing?(i)
            oppTrainers.push([owner, i]) if oppTrainers.none? { |tr| tr[0] == owner }
          else
            plyTrainers.push([owner, i]) if plyTrainers.none? { |tr| tr[0] == owner }
          end
        end
      end
    end

    #-------------------------------------------------------------------------
    # Draws party ball lineups.
    #-------------------------------------------------------------------------
    for trainers in [oppTrainers, plyTrainers]
      if !trainers.empty?
        ballXMiddle = (Graphics.width / 2) - 48
        ballX = ballXMiddle
        trainers.each do |array|
          trainer, idxTrainer = *array
          ballXFirst = 35
          ballXLast = Graphics.width - (16 * PokeBattle_Battle::MAXPARTYSIZE) - 35
          party = @battle.pbPartySingleOwner(idxTrainer)
          if @battle.pbIsOpposing?(idxTrainer)
            ballY = ypos - 17
            ballOffset = 3
          else
            ballY = ypos + 154
            ballOffset = 2
          end
          if trainers.length > 1
            case trainer
            when trainers.first[0] then ballX = ballXFirst
            when trainers.last[0]  then ballX = ballXLast
            else                        ballX = ballXMiddle
            end
          end
          imagePos.push(["Data/Mods/BetterBattleUI/Inspect/owner", ballX - 16, ballY - ballOffset, 0, 0, 128, 20])
          PokeBattle_Battle::MAXPARTYSIZE.times do |slot|
            idx = 0
            if !party[slot]                then idx = 3 # Empty
            elsif party[slot].hp <= 0      then idx = 2 # Fainted
            elsif !party[slot].status.nil? then idx = 1 # Status
            end
            imagePos.push(["Data/Mods/BetterBattleUI/Inspect/party", ballX + (slot * 16), ballY, idx * 15, 0, 15, 15])
          end
        end
      end
    end
    bbui_pbUpdateBattlerIcons

    if moveShift
      bbui_pbDrawPartialMoveInfo(0, ypos, trueBattler, @battle.battlers[idxPoke], cw, imagePos, textPos)
    end

    pbDrawImagePositions(@sprites["bbui_canvas"].bitmap, imagePos)
    pbDrawTextPositions(@sprites["bbui_canvas"].bitmap, textPos)
  end

  def pbChooseTarget(index)
    bbui_pbSelectBattlerInfo(index, "fightwindow", :SingleNonUser)
  end
  def pbChooseAccupressureTarget(index)
    bbui_pbSelectBattlerInfo(index, "fightwindow", :UserOrPartner)
  end

  def pbStatInfo(index)
    res = bbui_pbSelectBattlerInfo(index, "commandwindow")
    return @battle.battlers[res] if res >= 0
    return -1
  end

  def bbui_isAcceptable(index, origIndex, mode)
    index = SelectMenuBBUI::VISUAL_MAPPING[index] if @battle.doublebattle
    origIndex = SelectMenuBBUI::VISUAL_MAPPING[origIndex] if @battle.doublebattle
    return false unless @battle.battlers[index] && !@battle.battlers[index].isFainted?
    case mode
    when :UserOrPartner then return (index & 1) == (origIndex & 1)
    when :SingleNonUser then return index != origIndex
    else                     return true
    end
  end

  #-----------------------------------------------------------------------------
  # Handles the controls for the selection menu.
  #-----------------------------------------------------------------------------
  def bbui_pbSelectBattlerInfo(index, cwtype, mode=nil)
    prevselectmode = @bbui_displaymode
    @bbui_displaymode = :select
    @sprites["bbui_canvas"].visible = true
    trueBattler = @battle.battlers[index]
    case mode
    when :UserOrPartner then idxPoke = pbFirstTargetAcupressure(index)
    when :SingleNonUser then idxPoke = pbFirstTarget(index)
    else                idxPoke = index
    end
    if idxPoke == -1
      raise RuntimeError.new(_INTL("No targets somehow..."))
    end
    battler = @battle.battlers[idxPoke]
    cw = @sprites[cwtype]
    result = nil
    bbui_pbUpdateBattlerSelection(idxPoke, trueBattler, cw, prevselectmode)
    loop do
      oldPoke = idxPoke
      pbGraphicsUpdate
      pbFrameUpdate(cw)
      Input.update
      bbui_pbUpdateInfoSprites
      if Input.trigger?(Input::B)
        result = prevselectmode
        break
      elsif Input.trigger?(Input::C)
        pbPlayDecisionSE
        result = idxPoke
        break
      elsif Input.trigger?(Input::Y)
        if mode.nil?
          pbPlayDecisionSE
          result = idxPoke
          break
        else
          pbPlayCursorSE
          prevselectmode = prevselectmode == :move ? nil : :move
          oldPoke = -1
        end
      end
      for inp, consts in SelectMenuBBUI::INPUT_MAPPING
        if Input.trigger?(inp)
          idxPoke = SelectMenuBBUI::VISUAL_MAPPING[idxPoke] if @battle.doublebattle
          if idxPoke == 3 && battler && battler.isbossmon && (!battler.pbPartner || battler.pbPartner.isFainted?)
            target = consts[2]
            if bbui_isAcceptable(target, index, mode)
              idxPoke = target
            else
              target = target ^ 2
              idxPoke = target if bbui_isAcceptable(target, index, mode)
            end
          else
            target = idxPoke ^ consts[0]
            if bbui_isAcceptable(target, index, mode)
              idxPoke = target
            else
              target = target ^ consts[1]
              if bbui_isAcceptable(target, index, mode)
                idxPoke = target
              else
                target = target ^ consts[0]
                idxPoke = target if bbui_isAcceptable(target, index, mode)
              end
            end
          end
          idxPoke = SelectMenuBBUI::VISUAL_MAPPING.invert[idxPoke] if @battle.doublebattle
          pbPlayCursorSE
          break
        end
      end
      if oldPoke != idxPoke
        bbui_pbUpdateBattlerSelection(idxPoke, trueBattler, cw, prevselectmode)
        battler = @battle.battlers[idxPoke]
        # @battle.battlers.each do |b|
        #   showOutline = b.index == battler.index
        #   pbShowOutline("info_icon#{b.index}", showOutline)
        # end
      end
    end
    @bbui_displaymode = nil
    @sprites["bbui_canvas"].visible = false
    @battle.battlers.each do |b|
      @sprites["bbui_info_icon#{b.index}"].visible = false
    end
    if result == :move
      bbui_pbToggleMoveInfo(trueBattler, cw)
    elsif result.is_a?(Numeric)
      return result
    end
    return -1
  end
end