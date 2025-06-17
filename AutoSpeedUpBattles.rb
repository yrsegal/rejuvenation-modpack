class PokeBattle_Battle
  attr_accessor :speedup_spedup

  alias :speedup_old_initialize :initialize

  def initialize(*args,**kwargs)
    @speedup_spedup = Graphics.frame_rate != 40
    Graphics.frame_rate=200
    $speed_up = true
    return speedup_old_initialize(*args, **kwargs)
  end

  alias :speedup_old_pbEndOfBattle :pbEndOfBattle

  def pbEndOfBattle(*args, **kwargs)
    if @speedup_spedup
      Graphics.frame_rate=200
      $speed_up = true
    else
      Graphics.frame_rate=40
      $speed_up = false
    end
    return speedup_old_pbEndOfBattle(*args, **kwargs)
  end

end
