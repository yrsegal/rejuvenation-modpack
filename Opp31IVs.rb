Switches[:Opp31IVs] = 1789 # Reserving

PASSWORD_HASH["opp31ivs"] = :Opp31IVs

alias :opp31ivs_old_pbLoadTrainer :pbLoadTrainer

def pbLoadTrainer(*args)
  opponent, items, party = opp31ivs_old_pbLoadTrainer(*args)
  if $game_switches[:Opp31IVs]
    for pkmn in party
      pokemon.iv.map! {|value| [31,value].max}
    end
  end
  return [opponent, items, party]
end

# optional mod integration with PasswordOptions
class Game_System
  alias :opp31ivs_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = opp31ivs_old_initialize(*args, **kwargs)
    if defined?(ModPasswordOptions)
      ModPasswordOptions::PASSWORD_DESCRIPTIONS["opp31ivs"] = ["Enemy Max IVs", "All opponents have 31 IVs in all stats."]
    end
    return ret
  end
end
