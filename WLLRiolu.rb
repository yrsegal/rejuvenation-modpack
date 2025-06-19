Variables[:PasswordVar] = 28

# Make NGP look in the correct folders; overrides NewGamePlus.rb
### MODDED/ path begins above data directory
def findWLLSave(path=File.dirname(System.data_directory))
  ### /MODDED
  return true if $game_switches[:Finished_WLL] || $Unidata[:WLL]

  Dir.each_child(path) {|file|
    next if file === '.' || file == '..'
    next if !file.include?("Where Love Lies")
    newpath = path + "/" + file
    ### MODDED/
    next if !File.directory?(newpath)
    ### /MODDED
    Dir.each_child(newpath) {|wllFile|
      ### MODDED/
      if wllFile.end_with?(".rxdata")
        ### /MODDED
        return true if checkForCompletion(newpath + "/" + wllFile)
      end
    }
  }
  return false
end

def wllriolu_pbAddPokemonNoTimeSet(species,level=nil,seeform=true,form=0)
  return if !species || !$Trainer
  if pbBoxesFull?
    Kernel.pbMessage(_INTL("There's no more room for Pokémon!\1"))
    Kernel.pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
    return false
  end
  ### MODDED/
  if !species.is_a?(PokeBattle_Pokemon)
    pokemon=PokeBattle_Pokemon.new(species,level,$Trainer,true,form)
    speciesname = getMonName(pokemon.species)
    owner=nil
  else
    pokemon=species
    speciesname = getMonName(pokemon.species)
    owner=[pokemon.trainerID, pokemon.ot]
  end

  if owner && owner[0] != $Trainer.id && owner[1] != ''
    Kernel.pbMessage(_INTL("{1} obtained {2}'s {3}!\\se[itemlevel]\1",$Trainer.name, owner[1], speciesname))
  else
    Kernel.pbMessage(_INTL("{1} obtained {2}!\\se[itemlevel]\1",$Trainer.name,speciesname))
  end
  ### /MODDED
  
  pbNicknameAndStore(pokemon)
  $Trainer.pokedex.setFormSeen(pokemon) if seeform
  return true
end

InjectionHelper.defineMapPatch(294, 70) { |event| # GDC Central, clerk
    hasReputationPillars = defined?($GDC_REPUTATION_PILLARS)
    event.pages[0].list = InjectionHelper.parseEventCommands(
      [:ConditionalBranch, :Switch, :Finished_WLL, false],
        [:ShowText, hasReputationPillars ? "STAFF: Welcome to the GDC Central Building!" : "STAFF: Welcome to the GDC Central Building! How may I help you today?"],
        *(hasReputationPillars ? [[:ShowText, 'You can check your reputation using the pillars in the lobby.'], [:ShowText, 'How may I help you?']] : []),
        [:ShowChoices, ["Password", "Never mind"], 2],

        [:When, 0, "Password"],
          [:ConditionalBranch, :Script, '$Unidata[:WLL]'],
            [:ControlVariable, :PasswordVar, :Set, :Constant, 489234],
          :Done,
          [:ShowText, 'Enter a password.'],
          [:InputNumber, :PasswordVar, 6],
          [:ConditionalBranch, :Variable, :PasswordVar, :Constant, 489234, :Equals],
            [:ControlSwitch, :Finished_WLL, true],
            [:Script,          'poke=PokeBattle_Pokemon.new(:RIOLU,5,$Trainer)'],
            [:ScriptContinued, 'poke.iv = [20,20,20,20,20,20] if !$game_switches[:Full_IVs] && !$game_switches[:Empty_IVs_Password]'],
            [:ScriptContinued, 'poke.setAbility(:PRANKSTER)'],
            [:ScriptContinued, 'poke.setNature(:DOCILE)'],
            [:ScriptContinued, 'poke.pbLearnMove(:AURASPHERE)'],
            [:ScriptContinued, 'poke.pbLearnMove(:POISONJAB)'],
            [:ScriptContinued, 'poke.pbLearnMove(:DETECT)'],
            [:ScriptContinued, 'poke.pbLearnMove(:QUICKATTACK)'],
            [:ScriptContinued, 'poke.makeShiny'],
            [:ScriptContinued, 'poke.makeFemale'],
            [:ScriptContinued, 'poke.item = :LUCARIONITE'],

            # OT Properties
            [:ScriptContinued, 'timediverge = $Settings.unrealTimeDiverge'],
            [:ScriptContinued, '$Settings.unrealTimeDiverge = 0'],
            [:ScriptContinued, 'timeNow = pbGetTimeNow'],
            [:ScriptContinued, 'poke.timeReceived = Time.unrealTime_oldTimeNew(timeNow.year-38,6,8,timeNow.hour,timeNow.min,timeNow.sec)'], # 38 years ago, june 8th
            [:ScriptContinued, '$Settings.unrealTimeDiverge = timediverge'],
            [:ScriptContinued, 'poke.obtainText = _INTL("Four Island")'],
            [:ScriptContinued, 'poke.obtainMode = 0'], # Caught
            [:ScriptContinued, 'poke.ot = _INTL("Kenneth")'],
            [:ScriptContinued, 'poke.trainerID = 924'], # Kenesu goroawase

            [:ScriptContinued, 'wllriolu_pbAddPokemonNoTimeSet(poke)'],

            [:ShowText, 'STAFF: Have a nice day!'],
          :Else,
            [:ShowText, 'STAFF: Sorry, but that input is incorrect...'],
          :Done,
        :Else,
          [:ShowText, 'STAFF: Have a nice day!'],
        :Done,
      :Else,
        [:ShowText, 'STAFF: Welcome to the GDC Central Building!'],
        *(hasReputationPillars ? [[:ShowText, 'You can check your reputation using the pillars in the lobby.']] : []),
      :Done,
    :Done)
  next true
}
