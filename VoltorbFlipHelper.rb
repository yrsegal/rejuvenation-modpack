begin
  missing = ['VoltorbFlipExtras.png'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

# based on https://github.com/mrtenda/voltorbflipdotcom

class VoltorbFlip

  Voltorbfliphelper_LineTotal = Struct.new('LineTotal', :totalPoints, :totalVoltorbs)
  Voltorbfliphelper_LineData = Struct.new('LineData', :remainingPoints, :remainingVoltorbs, :unsolvedTiles, :unimportantTiles)

  VOLTORBFLIPHELPER_DIR = __dir__[Dir.pwd.length+1..] + "/VoltorbFlipExtras"

  def voltorbfliphelper_analysisMarkings
    analysis = voltorbfliphelper_analysis
    if !defined?(@voltorbfliphelper_lastanalysis) || @voltorbfliphelper_lastanalysis != analysis
      markings = analysis.each_with_index.map { |it, idx|
        if @squares[idx][3] # flipped
          next @voltorbfliphelper_lastmarkings[idx] if defined?(@voltorbfliphelper_lastmarkings)
          next nil
        end

        x = idx%5
        y = idx/5

        solved = it.one?

        next [VOLTORBFLIPHELPER_DIR,x*64+128,y*64,  0,0,64,64] if solved && it[0]
        next [VOLTORBFLIPHELPER_DIR,x*64+128,y*64, 64,0,64,64] if solved && it[1]
        next [VOLTORBFLIPHELPER_DIR,x*64+128,y*64,128,0,64,64] if !it[0]
        next [VOLTORBFLIPHELPER_DIR,x*64+128,y*64,192,0,64,64] if it == [true,  true, false, false]
        next nil
      }

      @voltorbfliphelper_lastanalysis = analysis
      @voltorbfliphelper_lastmarkings = markings
      return markings.compact
    end

    return nil
  end

  def voltorbfliphelper_analysis
    squareData = []

    rows = Array.new(5) { |row| 
      Enumerator.new do |y|
        for col in 0...5
          y << squareData[5 * row + col]
        end
      end
    }

    cols = Array.new(5) { |col| 
      Enumerator.new do |y|
        for row in 0...5
          y << squareData[5 * row + col]
        end
      end
    }

    rowTotals = Array.new(5) { Voltorbfliphelper_LineTotal.new(0, 0) }
    colTotals = Array.new(5) { Voltorbfliphelper_LineTotal.new(0, 0) }

    for row in 0...5
      for col in 0...5
        idx = row * 5 + col
        xpos, ypos, square, flipped = @squares[idx]
        voltorb = square == 0

        if flipped
          squareData[idx] = [false, false, false, false]
          squareData[idx][square] = true
        else
          squareData[idx] = [true, true, true, true]
        end

        rowTotal = rowTotals[row]
        colTotal = colTotals[col]

        rowTotal.totalPoints += square
        rowTotal.totalVoltorbs += 1 if voltorb

        colTotal.totalPoints += square
        colTotal.totalVoltorbs += 1 if voltorb
      end
    end


    loop do
      rowDatas = Array.new(5) { |i| Voltorbfliphelper_LineData.new(rowTotals[i].totalPoints, rowTotals[i].totalVoltorbs, 0, 0) }
      colDatas = Array.new(5) { |i| Voltorbfliphelper_LineData.new(colTotals[i].totalPoints, colTotals[i].totalVoltorbs, 0, 0) }

      for row in 0...5
        for col in 0...5

          idx = row * 5 + col
          sqdata = squareData[idx]

          rowData = rowDatas[row]
          colData = colDatas[col]
          if sqdata.one? # Solved
            square = sqdata.index(true)
            voltorb = square == 0

            rowData.remainingPoints -= square
            rowData.remainingVoltorbs -= 1 if voltorb

            colData.remainingPoints -= square
            colData.remainingVoltorbs -= 1 if voltorb
          else
            rowData.unsolvedTiles += 1
            rowData.unimportantTiles += 1 if sqdata == [true, true, false, false]
            colData.unsolvedTiles += 1
            colData.unimportantTiles += 1 if sqdata == [true, true, false, false]
          end
        end
      end

      anyUpdate = false

      for rowIdx in 0...5
        row = rows[rowIdx]
        rowData = rowDatas[rowIdx]
        next if rowData.unsolvedTiles == 0 # no unsolved tiles left

        anyUpdate = voltorbfliphelper_runheuristics(rowData, row)
        break if anyUpdate
      end

      next if anyUpdate

      for colIdx in 0...5
        col = cols[colIdx]
        colData = colDatas[colIdx]
        next if colData.unsolvedTiles == 0 # no unsolved tiles left

        anyUpdate = voltorbfliphelper_runheuristics(colData, col)
        break if anyUpdate
      end

      @lastrowDatas = rowDatas
      @lastcolDatas = colDatas
      return squareData unless anyUpdate
    end
  end

  def voltorbfliphelper_runheuristics(lineData, line)
    return (
      voltorbfliphelper_heuristic0(lineData, line) || 
      voltorbfliphelper_heuristic1(lineData, line) || 
      voltorbfliphelper_heuristic2(lineData, line) || 
      voltorbfliphelper_heuristic3(lineData, line) || 
      voltorbfliphelper_heuristic4(lineData, line) || 
      voltorbfliphelper_heuristic5(lineData, line) || 
      voltorbfliphelper_heuristic6(lineData, line) || 
      voltorbfliphelper_heuristic7(lineData, line) || 
      voltorbfliphelper_heuristic8(lineData, line) || 
      voltorbfliphelper_heuristic9(lineData, line))
  end

  # Heuristic #0 - If RemainingVoltorbs + RemainingPoints == NumUnsolvedTiles, eliminate all possibilities except V and 1 from unsolved tiles
  def voltorbfliphelper_heuristic0(lineData, line)
    return false if lineData.remainingVoltorbs + lineData.remainingPoints != lineData.unsolvedTiles

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true if tile[2] || tile[3]
        tile[2] = false
        tile[3] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #1 - If NumUnsolvedTiles - RemainingVoltorbs == RemainingPoints - 1, remove 3 as a possible option
  def voltorbfliphelper_heuristic1(lineData, line)
    return false if lineData.unsolvedTiles - lineData.remainingVoltorbs != lineData.remainingPoints - 1

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true if tile[3]
        tile[3] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #2 - If RemainingVoltorbs == 0, eliminate any possible voltorbs
  def voltorbfliphelper_heuristic2(lineData, line)
    return false if lineData.remainingVoltorbs != 0

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true if tile[0]
        tile[0] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #3 - If NumUnsolvedTiles - 1 == RemainingVoltorbs, mark all tiles as either voltorbs or tiles with a value of RemainingPoints
  def voltorbfliphelper_heuristic3(lineData, line)
    return false if lineData.unsolvedTiles - 1 != lineData.remainingVoltorbs

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        for value in 1..3
          next if lineData.remainingPoints == value
          anyUpdate = true if tile[value]
          tile[value] = false
        end
      end
    end
    return anyUpdate
  end

  # Heuristic #4 - If (NumUnsolvedTiles - RemainingVoltorbs) <= ((RemainingPoints + 1)/3), eliminate 1 as a possibility from all tiles
  def voltorbfliphelper_heuristic4(lineData, line)
    return false if (lineData.unsolvedTiles - lineData.remainingVoltorbs) > ((lineData.remainingPoints + 1) / 3)

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true if tile[1]
        tile[1] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #5 - If RemainingVoltorbs == 0 and RemainingPoints = NumUnsolvedTiles, mark all unsolved tiles as definitely 1s
  def voltorbfliphelper_heuristic5(lineData, line)
    return false if !((lineData.remainingVoltorbs == 0) && (lineData.remainingPoints == lineData.unsolvedTiles))

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true
        tile[0] = false
        tile[1] = true
        tile[2] = false
        tile[3] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #6 - If RemainingVoltorbs == NumUnsolvedTiles, mark all unsolved tiles as definitely voltorbs
  def voltorbfliphelper_heuristic6(lineData, line)
    return false if lineData.remainingVoltorbs != lineData.unsolvedTiles

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true
        tile[0] = true
        tile[1] = false
        tile[2] = false
        tile[3] = false
      end
    end
    return anyUpdate
  end

  # Heuristic #7 - If NumUnsolvedTiles == 1, fill in the single unsolved tile using RemainingPoints
  def voltorbfliphelper_heuristic7(lineData, line)
    return false if lineData.unsolvedTiles != 1 || lineData.remainingPoints > 3 # points > 3 is not possible, so to avoid a panic

    for tile in line
      unless tile.one? # Solved
        for value in 0..3
          tile[value] = (value == lineData.remainingPoints)
        end
        return true
      end
    end
    return false
  end

  # Heuristic #8 - If RemainingPoints == NumUnsolvedTiles*3, mark all unknowns as definitely 3s
  def voltorbfliphelper_heuristic8(lineData, line)
    return false if lineData.remainingPoints != lineData.unsolvedTiles * 3

    anyUpdate = false
    for tile in line
      unless tile.one? # Solved
        anyUpdate = true
        tile[0] = false
        tile[1] = false
        tile[2] = false
        tile[3] = true
      end
    end

    return anyUpdate
  end

  ### Wire's custom heuristics

  # Heuristic #9 - If (NumUnsolvedTiles - NumUnimportantTiles) <= ((RemainingPoints + 1)/3), eliminate voltorb as a possibility from all important tiles
  def voltorbfliphelper_heuristic9(lineData, line)
    return false if (lineData.unsolvedTiles - lineData.unimportantTiles) > ((lineData.remainingPoints - lineData.unimportantTiles + lineData.remainingVoltorbs + 1) / 3)

    anyUpdate = false
    for tile in line
      unless tile.one? || tile == [true, true, false, false] # Solved
        anyUpdate = true if tile[0]
        tile[0] = false
      end
    end
    return anyUpdate
  end

  def voltorbfliphelper_update
    markings = voltorbfliphelper_analysisMarkings
    if markings
      @sprites["voltorbfliphelper_mark2"].bitmap.clear
      pbDrawImagePositions(@sprites["voltorbfliphelper_mark2"].bitmap,markings)
    end
  end

  alias :voltorbfliphelper_old_pbCreateSprites :pbCreateSprites

  def pbCreateSprites
    voltorbfliphelper_old_pbCreateSprites
    @sprites["voltorbfliphelper_mark2"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["voltorbfliphelper_mark2"].visible = false
    pbDrawImagePositions(@sprites["bg"].bitmap,[[VOLTORBFLIPHELPER_DIR,448,320,256,0,64,64]])
  end

  alias :voltorbfliphelper_old_pbNewGame :pbNewGame

  def pbNewGame
    voltorbfliphelper_old_pbNewGame
    @sprites["voltorbfliphelper_mark2"].visible = false
    voltorbfliphelper_update
  end

  alias :voltorbfliphelper_old_getInput :getInput

  def getInput
    if Input.trigger?(Input::A) && !Input.press?(Input::SHIFT) && !@sprites["voltorbfliphelper_mark2"].visible
      if Kernel.pbConfirmMessage(_INTL("Do you want to turn on Voltorb Hints?"))
        @sprites["voltorbfliphelper_mark2"].visible = true
      end
    end
    voltorbfliphelper_old_getInput
  end

  alias :voltorbfliphelper_old_pbUpdateCoins :pbUpdateCoins

  def pbUpdateCoins
    voltorbfliphelper_old_pbUpdateCoins
    voltorbfliphelper_update
  end

  alias :voltorbfliphelper_old_pbShowAndDispose :pbShowAndDispose

  def pbShowAndDispose
    @sprites["voltorbfliphelper_mark2"].bitmap.clear
    @sprites["voltorbfliphelper_mark2"].visible = false
    voltorbfliphelper_old_pbShowAndDispose
  end
end
