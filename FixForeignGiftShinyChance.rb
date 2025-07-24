class PokeBattle_Pokemon
  alias :foreigngiftshiny_old_trainerIDSet :trainerID=

  def trainerID=(value)
    makeShiny if isShiny? && !@shinyflag && value != @trainerID
    foreigngiftshiny_old_trainerIDSet(value)
  end
end
