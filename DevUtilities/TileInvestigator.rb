
def tlset(layer, tileid)
  InjectionHelper::APPLIED_PATCHES.push($game_map.map_id) unless !defined?(InjectionHelper) || InjectionHelper::APPLIED_PATCHES.include?($game_map.map_id)
  $PREVIOUS_APPLIED_PATCHES.push($game_map.map_id) unless !defined?($PREVIOUS_APPLIED_PATCHES) || $PREVIOUS_APPLIED_PATCHES.include?($game_map.map_id)
  $game_map.data[$game_player.x,$game_player.y,layer] = tileid
end

def tlget
  px = $game_player.x
  py = $game_player.y
  [$game_map.data[px,py,0],$game_map.data[px,py,1],$game_map.data[px,py,2]]
end

def tlopen(layer=0)
  px = $game_player.x
  py = $game_player.y
  InjectionHelper::APPLIED_PATCHES.push($game_map.map_id) unless !defined?(InjectionHelper) || InjectionHelper::APPLIED_PATCHES.include?($game_map.map_id)
  $PREVIOUS_APPLIED_PATCHES.push($game_map.map_id) unless !defined?($PREVIOUS_APPLIED_PATCHES) || $PREVIOUS_APPLIED_PATCHES.include?($game_map.map_id)
  pbFadeOutIn(99999){
     scene=PokemonTilesetScene.new
     scene.pbSelect($game_map.data[px,py,layer])
     scene.pbStartScene
  }
end

class Game_Character
  attr_writer :x
  attr_writer :y
  attr_writer :direction
end

class Game_Map
  attr_reader :map
end

def tlexport(width, height, original, changed)
  palettechars = "ABCDEFGHIJKLMOPQRSTUVWXYZabcdefghjkmopqrstuvwxyz"

  minx = $game_map.height
  miny = $game_map.width
  maxx = 0
  maxy = 0

  width.times do |x|
    height.times do |y|
      if original[x,y,0] != changed[x,y,0] || original[x,y,1] != changed[x,y,1] || original[x,y,2] != changed[x,y,2]
        minx = x if x < minx
        miny = y if y < miny
        maxx = x if x > maxx
        maxy = y if y > maxy
      end
    end
  end

  if minx <= maxx && miny <= maxy
    palette = {}
    paletteorder = []
    startchar = " "
    paletteidx = 0

    canW = maxx - minx + 1
    canH = maxy - miny + 1
    canvas = Array.new(canH) {|i| " " * canW}

    canH.times do |yp|
      canW.times do |xp|
        x = minx + xp
        y = miny + yp
        key = Array.new(3) {|i| original[x,y,i] == changed[x,y,i] ? nil : changed[x,y,i]}
        if key != [nil,nil,nil]
          unless palette[key]
            if paletteidx < palettechars.length
              palettechar = palettechars.chars[paletteidx]
              paletteidx += 1
            else
              startchar = startchar.succ
              while palette.values.include?(startchar) || '"\\#%,[]{}()=>'.chars.include?(startchar) || startchar[/\p{Cntrl}/]
                startchar = (startchar.codepoints[0] + 1).chr(Encoding::UTF_8)
              end
              palettechar = startchar
            end
            paletteorder.push(palettechar)
            palette[key] = palettechar
          else
            palettechar = palette[key]
          end

          canvas[yp][xp] = palettechar
        end
      end
    end

    File.open("tileoutput.txt","wb"){|f| 
      f.write("map.fillArea(#{minx}, #{miny},\n")
      firstline = true
      f.write("  [")
      for s in canvas
        f.write(",\n   ") unless firstline
        firstline = false
        f.write(s.inspect)
      end
      f.write("],\n")
      f.write("  {\n")
      for key in paletteorder
        value = palette.invert[key]
        f.write("    ")
        f.write(key.inspect)
        f.write(" => ")
        f.write(value.inspect)
        f.write(",\n")
      end
      f.write("  })\n")
    }
    Kernel.pbMessage("Saved to tileoutput.txt")
  end
end

