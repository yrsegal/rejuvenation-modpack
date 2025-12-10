class MoveTutorScene
  alias :movetutorsorting_old_pbUpdate :pbUpdate
  def pbUpdate
    if Input.trigger?(Input::X)
      [@moves, $Trainer.tutorlist].each { |it|
        it.sort_by! { |mv| 
          if mv
            movedata=$cache.moves[mv]
            if movedata
              next movedata.name.to_s
            end
          end
          next nil
        }
        it.sort_by! { |mv| 
          if mv
            movedata=$cache.moves[mv]
            if movedata
              next movedata.type.to_s
            end
          end
          next nil
        }
      }
      pbPlayCursorSE()

      needsupdate = true
    end

    if Input.trigger?(Input::Y)
      pbPlayCursorSE()
      needsupdate = true
      if @movetutorsorting_sortselecting
        @movetutorsorting_sortselecting = nil
      else
        @movetutorsorting_sortselecting = @sprites["commands"].index
      end
    end

    if Input.trigger?(Input::C) && @movetutorsorting_sortselecting
      pbPlayCursorSE()
      cmd = @sprites["commands"].index
      if @movetutorsorting_sortselecting != cmd
        @moves[cmd], @moves[@movetutorsorting_sortselecting] = @moves[@movetutorsorting_sortselecting], @moves[cmd]
        $Trainer.tutorlist[cmd], $Trainer.tutorlist[@movetutorsorting_sortselecting] = $Trainer.tutorlist[@movetutorsorting_sortselecting], $Trainer.tutorlist[cmd]
        needsupdate = true
      end
      @movetutorsorting_sortselecting = nil
      Input.update # suppress confirm
    end

    if needsupdate
      @sprites["background"].x = 0
      @sprites["background"].y = 78 + (@sprites["commands"].index - @sprites["commands"].top_item) * 64
      pbDrawMoveList
    end

    movetutorsorting_old_pbUpdate
  end

  def pbDrawMoveList
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    textpos=[]
    imagepos=[]
    type1rect=Rect.new(0,0,64,28)
    type2rect=Rect.new(0,0,64,28)
    textpos=[
       [_INTL("Teach which move?"),16,8,0,Color.new(88,88,80),Color.new(168,184,184)]
    ]
    yPos=82
    for i in 0...VISIBLEMOVES
      moveobject=@moves[@sprites["commands"].top_item+i]
      if moveobject
        movedata=$cache.moves[moveobject]
        if movedata
          typeimage = AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",movedata.type))
          overlay.blt(12,yPos+2,typeimage.bitmap,type1rect)
          ### MODDED/
          if @movetutorsorting_sortselecting == @sprites["commands"].top_item+i
            textpos.push([getMoveName(moveobject),80,yPos,0, Color.new(224,0,0),Color.new(248,144,144)])
          else
            textpos.push([getMoveName(moveobject),80,yPos,0, Color.new(248,248,248),Color.new(0,0,0)])
          end
          ### /MODDED
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
    selmovedata=$cache.moves[@moves[@sprites["commands"].index]]
    if selmovedata
      canlearnmove=PokemonBag.pbPartyCanLearnThisMove?(selmovedata.move)
      for i in 0...$Trainer.party.length
          @sprites["pokemon#{i}"].visible=true
          @sprites["possiblelearn#{i}"].visible=true
          case canlearnmove[i]
          when 0 #unable
              @sprites["possiblelearn#{i}"].setBitmap(sprintf("Graphics/Pictures/Bag/tmnope")) rescue nil
          when 1 #able
              @sprites["possiblelearn#{i}"].setBitmap(sprintf("Graphics/Pictures/Bag/tmcheck")) rescue nil
          when 2 #learned
              @sprites["possiblelearn#{i}"].setBitmap(sprintf("Graphics/Pictures/Bag/tmdash")) rescue nil
          else
              @sprites["possiblelearn#{i}"].setBitmap(nil)
          end
      end
    else
      for i in 0...$Trainer.party.length
          @sprites["pokemon#{i}"].visible=false
          @sprites["possiblelearn#{i}"].visible=false
      end
    end 
    imagepos.push(["Graphics/Pictures/reminderSel", 0,78+(@sprites["commands"].index-@sprites["commands"].top_item)*64, 0,0,258,72])
    pbDrawTextPositions(overlay,textpos) 
    if @sprites["commands"].index<@moves.length-1
      imagepos.push(["Graphics/Pictures/reminderButtons",48,350,0,0,76,32])
    end
    if @sprites["commands"].index>0
      imagepos.push(["Graphics/Pictures/reminderButtons",134,350,76,0,76,32])
    end
    pbDrawImagePositions(overlay,imagepos)
  end
end
