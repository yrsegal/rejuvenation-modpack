
alias :fixHisuian_old_getEvolutionForm :getEvolutionForm

def getEvolutionForm(mon,item=nil)
  species = mon.species
  form = fixHisuian_old_getEvolutionForm(mon,item)
  case species
  when :QWILFISH # Overqwil
    return 0
  when :SNEASEL # Sneasler (Weavile has no forms so it's fine)
    return 0
  when :BASCULIN # Basculegion (this is the big one!)
    return 0
  else return form
  end
end
