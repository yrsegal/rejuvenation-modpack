class Window_AdvancedCommandPokemon
  def getAutoDims(commands,dims,width=nil)
    rowMax=((commands.length + self.columns - 1) / self.columns).to_i
    windowheight=(rowMax*self.rowHeight)
    windowheight+=self.borderY
    if !width || width<0
      width=0
      tmpbitmap=BitmapWrapper.new(1,1)
      pbSetSystemFont(tmpbitmap)
      for i in commands
        ### MODDED/
        width=[width,textWidth(tmpbitmap,i)].max
        ### /MODDED
      end
      # one 16 to allow cursor
      width+=16+16+SpriteWindow_Base::TEXTPADDING
      tmpbitmap.dispose
    end
    # Store suggested width and height of window
    dims[0]=[self.borderX+1,(width*self.columns)+self.borderX+
       (self.columns-1)*self.columnSpacing].max
    dims[1]=[self.borderY+1,windowheight].max
    dims[1]=[dims[1],Graphics.height].min
  end

  def drawItem(index,count,rect)
    pbSetSystemFont(self.contents)
    rect=drawCursor(index,rect)
    if toUnformattedText(@commands[index]).gsub(/\n/,"")==@commands[index]
      # Use faster alternative for unformatted text without line breaks
      pbDrawShadowText(self.contents,rect.x,rect.y,rect.width,rect.height,
         @commands[index],self.baseColor,self.shadowColor)
    else
      ### MODDED/
      @textCache = {} if !@textCache

      chars = @textCache[[index, rect.y]]
      if !chars
        chars=getFormattedText(
          self.contents,rect.x,rect.y,rect.width,rect.height,
          @commands[index],rect.height,true,true)
        @textCache[[index, rect.y]] = chars
      end
      ### /MODDED

      drawFormattedChars(self.contents,chars)
    end
  end
end

def Kernel.advanced_pbMessage(message,commands=nil,cmdIfCancel=0,skin=nil,defaultCmd=0,&block)
  ret=0
  msgwindow=Kernel.pbCreateMessageWindow(nil,skin)
  if commands
    ret=Kernel.pbMessageDisplay(msgwindow,message,true,
       proc {|msgwindow|
          next Kernel.advanced_pbShowCommands(msgwindow,commands,cmdIfCancel,defaultCmd,&block)
    },&block)
  else
    Kernel.pbMessageDisplay(msgwindow,message,&block)
  end
  Kernel.pbDisposeMessageWindow(msgwindow)
  Input.update
  return ret
end


def Kernel.advanced_pbShowCommandsWithHelp(msgwindow,commands,help,cmdIfCancel=0,defaultCmd=0)
  msgwin=msgwindow
  if !msgwindow
    msgwin=Kernel.pbCreateMessageWindow(nil)
  end
  oldlbl=msgwin.letterbyletter
  msgwin.letterbyletter=false
  if commands
    cmdwindow=Window_AdvancedCommandPokemon.new(commands)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.resizeToFit(cmdwindow.commands)
    cmdwindow.height=msgwin.y if cmdwindow.height>msgwin.y
    cmdwindow.index=defaultCmd
    command=0
    msgwin.text=help[cmdwindow.index]
    msgwin.width=msgwin.width # Necessary evil to make it use the proper margins.
    loop do
      Graphics.update
      Input.update
      oldindex=cmdwindow.index
      cmdwindow.update
      if oldindex!=cmdwindow.index
        msgwin.text=help[cmdwindow.index]
      end
      msgwin.update
      yield if block_given?
      if Input.trigger?(Input::B)
        if cmdIfCancel>0
          command=cmdIfCancel-1
          pbWait(2)
          break
        elsif cmdIfCancel<0
          command=cmdIfCancel
          pbWait(2)
          break
        end
      end
      if Input.trigger?(Input::C)
        command=cmdwindow.index
        break
      end
      pbUpdateSceneMap
    end
    ret=command
    cmdwindow.dispose
    Input.update
  end
  msgwin.letterbyletter=oldlbl
  if !msgwindow
    msgwin.dispose
  end
  return ret
end

def Kernel.advanced_pbShowCommands(msgwindow,commands=nil,cmdIfCancel=0,defaultCmd=0)
  ret=0
  if commands
    cmdwindow=Window_AdvancedCommandPokemon.new(commands)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.resizeToFit(cmdwindow.commands)
    pbPositionNearMsgWindow(cmdwindow,msgwindow,:right)
    cmdwindow.index=defaultCmd
    command=0
    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      msgwindow.update if msgwindow
      yield if block_given?
      if Input.trigger?(Input::B)
        if cmdIfCancel>0
          command=cmdIfCancel-1
          pbWait(2)
          break
        elsif cmdIfCancel<0
          command=cmdIfCancel
          pbWait(2)
          break
        end
      end
      if Input.trigger?(Input::C)
        command=cmdwindow.index
        break
      end
      pbUpdateSceneMap
    end
    ret=command
    cmdwindow.dispose
    Input.update
  end
  return ret
end