# Left click - paint/select tile
# Right click - copy target
# Hold shift to paint/copy all layers
# Scroll/Q/W to navigate tileset
# Tab to switch layers
# A to clear swatch layer
# Currently no support for complex autotile painting
def tleditor2

  tilesetwrapper=pbTilesetWrapper
  tileset=tilesetwrapper.data[$game_map.map.tileset_id]
  tilehelper=TileDrawingHelper.fromTileset(tileset)
  
  for event in $game_map.events.values
    event.minilock
  end
  wasthrough = $game_player.through
  $game_player.through = true


  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  background = BitmapSprite.new(256,Graphics.height-64,viewport)
  background.zoom_x = 0.5
  background.zoom_y = 0.5
  background.z = 99998
  overlay = BitmapSprite.new(256,Graphics.height-64,viewport)
  overlay.zoom_x = 0.5
  overlay.zoom_y = 0.5
  overlay.z = 99999
  infobox = Window_AdvancedTextPokemon.new()
  infobox.visible = false

  doneInitialInit = false
  
  orig = Table.new($game_map.width, $game_map.height, 3)
  $game_map.width.times do |x|
    $game_map.height.times do |y|
      3.times do |l|
        orig[x,y,l] = $game_map.data[x,y,l]
      end
    end
  end

  layer = 0
  swatch = tlget
  prevmpos = nil

  loop do
    doneAny = !doneInitialInit
    doneInitialInit = true

    Graphics.update
    Input.update

    mousepos = Mouse::getMousePos
    pbUpdateSceneMap

    if Input.scroll_v > 0 # Move up
      tile = swatch[layer]
      if tile < 384
        newtile = tileset.terrain_tags.xsize - 8 + (tile / 48)
      elsif tile < 384 + 8
        newtile = (tile - 384) * 48
      else
        newtile = tile - 8
      end
      swatch[layer] = newtile
      doneAny = true
    elsif Input.scroll_v < 0 # Move down
      tile = swatch[layer]
      if tile < 384
        newtile = 384 + (tile / 48)
      else
        newtile = (tile + 8)
        if newtile >= tileset.terrain_tags.xsize
          newtile = 48 * (tile % 8)
        end
      end
      swatch[layer] = newtile
      doneAny = true
    end

    if Input.pressex?(Input::LeftMouseKey) && prevmpos != mousepos && mousepos
      prevmpos = mousepos
      overlaywidth = 128
      overlayheight = (Graphics.height / 2) - 32
      inOverlay = mousepos[0] <= overlaywidth && mousepos[1] <= overlayheight
      selectedTile = false

      if inOverlay
        hoveredTileX = mousepos[0] / 16
        hoveredTileY = mousepos[1] / 16

        target=swatch[layer]
        row = (target - 384) / 8
        if row < 0
          row = -1
        end
        toprow = [row - 5, -1].max

        hoveredRow = toprow + hoveredTileY
        if hoveredRow < 0
          hoveredTile = 48*hoveredTileX
        else
          hoveredTile = 384 + hoveredRow * 8 + hoveredTileX
        end

        if hoveredTile < tileset.terrain_tags.xsize
          selectedTile = true
          if hoveredTile != swatch[layer]
            doneAny = true
            swatch[layer] = hoveredTile
          end
        end
      end

      if !selectedTile
        worldposX = ((mousepos[0] + $game_map.display_x / 4) / 32).floor
        worldposY = ((mousepos[1] + $game_map.display_y / 4) / 32).floor

        swatchToApply = swatch.clone
        if Input.press?(Input::X)
          swatchToApply[layer] += 8 * (worldposY - $game_player.y) + worldposX - $game_player.x
          if swatchToApply[layer] >= tileset.terrain_tags.xsize
            swatchToApply[layer] = swatch[layer]
          end
        end

        if Input.press?(Input::SHIFT)
          3.times do |i|
            if $game_map.data[worldposX,worldposY,i] != swatchToApply[i]
              doneAny = true
              $game_map.data[worldposX,worldposY,i] = swatchToApply[i]
            end
          end
        else
          if $game_map.data[worldposX,worldposY,layer] != swatchToApply[layer]
            doneAny = true
            $game_map.data[worldposX,worldposY,layer] = swatchToApply[layer]
          end
        end
      end
    elsif Input.pressex?(Input::RightMouseKey) && mousepos
      prevmpos = mousepos
      overlaywidth = 128
      overlayheight = (Graphics.height / 2) - 32
      inOverlay = mousepos[0] <= overlaywidth && mousepos[1] <= overlayheight
      selectedTile = false

      if inOverlay
        hoveredTileX = mousepos[0] / 16
        hoveredTileY = mousepos[1] / 16

        target=swatch[layer]
        row = (target - 384) / 8
        if row < 0
          row = -1
        end
        toprow = [row - 5, -1].max

        hoveredRow = toprow + hoveredTileY
        if hoveredRow < 0
          hoveredTile = 48*hoveredTileX
        else
          hoveredTile = 384 + hoveredRow * 8 + hoveredTileX
        end

        if hoveredTile < tileset.terrain_tags.xsize
          selectedTile = true
        end
      end

      if !selectedTile
        worldposX = (mousepos[0] + $game_map.display_x / 4) / 32
        worldposY = (mousepos[1] + $game_map.display_y / 4) / 32
        if Input.press?(Input::SHIFT)
          3.times do |i|
            if swatch[i] != $game_map.data[worldposX,worldposY,i]
              doneAny = true
              swatch[i] = $game_map.data[worldposX,worldposY,i]
            end
          end
        else
          if swatch[layer] != $game_map.data[worldposX,worldposY,layer]
            doneAny = true
            swatch[layer] = $game_map.data[worldposX,worldposY,layer]
          end
        end
      end
    else
      if Input.triggerex?(:TAB)
        layer = (layer + 1) % 3
        layer += 3 if layer < 0
        doneAny = true
      elsif Input.repeat?(Input::L)
        tile = swatch[layer]
        if tile < 384
          newtile = tileset.terrain_tags.xsize - 80 + (tile / 48)
        elsif tile < 384 + 80
          newtile = ((tile - 384) % 8) * 48
        else
          newtile = tile - 80
        end
        swatch[layer] = newtile
        doneAny = true
      elsif Input.repeat?(Input::R)
        tile = swatch[layer]
        if tile < 384
          newtile = 384 + (tile / 48) + 72
        else
          newtile = (tile + 80)
          if newtile >= tileset.terrain_tags.xsize
            newtile = 48 * (tile % 8)
          end
        end
        swatch[layer] = newtile
        doneAny = true
      elsif Input.press?(Input::A) && !Input.press?(Input::SHIFT)
        swatch[layer] = 0
        doneAny = true
      elsif Input.repeat?(Input::LEFT)
        unless $game_player.moving?
          if $game_player.x > 0
            $game_player.direction = 4
            $game_player.x -= 1
          end
        end
        doneAny = true
      elsif Input.repeat?(Input::RIGHT)
        unless $game_player.moving?
          if $game_player.x < $game_map.width - 1
            $game_player.direction = 6
            $game_player.x += 1
          end
        end
        doneAny = true
      elsif Input.repeat?(Input::UP)
        unless $game_player.moving?
          if $game_player.y > 0
            $game_player.direction = 8
            $game_player.y -= 1
          end
        end
        doneAny = true
      elsif Input.repeat?(Input::DOWN)
        unless $game_player.moving?
          if $game_player.y < $game_map.height - 1
            $game_player.direction = 2
            $game_player.y += 1
          end
        end
        doneAny = true
      elsif Input.trigger?(Input::B)
        if Kernel.pbConfirmMessage("Do you want to exit?")
          break
        end
      end
    end
    
    px, py = $game_player.x,$game_player.y

    if doneAny
      newtext = ""
      newtext += "Swatch ["
      newtext += "<b>" if layer == 0
      newtext += "#{swatch[0]}"
      newtext += "</b>" if layer == 0
      newtext += ","
      newtext += "<b>" if layer == 1
      newtext += "#{swatch[1]}"
      newtext += "</b>" if layer == 1
      newtext += ","
      newtext += "<b>" if layer == 2
      newtext += "#{swatch[2]}"
      newtext += "</b>" if layer == 2
      newtext += "]\n"

      newtext += sprintf("(%2d,%2d) [",px,py)
      newtext += "<b>" if layer == 0
      newtext += "#{$game_map.data[px,py,0]}"
      newtext += "</b>" if layer == 0
      newtext += ","
      newtext += "<b>" if layer == 1
      newtext += "#{$game_map.data[px,py,1]}"
      newtext += "</b>" if layer == 1
      newtext += ","
      newtext += "<b>" if layer == 2
      newtext += "#{$game_map.data[px,py,2]}"
      newtext += "</b>" if layer == 2
      newtext += "]"

      infobox.text = newtext
      infobox.resizeToFit(infobox.text,Graphics.width)
      infobox.x = Graphics.width - infobox.width
      infobox.y = Graphics.height - infobox.height
      infobox.visible = true
    end


    overlay.bitmap.clear
    background.bitmap.clear
    target = swatch[layer]
    row = (target - 384) / 8
    if row < 0
      row = -1
    end
    toprow = [row - 5, -1].max

    tilehelper.bltSection(overlay.bitmap,0,0,Rect.new(0,toprow * 32,256,Graphics.height-64))

    tilesize=tileset.terrain_tags.xsize
    for yy in 0...(Graphics.height-64)/32
      ypos=(yy+toprow)*8+384
      next if ypos>=tilesize
      for xx in 0...8
        terr=ypos<384 ? tileset.terrain_tags[xx*48] : tileset.terrain_tags[ypos+xx]
        background.bitmap.fill_rect(xx*32,   yy*32,   16,16,Color.new(128,128,128))
        background.bitmap.fill_rect(xx*32+16,yy*32,   16,16,Color.new(192,192,192))
        background.bitmap.fill_rect(xx*32,   yy*32+16,16,16,Color.new(192,192,192))
        background.bitmap.fill_rect(xx*32+16,yy*32+16,16,16,Color.new(128,128,128))
        if ypos<384
          if target >= 48 && target < 384 && xx == target / 48
            tilehelper.bltTile(overlay.bitmap,xx*32,yy*32,target)
          else
            tilehelper.bltTile(overlay.bitmap,xx*32,yy*32,xx*48)
          end
        end
      end
    end

    if target < 384
      selx = (target / 48) * 32
    else
      selx = (target % 8) * 32
    end

    overlay.bitmap.fill_rect(selx,(row-toprow)*32,32,4,Color.new(255,0,0))
    overlay.bitmap.fill_rect(selx,(row-toprow)*32,4,32,Color.new(255,0,0))
    overlay.bitmap.fill_rect(selx,(row-toprow)*32+28,32,4,Color.new(255,0,0))
    overlay.bitmap.fill_rect(selx+28,(row-toprow)*32,4,32,Color.new(255,0,0))
    if target < 384
      overlay.bitmap.fill_rect(target * 32 / 48,(row-toprow)*32,2,32,Color.new(0,0,255))
    end

    overlay.visible = true
    background.visible = true
  end

  infobox.dispose
  overlay.dispose
  background.dispose
  tilehelper.dispose

  $game_player.through = wasthrough
  for event in $game_map.events.values
    event.unlock
  end

  tlexport($game_map.width, $game_map.height, orig, $game_map.data)
