begin
  missing = ['favorite.png'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end


class PokemonBag_Scene
  # Called when the item screen wants an item to be chosen from the screen
  def pbChooseItem
    pbRefresh
    pbTMSprites
    @sprites["helpwindow"].visible=false
    itemwindow=@sprites["itemwindow"]
    itemwindow.refresh
    sorting=false
    sortindex=-1
    pbDetermineTMmenu(itemwindow)
    pbActivateWindow(@sprites,"itemwindow"){
      loop do
        Graphics.update
        Input.update
        olditem=itemwindow.item
        oldindex=itemwindow.index
        self.update
        if itemwindow.item!=olditem
          # Update slider position
          ycoord=60
          if itemwindow.itemCount>1
            ycoord+=116.0 * itemwindow.index/(itemwindow.itemCount-1)
          end
          @sprites["slider"].y=ycoord
          # Update item icon and description
          filename=pbItemIconFile(itemwindow.item)
          @sprites["icon"].setBitmap(filename)
          @sprites["itemtextwindow"].text=(itemwindow.item.nil?) ? _INTL("Close bag.") : $cache.items[itemwindow.item].desc
          pbDetermineTMmenu(itemwindow)
        end
        if itemwindow.index!=oldindex
          # Update selected item for current pocket
          @bag.setChoice(itemwindow.pocket,itemwindow.index)
        end
        # Change pockets if Left/Right pressed
        numpockets=PokemonBag.numPockets
        if Input.trigger?(Input::LEFT)
          if !sorting
            itemwindow.pocket=(itemwindow.pocket==1) ? numpockets : itemwindow.pocket-1
            @bag.lastpocket=itemwindow.pocket
            pbRefresh
            pbDetermineTMmenu(itemwindow)
          end
        elsif Input.trigger?(Input::RIGHT)
          if !sorting
            itemwindow.pocket=(itemwindow.pocket==numpockets) ? 1 : itemwindow.pocket+1
            @bag.lastpocket=itemwindow.pocket
            pbRefresh
            pbDetermineTMmenu(itemwindow)
          end
        end
        if Input.trigger?(Input::X)
          if pbHandleSortByType(itemwindow.pocket) # Returns true if the default sorting should be used
            pocket  = @bag.pockets[itemwindow.pocket]
            counter = 1
            while counter < pocket.length
              index     = counter
              while index > 0
                indexPrev = index - 1
                if itemwindow.pocket==TMPOCKET
                  ### MODDED/
                  firstName  = (((getItemName(pocket[indexPrev])).sub("TM","00")).sub("X","100")).to_s
                  secondName = (((getItemName(pocket[index])).sub("TM","00")).sub("X","100")).to_i
                  ### /MODDED
                else
                  firstName  = getItemName(pocket[indexPrev])
                  secondName = getItemName(pocket[index])
                end
                ### MODDED/
                if @bag.isFavorite?(pocket[indexPrev])
                  firstName = "AAAAAAAAAAAAAAAAAAA" + firstName
                else
                  firstName = "BBBBBBBBBBBBBBBBBBB" + firstName
                end
                if @bag.isFavorite?(pocket[index])
                  secondName = "AAAAAAAAAAAAAAAAAAA" + secondName
                else
                  secondName = "BBBBBBBBBBBBBBBBBBB" + secondName
                end
                ### /MODDED
                if firstName > secondName
                  aux               = pocket[index]
                  pocket[index]     = pocket[indexPrev]
                  pocket[indexPrev] = aux
                end
                index -= 1
              end
              counter += 1
            end
          end
          pbRefresh
        end
        # Select item for switching if A is pressed
        if Input.trigger?(Input::Y)
          thispocket=@bag.pockets[itemwindow.pocket]
          if itemwindow.index<thispocket.length && thispocket.length>1 &&
             !POCKETAUTOSORT[itemwindow.pocket]
            sortindex=itemwindow.index
            sorting=true
            @sprites["itemwindow"].sortIndex=sortindex
          else
            next
          end
        end
        ### MODDED/
        # Favorite item
        if Input.trigger?(Input::Z)
          if @bag.isFavorite?(itemwindow.item)
            @bag.removeFavorite(itemwindow.item)
          else
            @bag.addFavorite(itemwindow.item)
          end
          pbRefresh
        end
        ### /MODDED
        # Cancel switching or cancel the item screen
        if Input.trigger?(Input::B)
          if sorting
            sorting=false
            @sprites["itemwindow"].sortIndex=-1
          else
            return nil
          end
        end
        # Confirm selection or item switch
        if Input.trigger?(Input::C)
          thispocket=@bag.pockets[itemwindow.pocket]
          if itemwindow.index<thispocket.length
            if sorting
              sorting=false
              tmp=thispocket[itemwindow.index]
              thispocket[itemwindow.index]=thispocket[sortindex]
              thispocket[sortindex]=tmp
              @sprites["itemwindow"].sortIndex=-1
              pbRefresh
              next
            else
              pbRefresh
              return thispocket[itemwindow.index]
            end
          else
            return nil
          end
        end
      end
    }
  end

  alias :favoriteItems_old_pbApplySortingResult :pbApplySortingResult

  def pbApplySortingResult(items, result)
    result.sort! { |a,b| (@bag.isFavorite?(a) ? 0 : 1) <=> (@bag.isFavorite?(b) ? 0 : 1) }
    favoriteItems_old_pbApplySortingResult(items, result)
  end
end

class PokemonBag

  def favoriteItems
    @favoriteItems = [] unless @favoriteItems
    return @favoriteItems
  end

  def isFavorite?(item)
    return self.favoriteItems.include?(item)
  end

  def addFavorite(item)
    self.favoriteItems.push(item) unless isFavorite?(item)
  end

  def removeFavorite(item)
    self.favoriteItems.delete(item)
  end
end

class PokemonBagScreen
  def pbStartScreen
    @scene.pbStartScene(@bag)
    item=nil
    loop do
      item=@scene.pbChooseItem
      break if item.nil?
      cmdUse=-1
      cmdRegister=-1
      cmdGive=-1
      cmdToss=-1
      cmdRead=-1
      ### MODDED/
      cmdFavorite=-1
      ### /MODDED
      commands=[]
      # Generate command list
      commands[cmdRead=commands.length]=_INTL("Read") if pbIsMail?(item)
      commands[cmdUse=commands.length]=_INTL("Use") if ItemHandlers.hasOutHandler(item) || (pbIsTM?(item) && $Trainer.party.length>0)
      commands[cmdGive=commands.length]=_INTL("Give") if $Trainer.party.length>0 && !pbIsImportantItem?(item)
      commands[cmdToss=commands.length]=_INTL("Toss") if !pbIsImportantItem?(item) || $DEBUG
      if @bag.registeredItems.include?(item)
        commands[cmdRegister=commands.length]=_INTL("Deselect")
      elsif ItemHandlers.hasKeyItemHandler(item) && pbIsKeyItem?(item)
        commands[cmdRegister=commands.length]=_INTL("Register")
      end
      ### MODDED/
      if @bag.isFavorite?(item)
        commands[cmdFavorite=commands.length]=_INTL("Unfavorite")
      else
        commands[cmdFavorite=commands.length]=_INTL("Favorite")
      end
      ### /MODDED
      commands[commands.length]=_INTL("Cancel")
      # Show commands generated above
      itemname=getItemName(item) # Get item name
      command=@scene.pbShowCommands(_INTL("{1} is selected.",itemname),commands)
      if cmdUse>=0 && command==cmdUse # Use item
        ret=pbUseItem(@bag,item,@scene)
        # 0=Item wasn't used; 1=Item used; 2=Close Bag to use in field
        break if ret==2 # End screen
        @scene.pbRefresh
        next
      elsif cmdRead>=0 && command==cmdRead # Read mail
        pbFadeOutIn(99999){
           pbDisplayMail(PokemonMail.new(item,"",""))
        }
      elsif cmdRegister>=0 && command==cmdRegister # Register key item
        if @bag.pbIsRegistered?(item)
          @bag.pbUnregisterItem(item)
        else
          @bag.pbRegisterItem(item)
        end
        @scene.pbRefresh
      elsif cmdGive>=0 && command==cmdGive # Give item to Pokémon
        if $Trainer.pokemonCount==0
          @scene.pbDisplay(_INTL("There is no Pokémon."))
        elsif pbIsImportantItem?(item)
          @scene.pbDisplay(_INTL("The {1} can't be held.",itemname))
        elsif Rejuv && $game_variables[650] > 0 
          @scene.pbDisplay(_INTL("You are not allowed to change the rental team's items."))
        else
          # Give item to a Pokémon
          pbFadeOutIn(99999){
             sscene=PokemonScreen_Scene.new
             sscreen=PokemonScreen.new(sscene,$Trainer.party)
             sscreen.pbPokemonGiveScreen(item)
             @scene.pbRefresh
          }
        end
      ### MODDED/
      elsif cmdFavorite >= 0 && command == cmdFavorite # Favorite item
        if @bag.isFavorite?(item)
          @bag.removeFavorite(item)
        else
          @bag.addFavorite(item)
        end
        @scene.pbRefresh
      ### /MODDED
      elsif cmdToss>=0 && command==cmdToss # Toss item
        qty=@bag.pbQuantity(item)
        helptext=_INTL("Toss out how many {1}(s)?",itemname)
        qty=@scene.pbChooseNumber(helptext,qty)
        if qty>0
          if pbConfirm(_INTL("Is it OK to throw away {1} {2}(s)?",qty,itemname))
            pbDisplay(_INTL("Threw away {1} {2}(s).",qty,itemname))
            qty.times { @bag.pbDeleteItem(item) }
          end
        end
      end
    end
    @scene.pbEndScene
    return item
  end
end

class Window_PokemonBag < Window_DrawableCommand
  
  def drawItem(index,count,rect)
    textpos=[]
    rect=drawCursor(index,rect)
    ypos=rect.y+4
    if index==@bag.pockets[self.pocket].length
      textpos.push([_INTL("CLOSE BAG"),rect.x,ypos,false,
         self.baseColor,self.shadowColor])
    else
      item=@bag.pockets[self.pocket][index]
      itemname=@adapter.getDisplayName(item)
      qty=_ISPRINTF("x{1: 2d}",@bag.contents[item])
      sizeQty=self.contents.text_size(qty).width
      xQty=rect.x+rect.width-sizeQty-16
      baseColor=(index==@sortIndex) ? Color.new(224,0,0) : self.baseColor
      shadowColor=(index==@sortIndex) ? Color.new(248,144,144) : self.shadowColor
      textpos.push([itemname,rect.x,ypos,false,baseColor,shadowColor])
      if !pbIsImportantItem?(item) # Not a Key item or HM (or infinite TM)
        textpos.push([qty,xQty,ypos,false,baseColor,shadowColor])
      end
      ### MODDED/
      if @bag.isFavorite?(item)
        xshift = 38
        xshift += 40 if @bag.pbIsRegistered?(item)
        xshift += sizeQty if !pbIsImportantItem?(item)
        pbDrawImagePositions(self.contents,[
           ["#{__dir__[Dir.pwd.length+1..]}/favorite",rect.x+rect.width-xshift,ypos+6,0,0,-1,-1]
        ])
      end
      ### /MODDED
    end
    pbDrawTextPositions(self.contents,textpos)
    if index!=@bag.pockets[self.pocket].length
      if @bag.pbIsRegistered?(item)
        pbDrawImagePositions(self.contents,[
           ["Graphics/Pictures/Bag/bagReg",rect.x+rect.width-58,ypos+4,0,0,-1,-1]
        ])
      end
    end
  end
end
