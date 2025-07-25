def hpSummary_trueType(move, pokemon)
  type = move.type
  if move.move == :HIDDENPOWER || move.move == :UNLEASHEDPOWER
    type = pbHiddenPower(pokemon)
  elsif move.move == :REVELATIONDANCE || move.move == :BLINDINGSPEED
    type = pokemon.type1
  elsif move.move == :MIRRORBEAM
    if !pokemon.type2.nil?
      type = pokemon.type2
    else
      type = pokemon.type1
    end
  elsif move.move == :GILDEDARROW || move.move == :GILDEDHELIX
    if !pokemon.type2.nil? && (pokemon.type2 != :FAIRY && pokemon.type2 != :DARK)
      type = pokemon.type2
    else
      type = pokemon.type1
    end
  elsif move.move == :NATURALGIFT
    type = !PBStuff::NATURALGIFTTYPE[pokemon.item].nil? ? PBStuff::NATURALGIFTTYPE[pokemon.item] : :NORMAL
  elsif move.move == :DOMAINSHIFT
    type = $game_switches[:RenegadeRoute] ? :SHADOW : :FAIRY
  end

  if ((move.move == :JUDGMENT) && (pokemon.species == :ARCEUS)) ||
    ((move.move == :MULTIATTACK) && (pokemon.species == :SILVALLY))
    type = $cache.pkmn[pokemon.species].forms[pokemon.form%19].upcase.intern
    type = :QMARKS if type == "???".intern
  end

  if pokemon.item && $cache.items[pokemon.item] && pokemon.form<19
    if move.move == :TECHNOBLAST
      case pokemon.item
        when :SHOCKDRIVE then type = :ELECTRIC
        when :BURNDRIVE then type = :FIRE
        when :CHILLDRIVE then type = :ICE
        when :DOUSEDRIVE then type = :WATER
      end
    elsif move.move == :MULTIATTACK
      itemtype = $cache.items[pokemon.item].checkFlag?(:memory)
      type = itemtype if itemtype
    elsif move.move == :JUDGMENT || move.move == :MULTIPULSE
      if PBStuff::PLATEITEMS.include?(pokemon.item)
        itemtype = $cache.items[pokemon.item].checkFlag?(:typeboost)
        type = itemtype if itemtype
      end
    end
  end

  case pokemon.ability
    when :NORMALIZE   then type = :NORMAL
    when :PIXILATE    then type = :FAIRY    if type==:NORMAL
    when :AERILATE    then type = :FLYING   if type==:NORMAL
    when :GALVANIZE   then type = :ELECTRIC if type==:NORMAL
    when :REFRIGERATE then type = :ICE      if type==:NORMAL
    when :DUSKILATE   then type = :DARK     if type==:NORMAL
    when :LIQUIDVOICE then type = :WATER    if move.isSoundBased?
  end
  case pokemon.species
    when :SIMISEAR  then type = :WATER      if type==:NORMAL && pokemon.item==:SEARCREST
    when :SIMIPOUR  then type = :GRASS      if type==:NORMAL && pokemon.item==:POURCREST
    when :SIMISAGE  then type = :FIRE       if type==:NORMAL && pokemon.item==:SAGECREST
    when :LUXRAY    then type = :ELECTRIC   if type==:NORMAL && pokemon.item==:LUXCREST
    when :SAWSBUCK
      if pokemon.item == :SAWSCREST && type == :NORMAL
        case attacker.form
          when 0  then type = :WATER
          when 1  then type = :FIRE
          when 2  then type = :GROUND
          when 3  then type = :ICE
        end
      end
  end

  return type
end

