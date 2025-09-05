begin
  missing = ['0000.textures.rb', 'Windowskins'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

TextureOverrides.registerTextureOverride(TextureOverrides::SPEECH + "speech naming", TextureOverrides::SKINS + "speech naming")

class Bounded_Window_TextEntry_Keyboard < Window_TextEntry
  attr_reader :matchingnames
  attr_accessor :highlightindex
  attr_accessor :highlightoffset

  def initialize(text,names,x,y,width,height,heading=nil,usedarkercolor=false)
    @names = names
    @backnames = []
    @matchingnames = names
    @highlightindex = -1
    @highlightoffset = 0
    calculateNextchar(0)
    super(text,x,y,width,height,heading,usedarkercolor)
  end

  def update
    @frame+=1
    @frame%=20
    self.refresh if ((@frame%10)==0)
    return if !self.active
    # No moving cursor
    if Input.triggerex?(:BACKSPACE) || Input.repeatex?(:BACKSPACE)
      if @helper.cursor>0
        @matchingnames, @nextchars = @backnames.pop
        self.delete
      end
      return
    elsif Input.triggerex?(:RETURN) || Input.triggerex?(:ESCAPE)
      return
    elsif Input.triggerex?(:TAB)
      if @highlightindex > 0 && @highlightindex <= @matchingnames.length
        nextdisplay = @matchingnames[@highlightindex - 1]
        nextdisplay = nextdisplay[self.text.length..nextdisplay.length]

        for c in nextdisplay.chars
          c = c.downcase
          matches = @matchingnames.select { |n| n[self.text.length] && n[self.text.length].downcase == c }
          if !matches.empty?
            reup = @matchingnames.all? { |n| n[self.text.length].upcase == n[self.text.length] }
            @backnames.push([@matchingnames, @nextchars])
            @matchingnames = matches
            calculateNextchar(self.text.length)
            c = c.upcase if reup
            insert(c)
          end
          recapitalize
        end
      else
        for c in 0...@nextchars.length
          @backnames.push([@matchingnames, @nextchars[c..@nextchars.length]])
        end
        complete = @nextchars
        @nextchars = ""
        for c in complete.chars
          insert(c)
        end
        recapitalize
      end
    elsif (Input.triggerex?(:UP) || Input.repeatex?(:UP)) && @highlightindex > 0
      @highlightindex -= 1
      @highlightindex = @matchingnames.length if @highlightindex == 0
    elsif Input.triggerex?(:DOWN) || Input.repeatex?(:DOWN)
      @highlightindex += 1 if @highlightindex == -1
      @highlightindex += 1
      @highlightindex = 1 if @highlightindex > @matchingnames.length
    end

    Input.gets.each_char { |c|
      c = c.downcase
      matches = @matchingnames.select { |n| n[self.text.length] && n[self.text.length].downcase == c }
      if !matches.empty?
        reup = @matchingnames.all? { |n| n[self.text.length].upcase == n[self.text.length] }
        @backnames.push([@matchingnames, @nextchars])
        @matchingnames = matches
        calculateNextchar(self.text.length)
        c = c.upcase if reup
        insert(c)
      end
      recapitalize
    }
  end

  def insert(c)
    super(c)
    @highlightindex = -1
    @highlightoffset = 0
  end

  def recapitalize
    for i in 0...self.text.length - 1
      reup = @matchingnames.all? { |n| n[i].upcase == n[i] }
      self.text[i] = self.text[i].upcase if reup
      self.text[i] = self.text[i].downcase unless reup
    end
  end

  def calculateNextchar(currentlength)
    @nextchars = ""
    strings = @matchingnames.map { |n| n[(currentlength + 1)...n.length] }

    shortest = strings.min_by &:length
    maxlen = shortest.length
    maxlen.downto(0) do |len|
      0.upto(maxlen - len) do |start|
        substr = shortest[start,len]
        if strings.all? {|str| str.start_with? substr }
          @nextchars = substr
          return
        end
      end
    end
  end

  def isMatch?
    return @matchingnames.length == 1
  end

  def refresh
    self.contents=pbDoEnsureBitmap(self.contents,self.width-self.borderX,
       self.height-self.borderY)
    bitmap=self.contents
    bitmap.clear
    x=0
    y=0
    if @heading
      textwidth=bitmap.text_size(@heading).width
      pbDrawShadowText(bitmap,x,y, textwidth+4, 32, @heading,@baseColor,@shadowColor)
      y+=32
    end
    x+=4
    width=self.width-self.borderX
    height=self.height-self.borderY
    cursorcolor=Color.new(16,24,32)
    textscan=self.text.scan(/./m)
    scanlength=textscan.length
    @helper.cursor=scanlength if @helper.cursor>scanlength
    @helper.cursor=0 if @helper.cursor<0
    startpos=@helper.cursor
    fromcursor=0
    while (startpos>0)
      c=(@helper.passwordChar!="") ? @helper.passwordChar : textscan[startpos-1]
      fromcursor+=bitmap.text_size(c).width
      break if fromcursor>width-4
      startpos-=1
    end
    for i in startpos...scanlength
      c=(@helper.passwordChar!="") ? @helper.passwordChar : textscan[i]
      textwidth=bitmap.text_size(c).width
      next if c=="\n"
      # Draw text
      pbDrawShadowText(bitmap,x,y, textwidth+4, 32, c,@baseColor,@shadowColor)
      # Draw cursor if necessary
      if ((@frame/10)&1) == 0 && i==@helper.cursor
        bitmap.fill_rect(x,y+4,2,24,cursorcolor)
      end
      # Add x to drawn text width
      x += textwidth
    end
    if ((@frame/10)&1) == 0 && textscan.length==@helper.cursor
      bitmap.fill_rect(x,y+4,2,24,cursorcolor)
    end
    ### MODDED/
    nextdisplay = @nextchars
    if @highlightindex > 0 && @highlightindex <= @matchingnames.length
      nextdisplay = @matchingnames[@highlightindex - 1]
      nextdisplay = nextdisplay[self.text.length..nextdisplay.length]
    end
    textwidth=bitmap.text_size(nextdisplay).width
    pbDrawShadowText(bitmap,x,y, textwidth+4, 32, nextdisplay, @shadowColor,nil)
    ### /MODDED
  end
end

class BoundedPokemonEntryScene

  def pbStartScene(helptext,names)
    @names = names

    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["entry"]=Bounded_Window_TextEntry_Keyboard.new("", names,
       0,0,400-112,96,helptext,true)
    Input.text_input = true
    @sprites["entry"].x=(Graphics.width/2)-(@sprites["entry"].width/2)+32
    @sprites["entry"].viewport=@viewport
    @sprites["entry"].visible=true

    @sprites["helpwindow"]=Window_UnformattedTextPokemon.newWithSize(
       _INTL("Enter text using the keyboard.  Press\nESC to cancel, or ENTER to confirm."),
       32,Graphics.height-96,Graphics.width-64,96,@viewport
    )
    @sprites["helpwindow"].letterbyletter=false
    @sprites["helpwindow"].viewport=@viewport
    @sprites["helpwindow"].visible=true
    @sprites["helpwindow"].baseColor=Color.new(16,24,32)
    @sprites["helpwindow"].shadowColor=Color.new(168,184,184)

    hintwidth = names.map { |n| @sprites["entry"].contents.text_size(n).width }.max
    @sprites["matchwindow"] = Window_UnformattedTextPokemon.newWithSize("", 32, 96, hintwidth + 64, Graphics.height-192,@viewport)

    matchtxt, overlay_y, overlaytxt = updatematches

    @sprites["matchwindow"].text=matchtxt
    @sprites["matchwindow"].visible = true
    @sprites["matchwindow"].viewport=@viewport
    @sprites["matchwindow"].letterbyletter=false
    @sprites["matchwindow"].baseColor=Color.new(16,24,32)
    @sprites["matchwindow"].shadowColor=Color.new(168,184,184)

    @sprites["matchoverlay"] = Window_UnformattedTextPokemon.newWithSize("", 48, overlay_y, hintwidth + 64, 96,@viewport)
    @sprites["matchoverlay"].text=overlaytxt
    @sprites["matchoverlay"].visible = true
    @sprites["matchoverlay"].viewport=@viewport
    @sprites["matchoverlay"].letterbyletter=false
    @sprites["matchoverlay"].baseColor=Color.new(52, 152, 219)
    @sprites["matchoverlay"].shadowColor=Color.new(27, 79, 114)

    addBackgroundPlane(@sprites,"background","naming2bg",@viewport)

    # After background plane so that the box still renders
    @sprites["matchwindow"].setSkin("Graphics/Windowskins/speech naming")

    pbFadeInAndShow(@sprites)
  end

  def updatematches
    limit = 5
    matchesdisplayed = []
    heights = []
    totalheight = 0

    skipped = 0

    if @sprites["entry"].highlightindex == -1
      @sprites["entry"].highlightoffset = 0
    else
      while @sprites["entry"].highlightoffset + limit < @sprites["entry"].highlightindex
        @sprites["entry"].highlightoffset += 1
      end

      while @sprites["entry"].highlightoffset > @sprites["entry"].highlightindex - 1
        @sprites["entry"].highlightoffset -= 1
      end
    end

    for i in @sprites["entry"].matchingnames[@sprites["entry"].highlightoffset,limit]
      height = @sprites["entry"].contents.text_size(i).height
      heights.push(totalheight)
      totalheight += height + 2
      matchesdisplayed.push(i)
    end

    if @sprites["entry"].highlightindex > 0
      idx = @sprites["entry"].highlightindex - 1 - @sprites["entry"].highlightoffset
      return matchesdisplayed.join("\n"), @sprites["matchwindow"].y + heights[idx], matchesdisplayed[idx]
    end
    return matchesdisplayed.join("\n"), @sprites["matchwindow"].y, ""
  end

  def pbEntry
    ret=""
    loop do
      Graphics.update
      Input.update
      if Input.triggerex?(:ESCAPE)
        ret=""
        break
      elsif Input.triggerex?(:RETURN)
        if @sprites["entry"].isMatch?
          ret=@sprites["entry"].matchingnames[0]
          break
        elsif @sprites["entry"].highlightindex > 0 && @sprites["entry"].highlightindex <= @sprites["entry"].matchingnames.length
          ret=@sprites["entry"].matchingnames[@sprites["entry"].highlightindex - 1]
          break
        end
      end
      @sprites["helpwindow"].update
      lastmatchnames = @sprites["entry"].matchingnames
      lasthighlightindex = @sprites["entry"].highlightindex
      @sprites["entry"].update
      if lastmatchnames != @sprites["entry"].matchingnames || lasthighlightindex != @sprites["entry"].highlightindex
        matchtxt, overlay_y, overlaytxt = updatematches
        @sprites["matchwindow"].text=matchtxt
        @sprites["matchoverlay"].y=overlay_y
        @sprites["matchoverlay"].text=overlaytxt
      end
    end
    Input.update
    return ret
  end

  def pbEndScene
    Input.text_input = false
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

def boundedentry_textEntry(helptext, cacheList, ifno, &mapper)
  keys = cacheList.is_a?(Hash) ? cacheList.keys : cacheList
  names = keys.map { |key| (block_given? ? mapper.call(key) : key).gsub('é', 'e') }
  ret=""
  if names.length == 0
    Kernel.pbMessage(_INTL(ifno))
  else
    pbFadeOutIn(99999){
      sscene=BoundedPokemonEntryScene.new
      sscene.pbStartScene(helptext,names)
      ret=sscene.pbEntry
      sscene.pbEndScene
    }
  end
  ret = names.index(ret)
  return nil if ret.nil?
  return keys[ret]
end

class PokemonTypeReel < BitmapSprite
  attr_accessor :reel
  attr_accessor :pos
  attr_accessor :selected

  def initialize(x,y,allownil)
    @viewport=Viewport.new(x,y,68,32)
    @viewport.z = 100000
    super(68,32,@viewport)
    @reel=[]
    @reel.push(nil) if allownil
    for type in $cache.types.keys
      @reel.push(type) if type != :QMARKS && type != :SHADOW
    end
    @reel.push(*$cache.types.keys)
    @icons=@reel.map { |type|
      next AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BoxExtensions/TypeBlank") unless type

      next AnimatedBitmap.new(sprintf("Graphics/Icons/type%s",type))
    }
    @cursor=AnimatedBitmap.new("#{__dir__[Dir.pwd.length+1..]}/BoxExtensions/TypeCursor")
    @pos = 0
    @frame = 0
    @selected = false
  end

  def dispose
    @icons.each do |icon|
      icon.dispose if icon
    end
    @cursor.dispose
    super
  end

  def up
    return unless @selected
    @pos = @pos - 1
    if @pos < 0
      @pos = @reel.length - 1
    end
    refresh
  end

  def down
    return unless @selected
    @pos = (@pos + 1) % @reel.length
    refresh
  end

  def toggleSelect
    @selected = !@selected
    @frame = 0
    refresh
  end

  def update
    @frame+=1
    @frame%=20
    self.refresh if ((@frame%10)==0)
  end

  def selected
    return @reel[@pos]
  end

  def refresh
    self.bitmap.clear
    self.bitmap.blt(0,0,@cursor.bitmap,Rect.new(0,0,68,32)) if @selected && ((@frame/10)&1) == 0
    self.bitmap.blt(2,2,@icons[pos].bitmap,Rect.new(0,0,64,28))
  end
end

class PokemonTypeSelectionScreen

  def pbStartScene(helptext)
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["entry"]=Window_UnformattedTextPokemon.newWithSize(helptext,0,0,400-112,96,@viewport)
    @sprites["entry"].x=(Graphics.width/2)-(@sprites["entry"].width/2)+32
    @sprites["entry"].letterbyletter = false
    @sprites["entry"].viewport=@viewport
    @sprites["entry"].visible=true
    @sprites["entry"].baseColor=Color.new(16,24,32)
    @sprites["entry"].shadowColor=Color.new(168,184,184)

    @sprites["type1"]=PokemonTypeReel.new(@sprites["entry"].x + 10,50,false)
    @sprites["type1"].visible=true
    @sprites["type1"].selected=true

    @sprites["type2"]=PokemonTypeReel.new(@sprites["entry"].x + 10 + 72,50,true)
    @sprites["type2"].visible=true

    @sprites["helpwindow"]=Window_UnformattedTextPokemon.newWithSize(
       _INTL("Select types using the arrow keys.\nPress ESC to cancel, or ENTER to confirm."),
       32,Graphics.height-96,Graphics.width-64,96,@viewport
    )
    @sprites["helpwindow"].letterbyletter=false
    @sprites["helpwindow"].viewport=@viewport
    @sprites["helpwindow"].visible=true
    @sprites["helpwindow"].baseColor=Color.new(16,24,32)
    @sprites["helpwindow"].shadowColor=Color.new(168,184,184)

    addBackgroundPlane(@sprites,"background","naming2bg",@viewport)

    pbFadeInAndShow(@sprites)
  end

  def pbEntry
    ret=nil
    loop do
      Graphics.update
      Input.update
      if Input.triggerex?(:ESCAPE) || Input.trigger?(Input::B)
        ret=nil
        break
      elsif Input.triggerex?(:RETURN) || Input.trigger?(Input::C)
        type1 = @sprites["type1"].selected
        type2 = @sprites["type2"].selected
        ret = [type1]
        ret.push(type2) if type2
        break
      elsif Input.triggerex?(:LEFT) || Input.repeatex?(:LEFT) || Input.triggerex?(:RIGHT) || Input.repeatex?(:RIGHT)
        @sprites["type1"].toggleSelect
        @sprites["type2"].toggleSelect
      elsif Input.triggerex?(:DOWN) || Input.repeatex?(:DOWN)
        @sprites["type1"].down
        @sprites["type2"].down
      elsif Input.triggerex?(:UP) || Input.repeatex?(:UP)
        @sprites["type1"].up
        @sprites["type2"].up
      end
      @sprites["helpwindow"].update
      @sprites["entry"].update
      @sprites["type1"].update
      @sprites["type2"].update
    end
    Input.update
    return ret
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

def boundedentry_typeEntry(helptext)
  ret=""
  pbFadeOutIn(99999){
    sscene=PokemonTypeSelectionScreen.new
    sscene.pbStartScene(helptext)
    ret=sscene.pbEntry
    sscene.pbEndScene
  }
  return ret
end