end

# hold D - paint
# S - copy
# A - paste
# arrow keys - move (in edit mode, moves within tileset)
# q/w - move fast in tileset
# shift - toggle edit mode
# tab - change layer
# esc/x - end
# z - set to 0
def tleditor

  palettechars = "ABCDEFGHIJKLMOPQRSTUVWXYZabcdefghjkmopqrstuvwxyz"

  tilesetwrapper=pbTilesetWrapper
  tileset=tilesetwrapper.data[$game_map.map.tileset_id]
  tilehelper=TileDrawingHelper.fromTileset(tileset)
  
  for event in $game_map.events.values
    event.minilock
  end
  wasthrough = $game_player.through
  $game_player.through = true


  viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
  background = BitmapSprite.new(256,Graphics.height-64,viewport)
  background.zoom_x = 0.5
  background.zoom_y = 0.5
  background.z = 99998
  overlay = BitmapSprite.new(256,Graphics.height-64,viewport)
  overlay.zoom_x = 0.5
  overlay.zoom_y = 0.5
  overlay.z = 99999
  infobox = Window_AdvancedTextPokemon.new()
  infobox.visible = false

  doneInitialInit = false
  
  orig = Table.new($game_map.width, $game_map.height, 3)
  $game_map.width.times do |x|
    $game_map.height.times do |y|
      3.times do |l|
        orig[x,y,l] = $game_map.data[x,y,l]
      end
    end
  end
  editmode = false
  layer = 0
  paint = nil
  copy = nil

  loop do
    doneAny = !doneInitialInit
    doneInitialInit = true

    Graphics.update
    Input.update
    pbUpdateSceneMap

    if Input.pressex?(:D)
      unless paint
        doneAny = true
        paint = [layer, $game_map.data[$game_player.x,$game_player.y,layer]]
      end
    else
      if paint
        doneAny = true
        paint = nil
      end
    end

    if Input.trigger?(Input::Y)
      copy = [layer, $game_map.data[$game_player.x,$game_player.y,layer]]
      doneAny = true
    elsif Input.press?(Input::X) && copy
      if $game_map.data[$game_player.x,$game_player.y,copy[0]] != copy[1]
        doneAny = true
        tlset(*copy)
      end
    end

    if Input.trigger?(Input::SHIFT)
      editmode = !editmode
      if editmode
        $game_player.opacity = 60
      else
        $game_player.opacity = 255
      end
      doneAny = true
    elsif Input.triggerex?(:TAB)
      layer = (layer + 1) % 3
      layer += 3 if layer < 0
      doneAny = true
    elsif Input.repeat?(Input::L) && editmode
      tile = $game_map.data[$game_player.x,$game_player.y,layer]
      if tile < 384
        newtile = tileset.terrain_tags.xsize - 80 + (tile / 48)
      elsif tile < 384 + 80
        newtile = ((tile - 384) % 8) * 48
      else
        newtile = tile - 80
      end
      tlset(layer, newtile)
      doneAny = true
    elsif Input.repeat?(Input::R) && editmode
      tile = $game_map.data[$game_player.x,$game_player.y,layer]
      if tile < 384
        newtile = 384 + (tile / 48) + 72
      else
        newtile = (tile + 80)
        if newtile >= tileset.terrain_tags.xsize
          newtile = 48 * (tile % 8)
        end
      end
      tlset(layer, newtile)
      doneAny = true
    elsif Input.press?(Input::A) && !Input.press?(Input::SHIFT) && editmode && !paint
      tlset(layer, 0)
      doneAny = true
    elsif Input.repeat?(Input::LEFT)
      if editmode && !paint
        tile = $game_map.data[$game_player.x,$game_player.y,layer]
        newtile = tile - 1
        if newtile < 0
          newtile += tileset.terrain_tags.xsize
        end
        tlset(layer, newtile)
      else
        unless $game_player.moving?
          if $game_player.x > 0
            $game_player.direction = 4
            $game_player.x -= 1
            tlset(*paint) if paint
          end
        end
      end
      doneAny = true
    elsif Input.repeat?(Input::RIGHT)
      if editmode && !paint
        tile = $game_map.data[$game_player.x,$game_player.y,layer]
        newtile = (tile + 1) % tileset.terrain_tags.xsize
        tlset(layer, newtile)
      else
        unless $game_player.moving?
          if $game_player.x < $game_map.width - 1
            $game_player.direction = 6
            $game_player.x += 1
            tlset(*paint) if paint
          end
        end
      end
      doneAny = true
    elsif Input.repeat?(Input::UP)
      if editmode && !paint
        tile = $game_map.data[$game_player.x,$game_player.y,layer]
        if tile < 384
          newtile = tileset.terrain_tags.xsize - 8 + (tile / 48)
        elsif tile < 384 + 8
          newtile = (tile - 384) * 48
        else
          newtile = tile - 8
        end
        tlset(layer, newtile)
      else
        unless $game_player.moving?
          if $game_player.y > 0
            $game_player.direction = 8
            $game_player.y -= 1
            tlset(*paint) if paint
          end
        end
      end
      doneAny = true
    elsif Input.repeat?(Input::DOWN)
      if editmode && !paint
        tile = $game_map.data[$game_player.x,$game_player.y,layer]
        if tile < 384
          newtile = 384 + (tile / 48)
        else
          newtile = (tile + 8)
          if newtile >= tileset.terrain_tags.xsize
            newtile = 48 * (tile % 8)
          end
        end
        tlset(layer, newtile)
      else
        unless $game_player.moving?
          if $game_player.y < $game_map.height - 1
            $game_player.direction = 2
            $game_player.y += 1
            tlset(*paint) if paint
          end
        end
      end
      doneAny = true
    elsif Input.trigger?(Input::B)
      if Kernel.pbConfirmMessage("Do you want to exit?")
        break
      end
    end

    if doneAny
      px, py = $game_player.x,$game_player.y
      newtext = ""
      newtext += "EDIT\n" if editmode && !paint
      newtext += "PAINT\n" if paint
      if copy
        newtext += "Clip ["
        newtext += "#{copy[1]}" if copy[0] == 0
        newtext += ","
        newtext += "#{copy[1]}" if copy[0] == 1
        newtext += ","
        newtext += "#{copy[1]}" if copy[0] == 2
        newtext += "]\n"
      end
      newtext += "["
      newtext += "<b>" if layer == 0
      newtext += "#{$game_map.data[px,py,0]}"
      newtext += "</b>" if layer == 0
      newtext += ","
      newtext += "<b>" if layer == 1
      newtext += "#{$game_map.data[px,py,1]}"
      newtext += "</b>" if layer == 1
      newtext += ","
      newtext += "<b>" if layer == 2
      newtext += "#{$game_map.data[px,py,2]}"
      newtext += "</b>" if layer == 2
      newtext += sprintf("]\n(%03d,%03d)", px, py)

      infobox.text = newtext
      infobox.resizeToFit(infobox.text,Graphics.width)
      infobox.x = Graphics.width - infobox.width
      infobox.y = Graphics.height - infobox.height
      infobox.visible = true


      if editmode && !paint
        overlay.bitmap.clear
        background.bitmap.clear
        target = $game_map.data[px,py,layer]
        row = (target - 384) / 8
        if row < 0
          row = -1
        end
        toprow = [row - 5, -1].max

        tilehelper.bltSection(overlay.bitmap,0,0,Rect.new(0,toprow * 32,256,Graphics.height-64))

        tilesize=tileset.terrain_tags.xsize
        for yy in 0...(Graphics.height-64)/32
          ypos=(yy+toprow)*8+384
          next if ypos>=tilesize
          for xx in 0...8
            terr=ypos<384 ? tileset.terrain_tags[xx*48] : tileset.terrain_tags[ypos+xx]
            background.bitmap.fill_rect(xx*32,   yy*32,   16,16,Color.new(128,128,128))
            background.bitmap.fill_rect(xx*32+16,yy*32,   16,16,Color.new(192,192,192))
            background.bitmap.fill_rect(xx*32,   yy*32+16,16,16,Color.new(192,192,192))
            background.bitmap.fill_rect(xx*32+16,yy*32+16,16,16,Color.new(128,128,128))
            if ypos<384
              if target >= 48 && target < 384 && xx == target / 48
                tilehelper.bltTile(overlay.bitmap,xx*32,yy*32,target)
              else
                tilehelper.bltTile(overlay.bitmap,xx*32,yy*32,xx*48)
              end
            end
          end
        end

        if target < 384
          selx = (target / 48) * 32
        else
          selx = (target % 8) * 32
        end

        overlay.bitmap.fill_rect(selx,(row-toprow)*32,32,4,Color.new(255,0,0))
        overlay.bitmap.fill_rect(selx,(row-toprow)*32,4,32,Color.new(255,0,0))
        overlay.bitmap.fill_rect(selx,(row-toprow)*32+28,32,4,Color.new(255,0,0))
        overlay.bitmap.fill_rect(selx+28,(row-toprow)*32,4,32,Color.new(255,0,0))
        if target < 384
          overlay.bitmap.fill_rect(target * 32 / 48,(row-toprow)*32,2,32,Color.new(0,0,255))
        end

        overlay.visible = true
        background.visible = true
      else
        overlay.visible = false
        background.visible = false
      end
    end
  end

  if editmode
    $game_player.opacity = 255
  end

  infobox.dispose
  overlay.dispose
  background.dispose
  tilehelper.dispose

  $game_player.through = wasthrough
  for event in $game_map.events.values
    event.unlock
  end
  
  tlexport($game_map.width, $game_map.height, orig, $game_map.data)
