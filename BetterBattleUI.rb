$betterBattleUI_typeIcons_bitmaps = nil # Force the reloading of disposed graphics on soft resetting
$betterBattleUI_statBoosts_data = nil

module BBUIConsts 
  X_PAD = 50
  Y_PAD = 10
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
    $betterBattleUI_statBoosts_data[:background]=AnimatedBitmap.new('Data/Mods/BBUIStatGrid.png')
  end
  $betterBattleUI_statBoosts_data[:stages]={} if !$betterBattleUI_statBoosts_data[:stages]
  stagesToBeLoaded=[]
  for i in -6..6
    stage="#{i}"
    next if $betterBattleUI_statBoosts_data[:stages][stage] && !$betterBattleUI_statBoosts_data[:stages][stage].disposed?
    stagesToBeLoaded.push(i)
  end
  return nil if stagesToBeLoaded.length <= 0
  rawBmp=AnimatedBitmap.new('Data/Mods/BBUIStages.png')
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

# todo - dynamic extensions for all?

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

  if !defined?(betterBattleUI_old_refresh)
    alias :betterBattleUI_old_refresh :refresh
  end

  def refresh(*args, **kwargs)
    ret = betterBattleUI_old_refresh(*args, **kwargs)
    if defined?(@battler.stages)
      betterBattleUI_statBoosts_updateBitmap(@battler) if betterBattleUI_statBoosts_shouldUpdateBitmap(@battler)
      betterBattleUI_statBoosts_drawTab if @battler.pokemon
    end
  end

end

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
    ### MODDED\ Add sbY
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
      if @battler.isMega? && @battler.hasMega?
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
    if @battler.issossmon && !(@battler.index == 2)
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
    when 0 then return 34-rect.width, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD * 2 + 10)
    # Foe's mon in singles
    when 1 then return @databox.width+66, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD * 2 + 10)
    # Player's other mon in doubles
    when 2 then return 34-rect.width, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD * 2 + 10)
    # Foe's other mon in doubles
    else        return @databox.width+66, @doublebattle ? BBUIConsts::Y_PAD : (BBUIConsts::Y_PAD * 2 + 10)
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
      rawBmp=AnimatedBitmap.new('Data/Mods/BBUIType.png')
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
