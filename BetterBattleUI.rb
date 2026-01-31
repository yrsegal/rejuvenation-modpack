begin
  missing = ['BetterBattleUI'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end
$betterBattleUI_typeIcons_bitmaps = nil # Force the reloading of disposed graphics on soft resetting
$betterBattleUI_statBoosts_data = nil

$BBUI_FIXED_DAMAGE = [
  0x06A, # Sonic Boom
  0x06B, # Dragon Rage
  0x06C, # Super Fang
  0x06D, # Seismic Toss
  0x06E, # Endeavor
  0x06F, # Psywave
  0x070, # OHKO
  0x071, # Counter
  0x072, # Mirror Coat
  0x073, # Metal Burst
  0x0D4, # Bide
  0x0E1, # Final Gambit
  0x809, # Guardian of Alola
]

$BBUI_FIXED_DAMAGE_FIELD = {
  0x118 => :DEEPEARTH # Gravity
}

TextureOverrides.registerTextureOverride(TextureOverrides::BATTLEICON + "battleFightButtonsFighting", "#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/FightingButton") if defined?(TextureOverrides)

module BBUIConsts
  X_PAD = 50
  Y_PAD = 40
end

class AnimatedBitmap
  ### MODDED/
  def betterBattleUI_setBitmap(bitmap)
    @bitmap.betterBattleUI_setBitmap(bitmap)
  end
  ### /MODDED
end
class GifBitmap
  ### MODDED/
  def betterBattleUI_setBitmap(bitmap)
    @gifbitmaps[@currentIndex] = bitmap
  end
  ### /MODDED
end


def betterBattleUI_statBoosts_statMapping
  return [
                PBStats::ACCURACY,
    PBStats::ATTACK,         PBStats::SPATK,
                PBStats::SPEED,
    PBStats::DEFENSE,         PBStats::SPDEF,
                PBStats::EVASION
  ]
end
def betterBattleUI_statBoosts_coordMapping
  return [
                    [14,0],
        [2,10],                   [26,10],
                    [14,20],
        [2,30],                   [26,30],
                    [14,40]
  ]
end
def betterBattleUI_statBoosts_shouldUpdateBitmap(battler)
  return true if !defined?($betterBattleUI_statBoosts_data)
  return true if !$betterBattleUI_statBoosts_data
  return true if !$betterBattleUI_statBoosts_data[:battlers][battler.index]
  return true if $betterBattleUI_statBoosts_data[:battlers][battler.index][:bitmap].disposed?
  for pos in 0...$betterBattleUI_statBoosts_data[:battlers][battler.index][:stats].length
    lastVal=$betterBattleUI_statBoosts_data[:battlers][battler.index][:stats][pos]
    currVal=betterBattleUI_statBoosts_statValue(pos,battler)
    return true if lastVal != currVal
  end
  return false
end

def betterBattleUI_statBoosts_statValue(statPosition,battler)
  mapping=betterBattleUI_statBoosts_statMapping
  stat=mapping[statPosition]
  return 0 if !defined?(battler.stages)
  return battler.stages[stat]
end

def betterBattleUI_statBoosts_updateBitmap(battler)
  if !defined?($betterBattleUI_statBoosts_data) || !$betterBattleUI_statBoosts_data
    $betterBattleUI_statBoosts_data={
      'battlers': []
    }
  end
  # Get the current stages
  if $betterBattleUI_statBoosts_data[:battlers][battler.index]
    len=$betterBattleUI_statBoosts_data[:battlers][battler.index][:stats].length
  else
    $betterBattleUI_statBoosts_data[:battlers][@battler.index]={
      'stats': []
    }
    mapping=betterBattleUI_statBoosts_statMapping
    len=mapping.length
  end
  for pos in 0...len
    $betterBattleUI_statBoosts_data[:battlers][@battler.index][:stats][pos]=betterBattleUI_statBoosts_statValue(pos,battler)
  end
  # Get the bitmap
  $betterBattleUI_statBoosts_data[:battlers][@battler.index][:bitmap]=betterBattleUI_statBoosts_buildBitmap(battler)
end

def betterBattleUI_statBoosts_buildBitmap(battler)
  betterBattleUI_statBoosts_ensureGraphicsLoaded
  bitmap=$betterBattleUI_statBoosts_data[:background].bitmap
  result=Bitmap.new(bitmap.rect.width, bitmap.rect.height)
  result.blt(0, 0, bitmap, bitmap.rect)
  coordsMapping=betterBattleUI_statBoosts_coordMapping
  for pos in 0...$betterBattleUI_statBoosts_data[:battlers][battler.index][:stats].length
    val=$betterBattleUI_statBoosts_data[:battlers][battler.index][:stats][pos]
    stage="#{val}"
    next if !$betterBattleUI_statBoosts_data[:stages][stage]
    x,y=coordsMapping[pos]
    result.blt(x, y, $betterBattleUI_statBoosts_data[:stages][stage], $betterBattleUI_statBoosts_data[:stages][stage].rect)
  end
  return result
end

def betterBattleUI_statBoosts_ensureGraphicsLoaded
  if !$betterBattleUI_statBoosts_data[:background] || $betterBattleUI_statBoosts_data[:background].disposed?
    $betterBattleUI_statBoosts_data[:background]=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/StatGrid.png")
  end
  $betterBattleUI_statBoosts_data[:stages]={} if !$betterBattleUI_statBoosts_data[:stages]
  stagesToBeLoaded=[]
  for i in -6..6
    stage="#{i}"
    next if $betterBattleUI_statBoosts_data[:stages][stage] && !$betterBattleUI_statBoosts_data[:stages][stage].disposed?
    stagesToBeLoaded.push(i)
  end
  return nil if stagesToBeLoaded.length <= 0
  rawBmp=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/StatStages.png")
  for i in stagesToBeLoaded
    stage="#{i}"
    if i == 0
      $betterBattleUI_statBoosts_data[:stages][stage]=nil
      next
    end
    rect=betterBattleUI_statBoosts_createDisplayRect(i)
    bitmap=Bitmap.new(rect.width, rect.height)
    bitmap.blt(0, 0, rawBmp.bitmap, rect)
    $betterBattleUI_statBoosts_data[:stages][stage]=bitmap
  end
end

def betterBattleUI_statBoosts_createDisplayRect(stageId)
  stageWidth=22
  stageHeight=22
  paddingTop=0
  if stageId > 0
    i=stageId
    x=0
  else
    i=-stageId
    x=stageWidth
  end
  y=i*(stageHeight+paddingTop)-stageHeight
  return Rect.new(x, y, stageWidth, stageHeight)
end

class BossPokemonDataBox < SpriteWrapper
  def betterBattleUI_statBoosts_tabCoords
    rect=$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:bitmap].rect
    case @battlerindex
    # Player's mon in singles
    when 0 then return 34-rect.width, 0
    # Foe's mon in singles
    when 1 then return @shieldGaugeX+@shieldX, @shieldGaugeY/2
    # Player's other mon in doubles
    when 2 then return 34-rect.width, 0
    # Foe's other mon in doubles
    else        return @shieldGaugeX+@shieldX, @shieldGaugeY/2
    end
  end

  def betterBattleUI_statBoosts_drawTab
    statsBitmap=$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:bitmap]
    x,y=betterBattleUI_statBoosts_tabCoords
    x,y=betterBattleUI_statBoosts_ensureOffsets(x, y)
    self.bitmap.blt(x, y, statsBitmap, statsBitmap.rect)
  end

  def betterBattleUI_statBoosts_ensureOffsets(x, y)
    offsetX=[-x, 0].max
    offsetY=[-y, 0].max
    rect=$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:bitmap].rect
    # Save the old positions
    type=@battler.battle.doublebattle ? 'doubleBattle' : 'singleBattle'
    $betterBattleUI_statBoosts_data[:battlers][@battlerindex][:oldGeometry]={} if !$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:oldGeometry]
    $betterBattleUI_statBoosts_data[:battlers][@battlerindex][:oldGeometry][type]={} if !$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:oldGeometry][type]
    old=$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:oldGeometry][type]
    old[:bitmap_width]=self.bitmap.width if !old[:bitmap_width]
    old[:bitmap_height]=self.bitmap.height if !old[:bitmap_height]
    old[:spritebaseX]=@spritebaseX if !old[:spritebaseX]
    old[:spritebaseY]=@spritebaseY if !old[:spritebaseY]
    old[:spriteX]=@spriteX if !old[:spriteX]
    old[:spriteY]=@spriteY if !old[:spriteY]
    # Extend in the positive
    rect=$betterBattleUI_statBoosts_data[:battlers][@battlerindex][:bitmap].rect
    targetX=[old[:bitmap_width]+offsetX, offsetX+x+rect.width].max
    targetY=[old[:bitmap_height]+offsetY, offsetY+y+rect.height].max
    if self.bitmap.width < targetX || self.bitmap.height < targetY
      temp=Bitmap.new(targetX, targetY)
      temp.blt(0, 0, self.bitmap, self.bitmap.rect)
      self.bitmap=temp
    end
    # Extend in the negative
    if !defined?(@statsBoostsOffsetApplied) || !@statsBoostsOffsetApplied
      if (offsetX != 0 || offsetY != 0)
        bitmap=Bitmap.new(@databox.bitmap.width+2*offsetX, @databox.bitmap.height+2*offsetY)
        bitmap.blt(offsetX, offsetY, @databox.bitmap, @databox.bitmap.rect)
        @databox.betterBattleUI_setBitmap(bitmap)

        if defined?(@spritebaseX)
          @spritebaseX=old[:spritebaseX]+offsetX
          @betterBattleUI_statBoosts_xShift = offsetX
        end
        if defined?(@spritebaseY)
          @spritebaseY=old[:spritebaseY]+offsetY
        end
        @spriteX=old[:spriteX]-offsetX
        # @spriteY=old[:spriteY]-offsetY
      end
      @statsBoostsOffsetApplied=true
    end

    # Fin
    return x+offsetX, y+offsetY
  end

  alias :betterBattleUI_old_refresh :refresh

  def refresh(*args, **kwargs)
    ret = betterBattleUI_old_refresh(*args, **kwargs)
    if defined?(@battler.stages)
      betterBattleUI_statBoosts_updateBitmap(@battler) if betterBattleUI_statBoosts_shouldUpdateBitmap(@battler)
      betterBattleUI_statBoosts_drawTab if @battler.pokemon
    end
  end