def hpSummary_trueDamage(move, pokemon)
  damage = move.basedamage

  if pokemon.species == :LUVDISC && pokemon.item == :LUVCREST
    return [250-pokemon.happiness,1].max if move.move == :FRUSTRATION
    return [pokemon.happiness,250].min
  end

  if move.move == :NATURALGIFT && PBStuff::NATURALGIFTDAMAGE[pokemon.item]
    damage = PBStuff::NATURALGIFTDAMAGE[pokemon.item]
  elsif move.move == :FLING
    damage = PBStuff::FLINGDAMAGE[pokemon.item] if PBStuff::FLINGDAMAGE[pokemon.item]
    damage = 10 if !pokemon.item.nil? && pbIsBerry?(pokemon.item)
  elsif move.move == :ACROBATICS && (pokemon.item.nil? || pokemon.item == :FLYINGGEM)
    damage *= 2
  elsif move.move == :RETURN
    damage = [(pokemon.happiness*2/5.0).floor,1].max
  elsif move.move == :FRUSTRATION
    damage = [((255-pokemon.happiness)*2/5.0).floor,1].max
  elsif move.move == :ERUPTION || move.move == :WATERSPOUT || move.move == :DRAGONENERGY
    damage = [(150*(pokemon.hp.to_f)/pokemon.totalhp).floor,1].max
  end

  return damage
end

class MoveData
  if !defined?(isSoundBased?)
    def isSoundBased?
      return checkFlag?(:soundmove)
    end
  end
end

class PBMove
  if !defined?(isSoundBased?)
    def isSoundBased?
      return $cache.moves[@move].checkFlag?(:soundmove)
    end
  end
end

class MoveRelearnerScene
  def pbDrawMoveList
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    textpos=[]
    imagepos=[]
    type1rect=Rect.new(0,0,64,28)
    type2rect=Rect.new(0,0,64,28)
    if @pokemon.type1==@pokemon.type2
      type1image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",@pokemon.type1))
      overlay.blt(400,70,type1image.bitmap,type1rect)
    else
      type1image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",@pokemon.type1))
      overlay.blt(366,70,type1image.bitmap,type1rect)
      type2image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",@pokemon.type2))
      overlay.blt(436,70,type2image.bitmap,type2rect)
    end
    textpos=[
       [_INTL("Teach which move?"),16,8,0,Color.new(88,88,80),Color.new(168,184,184)]
    ]
    yPos=82
    for i in 0...VISIBLEMOVES
      moveobject=@moves[@sprites["commands"].top_item+i]
      if moveobject
        movedata=$cache.moves[moveobject]
        if movedata
          ### MODDED/
          typeimage = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",hpSummary_trueType(movedata, @pokemon)))
          #### /MODDED
          overlay.blt(12,yPos+2,typeimage.bitmap,type1rect)
          textpos.push([getMoveName(moveobject),80,yPos,0, Color.new(248,248,248),Color.new(0,0,0)])
          if movedata.maxpp>0
            textpos.push([_INTL("PP"),112,yPos+32,0, Color.new(64,64,64),Color.new(176,176,176)])
            textpos.push([_ISPRINTF("{1:d}/{2:d}", movedata.maxpp,movedata.maxpp),230,yPos+32,1, Color.new(64,64,64),Color.new(176,176,176)])
          end
        else
          textpos.push(["-",80,yPos,0,Color.new(64,64,64),Color.new(176,176,176)])
          textpos.push(["--",228,yPos+32,1,Color.new(64,64,64),Color.new(176,176,176)])
        end
      end
      yPos+=64
    end
    imagepos.push(["Graphics/Pictures/reminderSel", 0,78+(@sprites["commands"].index-@sprites["commands"].top_item)*64, 0,0,258,72])
    selmovedata=$cache.moves[@moves[@sprites["commands"].index]]
    ### MODDED/
    basedamage=hpSummary_trueDamage(selmovedata, @pokemon)
    ### /MODDED
    category=selmovedata.category
    accuracy=selmovedata.accuracy

    textpos.push([_INTL("CATEGORY"),272,114,0,Color.new(248,248,248),Color.new(0,0,0)])
    textpos.push([_INTL("POWER"),272,146,0,Color.new(248,248,248),Color.new(0,0,0)])
    textpos.push([basedamage<=1 ? basedamage==1 ? "???" : "---" : sprintf("%d",basedamage),
          468,146,2,Color.new(64,64,64),Color.new(176,176,176)])
    textpos.push([_INTL("ACCURACY"),272,178,0,Color.new(248,248,248),Color.new(0,0,0)])
    textpos.push([accuracy==0 ? "---" : sprintf("%d",accuracy),
          468,178,2,Color.new(64,64,64),Color.new(176,176,176)])
    pbDrawTextPositions(overlay,textpos)
    case category
    when :physical then cattype = 0
    when :special  then cattype = 1
    when :status   then cattype = 2
    end
    imagepos.push(["Graphics/Pictures/category",436,116,0,cattype*28,64,28])
    if @sprites["commands"].index<@moves.length-1
      imagepos.push(["Graphics/Pictures/reminderButtons",48,350,0,0,76,32])
    end
    if @sprites["commands"].index>0
      imagepos.push(["Graphics/Pictures/reminderButtons",134,350,76,0,76,32])
    end
    pbDrawImagePositions(overlay,imagepos)
    drawTextEx(overlay,272,210,238,5,
       getMoveDesc(selmovedata.move),
       Color.new(64,64,64),Color.new(176,176,176))
  end
