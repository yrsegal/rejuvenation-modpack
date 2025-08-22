##########################################################
##					Mining Overhaul	v2					##
##					by AiedailEclipsed					##
##			Ported to Rejuv v13.5 by AsNKrysis			##
##########################################################
# All code edits made will be noted in comments.		 #
# Unless otherwise denoted by a comment, all code		 #
# within is from the original Mining minigame script	 #
# by Maruno or has been edited by the individual		 #
# developer or user.									 #
##########################################################
# Spreadsheet with probability formulas:				 #
#	https://bit.ly/miningoverhaulprob					 #
##########################################################
##				THANK YOU AND PLEASE ENJOY!				##
##########################################################
# ADDED BY WIRE: RELICS, GEMS, SWM MINEFORRICH
# Sprites largely sourced from Screen Lady at https://eeveeexpo.com/resources/1274/
# Gem sprites made by wire based on Screen Lady's Diamond Sphere (small)
#####MODDED
if defined?($miningoverhaul_hitsRemoved)
  $miningoverhaul_hitsRemoved=0
end

def miningoverhaul_getDrawnTextWOutline(outline, text, fontSize)
  height=fontSize
  bitmap=Bitmap.new(Graphics.width, height)
  bitmap.font.name='Arial Black' # $VersionStyles[$PokemonSystem.font]
  bitmap.font.size=fontSize
  bitmap.font.color.set(0, 0, 0)
  bitmap.draw_text(0, 0, bitmap.width, bitmap.height, text, 0)

  bitmap2=Bitmap.new(Graphics.width, height)
  for i in 0...(outline*2+1)
    bitmap2.blt(0, i, bitmap, bitmap.rect)
  end

  bitmap3 = Bitmap.new(Graphics.width, height)
  bitmap3.blt(0, 0, bitmap2, bitmap2.rect)

  for i in 0...(outline*2+1)
    bitmap2.blt(i, 0, bitmap3, bitmap3.rect)
  end

  bitmap.font.color.set(255, 255, 255)
  bitmap.draw_text(outline, outline, bitmap.width, bitmap.height, text, 0)
  bitmap2.blt(0, 0, bitmap, bitmap.rect)

  return bitmap2
end

def miningoverhaul_getHitCost(hitsToRemove, registerNewCount)
  baseCost=125
  count=miningoverhaul_getHitsCount(hitsToRemove, registerNewCount)
  return count*baseCost
end

def miningoverhaul_getHitsCount(hitsToRemove, registerNewCount)
  if defined?($miningoverhaul_hitsRemoved)
    count=$miningoverhaul_hitsRemoved
  else
    count=0
  end
  count+=hitsToRemove
  $miningoverhaul_hitsRemoved=count if registerNewCount
  return count
end
#####/MODDED

class MiningGameTile
  alias :miningoverhaul_old_initialize :initialize
  def initialize(*args, **kwargs)
    miningoverhaul_old_initialize(*args, **kwargs)
    @image = AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/MiningTiles")
  end
end