end

### Command Menu Throw Ball

class BetterBattleUI_PokeballThrowButtonDisplay
  def initialize(battle,viewport=nil)
    @battle = battle
    @display=BetterBattleUI_PokeballThrowButton.new(viewport)
  end

  def updateData(index)
    @display.updateData(index, @battle)
  end

  def throwBall(scene)
    ball = @display.pokeball
    if pbIsPokeBall?(ball) && ItemHandlers.hasBattleUseOnBattler(ball) && @display.canCatch(@battle)
      scene.betterBattleUI_autoselectitem = ball
      return true
    end
    return false
  end

  def changeBall(index)
    $PokemonBag.setChoice(3, ($PokemonBag.getChoice(3) + 1) % $PokemonBag.pockets[3].length)
    updateData(index)
  end

  def x; @display.x; end
  def x=(value)
    @display.x=value
  end

  def y; @display.y; end
  def y=(value)
    @display.y=value
  end

  def z; @display.z; end
  def z=(value)
    @display.z=value
  end

  def ox; @display.ox; end
  def ox=(value)
    @display.ox=value
  end

  def oy; @display.oy; end
  def oy=(value)
    @display.oy=value
  end

  def visible; @display.visible; end
  def visible=(value)
    @display.visible=value
  end

  def color; @display.color; end
  def color=(value)
    @display.color=value
  end

  def disposed?
    return @display.disposed?
  end

  def dispose
    return if disposed?
    @display.dispose
  end

  def refresh
    @display.refresh
  end

  def update
    @display.update
  end
end


class BetterBattleUI_PokeballThrowButton < BitmapSprite
  attr_reader :pokeball

  def initialize(viewport=nil)
    super(44,68,viewport)
    self.x=0
    self.y=118
    @buttonbitmap=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/ThrowBall")
    @pokeball = nil
    @pokeballbitmap=nil
    @cancatch = false
  end

  def dispose
    @buttonbitmap.dispose
    super
  end

  def updateData(index, battle)
    @index = index

    ball = $PokemonBag.pockets[3][$PokemonBag.getChoice(3)] || $PokemonBag.pockets[3][0]  # Pokeballs
    if !ball.nil? && pbIsPokeBall?(ball) && (ball != @pokeball || !@pokeballbitmap)
      @pokeball = ball
      @pokeballbitmap = AnimatedBitmap.new(sprintf("Graphics/Icons/" + @pokeball.to_s.downcase))
    end

    @cancatch = canCatch(battle)

    refresh
  end

  def refresh
    self.bitmap.clear
    if @pokeballbitmap && @cancatch
      self.bitmap.blt(0,0,@buttonbitmap.bitmap,Rect.new(0,0,44,68))
      self.bitmap.blt(-4,0,@pokeballbitmap.bitmap,Rect.new(0,0,48,48))
    end
  end

  def update
    refresh
  end

  def canCatch(battle)
    if battle.pbIsOpposing?(@index)
      target=battle.battlers[@index]
    else
      target=battle.battlers[@index].pbOppositeOpposing
    end
    if target.isFainted?
      target=target.pbPartner
    end
    return false if @pokeball == nil || $PokemonBag.pbQuantity(@pokeball) == 0
    return false if target.isFainted?
    return false if battle.opponent && (!pbIsSnagBall?(@pokeball) || !target.isShadow?)
    return false if $game_switches[:No_Catching] || target.issossmon || (target.isbossmon && (!target.capturable || target.shieldCount > 0))
    return true
  end
end

