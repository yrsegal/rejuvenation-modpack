class PokeBattle_Pokemon
  alias :foreigngiftshiny_old_trainerIDSet :trainerID=

  def trainerID=(value)
    lowNewTID = value & 0xFFFF
    highNewTID = (value >> 16) & 0xFFFF

    lowOldTID = @trainerID & 0xFFFF
    highOldTID = (@trainerID >> 16) & 0xFFFF

    @personalID ^= (highOldTID ^ lowOldTID ^ highNewTID ^ lowNewTID) << 16

    foreigngiftshiny_old_trainerIDSet(value)
    
    calcStats
  end
end
