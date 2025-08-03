class PokeBattle_Pokemon
  ### MODDED/ add parameter
  def makeUnultra(startform = self.originalForm)
    self.form=startform
  ### /MODDED
    self.ability = self.originalAbility if self.originalAbility
    self.originalAbility = nil
    self.originalForm = nil
  end
end