class PokeBattle_Scene

  alias :betterBattleUI_old_pbStartBattle :pbStartBattle

  def pbStartBattle(battle)
    betterBattleUI_old_pbStartBattle(battle)
    @bbui_displaymode = nil
    @sprites["bbui_ballwindow"]=BetterBattleUI_PokeballThrowButtonDisplay.new(@battle,@viewport)
    @sprites["bbui_ballwindow"].z=100
    @sprites["bbui_canvas"]=BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["bbui_canvas"].z=101
    @sprites["bbui_canvas"].visible=false
    pbSetSmallFont(@sprites["bbui_canvas"].bitmap)

    @sprites["bbui_leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow", 8, 40, 28, 2, @viewport)
    @sprites["bbui_leftarrow"].x = -2
    @sprites["bbui_leftarrow"].y = 71
    @sprites["bbui_leftarrow"].z = 300
    @sprites["bbui_leftarrow"].play
    @sprites["bbui_leftarrow"].visible = false
    @sprites["bbui_rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow", 8, 40, 28, 2, @viewport)
    @sprites["bbui_rightarrow"].x = Graphics.width - 38
    @sprites["bbui_rightarrow"].y = 71
    @sprites["bbui_rightarrow"].z = 300
    @sprites["bbui_rightarrow"].play
    @sprites["bbui_rightarrow"].visible = false
    @battle.battlers.each do |b|
      @sprites["bbui_info_icon#{b.index}"] = PokemonIconSprite.new(b.pokemon, @viewport)
      # @sprites["bbui_info_icon#{b.index}"].setOffset(PictureOrigin::CENTER)
      @sprites["bbui_info_icon#{b.index}"].visible = false
      @sprites["bbui_info_icon#{b.index}"].z = 300
      # pbAddSpriteOutline(["bbui_info_icon#{b.index}", @viewport, b.pokemon, PictureOrigin::CENTER])
    end
  end

  def bbui_pbUpdateBattlerIcons
    @battle.battlers.each do |b|
      next if !b
      poke = b.pokemon
      if @battle.pbIsOpposing?(b.index)
        poke = b.effects[:Illusion] ? b.effects[:Illusion] : poke
        poke = poke.pokemon if poke.is_a?(PokeBattle_Battler)
      end
      if !b.isFainted?
        @sprites["bbui_info_icon#{b.index}"].pokemon = poke
        @sprites["bbui_info_icon#{b.index}"].visible = @bbui_displaymode == :battler || @bbui_displaymode == :select
      else
        @sprites["bbui_info_icon#{b.index}"].visible = false
      end
    end
  end

  def bbui_pbUpdateInfoSprites
    @sprites["bbui_leftarrow"].update
    @sprites["bbui_rightarrow"].update
    @sprites.each_key do |key|
      next if !key.include?("bbui_info_icon")
      next if @sprites[key].disposed?
      @sprites[key].update
    end
  end

  alias :betterBattleUI_old_pbEndBattle :pbEndBattle

  def pbEndBattle(*args, **kwargs)
    $betterBattleUI_statBoosts_data = nil
    $betterBattleUI_typeIcons_bitmaps = nil
    return betterBattleUI_old_pbEndBattle(*args, **kwargs)
  end

  alias :betterBattleUI_old_pbShowWindow :pbShowWindow

  def pbShowWindow(windowtype)
    betterBattleUI_old_pbShowWindow(windowtype)
    @sprites["bbui_ballwindow"].visible=windowtype==COMMANDBOX if @sprites["bbui_ballwindow"]
    @bbui_displaymode = nil if @bbui_displaymode == :move && windowtype != FIGHTBOX
    @sprites["bbui_canvas"].visible=!@bbui_displaymode.nil? if @sprites["bbui_canvas"]
  end

  attr_accessor :betterBattleUI_autoselectitem
  alias :betterBattleUI_old_pbItemMenu :pbItemMenu

  def pbItemMenu(i)
    if @betterBattleUI_autoselectitem
      ret = @betterBattleUI_autoselectitem
      @betterBattleUI_autoselectitem = nil
      return [ret, $PokemonBag.getChoice(3)]
    end
    return betterBattleUI_old_pbItemMenu(i)
  end

  def pbCommandMenuEx(index,texts,mode=0)      # Mode: 0 - regular battle
    pbShowWindow(COMMANDBOX)                   #       1 - Shadow Pokémon battle
    cw=@sprites["commandwindow"]               #       2 - Safari Zone
    cw.setTexts(texts)                         #       3 - Bug Catching Contest
    cw.index=0 if @lastcmd[index]==2
    cw.mode=mode
    ### MODDED/
    bw=@sprites["bbui_ballwindow"]
    bw.updateData(index) if bw
    ### /MODDED
    pbSelectBattler(index)
    pbRefresh
    update_menu=true
    loop do
      pbGraphicsUpdate
      Input.update
      pbFrameUpdate(cw,update_menu)
      ### MODDED/
      bw.updateData(index) if bw
      ### /MODDED
      update_menu=false
      # Update selected command
      if Input.trigger?(Input::CTRL)
        pbToggleStatsBoostsVisibility
        pbPlayCursorSE()
        update_menu=true
      elsif Input.trigger?(Input::LEFT) && (cw.index&1)==1
        pbPlayCursorSE()
        cw.index-=1
        update_menu=true
      elsif Input.trigger?(Input::RIGHT) &&  (cw.index&1)==0
        pbPlayCursorSE()
        cw.index+=1
        update_menu=true
      elsif Input.trigger?(Input::UP) &&  (cw.index&2)==2
        pbPlayCursorSE()
        cw.index-=2
        update_menu=true
      elsif Input.trigger?(Input::DOWN) &&  (cw.index&2)==0
        pbPlayCursorSE()
        cw.index+=2
        update_menu=true
      ### MODDED/
      elsif Input.trigger?(Input::B) && index==0 && cw.index != 3 # X Over Run
        pbPlayDecisionSE()
        cw.index=3
        update_menu=true
      elsif Input.trigger?(Input::L) # Throw Pokeball Directly
        if bw.throwBall(self)
          pbPlayDecisionSE()
          return 1
        end
      elsif Input.trigger?(Input::R) # Change Pokeball
        if $PokemonBag.pockets[3].length > 1
          pbPlayDecisionSE()
          bw.changeBall(index)
        end
      ### /MODDED
      elsif Input.trigger?(Input::Y)  #Show Battle Stats feature made by DemICE
        statstarget=pbStatInfo(index)
        return -1 if statstarget==-1
        if !pbInSafari?
          pbShowBattleStats(statstarget)
        end
      end
      if Input.trigger?(Input::C)   # Confirm choice
        pbPlayDecisionSE()
        ret=cw.index
        @lastcmd[index]=ret
        cw.index=0 if $Settings.remember_commands==0
        return ret
      elsif Input.trigger?(Input::B) && index==2 #&& @lastcmd[0]!=2 # Cancel #Commented out for cancelling switches in doubles
        pbPlayDecisionSE()
        return -1
      end
    end
  end

  ### MOVE INFO

  alias :betterBattleUI_old_pbFrameUpdate :pbFrameUpdate

  def pbFrameUpdate(cw, update_cw=true)
    betterBattleUI_old_pbFrameUpdate(cw, update_cw)
    bbui_pbUpdateMoveInfoWindow(cw.battler, cw) if cw && @sprites["bbui_canvas"] && update_cw && @bbui_displaymode == :move
  end

  def pbFightMenu(index)
    pbShowWindow(FIGHTBOX)
    cw = @sprites["fightwindow"]
    battler=@battle.battlers[index]
    cw.battler=battler
    lastIndex=@lastmove[index]
    if battler.moves[lastIndex]
      cw.setIndex(lastIndex)
    else
      cw.setIndex(0)
    end
    cw.megaButton=0
    cw.megaButton=1 if (@battle.pbCanMegaEvolve?(index) && !@battle.pbCanZMove?(index))
    cw.megaButton=2 if @battle.megaEvolution[(@battle.pbIsOpposing?(index)) ? 1 : 0][@battle.pbGetOwnerIndex(index)] == index && @battle.battlers[index].hasMega?
    cw.ultraButton=0
    cw.ultraButton=1 if @battle.pbCanUltraBurst?(index)
    cw.ultraButton=2 if @battle.ultraBurst[(@battle.pbIsOpposing?(index)) ? 1 : 0][@battle.pbGetOwnerIndex(index)] == index && @battle.battlers[index].hasUltra?
    cw.zButton=0
    cw.zButton=1 if @battle.pbCanZMove?(index)
    #cw.zButton=2 if @battle.zMove[(@battle.pbIsOpposing?(index)) ? 1 : 0][@battle.pbGetOwnerIndex(index)] == index && @battle.battlers[index].hasZMove?
    pbSelectBattler(index)
    pbRefresh
    update_menu = true
    loop do
        Graphics.update
        Input.update
        pbFrameUpdate(cw,update_menu)
        update_menu = false
      # Update selected command
      if Input.trigger?(Input::LEFT) && (cw.index&1)==1
        pbPlayCursorSE() if cw.setIndex(cw.index-1)
          update_menu=true
      elsif Input.trigger?(Input::RIGHT) &&  (cw.index&1)==0
        pbPlayCursorSE() if cw.setIndex(cw.index+1)
          update_menu=true
      elsif Input.trigger?(Input::UP) &&  (cw.index&2)==2
        pbPlayCursorSE() if cw.setIndex(cw.index-2)
          update_menu=true
      elsif Input.trigger?(Input::DOWN) &&  (cw.index&2)==0
        pbPlayCursorSE() if cw.setIndex(cw.index+2)
        update_menu=true
      ### MODDED/ replace battle stats in fight menu with move info
      elsif Input.trigger?(Input::Y)
        pbPlayCursorSE()
        bbui_pbToggleMoveInfo(battler, cw) if defined?(bbui_pbToggleMoveInfo)
        update_menu=true
      ### /MODDED
      end
      if Input.trigger?(Input::C)   # Confirm choice
        ret=cw.index
        if cw.zButton==2
          if battler.pbCompatibleZMoveFromMove?(ret,true)
            pbPlayDecisionSE()
            @lastmove[index]=ret
            return ret
          else
            @battle.pbDisplay(_INTL("{1} is not compatible with {2}!",battler.moves[ret].name,getItemName(battler.item)))
            @lastmove[index]=cw.index
            return -1
          end
        else
          pbPlayDecisionSE()
          @lastmove[index]=ret
          return ret
        end
      elsif Input.trigger?(Input::X)   # Use Mega Evolution
        if @battle.pbCanMegaEvolve?(index) && !pbIsZCrystal?(battler.item)
          if cw.megaButton==2
            @battle.pbUnRegisterMegaEvolution(index)
            cw.megaButton=1
            pbPlayCancelSE()
          else
            @battle.pbRegisterMegaEvolution(index)
            cw.megaButton=2
            pbPlayDecisionSE()
          end
        end
          if @battle.pbCanUltraBurst?(index)
            if cw.ultraButton==2
              @battle.pbUnRegisterUltraBurst(index)
              cw.ultraButton=1
              pbPlayCancelSE()
            else
              @battle.pbRegisterUltraBurst(index)
              cw.ultraButton=2
              pbPlayDecisionSE()
            end
          end
        if @battle.pbCanZMove?(index)  # Use Z Move
          if cw.zButton==2
            @battle.pbUnRegisterZMove(index)
            cw.zButton=1
            pbPlayCancelSE()
          else
            @battle.pbRegisterZMove(index)
            cw.zButton=2
            pbPlayDecisionSE()
          end
        end
        update_menu=true
      elsif Input.trigger?(Input::B)   # Cancel fight menu
        @lastmove[index]=cw.index
        pbPlayCancelSE()
        return -1
      end
    end
  end

  ###
end

###

