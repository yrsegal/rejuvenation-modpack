
class PokeBattle_Pokemon
  if !defined?(relearnPreShadowMoves_old_adjustHeart)
    alias :relearnPreShadowMoves_old_adjustHeart :adjustHeart
  end

  def adjustHeart(*args, **kwargs)
    ret = relearnPreShadowMoves_old_adjustHeart(*args, **kwargs)
    pbUpdateShadowMoves() if @shadow
    return ret
  end
end
