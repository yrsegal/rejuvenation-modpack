

# based on https://github.com/mrtenda/voltorbflipdotcom
class VoltorbFlip

  VOLTORBFLIPHELPER_DIR = "Graphics/Pictures/VoltorbFlipExtras"

  def voltorbfliphelper_analysisMarkings

    analysis = boardAnalysis
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
    @startedVF = true
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
    voltorbfliphelper_update if @startedVF
  end

  alias :voltorbfliphelper_old_pbShowAndDispose :pbShowAndDispose

  def pbShowAndDispose
    @sprites["voltorbfliphelper_mark2"].bitmap.clear
    @sprites["voltorbfliphelper_mark2"].visible = false
    voltorbfliphelper_old_pbShowAndDispose
  end
end