class PokemonDataBox < SpriteWrapper
  attr_accessor :betterBattleUI_statBoosts_xShift

  def initialize(battler,doublebattle,viewport=nil,battle)
    super(viewport)
    @betterBattleUI_statBoosts_xShift = 0
    @explevel=0
    @battler=battler
    @battle = battle
    @selected=0
    @frame=0
    @showhp=false
    @showexp=false
    @appearing=false
    @animatingHP=false
    @animatingScale=0 # add this line
    @starthp=0
    @currenthp=0
    @endhp=0
    @expflash=0
    @doublebattle=doublebattle
    if (@battler.index&1)==0 # if player's Pokémon
      @spritebaseX=34
    else
      @spritebaseX=16
    end
    @spritebaseY=0
    if doublebattle
      case @battler.index
        when 0
          @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battlePlayerBoxD")
          @spriteX=PBScene::PLAYERBOXD1_X
          @spriteY=PBScene::PLAYERBOXD1_Y
        when 1
          if @battler.issossmon
            @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/boss_bar_sos")
            @spriteX=PBScene::FOEBOXD1_X-12
            @spriteY=PBScene::FOEBOXD1_Y-23
          else
            @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battleFoeBoxD")
            @spriteX=PBScene::FOEBOXD1_X
            @spriteY=PBScene::FOEBOXD1_Y
          end
        when 2
          @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battlePlayerBoxD")
          @spriteX=PBScene::PLAYERBOXD2_X
          @spriteY=PBScene::PLAYERBOXD2_Y
        when 3
          if @battler.issossmon
            @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/boss_bar_sos")
            @spriteX=PBScene::FOEBOXD2_X+8
            @spriteY= PBScene::FOEBOXD2_Y+23
          else
            @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battleFoeBoxD")
            @spriteX=PBScene::FOEBOXD2_X+4
            @spriteY=PBScene::FOEBOXD2_Y
          end
      end
    else
      case @battler.index
        when 0
          @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battlePlayerBoxS")
          @spriteX=PBScene::PLAYERBOX_X
          @spriteY=PBScene::PLAYERBOX_Y
          @showhp=true
          @showexp=true
        when 1
          @databox=AnimatedBitmap.new("Graphics/Pictures/Battle/battleFoeBoxS")
          @spriteX=PBScene::FOEBOX_X+4
          @spriteY=PBScene::FOEBOX_Y
      end
    end
    ### MODDED/
    @spriteX -= BBUIConsts::X_PAD
    @spritebaseX += BBUIConsts::X_PAD
    @spriteY -= BBUIConsts::Y_PAD
    @spritebaseY += BBUIConsts::Y_PAD

    @contents=BitmapWrapper.new(@databox.width+(BBUIConsts::X_PAD*2),@databox.height+(BBUIConsts::Y_PAD*2))
    ### /MODDED
    self.bitmap=@contents
    self.visible=false
    self.z=50
    refreshExpLevel
    refresh
  end

  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    bIsFoe = ((@battler.index == 1) || (@battler.index == 3))
    filename = @battler.issossmon && (battler.index != 2) ? "Graphics/Pictures/Battle/" : "Graphics/Pictures/Battle/battle"
    if @doublebattle
      case @battler.index % 2
        when 0
          if @battler.issossmon
            filename += "PlayerBoxSOS"
          else
            filename += "PlayerBoxD"
          end
        when 1
          if @battler.issossmon
            filename += "boss_bar_sos"
          else
            filename += "FoeBoxD"
          end
      end
    else
      case @battler.index
        when 0
          filename += "PlayerBoxS"
        when 1
          filename += "FoeBoxS"
      end
    end
    filename += battlerStatus(@battler) if !@battler.issossmon || (@battler.issossmon && @battler.index==2)
    @databox=AnimatedBitmap.new(filename)

    ### MODDED/
    self.bitmap.blt(BBUIConsts::X_PAD+@betterBattleUI_statBoosts_xShift,BBUIConsts::Y_PAD,@databox.bitmap,Rect.new(0,0,@databox.width,@databox.height))
    ### /MODDED
    if @doublebattle
      if !@battler.issossmon || (battler.issossmon && battler.index == 2)
        @hpbar = AnimatedBitmap.new("Graphics/Pictures/Battle/hpbardoubles")
      else
        @hpbar = AnimatedBitmap.new("Graphics/Pictures/Battle/hpbarsos")
      end
      hpbarconstant=PBScene::HPGAUGEHEIGHTD
    else
      @hpbar = AnimatedBitmap.new("Graphics/Pictures/Battle/hpbar")
      hpbarconstant=PBScene::HPGAUGEHEIGHTS
    end
    base=PBScene::BOXBASE
    shadow=PBScene::BOXSHADOW
    ### MODDED/ Add sbY
    sbY = @spritebaseY
    headerY = 18 + sbY
    sbX = @spritebaseX
    if bIsFoe
      headerY += 4
      sbX -= 12
    end
    if @doublebattle
      headerY -= 12
      sbX += 6

      if bIsFoe
        headerY -= 4
        sbX += 2
      end
    end

    # Pokemon Name
    pokename=@battler.name
    if @battler.issossmon && !(@battler.index == 2)
      pbSetSmallFont(self.bitmap)
      nameposition=sbX+4
    else
      pbSetSystemFont(self.bitmap)
      nameposition=sbX+8
    end

    textpos=[
       [pokename,nameposition,headerY,false,base,shadow]
    ]
    leveltxt = _INTL("Lv{1}",$game_switches[1306] && (@battler.index%2)==1 ? "???" : @battler.level)
    if !@battler.issossmon  || (@battler.issossmon && @battler.index == 2)
      genderX=self.bitmap.text_size(pokename).width
      genderX+=sbX+14
      if genderX > (165 + BBUIConsts::X_PAD) && !@doublebattle && (@battler.index&1)==1 #opposing pokemon
        genderX = sbX-16+206-self.bitmap.text_size(leveltxt).width
      end
      gendertarget = @battler.effects[:Illusion] ? @battler.effects[:Illusion] : @battler
      gendertarget = gendertarget.pokemon if gendertarget.is_a?(PokeBattle_Battler)
      if gendertarget.gender==0 # Male
        textpos.push([_INTL("♂"),genderX,headerY,false,Color.new(48,96,216),shadow])
      elsif gendertarget.gender==1 # Female
        textpos.push([_INTL("♀"),genderX,headerY,false,Color.new(248,88,40),shadow])
      end
    end
    pbDrawTextPositions(self.bitmap,textpos)
    pbSetSmallFont(self.bitmap)
    # Level
    hpShiftX = 202
    if bIsFoe
      hpShiftX -= 4
    end
    textpos=[[leveltxt,sbX+hpShiftX,headerY+8,true,base,shadow]]
    textpos=[] if @battler.issossmon
    # HP Numbers
    if @showhp
      hpstring=_ISPRINTF("{1: 2d}/{2: 2d}",self.hp,@battler.totalhp)
      textpos.push([hpstring,sbX+202,sbY+78,true,base,shadow])
    end
    pbDrawTextPositions(self.bitmap,textpos)
    # Shiny
    imagepos=[]
    if (@battler.pokemon.isShiny? && @battler.effects[:Illusion].nil?) || (!@battler.effects[:Illusion].nil? && @battler.effects[:Illusion].isShiny?)
      shinyX=202
      shinyX=-16 if (@battler.index&1)==0 # If player's Pokémon
      shinyY=24
      shinyY=12 if @doublebattle
      if (@battler.index&1)==1 && !@doublebattle
        shinyY+=4
      end
      imagepos.push(["Graphics/Pictures/shiny.png",sbX+shinyX,sbY+shinyY,0,0,-1,-2])
    end
    # Mega
    megaY=52
    megaY-=4 if (@battler.index&1)==0 # If player's Pokémon
    megaY=32 if @doublebattle
    megaX=215
    megaX=-27 if (@battler.index&1)==0 # If player's Pokémon
    if !@battler.issossmon || (@battler.issossmon && @battler.index == 2)
      if @battler.pokemon.isPulse?
        imagepos.push(["Graphics/Pictures/Battle/battlePulseEvoBox.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      elsif @battler.pokemon.isRift?
        imagepos.push(["Graphics/Pictures/Battle/battleRiftEvoBox.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      elsif @battler.pokemon.isPerfection?
        imagepos.push(["Graphics/Pictures/Battle/battlePerfectionEvoBox.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      elsif @battler.isMega?
        imagepos.push(["Graphics/Pictures/Battle/battleMegaEvoBox.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      elsif @battler.isUltra? # Maybe temporary until new icon
        imagepos.push(["Graphics/Pictures/Battle/battleMegaEvoBox.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      end
      # Crest
      illusion = !@battler.effects[:Illusion].nil?
      if @battler.hasCrest?(illusion) || (@battler.crested && !illusion)
        imagepos.push(["Graphics/Pictures/Battle/battleCrest.png",sbX+megaX,sbY+megaY,0,0,-1,-1])
      end
      # Owned
      if @battler.owned && (@battler.index&1)==1
        if @doublebattle
          imagepos.push(["Graphics/Pictures/Battle/battleBoxOwned.png",sbX-12,sbY+4,0,0,-1,-1]) if (@battler.index)==3
          imagepos.push(["Graphics/Pictures/Battle/battleBoxOwned.png",sbX-18,sbY+4,0,0,-1,-1]) if (@battler.index)==1
        else
          imagepos.push(["Graphics/Pictures/Battle/battleBoxOwned.png",sbX-12,sbY+20,0,0,-1,-1])
        end
      end
      ### MODDED/ crest display for sos
    else
      # Crest
      illusion = !@battler.effects[:Illusion].nil?
      if @battler.hasCrest?(illusion) || (@battler.crested && !illusion)
        imagepos.push(["Graphics/Pictures/Battle/battleCrest.png",sbX+100,sbY+4,0,0,-1,-1])
      end
      ### /MODDED
    end
    pbDrawImagePositions(self.bitmap,imagepos)
    hpGaugeSize=PBScene::HPGAUGESIZE
    hpgauge=@battler.totalhp==0 ? 0 : (self.hp*hpGaugeSize/@battler.totalhp)
    hpgauge=2 if hpgauge==0 && self.hp>0
    hpzone=0
    hpzone=1 if self.hp<=(@battler.totalhp/2.0).floor
    hpzone=2 if self.hp<=(@battler.totalhp/4.0).floor
    hpcolors=[
      PBScene::HPGREENDARK,
      PBScene::HPGREEN,
      PBScene::HPYELLOWDARK,
      PBScene::HPYELLOW,
      PBScene::HPREDDARK,
      PBScene::HPRED
    ]
    # fill with black (shows what the HP used to be)
    hpGaugeX=PBScene::HPGAUGE_X
    hpGaugeY=PBScene::HPGAUGE_Y
    if @battler.issossmon && (@battler.index&1)!=0 && !(@battler.index == 2)
      hpGaugeY=PBScene::HPGAUGE_Y-10
      hpGaugeX=PBScene::HPGAUGE_X-16
    end
    hpGaugeLowerY = 14
    hpThiccness = 16
    if bIsFoe
      hpGaugeX += 8
      hpGaugeY += 4
    end
    if @doublebattle
      hpGaugeY -= 12
      hpGaugeLowerY = 10
      hpThiccness = 12

      if bIsFoe
        hpGaugeY -= 4
      end
    end
    self.bitmap.blt(sbX+hpGaugeX,sbY+hpGaugeY,@hpbar.bitmap,Rect.new(0,(hpzone)*hpbarconstant,hpgauge,hpbarconstant))

    # self.bitmap.fill_rect(sbX+hpGaugeX,sbY+hpGaugeY,hpgauge,hpThiccness,hpcolors[hpzone*2+1])
    # self.bitmap.fill_rect(sbX+hpGaugeX,sbY+hpGaugeY,hpgauge,2,hpcolors[hpzone*2])
    # self.bitmap.fill_rect(sbX+hpGaugeX,sbY+hpGaugeY+hpGaugeLowerY,hpgauge,2,hpcolors[hpzone*2])
    # Status
    if !@battler.status.nil?
      imagepos=[]
      doubles = "D"
      if @doublebattle
        if bIsFoe
          if @battler.issossmon && !(@battler.index == 2)
            imagepos.push([sprintf("Graphics/Pictures/Battle/battleStatuses"+ doubles + "%s",@battler.status),@spritebaseX-6,@spritebaseY+26,0,0,64,28])
          else
            imagepos.push([sprintf("Graphics/Pictures/Battle/battleStatuses"+ doubles + "%s",@battler.status),@spritebaseX+8,@spritebaseY+36,0,0,64,28])
          end
        else
          imagepos.push([sprintf("Graphics/Pictures/Battle/battleStatuses"+ doubles + "%s",@battler.status),@spritebaseX+10,@spritebaseY+36,0,0,64,28])
        end
      elsif bIsFoe
        imagepos.push([sprintf("Graphics/Pictures/Battle/battleStatuses%s",@battler.status),@spritebaseX,@spritebaseY+54,0,0,64,28])
      else
        imagepos.push([sprintf("Graphics/Pictures/Battle/battleStatuses%s",@battler.status),@spritebaseX+4,@spritebaseY+50,0,0,64,28])
      end
      pbDrawImagePositions(self.bitmap,imagepos)
    end
    if @showexp
      # fill with EXP color
      expGaugeX=PBScene::EXPGAUGE_X
      expGaugeY=PBScene::EXPGAUGE_Y
      self.bitmap.fill_rect(sbX+expGaugeX,sbY+expGaugeY,self.exp,2,
         PBScene::EXPCOLORSHADOW)
      self.bitmap.fill_rect(sbX+expGaugeX,sbY+expGaugeY+2,self.exp,4,
         PBScene::EXPCOLORBASE)
    end
    ### /MODDED
    ### MODDED/
    betterBattleUI_typeIcons_apply if @battler.pokemon
    if defined?(@battler.stages)
      betterBattleUI_statBoosts_updateBitmap(@battler) if betterBattleUI_statBoosts_shouldUpdateBitmap(@battler)
      betterBattleUI_statBoosts_drawTab if @battler.pokemon
    end
    ### /MODDED
  end





  ### Stat Boosts


  def betterBattleUI_statBoosts_tabCoords
    rect=$betterBattleUI_statBoosts_data[:battlers][@battler.index][:bitmap].rect
    case battler.index
    # Player's mon in singles
    when 0 then return 34-rect.width, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD + 20)
    # Foe's mon in singles
    when 1 then return @databox.width+66, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD + 20)
    # Player's other mon in doubles
    when 2 then return 34-rect.width, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD + 20)
    # Foe's other mon in doubles
    else        return @databox.width+66, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD + 20)
    end
  end


  def betterBattleUI_statBoosts_drawTab
    statsBitmap=$betterBattleUI_statBoosts_data[:battlers][@battler.index][:bitmap]
    x,y=betterBattleUI_statBoosts_tabCoords
    x,y=betterBattleUI_statBoosts_ensureOffsets(x, y)
    self.bitmap.blt(x, y, statsBitmap, statsBitmap.rect)
  end

  def betterBattleUI_statBoosts_ensureOffsets(x, y)
    offsetX=[-x, 0].max
    offsetY=[-y, 0].max
    rect=$betterBattleUI_statBoosts_data[:battlers][@battler.index][:bitmap].rect
    # Save the old positions
    type=@battler.battle.doublebattle ? 'doubleBattle' : 'singleBattle'
    $betterBattleUI_statBoosts_data[:battlers][@battler.index][:oldGeometry]={} if !$betterBattleUI_statBoosts_data[:battlers][@battler.index][:oldGeometry]
    $betterBattleUI_statBoosts_data[:battlers][@battler.index][:oldGeometry][type]={} if !$betterBattleUI_statBoosts_data[:battlers][@battler.index][:oldGeometry][type]
    old=$betterBattleUI_statBoosts_data[:battlers][@battler.index][:oldGeometry][type]
    old[:bitmap_width]=self.bitmap.width if !old[:bitmap_width]
    old[:bitmap_height]=self.bitmap.height if !old[:bitmap_height]
    old[:spritebaseX]=@spritebaseX if !old[:spritebaseX]
    old[:spritebaseY]=@spritebaseY if !old[:spritebaseY]
    old[:spriteX]=@spriteX if !old[:spriteX]
    old[:spriteY]=@spriteY if !old[:spriteY]
    # Extend in the positive
    rect=$betterBattleUI_statBoosts_data[:battlers][@battler.index][:bitmap].rect
    targetX=[old[:bitmap_width]+offsetX, offsetX+x+rect.width].max
    targetY=[old[:bitmap_height]+offsetY, offsetY+y+rect.height].max
    if self.bitmap.width < targetX || self.bitmap.height < targetY
      temp=Bitmap.new(targetX, targetY)
      temp.blt(0, 0, self.bitmap, self.bitmap.rect)
      self.bitmap=temp
    end
    # Extend in the negative
    if !defined?(@statsBoostsOffsetApplied) || !@statsBoostsOffsetApplied
      if (offsetX != 0 || offsetY != 0)
        bitmap=Bitmap.new(@databox.bitmap.width+2*offsetX, @databox.bitmap.height+2*offsetY)
        bitmap.blt(offsetX, offsetY, @databox.bitmap, @databox.bitmap.rect)
        @databox.betterBattleUI_setBitmap(bitmap)

        if defined?(@spritebaseX)
          @spritebaseX=old[:spritebaseX]+offsetX
          @betterBattleUI_statBoosts_xShift = offsetX
        end
        if defined?(@spritebaseY)
          @spritebaseY=old[:spritebaseY]+offsetY
        end
        @spriteX=old[:spriteX]-offsetX
        # @spriteY=old[:spriteY]-offsetY
      end
      @statsBoostsOffsetApplied=true
    end

    # Fin
    return x+offsetX, y+offsetY
  end





  ### TypeIcons

  def betterBattleUI_typeIcons_apply
    battlerTypes = betterBattleUI_typeIcons_battlerType

    bIsFoe = ((@battler.index == 1) || (@battler.index == 3))
    issos = @battler.issossmon
    baseX=@spritebaseX + (bIsFoe ? 200 : -50)
    baseX -= 100 if issos
    baseY=(@spritebaseY || 0)
    baseY += 20 if !@doublebattle

    background1, background2 = betterBattleUI_typeIcons_backgroundBitmap(bIsFoe, issos)

    shiftX1 = bIsFoe ? 14 : 4
    shiftY1 = 0
    shiftX2 = bIsFoe ? 16 : 2
    shiftY2 = 28

    illusion = !@battler.effects[:Illusion].nil?
    crested = @battler.hasCrest?(illusion) || (@battler.crested && !illusion)
    shiny = (@battler.pokemon.isShiny? && @battler.effects[:Illusion].nil?) || (!@battler.effects[:Illusion].nil? && @battler.effects[:Illusion].isShiny?)
    if !@doublebattle
      shiftY2 += 8 if crested
      shiftY2 += 6
      shiftX2 += bIsFoe ? 2 : -2
    else
      shiftX2 += 8 if crested && bIsFoe
      shiftX2 += bIsFoe ? 4 : -4
      shiftY2 -= 2

      if !crested && !bIsFoe
        if shiny
          shiftX1 += 6
          shiftX2 += 6
        else
          shiftX1 += 16
          shiftX2 += 16
        end
      end
      if issos
        shiftY2 = shiftY1
        shiftX1 += 20
        shiftX2 += 34
      end
    end

    self.bitmap.blt(baseX+shiftX1, baseY+shiftY1, background1, background1.rect)

    typepos=[]
    typepos.push([sprintf("Graphics/Icons/bosstype%s",battlerTypes[0]),baseX+4+shiftX1,baseY+4+shiftY1,0,0,64,28])
    if battlerTypes.length() > 1
      self.bitmap.blt(baseX+shiftX2, baseY+shiftY2, background2, background2.rect)
      typepos.push([sprintf("Graphics/Icons/bosstype%s",battlerTypes[1]),baseX+4+shiftX2,baseY+4+shiftY2,0,0,64,28])
    end
    pbDrawImagePositions(self.bitmap, typepos)
  end

  def betterBattleUI_typeIcons_backgroundBitmap(isFoe, issos)
    if !$betterBattleUI_typeIcons_bitmaps
      rawBmp=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/TypeDiamonds.png")
      retval=[]
      spriteWidth=26
      spriteHeight=28
      for y in 0..1
        for x in 0..2
          rect=Rect.new(x*spriteWidth,y*spriteHeight,spriteWidth,spriteHeight)
          bitmap=Bitmap.new(rect.width, rect.height)
          bitmap.blt(0, 0, rawBmp.bitmap, rect)
          retval.push(bitmap)
        end
      end

      $betterBattleUI_typeIcons_bitmaps=retval
    end

    idx = isFoe ? 1 : 0
    idx = 2 if issos

    return $betterBattleUI_typeIcons_bitmaps[idx], $betterBattleUI_typeIcons_bitmaps[idx+3]
  end

  def betterBattleUI_typeIcons_battlerType
    if @battler.effects[:Illusion]
      # Zorua
      type1=@battler.effects[:Illusion].type1
      type2=@battler.effects[:Illusion].type2
    else
      type1=@battler.type1
      type2=@battler.type2
    end
    typearray = [type1.to_s.upcase]
    typearray.push(type2.to_s.upcase) if type2 && (type2 != type1)
    return typearray
  end
end

def betterBattleUI_withForm(attacker)
  if !attacker.isMega? && attacker.hasMega?
    side=(attacker.battle.pbIsOpposing?(attacker.index)) ? 1 : 0
    owner=attacker.battle.pbGetOwnerIndex(attacker.index)
    if attacker.battle.megaEvolution[side][owner] == attacker.index
      attacker.pokemon.makeMega
      prevAbility = attacker.ability
      prevType1 = attacker.type1
      prevType2 = attacker.type2
      attacker.ability = attacker.pokemon.ability
      attacker.type1 = attacker.pokemon.type1
      attacker.type2 = attacker.pokemon.type2
      ret = yield
      attacker.pokemon.makeUnmega
      attacker.ability = prevAbility
      attacker.type1 = prevType1
      attacker.type2 = prevType2
      return ret
    end
  elsif !attacker.isUltra? && attacker.hasUltra?
    side=(attacker.battle.pbIsOpposing?(attacker.index)) ? 1 : 0
    owner=attacker.battle.pbGetOwnerIndex(attacker.index)
    if attacker.battle.ultraBurst[side][owner] == attacker.index
      attacker.pokemon.makeMega
      prevAbility = attacker.ability
      prevType1 = attacker.type1
      prevType2 = attacker.type2
      attacker.ability = attacker.pokemon.ability
      attacker.type1 = attacker.pokemon.type1
      attacker.type2 = attacker.pokemon.type2
      ret = yield
      attacker.pokemon.makeUnmega
      attacker.ability = prevAbility
      attacker.type1 = prevType1
      attacker.type2 = prevType2
      return ret
    end
  end
  return yield
end

class FightMenuButtons < BitmapSprite

  alias :betterBattleUI_old_initialize :initialize
  def initialize(*args,**kwargs)
    @betterBattleUI_fieldnullmove=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/FieldNulled"))

    @betterBattleUI_movenoeffect_left=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/NoEffectLeft"))
    @betterBattleUI_movenoeffect_right=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/NoEffectRight"))
    @betterBattleUI_movedoubleresisted_left=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/ResistedDoubleLeft"))
    @betterBattleUI_movedoubleresisted_right=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/ResistedDoubleRight"))
    @betterBattleUI_moveresisted_left=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/ResistedLeft"))
    @betterBattleUI_moveresisted_right=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/ResistedRight"))
    @betterBattleUI_movesupereffective_left=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/SuperEffectiveLeft"))
    @betterBattleUI_movesupereffective_right=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/SuperEffectiveRight"))
    @betterBattleUI_movedoublesuper_left=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/SuperEffectiveDoubleLeft"))
    @betterBattleUI_movedoublesuper_right=AnimatedBitmap.new(_INTL("#{__dir__[Dir.pwd.length+1..]}/BetterBattleUI/SuperEffectiveDoubleRight"))

    return betterBattleUI_old_initialize(*args, **kwargs)
  end

  def betterBattleUI_pbType(move, attacker)
    betterBattleUI_withForm(attacker) {
      move.pbType(attacker, move.type)
    }
  end


  alias :betterBattleUI_old_dispose :dispose
  def dispose
    @betterBattleUI_fieldnullmove.dispose

    @betterBattleUI_movenoeffect_left.dispose
    @betterBattleUI_movenoeffect_right.dispose
    @betterBattleUI_movedoubleresisted_left.dispose
    @betterBattleUI_movedoubleresisted_right.dispose
    @betterBattleUI_moveresisted_left.dispose
    @betterBattleUI_moveresisted_right.dispose
    @betterBattleUI_movesupereffective_left.dispose
    @betterBattleUI_movesupereffective_right.dispose
    @betterBattleUI_movedoublesuper_left.dispose
    @betterBattleUI_movedoublesuper_right.dispose
    return betterBattleUI_old_dispose
  end

  def refresh(index,battler,megaButton,zButton,ultraButton)
    return if !battler
    moves = nil
    if battler.moves
      moves = []
      for move in battler.moves
        moves.push(move)
      end
    end
    if zButton == 2 && !battler.zmoves.nil?
      for i in 0...battler.zmoves.length
        next if battler.zmoves[i].nil?
        moves[i] = battler.zmoves[i]
      end
    end
    return if !moves
    self.bitmap.clear
    textpos=[]
    for i in 0...4
      next if i==index
      next if !moves[i]
      x=((i%2)==0) ? 4 : 192
      y=((i/2)==0) ? 6 : 48
      y+=UPPERGAP
      imagepos=[]
      ### MODDED/
      movetype = betterBattleUI_pbType(moves[i], battler)
      ### /MODDED
      imagepos.push([sprintf("Graphics/Pictures/Battle/battleFightButtons%s",movetype),x,y,0,0,192,46])
      pbDrawImagePositions(self.bitmap,imagepos)
      textpos.push([_INTL("{1}",moves[i].name),x+96,y+12,2,
          PBScene::MENUBASE,PBScene::MENUSHADOW])
    end
    ppcolors=[
      PBScene::PPBASE,PBScene::PPSHADOW,
      PBScene::PPBASE,PBScene::PPSHADOW,
      PBScene::PPBASEYELLOW,PBScene::PPSHADOWYELLOW,
      PBScene::PPBASEORANGE,PBScene::PPSHADOWORANGE,
      PBScene::PPBASERED,PBScene::PPSHADOWRED
      ]
    for i in 0...4
      next if i!=index
      next if !moves[i]
      x=((i%2)==0) ? 4 : 192
      y=((i/2)==0) ? 6 : 48
      y+=UPPERGAP
      imagepos=[]
      ### MODDED/
      movetype = betterBattleUI_pbType(moves[i], battler)
      ### /MODDED
      secondtype = moves[i].getSecondaryType(battler)
      if secondtype.nil?
        imagepos.push([sprintf("Graphics/Icons/type%s",movetype),416,20+UPPERGAP,0,0,64,28])
      elsif secondtype.length == 1
        imagepos.push([sprintf("Graphics/Icons/type%s",movetype),402,20+UPPERGAP,0,0,64,28])
        imagepos.push([sprintf("Graphics/Icons/minitype%s",secondtype[0]),466,20+UPPERGAP,0,0,28,28])
      else
        imagepos.push([sprintf("Graphics/Icons/minitype%s",movetype),404,20+UPPERGAP,0,0,64,28])
        imagepos.push([sprintf("Graphics/Icons/minitype%s",secondtype[0]),432,20+UPPERGAP,0,0,28,28])
        imagepos.push([sprintf("Graphics/Icons/minitype%s",secondtype[1]),460,20+UPPERGAP,0,0,28,28])
      end
      imagepos.push([sprintf("Graphics/Pictures/Battle/battleFightButtons%s",movetype),x,y,192,0,192,46])
      textpos.push([_INTL("{1}",moves[i].name),x+96,y+12,2,
          PBScene::MENUBASE,PBScene::MENUSHADOW])
      if moves[i].totalpp>0
        ppfraction=(4.0*moves[i].pp/moves[i].totalpp).ceil
        textpos.push([_INTL("PP: {1}/{2}",moves[i].pp,moves[i].totalpp),
            448,50+UPPERGAP,2,ppcolors[(4-ppfraction)*2],ppcolors[(4-ppfraction)*2+1]])
      end
    end
    ### MODDED/ For feraligatr crest
    battler.turncount += 1
    ### /MODDED
    pbDrawImagePositions(self.bitmap,imagepos)
    for i in 0...4
      next if !moves[i]
      move = moves[i]
      x=((i%2)==0) ? 4 : 192
      y=((i/2)==0) ? 6 : 48
      y+=UPPERGAP
      y-=2 if Rejuv
      ### MODDED/
      movetype = betterBattleUI_pbType(move, battler)
      typemodR = 4
      typemodL = 4
      twoOpponents = false
      if battler.battle.doublebattle && !(battler.pbOpposing1.isFainted? || battler.pbOpposing2.isFainted?)
        twoOpponents = true
      end
      opponent = battler.pbOpposing1
      opponent = battler.pbOpposing2 if battler.pbOpposing1.isFainted? && !battler.pbOpposing2.isFainted?
      if opponent.effects[:Illusion]
        zorovar = true
      else
        zorovar = false
      end
      if (battler.ability == :MOLDBREAKER || battler.ability == :TERAVOLT || battler.ability == :TURBOBLAZE) ||
        move.function==0x166 || move.function==0x176 || move.function==0x200 # Solgaluna/crozma signatures
        for i in 0..3
          battler.battle.battlers[i].moldbroken = true
        end
      else
        for i in 0..3
          battler.battle.battlers[i].moldbroken = false
        end
      end
      if !move.pbIsStatus?
        if twoOpponents
          if battler.pbOpposing1.effects[:Illusion]
            zorovar1 = true
          else
            zorovar1 = false
          end
          if battler.pbOpposing2.effects[:Illusion]
            zorovar2 = true
          else
            zorovar2 = false
          end
          typemodR = move.betterBattleUI_showMoveEffectiveness(movetype, battler, battler.pbOpposing1, battler.pbOpposing2, zorovar1)
          typemodL = move.betterBattleUI_showMoveEffectiveness(movetype, battler, battler.pbOpposing2, battler.pbOpposing1, zorovar2)
        else
          typemodL = move.betterBattleUI_showMoveEffectiveness(movetype, battler, opponent, nil, zorovar)
        end
      else
        if battler.effects[:Taunt] > 0 ||
          (battler.effects[:HealBlock] > 0 && (move.isHealingMove? || (move.function == 0xDD || move.function == 0x139 || move.function == 0x158))) # Healing and Absorbtion Moves fail on HealBlock
          typemod = 0
        elsif move.target != :User && move.target != :Partner
          if twoOpponents
            typemodR = betterBattleUI_showMoveEffectivenessStatus(move, battler, battler.pbOpposing1, battler.pbOpposing2, movetype, typemodR, zorovar1)
            typemodL = betterBattleUI_showMoveEffectivenessStatus(move, battler, battler.pbOpposing2, battler.pbOpposing1, movetype, typemodL, zorovar2)
          else
            typemodL = betterBattleUI_showMoveEffectivenessStatus(move, battler, opponent, nil, movetype, typemodL, zorovar)
          end
        end
      end
      typemodL = typemodL.clamp(1,16) if typemodL != 0
      typemodR = typemodR.clamp(1,16) if typemodR != 0
      if move.betterBattleUI_fixedDamageMove?
        typemodL = 4 if typemodL != 0
        typemodR = 4 if typemodR != 0
      end
      case pbFieldNotesBattle(move)
        when 1 then self.bitmap.blt(x + 2, y + 2, @goodmovebitmap.bitmap, Rect.new(0, 0, @goodmovebitmap.bitmap.width, @goodmovebitmap.bitmap.height))
        when 2 then self.bitmap.blt(x + 2, y + 2, @badmovebitmap.bitmap, Rect.new(0, 0, @badmovebitmap.bitmap.width, @badmovebitmap.bitmap.height))
        when 3 then self.bitmap.blt(x + 2, y + 2, @betterBattleUI_fieldnullmove.bitmap, Rect.new(0, 0, @betterBattleUI_fieldnullmove.bitmap.width, @betterBattleUI_fieldnullmove.bitmap.height))
      end
      case typemodR
        when 0 # Ineffective
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movenoeffect_right.bitmap, Rect.new(0, 0, @betterBattleUI_movenoeffect_right.bitmap.width, @betterBattleUI_movenoeffect_right.bitmap.height))
        when 1 # 1/4
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movedoubleresisted_right.bitmap, Rect.new(0, 0, @betterBattleUI_movedoubleresisted_right.bitmap.width, @betterBattleUI_movedoubleresisted_right.bitmap.height))
        when 2 # 1/2
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_moveresisted_right.bitmap, Rect.new(0, 0, @betterBattleUI_moveresisted_right.bitmap.width, @betterBattleUI_moveresisted_right.bitmap.height))
        when 8 # x2
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movesupereffective_right.bitmap, Rect.new(0, 0, @betterBattleUI_movesupereffective_right.bitmap.width, @betterBattleUI_movesupereffective_right.bitmap.height))
        when 16 # x4
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movedoublesuper_right.bitmap, Rect.new(0, 0, @betterBattleUI_movedoublesuper_right.bitmap.width, @betterBattleUI_movedoublesuper_right.bitmap.height))
      end
      case typemodL
        when 0 # Ineffective
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movenoeffect_left.bitmap, Rect.new(0, 0, @betterBattleUI_movenoeffect_left.bitmap.width, @betterBattleUI_movenoeffect_left.bitmap.height))
        when 1 # 1/4
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movedoubleresisted_left.bitmap, Rect.new(0, 0, @betterBattleUI_movedoubleresisted_left.bitmap.width, @betterBattleUI_movedoubleresisted_left.bitmap.height))
        when 2 # 1/2
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_moveresisted_left.bitmap, Rect.new(0, 0, @betterBattleUI_moveresisted_left.bitmap.width, @betterBattleUI_moveresisted_left.bitmap.height))
        when 8 # x2
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movesupereffective_left.bitmap, Rect.new(0, 0, @betterBattleUI_movesupereffective_left.bitmap.width, @betterBattleUI_movesupereffective_left.bitmap.height))
        when 16 # x4
          self.bitmap.blt(x + 2, y + 2, @betterBattleUI_movedoublesuper_left.bitmap, Rect.new(0, 0, @betterBattleUI_movedoublesuper_left.bitmap.width, @betterBattleUI_movedoublesuper_left.bitmap.height))
      end
    end
    battler.turncount -= 1 # For feraligatr crest
    ### /MODDED
    pbDrawTextPositions(self.bitmap,textpos)
    if megaButton>0
      self.bitmap.blt(146,0,@megaevobitmap.bitmap,Rect.new(0,(megaButton-1)*46,96,46))
    end
    if ultraButton>0
      self.bitmap.blt(146,0,@megaevobitmap.bitmap,Rect.new(0,(ultraButton-1)*46,96,46))
    end
    if zButton>0
      self.bitmap.blt(146,0,@zmovebitmap.bitmap,Rect.new(0,(zButton-1)*46,96,46))
    end
  end

  def betterBattleUI_showMoveEffectivenessStatus (move, battler, opponent, otherOpponent, movetype, typemod = 4, zorovar = false)
    if movetype == :WATER && ((!opponent.moldbroken && opponent.ability == :STORMDRAIN) ||
      (otherOpponent && !otherOpponent.moldbroken && otherOpponent.ability == :STORMDRAIN))
      return 0
    end
    if movetype == :ELECTRIC && ((!opponent.moldbroken && opponent.ability == :LIGHTNINGROD) ||
      (otherOpponent && !otherOpponent.moldbroken && otherOpponent.ability == :LIGHTNINGROD))
      return 0
    end

    if (move.move == :THUNDERWAVE && (move.pbTypeModifier(movetype, battler, opponent, zorovar) == 0 || !opponent.pbCanParalyze?(false) ||
       (opponent.nullsElec? && movetype == :ELECTRIC))) || #Innefective by type or immune to paralysis. If Thunder Wave is electrict type, the abilities nullyfing it also nullify this one
       (battler.battle.state.effects[:Gravity]!=0 && (move.move == :SPLASH || move.move == :TELEKINESIS)) ||
       (!opponent.pbCanPoison?(false, false, battler.ability == :CORROSION) && (move.move == :POISONGAS || move.move == :POISONPOWDER || move.move == :TOXIC)) ||
       (opponent.status != :POISON && move.move == :VENOMDRENCH) ||
       (PBStuff::POWDERMOVES.include?(move.move) && (opponent.hasType?(:GRASS) || opponent.ability == :OVERCOAT || (opponent.itemWorks? && opponent.item == :SAFETYGOGGLES))) ||
       (move.move == :WILLOWISP && (!opponent.pbCanBurn?(false) || opponent.ability == :FLASHFIRE)) ||
       (PBStuff::SLEEPMOVE.include?(move.move) && !opponent.pbCanSleep?(false)) ||
       (PBStuff::PARAMOVE.include?(move.move) && !opponent.pbCanParalyze?(false)) ||
       (opponent.ability == :SOUNDPROOF && move.isSoundBased?) ||
       ((opponent.effects[:MagicCoat] || (opponent.ability == (:MAGICBOUNCE) && !(opponent.moldbroken))) && move.canMagicCoat?) ||
       (battler.ability == :PRANKSTER && (opponent.type1 == :DARK || opponent.type2 == :DARK)) ||
       (move.move == :LEECHSEED && (opponent.hasType?(:GRASS) || opponent.effects[:LeechSeed] >= 0 || opponent.effects[:Substitute] > 0))
      typemod = 0
    end
    return typemod
  end

  def pbFieldNotesBattle(move)
    return 0 if $Settings.field_effects_highlights==1
    return 0 if !move.battle.field.isFieldEffect?
    battle = move.battle
    return 1 if battle.field.statusMoves && battle.field.statusMoves.include?(move.move)
    ### MODDED/ Mod compat; teleport is weakened on field
    return 2 if defined?(move_tweak) && battle.FE == :COLOSSEUM && move.move == :TELEPORT
    ### /MODDED
    typeBoost = 1; moveBoost=1
    attacker = battle.battlers.find { |battler| battler.moves.include?(move) || (battler.zmoves && battler.zmoves.include?(move)) }
    opponent = attacker.pbOppositeOpposing
    ### MODDED/ Take form into account
    movetype = betterBattleUI_pbType(move, attacker)
    ### /MODDED
    if move.basedamage > 0 && !((0x6A..0x73).include?(move.function) || [0xD4,0xE1].include?(move.function))
      typeBoost = move.typeFieldBoost(movetype,attacker,opponent)
      moveBoost = move.moveFieldBoost
      moveBoost = 1.5 if move.isSoundBased? && move.basedamage > 0 && [:CAVE,:BIGTOP,:CONCERT1,:CONCERT2,:CONCERT3,:CONCERT4].include?(battle.FE)
      ### MODDED/ Account for overlays
      typeBoost *= move.typeOverlayBoost(movetype,attacker,opponent)[0]
      for terrain in [:ELECTERRAIN,:GRASSY,:MISTY,:PSYTERRAIN]
        if battle.state.effects[terrain] > 0
          moveBoost *= move.moveOverlayBoost(terrain)
        end
      end
      ### /MODDED
    end
    moveBoost = 1.5 if move.move == :SONICBOOM && battle.FE == :RAINBOW

    ### /MODDED account for Snowy Mountain, Deep Earth multipliers
    case battle.FE
      when :MOUNTAIN,:SNOWYMOUNTAIN
        if movetype == :FLYING && !move.pbIsPhysical?(movetype) && battle.pbWeather== :STRONGWINDS
          typeBoost*=1.5
        end
      when :DEEPEARTH
        if movetype == :GROUND && opponent.hasType?(:GROUND)
          typeBoost*=0.25
        end
        if (move.priorityCheck(attacker) > 0) && move.basedamage > 0
          moveBoost*=0.7
        end
        if (move.priorityCheck(attacker) < 0) && move.basedamage > 0
          moveBoost*=1.3
        end
    end
    ### /MODDED

    # Failing moves
    case battle.FE
    when :UNDERWATER
      moveBoost = 0 if [:ELECTRICTERRAIN, :GRASSYTERRAIN, :MISTYTERRAIN, :PSYCHICTERRAIN, :MIST].include?(move.move)
      moveBoost = 0 if [:RAINDANCE, :SUNNYDAY, :HAIL, :SANDSTORM].include?(move.move)
    when :NEWWORLD
      moveBoost = 0 if [:ELECTRICTERRAIN, :GRASSYTERRAIN, :MISTYTERRAIN, :PSYCHICTERRAIN, :MIST].include?(move.move)
      moveBoost = 0 if [:RAINDANCE, :SUNNYDAY, :HAIL, :SANDSTORM].include?(move.move)
    when :ELECTERRAIN
      moveBoost = 0 if move.move == :FOCUSPUNCH
    when :CAVE
      moveBoost = 0 if move.move == :SKYDROP
    end
    totalboost = typeBoost*moveBoost
    ### MODDED/
    if totalboost == 0
      return 3
    ### /MODDED
    elsif totalboost < 1
      return 2
    elsif totalboost > 1
      return 1
    end

    return 0
  end