end

class PokemonSummaryScene < SpriteWrapper
  def drawPageFive(pokemon)
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    @sprites["background"].setBitmap("Graphics/Pictures/Summary/summary5")
    @sprites["pokemon"].visible=true
    @sprites["pokeicon"].visible=false
    imagepos=[]
    if pbPokerus(pokemon)==1 || pokemon.hp==0 || !@pokemon.status.nil?
      status=:POKERUS if pbPokerus(pokemon)==1
      status=@pokemon.status if !@pokemon.status.nil?
      status=:FAINTED if pokemon.hp==0
      imagepos.push([sprintf("Graphics/Pictures/Party/status%s",status),120,100,0,0,44,16])
    end
    if pokemon.isShiny?
      imagepos.push([sprintf("Graphics/Pictures/shiny"),2,134,0,0,-1,-1])
    end
    if pbPokerus(pokemon)==2
      imagepos.push([sprintf("Graphics/Pictures/Summary/statusPKRS"),176,100,0,0,-1,-1])
    end
    ballused = @pokemon.ballused ? @pokemon.ballused : :POKEBALL
    ballimage=sprintf("Graphics/Pictures/Summary/summaryball" + @pokemon.ballused.to_s)
    imagepos.push([ballimage,14,60,0,0,-1,-1])
    pbDrawImagePositions(overlay,imagepos)
    pbSetSystemFont(overlay)
    itemname=pokemon.hasAnItem? ? getItemName(pokemon.item) : _INTL("None")
    pokename=@pokemon.name
    textpos=[
       [_INTL("MOVES"),26,16,0,LightBase,LightShadow],
       [pokename,46,62,0,LightBase,LightShadow],
       [pokemon.level.to_s,46,92,0,DarkBase,DarkShadow],
       [_INTL("Item"),16,320,0,LightBase,LightShadow],
       [itemname,16,352,0,DarkBase,DarkShadow],
    ]
    if pokemon.isMale?
      textpos.push([_INTL("♂"),178,62,0,Color.new(24,112,216),Color.new(136,168,208)])
    elsif pokemon.isFemale?
      textpos.push([_INTL("♀"),178,62,0,ShinyBase,ShinyShadow])
    end
    pbDrawTextPositions(overlay,textpos)
    imagepos=[]
    yPos=98
    for i in 0...pokemon.moves.length
      if pokemon.moves[i].move != nil
        ### MODDED/
        imagepos.push([sprintf("Graphics/Icons/type%s",hpSummary_trueType(pokemon.moves[i], pokemon)),248,yPos+2,0,0,64,28])
        ### /MODDED
        textpos.push([getMoveName(pokemon.moves[i].move),316,yPos,0,DarkBase,DarkShadow])
        if pokemon.moves[i].totalpp>0
          textpos.push([_ISPRINTF("PP"),342,yPos+32,0,DarkBase,DarkShadow])
          textpos.push([sprintf("%d/%d",pokemon.moves[i].pp,pokemon.moves[i].totalpp),460,yPos+32,1,DarkBase,DarkShadow])
        end
      else
        textpos.push(["-",316,yPos,0,DarkBase,DarkShadow])
        textpos.push(["--",442,yPos+32,1,DarkBase,DarkShadow])
      end
      yPos+=64
    end
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
    drawMarkings(overlay,15,291,72,20,pokemon.markings)
  end

  def drawMoveSelection(pokemon,moveToLearn)
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    @sprites["background"].setBitmap("Graphics/Pictures/Summary/summary5details")
    if moveToLearn!=0
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/summary5learning")
    end
    pbSetSystemFont(overlay)
    textpos=[
       [_INTL("MOVES"),26,16,0,LightBase,LightShadow],
       [_INTL("CATEGORY"),20,122,0,LightBase,LightShadow],
       [_INTL("POWER"),20,154,0,LightBase,LightShadow],
       [_INTL("ACCURACY"),20,186,0,LightBase,LightShadow]
    ]
    type1rect=Rect.new(0,0,64,28)
    type2rect=Rect.new(0,0,64,28)
    if pokemon.type1==pokemon.type2
      type1image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",pokemon.type1))
      overlay.blt(130,78,type1image.bitmap,type1rect)
    else
      type1image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",pokemon.type1))
      type2image = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",pokemon.type2))
      overlay.blt(96,78,type1image.bitmap,type1rect)
      overlay.blt(166,78,type2image.bitmap,type2rect)
    end
    imagepos=[]
    yPos=98
    yPos-=76 if moveToLearn!=0
    for i in 0...5
      moveobject=nil
      if i==4
        moveobject=PBMove.new(moveToLearn) if moveToLearn!=0
        yPos+=20
      else
        moveobject=pokemon.moves[i]
      end
      if moveobject
        if moveobject.move != nil
          ### MODDED/
          imagepos.push([sprintf("Graphics/Icons/type%s",hpSummary_trueType(moveobject, pokemon)),248,yPos+2,0,0,64,28])
          ### /MODDED
          textpos.push([getMoveName(moveobject.move),316,yPos,0,DarkBase,DarkShadow])
          if moveobject.totalpp>0
            textpos.push([_ISPRINTF("PP"),342,yPos+32,0,
               DarkBase,DarkShadow])
            textpos.push([sprintf("%d/%d",moveobject.pp,moveobject.totalpp),
               460,yPos+32,1,DarkBase,DarkShadow])
          end
        else
          textpos.push(["-",316,yPos,0,DarkBase,DarkShadow])
          textpos.push(["--",442,yPos+32,1,DarkBase,DarkShadow])
        end
      end
      yPos+=64
    end
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
  end

  def drawSelectedMove(pokemon,moveToLearn,move)
    overlay=@sprites["overlay"].bitmap
    @sprites["pokemon"].visible=false if @sprites["pokemon"]
    @sprites["pokeicon"].bitmap = pbPokemonIconBitmap(pokemon,pokemon.isEgg?)
    @sprites["pokeicon"].src_rect=Rect.new(0,0,64,64)
    @sprites["pokeicon"].visible=true
    movedata=$cache.moves[move]
    ### MODDED/
    basedamage=hpSummary_trueDamage(movedata, pokemon)
    type=hpSummary_trueType(movedata, pokemon)
    ### /MODDED
    category=movedata.category
    accuracy=movedata.accuracy
    drawMoveSelection(pokemon,moveToLearn)
    pbSetSystemFont(overlay)
    textpos=[
       [basedamage<=1 ? basedamage==1 ? "???" : "---" : sprintf("%d",basedamage),
          216,154,1,DarkBase,DarkShadow],
       [accuracy==0 ? "---" : sprintf("%d",accuracy),
          216,186,1,DarkBase,DarkShadow]
    ]
    pbDrawTextPositions(overlay,textpos)
    cattype = 2
    case category
      when :physical then cattype = 0
      when :special  then cattype = 1
      when :status   then cattype = 2
    end
    imagepos=[["Graphics/Pictures/category",166,124,0,cattype*28,64,28]]
    pbDrawImagePositions(overlay,imagepos)
    drawTextEx(overlay,4,218,238,5,getMoveDesc(move),DarkBase,DarkShadow)
  end
end
