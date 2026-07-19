class PokeBattle_Battle
  attr_accessor :speedup_spedup

  alias :speedup_old_initialize :initialize

  def initialize(*args,**kwargs)
    if !$speed_up
      Graphics.toggleTurbo
      @speedup_spedup = true
    end
    return speedup_old_initialize(*args, **kwargs)
  end

  alias :speedup_old_pbEndOfBattle :pbEndOfBattle

  def pbEndOfBattle(*args, **kwargs)
    if @speedup_spedup
      Graphics.toggleTurbo
      @speedup_spedup = false
    end
    return speedup_old_pbEndOfBattle(*args, **kwargs)
  end

end