class MiningGameCounter < BitmapSprite
  #####MODDED
  def miningoverhaul_resetMiningCounters
    @miningoverhaul_oldCost=nil
    $miningoverhaul_hitsRemoved=0
  end

  def miningoverhaul_notifyNextHit
    bmps=miningoverhaul_getMiningBmps
    self.bitmap.blt(5, 0, bmps[0], bmps[0].rect)
    self.bitmap.blt(5, 25, bmps[1], bmps[1].rect)
  end

  def miningoverhaul_getMiningBmps
    return @miningoverhaul_miningBmps if !miningoverhaul_shouldResetMiningBmps?
    lines=miningoverhaul_getMiningCostLines
    bmps=[
    ]
    @miningoverhaul_miningBmps=bmps
    return @miningoverhaul_miningBmps
  end

  def miningoverhaul_shouldResetMiningBmps?
    return true if miningoverhaul_checkCostChanged?
    return true if !defined?(@miningoverhaul_miningBmps)
    return true if @miningoverhaul_miningBmps[0].disposed?
    return true if @miningoverhaul_miningBmps[1].disposed?
    return false
  end

  def miningoverhaul_checkCostChanged?
    cost=miningoverhaul_getHitCost(0, false)
    return false if defined?(@miningoverhaul_oldCost) && @miningoverhaul_oldCost == cost
    @miningoverhaul_oldCost=cost
    return true
  end

  def miningoverhaul_getMiningCostLines
    miningoverhaul_hitsRemoved=miningoverhaul_getHitsCount(0, false)
    return [] if miningoverhaul_hitsRemoved <= 0
    textA=_INTL(
      'Next hit: ${1} (pick), ${2} (hammer)',
      pickaxeCost,
      hammerCost
    )
    return [textA]
  end

  alias :miningoverhaul_miningForRich_oldInitialize :initialize
  #####/MODDED

  def initialize(*args, **kwargs)
    result=miningoverhaul_miningForRich_oldInitialize(*args, **kwargs)
    miningoverhaul_resetMiningCounters
    return result
  end
end