end

# For compatability with how Gen 9 mod changes Illusion
class PokeBattle_Battler
  def isShiny?
    @pokemon.isShiny?
  end
end

class PokeBattle_Move

  def betterBattleUI_fixedDamageMove?
    return true if $BBUI_FIXED_DAMAGE.include?(self.function)
    return true if $BBUI_FIXED_DAMAGE_FIELD[self.function] && $BBUI_FIXED_DAMAGE_FIELD[self.function] == self.battle.field
    return false
  end

  def betterBattleUI_showMoveEffectiveness(type, attacker, opponent, otherOpponent, zorovar = false)
    secondtype = getSecondaryType(attacker)


    if opponent.item == nil && @function == 0x315
      return 0
    end

    if @move == :STEELROLLER && @battle.FE == :INDOOR
      return 0
    end

    if @move == :BELCH && attacker.pokemon.belch != true && attacker.crested != :SWALOT
      return 0
    end

    if @battle.state.effects[:Gravity]!=0 && [0x10B,0x0CE,0x0CC,0x0C9,0x137].include?(@function)
      return 0
    end

    if @move == :NATURALGIFT && (attacker.item.nil? || !pbIsBerry?(attacker.item))
      return 0
    end

    if (@move == :FAKEOUT || @move == :FIRSTIMPRESSION) && attacker.turncount != 1 # Shifted by 1 for feraligatr crest
      return 0
    end

    if priorityCheck(attacker) > 0 && ((!opponent.moldbroken && (opponent.ability == :DAZZLING || opponent.ability == :QUEENLYMAJESTY || 
        (@battle.FE == :STARLIGHT && opponent.ability == :MIRRORARMOR))) ||
      (otherOpponent && (!otherOpponent.moldbroken && (otherOpponent.ability == :DAZZLING || otherOpponent.ability == :QUEENLYMAJESTY || 
        (@battle.FE == :STARLIGHT && otherOpponent.ability == :MIRRORARMOR)))) ||
      @battle.FE == :PSYCHICTERRAIN)
      return 0
    end

    if opponent.ability == :SAPSIPPER && !opponent.moldbroken && (type == :GRASS || (!secondtype.nil? && secondtype.include?(:GRASS)))
      return 0
    end
    if ((opponent.ability == :STORMDRAIN && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       (opponent.ability == :LIGHTNINGROD && (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC))))) && !opponent.moldbroken
      return 0
    end
    if otherOpponent && [:SingleNonUser, :RandomOpposing, :SingleOpposing, :OppositeOpposing].include?(@target) && !attacker.ability == :STALWART && !attacker.ability == :PROPELLERTAIL &&
      ((otherOpponent.ability == :STORMDRAIN && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       (otherOpponent.ability == :LIGHTNINGROD && (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC))))) && !otherOpponent.moldbroken
      return 0
    end
    if ((opponent.ability == :MOTORDRIVE && !opponent.moldbroken) ||
       (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:SHOCKDRIVE))) &&
       (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC)))
      return 0
    end
    if ((opponent.ability == :DRYSKIN && !(opponent.moldbroken)) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       (opponent.ability == :VOLTABSORB && !(opponent.moldbroken) && (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC)))) ||
       (opponent.ability == :WATERABSORB && !(opponent.moldbroken) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       ((Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:DOUSEDRIVE)) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       ((Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:CHILLDRIVE)) && (type == :ICE || (!secondtype.nil? && secondtype.include?(:ICE)))) ||
       ((Rejuv && @battle.FE == :DESERT) && (opponent.hasType?(:GRASS) || opponent.hasType?(:WATER)) && @battle.pbWeather == :SUNNYDAY && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER))))
      if opponent.effects[:HealBlock]==0
        return 0
      end
    end
    # Immunity Crests
    case opponent.crested
      when :SKUNTANK
        if (type == :GROUND || (!secondtype.nil? && secondtype.include?(:GROUND)))
          return 0
        end
      when :DRUDDIGON
        if (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE)))
          if opponent.effects[:HealBlock] == 0
            return 0
          end
        end
      when :WHISCASH
        if (type == :GRASS || (!secondtype.nil? && secondtype.include?(:GRASS)))
          return 0
        end
    end
    if (opponent.ability == :BULLETPROOF) && !(opponent.moldbroken)
      if (PBStuff::BULLETMOVE).include?(@move)
        return 0
      end
    end
    if (opponent.ability == :SOUNDPROOF) && !(opponent.moldbroken)
      if isSoundBased?
        return 0
      end
    end
    if @battle.FE == :ROCKY && (opponent.effects[:Substitute]>0 || opponent.stages[PBStats::DEFENSE] > 0)
      if (PBStuff::BULLETMOVE).include?(@move)
        return 0
      end
    end
    if ((opponent.ability == :FLASHFIRE && !opponent.moldbroken) ||
      (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:BURNDRIVE))) &&
      (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE))) && @battle.FE != :FROZENDIMENSION
      return 0
    end
    if opponent.ability == :MAGMAARMOR && (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE))) &&
      (@battle.FE == :DRAGONSDEN || @battle.FE == :VOLCANICTOP || @battle.FE == :INFERNAL) && !(opponent.moldbroken)
      return 0
    end
    #Telepathy
    if ((opponent.ability == :TELEPATHY  && !opponent.moldbroken) || @battle.FE == :HOLY) && @basedamage>0
      if opponent.index == attacker.pbPartner.index
        return 0
      end
    end

    # Handle Lunar/Solar Idol, Deep Earth
    if !opponent.moldbroken
      if (type == :GROUND && (opponent.ability == :SOLARIDOL || opponent.ability == :LUNARIDOL ||
        (@battle.FE == :DEEPEARTH && [:UNAWARE,:OBLIVIOUS,:MAGNETPULL,:CONTRARY].include?(opponent.ability))) &&
        @battle.FE != :CAVE && @move != :THOUSANDARROWS && opponent.isAirborne?)
        return 0
      end
    end

    # OK because Air Balloon informs on entry
    if type == :GROUND && opponent.isAirborne?
      return 0
    end

    # UPDATE Implementing Flying Press + Freeze Dry
    typemod=pbTypeModifier(type,attacker,opponent, zorovar)
    typemodL= nil
    typemod3= nil
    if type == :FIRE && opponent.effects[:TarShot]
      typemod*=2
    end
    # Resistance-changing Crests
    if opponent.crested
      case opponent.species
      when :LUXRAY
        typemod /= 2 if (type == :GHOST || type == :DARK)
        typemod = 0 if type == :PSYCHIC
      when :SAMUROTT
        typemod /= 2 if (type == :BUG || type == :DARK || type == :ROCK)
      when :LEAFEON
        typemod /= 4 if (type == :FIRE || type == :FLYING)
      when :GLACEON
        typemod /= 4 if (type == :ROCK || type == :FIGHTING)
      when :SIMISEAR
        typemod /= 2 if [:STEEL, :FIRE,:ICE].include?(type)
        typemod /= 2 if type == :WATER && @battle.FE != :UNDERWATER
      when :SIMIPOUR
        typemod /= 2 if [:GROUND,:WATER,:GRASS,:ELECTRIC].include?(type)
      when :SIMISAGE
        typemod /= 2 if [:BUG,:STEEL,:FIRE,:GRASS,:FAIRY].include?(type)
        typemod /= 2 if type == :ICE && @battle.FE != :GLITCH
      when :TORTERRA
        if !($game_switches[:Inversemode] ^ (@battle.FE == :INVERSE))
          typemod = 16 / typemod if typemod != 0
        end
      end
    end
    typemod *= 4 if @move == :FREEZEDRY && opponent.hasType?(:WATER)
    if @move == :CUT && opponent.hasType?(:GRASS) && ((!Rejuv && @battle.FE == :FOREST) || @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,2,5))
      typemod *= 2
    end
    if @move == :FLYINGPRESS
      if @battle.FE == :SKY
        if ((PBTypes.oneTypeEff(:FLYING, opponent.type1) > 2) || (PBTypes.oneTypeEff(:FLYING, opponent.type1) < 2 && $game_switches[:Inversemode]))
          typemod*=2
        end
        if ((PBTypes.oneTypeEff(:FLYING, opponent.type2) > 2) || (PBTypes.oneTypeEff(:FLYING, opponent.type2) < 2 && $game_switches[:Inversemode]))
          typemod*=2
        end
      else
        typemodL=pbTypeModifier(:FLYING,attacker,opponent)
        typemod3= ((typemod*typemodL)/4)
        typemod=typemod3
      end
    end

    # Field Effect second type changes
    typemod=fieldTypeChange(attacker,opponent,typemod,false)
    typemod=overlayTypeChange(attacker,opponent,typemod,false)

    # Cutting typemod in half
    if @battle.pbWeather==:STRONGWINDS && (opponent.hasType?(:FLYING) && !opponent.effects[:Roost]) &&
      ((PBTypes.oneTypeEff(type, :FLYING) > 2) || (PBTypes.oneTypeEff(type, :FLYING) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.FE == :SNOWYMOUNTAIN && opponent.ability == :ICESCALES && opponent.hasType?(:ICE) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :ICE) > 2) || (PBTypes.oneTypeEff(type, :ICE) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
      typemod /= 2
    end
    if @battle.FE == :DRAGONSDEN && opponent.ability == :MULTISCALE && opponent.hasType?(:DRAGON) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :DRAGON) > 2) || (PBTypes.oneTypeEff(type, :DRAGON) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,4,5) && opponent.hasType?(:GRASS) &&
      ((PBTypes.oneTypeEff(type, :GRASS) > 2) || (PBTypes.oneTypeEff(type, :GRASS) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.FE == :BEWITCHED && opponent.hasType?(:FAIRY) && (opponent.ability == :PASTELVEIL || opponent.pbPartner.ability == :PASTELVEIL) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :FAIRY) > 2) || (PBTypes.oneTypeEff(type, :FAIRY) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
      typemod /= 2
    end
    if typemod==0
      if @function==0x111
        return 1
      end
    end

    if opponent.ability == :WONDERGUARD && !opponent.moldbroken && typemod <= 4
      return 0
    end

    return typemod
  end
end
