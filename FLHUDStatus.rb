class Spriteset_Map
  class HUD

    def flhudstatus_tone(tone, status)
      case status
        when :POISON
          tone.set(50,-50,50,0)
        when :PARALYSIS
          tone.set(50,50,-50,0)
        when :BURN
          tone.set(50,-50,-50,0)
        when :SLEEP
          tone.set(-25,-25,-25,200)
        when :FROZEN
          tone.set(-50,50,50,0)
        when :PETRIFIED
          tone.set(0,0,0,255)
        else
          tone.set(0,0,0,0)
      end
    end

    def refreshPartyIcons
      ### MODDED/
      @partyStatus = Array.new(6,nil) if !@partyStatus
      ### /MODDED

      for i in 0...6
        partyMemberExists = $Trainer.party.size > i
        partySpecie = 0
        partyForm = 0
        partyIsEgg = false
        ### MODDED/
        partyStatus = nil
        ### /MODDED
        if partyMemberExists
          partySpecie = $Trainer.party[i].species
          partyForm = $Trainer.party[i].form
          partyIsEgg = $Trainer.party[i].egg?
          ### MODDED/
          partyStatus = $Trainer.party[i].status
          ### /MODDED
        end
        refresh = (
          @partySpecies[i]!=partySpecie ||
          @partyForm[i]!=partyForm ||
          @partyIsEgg[i]!=partyIsEgg
        )
        ### MODDED/
        refresh = true if @partyStatus[i]!=partyStatus
        ### /MODDED
        if refresh
          @partySpecies[i] = partySpecie
          @partyForm[i] = partyForm
          @partyIsEgg[i] = partyIsEgg
          ### MODDED/
          @partyStatus[i] = partyStatus
          ### /MODDED
          if partyMemberExists
            @sprites["pokeicon#{i}"].bitmap = pbPokemonIconBitmap($Trainer.party[i],$Trainer.party[i].isEgg?)
            @sprites["pokeicon#{i}"].src_rect=Rect.new(0,0,64,64)
            ### MODDED/
            flhudstatus_tone(@sprites["pokeicon#{i}"].tone, partyStatus)
            ### /MODDED

          end
          @sprites["pokeicon#{i}"].visible = partyMemberExists
        end
      end
    end
  end
end
