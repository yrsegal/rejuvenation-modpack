# Now, you might ask - Why fix this crash if you can't get Rayquaza?
# Sometimes you just want to use Rayquaza in a silly challenge run WITHOUT IT CRASHING.

class PokeBattle_Pokemon
  def isMega?
    v = $cache.pkmn[@species].formData.dig(:MegaForm)
    v = $cache.pkmn[@species].formData.dig(:PulseForm) if (Reborn && !v)
    v = $cache.pkmn[@species].formData.dig(:RiftForm) if (Rejuv && !v)
    ### MODDED/ add v.is_a?(Hash) to make rayquaza not crash
    v.values.each{|a| v=a if a.is_a?(Hash)} if v && v.is_a?(Hash) # filter for nested hashes aka Urshifu (if there is ever a mon with more than 1 megastone and a nested hash this needs rewriting)
    ### /MODDED
    return true if v.is_a?(Hash) && v.values.include?(self.form)
    return false if v.is_a?(Hash)
    return v!=nil && self.form >= v
  end

  def hasMegaForm?
    #check for forms
    v = $cache.pkmn[@species].formData.dig(:MegaForm)
    v = $cache.pkmn[@species].formData.dig(:PulseForm) if (Reborn && !v)
    #v = $cache.pkmn[@species].formData.dig(:RiftForm) if (Rejuv && !v)
    return false if !v
    # check if current species form *can* Mega
    if !self.isMega? # don't do this check if you are already a Mega
      k = $cache.pkmn[@species].formData.dig(:DefaultForm)
      if k.is_a?(Array)
        return false if !k.include?(@form)
      else
        return false if k != @form
      end 
    end
    #check if conditions are met
    if @species==:RAYQUAZA && !pbIsZCrystal?(@item)
      for i in @moves
        ### MODDED/ replace i.id with i.move
         return true if i.move==:DRAGONASCENT
        ### /MODDED
      end
    end
    ### MODDED/ add v.is_a?(Hash) to make rayquaza not crash
    return v.is_a?(Hash) && v.keys.include?(@item)
    ### /MODDED
  end
end
