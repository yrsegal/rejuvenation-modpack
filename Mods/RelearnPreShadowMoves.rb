
class PokeBattle_Pokemon
  alias :relearnPreShadowMoves_old_adjustHeart :adjustHeart

  def adjustHeart(*args, **kwargs)
    ret = relearnPreShadowMoves_old_adjustHeart(*args, **kwargs)
    pbUpdateShadowMoves() if @shadow
    return ret
  end
end
