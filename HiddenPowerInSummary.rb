def hpSummary_trueType(move, pokemon)
    type = move.type
    if move.move == :HIDDENPOWER
      type = pbHiddenPower(pokemon)
    elsif move.move == :REVELATIONDANCE
      type = pokemon.type1
    elsif move.move == :MIRRORBEAM
      if !pokemon.type2.nil?
        type = pokemon.type2
      else
        type = pokemon.type1
      end
    end
    return type
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
    basedamage=selmovedata.basedamage
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
end