class MiningGameScene
  BOARDWIDTH  = 13
  BOARDHEIGHT = 10
  ITEMS = [ # Item, probability, graphic x, graphic y, width, height, pattern
        [:HELIXFOSSIL,2, 5,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:HELIXFOSSIL,2, 9,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:HELIXFOSSIL,1, 13,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:HELIXFOSSIL,1, 17,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:ROOTFOSSIL,1, 0,7, 5,5,[1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,0,0,0,1,1,0,0,1,1,0]],
     [:ROOTFOSSIL,1, 5,7, 5,5,[0,0,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,1,0,1,1,1,0]],
     [:ROOTFOSSIL,1, 10,7, 5,5,[0,1,1,0,0,1,1,0,0,0,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1]],
     [:ROOTFOSSIL,1, 15,7, 5,5,[0,1,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,0,0]],
     [:CLAWFOSSIL,1, 0,12, 4,5,[0,0,1,1,0,1,1,1,0,1,1,1,1,1,1,0,1,1,0,0]],
     [:CLAWFOSSIL,1, 4,12, 5,4,[1,1,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1]],
     [:CLAWFOSSIL,1, 9,12, 4,5,[0,0,1,1,0,1,1,1,1,1,1,0,1,1,1,0,1,1,0,0]],
     [:CLAWFOSSIL,1, 13,12, 5,4,[1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,1,1]],
     [:DOMEFOSSIL,4, 0,3, 5,4,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0]],
     [:SKULLFOSSIL,4, 20,7, 4,4,[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0]],
     [:ARMORFOSSIL,4, 24,7, 5,4,[0,1,1,1,0,0,1,1,1,0,1,1,1,1,1,0,1,1,1,0]],
     [:SUNSTONE,16, 21,17, 3,3,[0,1,0,1,1,1,1,1,1]],
     [:SHINYSTONE,16, 26,29, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:DAWNSTONE,16, 26,32, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:ICESTONE,3, 10,24, 4,2,[1,1,1,0,0,1,1,1]],
     [:ICESTONE,3, 24,26, 2,4,[0,1,1,1,1,1,1,0]],
   [:BLKPRISM,10, 23,33, 3,2,[1,1,1,0,1,1]],
     [:BLKPRISM,10, 24,30, 2,3,[1,1,1,1,1,0]],
     [:DUSKSTONE,16, 14,23, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:THUNDERSTONE,16, 26,11, 3,3,[0,1,1,1,1,1,1,1,0]],
     [:FIRESTONE,16, 20,11, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:WATERSTONE,16, 23,11, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:LEAFSTONE,8, 18,14, 3,4,[0,1,0,1,1,1,1,1,1,0,1,0]],
     [:LEAFSTONE,8, 21,14, 4,3,[0,1,1,0,1,1,1,1,0,1,1,0]],
     [:MOONSTONE,8, 25,14, 4,2,[0,1,1,1,1,1,1,0]],
     [:MOONSTONE,8, 27,16, 2,4,[1,0,1,1,1,1,0,1]],
     [:OVALSTONE,24, 24,17, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:EVERSTONE,24, 21,20, 4,2,[1,1,1,1,1,1,1,1]],
     [:STARPIECE,20, 0,17, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:RAREBONE,10, 3,17, 6,3,[1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1]],
     [:RAREBONE,10, 3,20, 3,6,[1,1,1,0,1,0,0,1,0,0,1,0,0,1,0,1,1,1]],
     [:REVIVE,20, 0,20, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:MAXREVIVE,12, 0,23, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:LIGHTCLAY,24, 6,20, 4,4,[1,0,1,0,1,1,1,0,1,1,1,1,0,1,0,1]],
     [:HARDSTONE,24, 6,24, 2,2,[1,1,1,1]],
     [:HEARTSCALE,56, 8,24, 2,2,[1,0,1,1]],
     [:IRONBALL,24, 9,17, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:ODDKEYSTONE,12, 10,20, 4,4,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]],
     [:HEATROCK,20, 12,17, 4,3,[1,0,1,0,1,1,1,1,1,1,1,1]],
     [:DAMPROCK,20, 14,20, 3,3,[1,1,1,1,1,1,1,0,1]],
     [:SMOOTHROCK,20, 17,18, 4,4,[0,0,1,0,1,1,1,0,0,1,1,1,0,1,0,0]],
     [:ICYROCK,20, 17,22, 4,4,[0,1,1,0,1,1,1,1,1,1,1,1,1,0,0,1]],
     [:AMPLIFIELDROCK,12, 25,0, 4,3,[1,1,0,1,1,1,1,1,1,1,1,1]],
     [:REDSHARD,56, 21,22, 3,3,[1,1,1,1,1,0,1,1,1]],
     [:GREENSHARD,56, 25,20, 4,3,[1,1,1,1,1,1,1,1,1,1,0,1]],
     [:YELLOWSHARD,56, 25,23, 4,3,[1,0,1,0,1,1,1,0,1,1,1,1]],
     [:BLUESHARD,56, 26,26, 3,3,[1,1,1,1,1,1,1,1,0]],
     [:INSECTPLATE,8, 0,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:DREADPLATE,8, 4,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:DRACOPLATE,8, 8,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:ZAPPLATE,8, 12,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:FISTPLATE,8, 16,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:FLAMEPLATE,8, 20,26, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:MEADOWPLATE,8, 0,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:EARTHPLATE,8, 4,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:ICICLEPLATE,8, 8,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:TOXICPLATE,8, 12,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:MINDPLATE,8, 16,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:STONEPLATE,8, 20,29, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SKYPLATE,8, 0,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SPOOKYPLATE,8, 4,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:IRONPLATE,8, 8,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:SPLASHPLATE,8, 12,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
     [:PIXIEPLATE,8, 16,32, 4,3,[1,1,1,1,1,1,1,1,1,1,1,1]],
   ##       MODDED          ##
     [:OLDAMBER,2, 21,3, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:OLDAMBER,2, 25,3, 4,4,[1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1]],
     [:NUGGET,20, 19,35, 2,2,[1,1,1,1]],
     [:BIGNUGGET,12, 16,35, 3,3,[1,1,1,1,1,1,1,1,1]],
     [:COMETSHARD,12, 21,35, 3,3,[0,1,0,1,1,1,0,1,0]],
     [:COVERFOSSIL,4, 12,35, 4,4,[1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0]],
     [:PLUMEFOSSIL,4, 4,35, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:JAWFOSSIL,4, 0,35, 4,4,[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0]],
     [:SAILFOSSIL,4, 8,35, 4,4,[0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1]],
     [:RELICGOLD,6,20,32,2,1,[1,1]],
     [:RELICSILVER,10,20,33,2,1,[1,1]],
     [:RELICCOPPER,16,20,34,2,1,[1,1]],
     [:BUGGEM,20, 0,39, 2,2,[1,1,1,1]],
     [:DARKGEM,20, 2,39, 2,2,[1,1,1,1]],
     [:DRAGONGEM,20, 4,39, 2,2,[1,1,1,1]],
     [:ELECTRICGEM,20, 6,39, 2,2,[1,1,1,1]],
     [:FIGHTINGGEM,20, 8,39, 2,2,[1,1,1,1]],
     [:FIREGEM,20, 10,39, 2,2,[1,1,1,1]],
     [:GRASSGEM,20, 12,39, 2,2,[1,1,1,1]],
     [:GROUNDGEM,20, 14,39, 2,2,[1,1,1,1]],
     [:ICEGEM,20, 16,39, 2,2,[1,1,1,1]],
     [:POISONGEM,20, 0,41, 2,2,[1,1,1,1]],
     [:PSYCHICGEM,20, 2,41, 2,2,[1,1,1,1]],
     [:ROCKGEM,20, 4,41, 2,2,[1,1,1,1]],
     [:FLYINGGEM,20, 6,41, 2,2,[1,1,1,1]],
     [:GHOSTGEM,20, 8,41, 2,2,[1,1,1,1]],
     [:STEELGEM,20, 10,41, 2,2,[1,1,1,1]],
     [:WATERGEM,20, 12,41, 2,2,[1,1,1,1]],
     [:FAIRYGEM,10, 14,41, 2,2,[1,1,1,1]], # Canonically rarer
     [:NORMALGEM,20, 16,41, 2,2,[1,1,1,1]]
   ##       MODDED          ##
  ]

  def pbStartScene
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    # mod
    @viewport2=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport2.z=100000
    #/mod
    addBackgroundPlane(@sprites,"bg","Mining/miningbg",@viewport)
    @sprites["itemlayer"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    ##				MODDED					##
	@itembitmap=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/MiningItems")
	## 				MODDED 					##
    @ironbitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/Mining/irons"))
    @items=[]
    @itemswon=[]
    @iron=[]
    pbDistributeItems
    pbDistributeIron
    for i in 0...BOARDHEIGHT
      for j in 0...BOARDWIDTH
        @sprites["tile#{j+i*BOARDWIDTH}"]=MiningGameTile.new(32*j,64+32*i)
      end
    end
    @sprites["crack"]=MiningGameCounter.new(0,4)
    @sprites["cursor"]=MiningGameCursor.new(58,0) # central position, pick
    @sprites["tool"]=IconSprite.new(434,254,@viewport)
    @sprites["tool"].setBitmap(sprintf("Graphics/Pictures/Mining/toolicons"))
    @sprites["tool"].src_rect.set(0,0,68,100)

    #modded
    @sprites["moneywindow"]=Window_AdvancedTextPokemon.new("")
    @sprites["moneywindow"].letterbyletter = false
    @sprites["moneywindow"].visible=false
    @sprites["moneywindow"].viewport=@viewport2
    @sprites["moneywindow"].x=0
    @sprites["moneywindow"].y=0
    @sprites["moneywindow"].width=190
    @sprites["moneywindow"].height=96
    @sprites["moneywindow"].baseColor=Color.new(88,88,80)
    @sprites["moneywindow"].shadowColor=Color.new(168,184,184)

    @sprites["costwindow"]=Window_AdvancedTextPokemon.new("")
    @sprites["costwindow"].letterbyletter = false
    @sprites["costwindow"].visible=false
    @sprites["costwindow"].viewport=@viewport2
    @sprites["costwindow"].x=Graphics.width - 210
    @sprites["costwindow"].y=0
    @sprites["costwindow"].width=210
    @sprites["costwindow"].height=96
    @sprites["costwindow"].baseColor=Color.new(88,88,80)
    @sprites["costwindow"].shadowColor=Color.new(168,184,184)
    miningoverhaul_displaymoney
    ###/modded
    update
    pbFadeInAndShow(@sprites)
  end

#mod
  def miningoverhaul_displaymoney
    hits = miningoverhaul_getHitsCount(0, false)
    pickaxeHits=1
    hammerHits=2
    pickaxeCost=miningoverhaul_getHitCost(pickaxeHits, false)
    hammerCost=miningoverhaul_getHitCost(hammerHits, false)

    show = hits > 0

    if !@wasDisplaying && show
      foundall=true
      for i in @items
        foundall=false if !i[3]
        break if !foundall
      end
      show = false if foundall
      @wasDisplaying = show
    end

    @sprites["moneywindow"].visible = show
    @sprites["costwindow"].visible = show
    @sprites["moneywindow"].text=_INTL("Money:\n<r>${1}",$Trainer.money)
    @sprites["costwindow"].text=_INTL("Pick:<r>${1}\nHammer:<r>${2}",pickaxeCost,hammerCost)
  end
  #/mod

  def pbNoDuplicateItems(newitem)
    return true if newitem==:HEARTSCALE   # Allow multiple Heart Scales
  ##        MODDED          ##
    return true if newitem==:RELICCOPPER   # Allow multiple relics
    return true if newitem==:RELICSILVER   # Allow multiple relics
    return true if newitem==:RELICGOLD   # Allow multiple relics
    fossils=[:DOMEFOSSIL,:HELIXFOSSIL,:OLDAMBER,:ROOTFOSSIL,
             :SKULLFOSSIL,:ARMORFOSSIL,:CLAWFOSSIL,:COVERFOSSIL,
			 :PLUMEFOSSIL,:SAILFOSSIL,:JAWFOSSIL]
    plates=[:INSECTPLATE,:DREADPLATE,:DRACOPLATE,:ZAPPLATE,:FISTPLATE,
            :FLAMEPLATE,:MEADOWPLATE,:EARTHPLATE,:ICICLEPLATE,:TOXICPLATE,
            :MINDPLATE,:STONEPLATE,:SKYPLATE,:SPOOKYPLATE,:IRONPLATE,:SPLASHPLATE,
            :PIXIEPLATE]
	raremisc=[:MAXREVIVE,:AMPLIFIELDROCK,:BIGNUGGET,
			  :COMETSHARD,:ODDKEYSTONE]
	evostones=[:FIRESTONE,:WATERSTONE,:THUNDERSTONE,
			   :LEAFSTONE,:MOONSTONE,:SUNSTONE,:DAWNSTONE,
			   :DUSKSTONE,:SHINYSTONE,:ICESTONE]
    for i in @items
      preitem=ITEMS[i[0]][0]
      return false if preitem==newitem   # No duplicate items
      return false if fossils.include?(preitem) && fossils.include?(newitem)
      return false if plates.include?(preitem) && plates.include?(newitem)
	  return false if raremisc.include?(preitem) && raremisc.include?(newitem)
	  return false if evostones.include?(preitem) && evostones.include?(newitem)
	##				MODDED					##
    end
    return true
  end

  ## MODDED

  def miningoverhaul_payToMine
    hitsToRemove=miningoverhaul_getHitsToRemove
    return nil if hitsToRemove <= 0
    cost=miningoverhaul_getHitCost(hitsToRemove, true)
    if $Trainer.money < cost
      Kernel.pbMessage(_INTL('You can\'t afford to mine any more!'))
      return nil
    end
    @sprites["crack"].hits-=hitsToRemove
    $Trainer.money-=cost
  end

  def miningoverhaul_getHitsToRemove
    return @sprites["crack"].hits-48
  end

  alias :miningoverhaul_miningForRich_oldPbHit :pbHit

  def pbHit(*args, **kwargs)
    result=miningoverhaul_miningForRich_oldPbHit(*args, **kwargs)
    miningoverhaul_payToMine
    miningoverhaul_displaymoney
    return result
  end

  alias :miningoverhaul_miningForRich_oldPbEndScene :pbEndScene
  def pbEndScene(*args, **kwargs)
    result = miningoverhaul_miningForRich_oldPbEndScene(*args, **kwargs)
    @viewport2.dispose
    return result
  end

  ### / MODDED
end
