class PokeBattle_Battler
  alias :primalreversion_old_pbUpdate :pbUpdate
  def pbUpdate(fullchange=false)
    primalreversion_old_pbUpdate(fullchange)
    if @pokemon && fullchange
      @form = @pokemon.form
    end
  end

  # Fixes grassy interaction
  def setField(*args, **kwargs)
    @battle.setField(*args, **kwargs)
  end
end

class PokemonScreen
  def pbGiveItem(item,pkmn,pkmnid=0)
    thisitemname=getItemName(item)
    if pkmn.isEgg?
      pbDisplay(_INTL("Eggs can't hold items."))
      return false
    end
    if pkmn.mail
      pbDisplay(_INTL("Mail must be removed before holding an item."))
      return false
    end
    ### MODDED/ Disable can't be held messages which are unneeded
    # if thisitemname == "Blue Orb"
    #   pbDisplay(_INTL("The Blue Orb can't be held!"))
    #   return false if pkmn.species != :KYOGRE
    # end
    # if thisitemname == "Red Orb"
    #   pbDisplay(_INTL("The Red Orb can't be held!"))
    #   return false if pkmn.species != :GROUDON
    # end
    ### /MODDED
    if pkmn.item
      itemname=getItemName(pkmn.item)
      pbDisplay(_INTL("{1} is already holding one {2}.\1",pkmn.name,itemname))
      if pbConfirm(_INTL("Would you like to switch the two items?"))
        $PokemonBag.pbDeleteItem(item)
        if !$PokemonBag.pbStoreItem(pkmn.item)
          if !$PokemonBag.pbStoreItem(item) # Compensate
            raise _INTL("Can't re-store deleted item in bag")
          end
          pbDisplay(_INTL("The Bag is full.  The Pokémon's item could not be removed."))
        else
          if pbIsMail?(item)
            if pbMailScreen(item,pkmn,pkmnid)
              pkmn.setItem(item)
              pbDisplay(_INTL("The {1} was taken and replaced with the {2}.",itemname,thisitemname))
              return true
            else
              if !$PokemonBag.pbStoreItem(item) # Compensate
                raise _INTL("Can't re-store deleted item in bag")
              end
            end
          else
            pkmn.setItem(item)
            pbDisplay(_INTL("The {1} was taken and replaced with the {2}.",itemname,thisitemname))
            check = pkmn.form
            pkmn.form = pkmn.getForm(pkmn)
            if check != pkmn.form
              if pkmn.getAbilityList.length > 1
                if pkmn.getAbilityList.include?(pkmn.originalAbility)
                  pkmn.ability = pkmn.originalAbility
                  pkmn.originalAbility = nil
                else
                  pkmn.initAbility
                end
              else
                pkmn.originalAbility = pkmn.originalAbility.nil? ? pkmn.ability : nil
                pkmn.initAbility
              end
            end
            return true
          end
        end
      end
    else
      if !pbIsMail?(item) || pbMailScreen(item,pkmn,pkmnid) # Open the mail screen if necessary
        $PokemonBag.pbDeleteItem(item)
        pkmn.setItem(item)
        pbDisplay(_INTL("{1} was given the {2} to hold.",pkmn.name,thisitemname))
        check = pkmn.form
        pkmn.form = pkmn.getForm(pkmn)
        if check != pkmn.form
          if pkmn.getAbilityList.length > 1
            if pkmn.getAbilityList.include?(pkmn.originalAbility)
              pkmn.ability = pkmn.originalAbility
              pkmn.originalAbility = nil
            else
              pkmn.initAbility
            end
          else
            pkmn.originalAbility = pkmn.originalAbility.nil? ? pkmn.ability : nil
            pkmn.initAbility
          end
        end
        return true
      end
    end
    return false
  end
end