end


def tlcombine(map)
  orig = Table.new(map.width, map.height, 3)
  map.width.times do |x|
    map.height.times do |y|
      3.times do |l|
        orig[x,y,l] = map.data[x,y,l]
      end
    end
  end

  yield

  tlexport(map.width, map.height, orig, map.data)
end

class TileDrawingHelper
  def bltSection(bitmap, x, y, rect)
    target = Rect.new(x, y, rect.width, rect.height)
    bitmap.stretch_blt(target,@tileset,rect)
  end
end

class PokemonTilesetScene
  ### MODDED/
  TERRAIN_TAGS = ["None","Ledge","Grass","Sand","Rock","DeepWater","StillWater","Water","Waterfall","WaterfallCrest","TallGrass","UnderwaterGrass","Ice","Neutral","SootGrass","Bridge","Puddle","Grime","PokePuddle","Dummy","DownConveyor","LeftConveyor","RightConveyor","UpConveyor","SandDune","PokeSand","Lava"]
  PASS_BITS = [ # Out of order for better visual grouping
               [1 << 3, "Top Solid"],
               [1 << 0, "Bottom Solid"], 
               [1 << 1, "Left Solid"],
               [1 << 2, "Right Solid"],
               [1 << 6, "Cover Player"],
               [1 << 7, "Interact Past"]]
  ### /MODDED

  def pbUpdateTileset
    @sprites["overlay"].bitmap.clear
    ### MODDED/
    @sprites["background"].bitmap.clear
    @sprites["tileset"].bitmap.clear
    @tilehelper.bltSection(@sprites["tileset"].bitmap,0,0,Rect.new(0,@topy,256,Graphics.height-64))
    # textpos=[]
    ### /MODDED
    tilesize=@tileset.terrain_tags.xsize
    for yy in 0...(Graphics.height-64)/32
      ypos=(yy+(@topy/32))*8+384
      next if ypos>=tilesize
      for xx in 0...8
        terr=ypos<384 ? @tileset.terrain_tags[xx*48] : @tileset.terrain_tags[ypos+xx]
        if ypos<384
          @tilehelper.bltTile(@sprites["overlay"].bitmap,xx*32,yy*32,xx*48)
        end
        ### MODDED/
        @sprites["background"].bitmap.fill_rect(xx*32,   yy*32,   16,16,Color.new(128,128,128))
        @sprites["background"].bitmap.fill_rect(xx*32+16,yy*32,   16,16,Color.new(192,192,192))
        @sprites["background"].bitmap.fill_rect(xx*32,   yy*32+16,16,16,Color.new(192,192,192))
        @sprites["background"].bitmap.fill_rect(xx*32+16,yy*32+16,16,16,Color.new(128,128,128))
        # textpos.push(["#{terr}",xx*32+16,yy*32,2,Color.new(80,80,80),Color.new(192,192,192)])
        ### /MODDED
      end
    end
    @sprites["overlay"].bitmap.fill_rect(@x,@y-@topy,32,4,Color.new(255,0,0))
    @sprites["overlay"].bitmap.fill_rect(@x,@y-@topy,4,32,Color.new(255,0,0))
    @sprites["overlay"].bitmap.fill_rect(@x,@y-@topy+28,32,4,Color.new(255,0,0))
    @sprites["overlay"].bitmap.fill_rect(@x+28,@y-@topy,4,32,Color.new(255,0,0))
    ### MODDED/
    selected = pbGetSelected(@x, @y)
    if selected >= tilesize
      @sprites["tilesetinfo"].visible = false
    else
      @sprites["tilesetinfo"].visible = true
      tag = @tileset.terrain_tags[selected]
      pass = @tileset.passages[selected]
      pri = @tileset.priorities[selected]
      desc = "Tile #{pbGetSelected(@x, @y)}\n#{PokemonTilesetScene::TERRAIN_TAGS[tag]}\n"
      if selected >= 384
        desc += "#{pbPassDesc(pass)}\n#{pri}"
      else
        desc += "\n\n" # Autotile terrain tags aren't our purview
      end
      @sprites["tilesetinfo"].text=desc
      @sprites["tilesetinfo"].resizeToFit(@sprites["tilesetinfo"].text,Graphics.width)
      @sprites["tilesetinfo"].x = Graphics.width - @sprites["tilesetinfo"].width
      @sprites["tilesetinfo"].y = Graphics.height - @sprites["tilesetinfo"].height
    end
    # pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)
    ### /MODDED
  end

  ### MODDED/
  def pbGetHeight
    size = @tileset.terrain_tags.xsize
    if size < 384
      return 32
    else
      return (size - 352) * 32 / 8
    end
  end

  def pbSelect(target)
    selected=nil
    selected=pbGetSelected(@x,@y) if defined?(@x) && defined?(@y)
    if target != selected
      if target < 384
        @topy = -32
        @y = -32
        @x = 32 * (target/48)
      else
        row = (target - 384) / 8
        toprow = [row - 5, 0].max
        @topy = 32 * toprow
        @y = 32 * row
        @x = (target % 8) * 32
      end
    end
  end

  def pbPassDesc(pass)
    passbits = pass & 0b1111
    if passbits == 0
      desc = 'O'
    elsif passbits == 0b1111
      desc = 'X'
    else
      desc = ''
      desc += '<' if (passbits & 0b0010) == 0
      desc += '^' if (passbits & 0b1000) == 0
      desc += 'v' if (passbits & 0b0001) == 0
      desc += '>' if (passbits & 0b0100) == 0
    end

    
    desc += ' #' if pass & 0x40 != 0
    desc += ' |' if pass & 0x80 != 0
    
    return desc
  end
  ### /MODDED

  def pbGetSelected(x,y)
    if y<0
      return 48*(x/32)
    else
      return (y/32)*8+384+(x/32)
    end
  end

  def pbSetSelected(i,value)
    if i<384
      for j in 0...48
        @tileset.terrain_tags[i+j]=value
      end
    else
      @tileset.terrain_tags[i]=value
    end
  end

  def pbChooseTileset
    commands=[]
    for i in 1...@tilesetwrapper.data.length
      commands.push(sprintf("%03d %s",i,@tilesetwrapper.data[i].name))
    end
    ### MODDED/
    ret=Kernel.pbShowCommands(nil,commands,-1,@tileset.id-1)
    ### /MODDED
    if ret>=0
      @tileset=@tilesetwrapper.data[ret+1]
      @tilehelper.dispose
      @tilehelper=TileDrawingHelper.fromTileset(@tileset)
      ### MODDED/
      # @sprites["tileset"].setBitmap("Graphics/Tilesets/#{@tileset.tileset_name}")
      ### /MODDED
      @x=0
      @y=-32
      @topy=-32
      pbUpdateTileset
    end
  end

  def pbStartScene
    ### MODDED/
    madeChanges = false
    ### /MODDED
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @tilesetwrapper=pbTilesetWrapper
    @tileset=@tilesetwrapper.data[$game_map.map.tileset_id]
    @tilehelper=TileDrawingHelper.fromTileset(@tileset)
    @sprites={}
    ### MODDED/
    @sprites["background"]=BitmapSprite.new(256,Graphics.height-64, @viewport)
    @sprites["background"].x=0
    @sprites["background"].y=64
    @sprites["background"].viewport=@viewport
    @sprites["background"].visible = true

    @sprites["tilesetinfo"]=Window_UnformattedTextPokemon.new(_INTL(""))
    @sprites["tilesetinfo"].viewport=@viewport
    @sprites["tilesetinfo"].x=Graphics.width
    @sprites["tilesetinfo"].y=0
    ### /MODDED
    @sprites["title"]=Window_UnformattedTextPokemon.new(_INTL("Q/W: SCROLL; C: EDIT, A: JUMP, S: MENU"))
    @sprites["title"].viewport=@viewport
    @sprites["title"].x=0
    @sprites["title"].y=0
    @sprites["title"].width=Graphics.width
    @sprites["title"].height=64
    ### MODDED/
    # @sprites["tileset"]=IconSprite.new(0,64,@viewport)
    # @sprites["tileset"].setBitmap("Graphics/Tilesets/#{@tileset.tileset_name}")
    # @sprites["tileset"].src_rect=Rect.new(0,0,256,Graphics.height-64)
    @sprites["tileset"]=BitmapSprite.new(256,Graphics.height-64,@viewport)
    @sprites["tileset"].x=0
    @sprites["tileset"].y=64
    ### /MODDED
    @sprites["overlay"]=BitmapSprite.new(256,Graphics.height-64,@viewport)
    @sprites["overlay"].x=0
    @sprites["overlay"].y=64
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["title"].visible=true
    ### MODDED/
    # @sprites["tileset"].visible=true
    @sprites["tilesetinfo"].visible=true
    ### /MODDED
    @sprites["overlay"].visible=true
    ### MODDED/
    @x=0 if !defined?(@x)
    @y=-32 if !defined?(@y)
    @topy=-32 if !defined?(@topy)
    ### /MODDED
    pbUpdateTileset
    pbFadeInAndShow(@sprites)
    ### MODDED/
    height=pbGetHeight
    ### /MODDED
    ########
    loop do
      Graphics.update
      Input.update
      if Input.repeat?(Input::UP)
        @y-=32
        ### MODDED/
        if @y<-32
          @y=height-32
          @topy=@y-(Graphics.height-64)+32 if @y-@topy>=Graphics.height-64
        else
          @topy=@y if @y<@topy
        end
        ### /MODDED
        pbUpdateTileset
      elsif Input.repeat?(Input::DOWN)
        @y+=32
        ### MODDED/
        if @y>height-32
          @y=-32
          @topy=@y if @y<@topy
        else
          @y=height-32 if @y>=height-32
          @topy=@y-(Graphics.height-64)+32 if @y-@topy>=Graphics.height-64
        end
        ### /MODDED
        pbUpdateTileset
      elsif Input.repeat?(Input::LEFT)
        @x-=32
        ### MODDED/
        @x+=256 if @x<0
        ### /MODDED
        pbUpdateTileset
      elsif Input.repeat?(Input::RIGHT)
        @x+=32
        ### MODDED/
        @x-=256 if @x>=256
        ### /MODDED
        pbUpdateTileset
      elsif Input.repeat?(Input::L)
        @y-=((Graphics.height-64)/32)*32
        @topy-=((Graphics.height-64)/32)*32
        @y=-32 if @y<-32
        @topy=@y if @y<@topy
        @topy=-32 if @topy<-32
        pbUpdateTileset
      elsif Input.repeat?(Input::R)
        @y+=((Graphics.height-64)/32)*32
        @topy+=((Graphics.height-64)/32)*32
        ### MODDED/
        @y=height-32 if @y>=height-32
        ### /MODDED
        @topy=@y-(Graphics.height-64)+32 if @y-@topy>=Graphics.height-64
        ### MODDED/
        @topy=height-(Graphics.height-64) if @topy>=height-(Graphics.height-64)
        ### /MODDED
        pbUpdateTileset
      ### MODDED/
      elsif Input.trigger?(Input::X)
        selected=pbGetSelected(@x,@y)
        params=ChooseNumberParams.new
        params.setRange(0,@tileset.terrain_tags.xsize)
        params.setDefaultValue(selected)

        @sprites["tilesetinfo"].visible=false
        pbSelect(Kernel.pbMessageChooseNumber(
           _INTL("Jump to?"),params
        ))
        @sprites["tilesetinfo"].visible=true
        pbUpdateTileset
      elsif Input.trigger?(Input::Y)
      ### /MODDED
        commands=[
           _INTL("Find next"),
           _INTL("Go to top"),
           _INTL("Change tileset"),
           _INTL("Cancel")
        ]
        ret=Kernel.pbShowCommands(nil,commands,-1)
        case ret
          when 0
            ### MODDED/
            startpos = selected = pbGetSelected(@x, @y)
            type = Kernel.pbShowCommands(nil,PokemonTilesetScene::TERRAIN_TAGS, -1, @tileset.terrain_tags[selected])
            if type >= 0
              begin
                if selected < 384
                  selected = ((selected / 48) + 1) * 48 # Intentionally clamps via int math
                  selected = 384 if selected > 384
                else
                  selected += 1
                  selected = 0 if selected > @tileset.terrain_tags.xsize
                end
              end while selected != startpos && @tileset.terrain_tags[selected] != type
              pbSelect(selected)
              pbUpdateTileset
            end
            ### MODDED/
          when 1
            @y=-32
            @topy=@y if @y<@topy
            pbUpdateTileset
          when 2
            pbChooseTileset
            ### MODDED/
            height=pbGetHeight
            ### /MODDED
        end
      elsif Input.trigger?(Input::B)
        ### MODDED/
        @sprites["tilesetinfo"].visible=false
        if madeChanges && Kernel.pbConfirmMessage(_INTL("Save changes?"))
          ### /MODDED
          @tilesetwrapper.save
          $cache.cacheTilesets
          if $game_map && $MapFactory
            $MapFactory.setup($game_map.map_id)
            $game_player.center($game_player.x,$game_player.y)
            if $scene.is_a?(Scene_Map)
              $scene.disposeSpritesets
              $scene.createSpritesets
            end
          end
          Kernel.pbMessage(_INTL("To ensure that the changes remain, close and reopen RPG Maker XP."))
        end
        break if Kernel.pbConfirmMessage(_INTL("Exit from the editor?"))
        ### MODDED/
        @sprites["tilesetinfo"].visible=true
        ### /MODDED
      elsif Input.trigger?(Input::C)
        selected=pbGetSelected(@x,@y)
        ### MODDED/
        option = 0
        while option >= 0
          passtxt = ""
          
          tag = @tileset.terrain_tags[selected]
          pass = @tileset.passages[selected]
          pri = @tileset.priorities[selected]

          anychange = tag != @tileset.terrain_tags[selected] || pass != @tileset.passages[selected] || pri != @tileset.priorities[selected]

          @sprites["tilesetinfo"].visible=false
          if selected < 384
            newvalue = Kernel.pbShowCommands(nil, PokemonTilesetScene::TERRAIN_TAGS, -1, tag)
            if newvalue != tag
              pbSetSelected(selected, newvalue)
              madeChanges = true
            end
          else
            option = Kernel.pbShowCommandsWithHelp(nil, 
              ["Terrain Tag", "Passability", "Priority", anychange ? "Cancel" : "Save"], 
              ["Current value: #{PokemonTilesetScene::TERRAIN_TAGS[tag]}",
               "Current value: #{pbPassDesc(pass)}",
               "Current value: #{pri}", nil], -1, option)
            case option
            when 0 # Terrain Tag
              newvalue = Kernel.pbShowCommands(nil, PokemonTilesetScene::TERRAIN_TAGS, -1, tag)
              tag = newvalue if newvalue >= 0
            when 1 # Passability
              suboption = 0
              while suboption != -1
                commands = PokemonTilesetScene::PASS_BITS.map { |bit, desc, ch| "#{(bit & pass != 0) ? '> ' : '    '}#{desc}"}
                suboption = Kernel.pbShowCommands(nil, commands, -1, suboption)
                if suboption != -1
                  pass = pass ^ PokemonTilesetScene::PASS_BITS[suboption][0]
                end
              end
            when 2 # Priority
              params=ChooseNumberParams.new
              params.setRange(0,5)
              params.setDefaultValue(pri)
              pri = Kernel.pbMessageChooseNumber(
                 _INTL("Set tile priority."),params
              )
            when 3 # Save/Cancel
              if anychange && Kernel.pbConfirmMessage("Set tile properties?")
                pbSetSelected(selected, tag)
                @tileset.passages[selected] = pass
                @tileset.priorities[selected] = pri
                madeChanges = true
              end
              break
            when -1 # Cancel
              option = 3 if anychange && !Kernel.pbConfirmMessage("Discard changes to tile #{selected}?")
            end
          end
        end
        @sprites["tilesetinfo"].visible=true
        ### /MODDED
      end
    end
    ########
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @tilehelper.dispose
  end
end
