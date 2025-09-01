class Window_AdvancedCommandPokemon
  def commands=(value)
    @commands=value
    @item_max=commands.length
    ### MODDED/
    self.build_format_cache(value)
    ### /MODDED
    self.update_cursor_rect
    self.refresh
  end

  def build_format_cache(value)
    @textCache.each(&:dispose) if defined?(@textCache)
    txtbmp = Bitmap.new(1, 1)
    pbSetSystemFont(txtbmp)
    @textCache = value.each_with_index.map { |cmd, idx|
      dims=[nil,0]

      formattedText = getFormattedText(txtbmp,0,0,Graphics.width,@row_height,cmd,@row_height,true,true)
      for ch in formattedText
        dims[0]=dims[0] ? [dims[0],ch[1]].min : ch[1]
        dims[1]=[dims[1],ch[1]+ch[3]].max
      end
      dims[0]=0 if !dims[0]
      
      choicebmp = Bitmap.new(dims[1]-dims[0], @row_height)
      pbSetSystemFont(choicebmp)
      drawFormattedChars(choicebmp, formattedText)

      next choicebmp
    }
    txtbmp.dispose
  end

  def dispose
    super
    @textCache.each(&:dispose) if defined?(@textCache)
  end

  def getAutoDims(commands,dims,width=nil)
    ### MODDED/
    self.build_format_cache(commands)
    ### /MODDED

    rowMax=((commands.length + self.columns - 1) / self.columns).to_i
    windowheight=(rowMax*self.rowHeight)
    windowheight+=self.borderY
    if !width || width<0
      width=0
      for i in 0...commands.length
        ### MODDED/
        width=[width,@textCache[i].width].max
        ### /MODDED
      end
      if !@textCache
        choicebmp.dispose
      end
      # one 16 to allow cursor
      width+=16+16+SpriteWindow_Base::TEXTPADDING
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
      chars=@textCache[index]
      choicerect = Rect.new(0, 0, rect.width, rect.height)
      self.contents.blt(rect.x, rect.y, chars, choicerect)
      ### /MODDED
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
