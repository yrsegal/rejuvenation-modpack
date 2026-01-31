# Modify Pokedex to have Form Data

class Pokedex

  alias :lurerework_old_initDexList :initDexList

  def initDexList(debug = false)
    lurerework_old_initDexList(debug)

    # init formdata
    @formList = Hash.new()
    $cache.pkmn.each{|monKey, data|
      formListHash = {
        forms: {},
        gender: lurerework_has_genderform(monKey) ? { "Male" => false, "Female" => false } : nil
      }
      formNames = data.forms

      for i in 0...formNames.length
        formListHash[:forms].store(formNames[i], false)
      end

      @formList.store(monKey, formListHash)
    }
  end 

  alias :lurerework_old_updateGenderFormEntries :updateGenderFormEntries

  def updateGenderFormEntries
    lurerework_old_updateGenderFormEntries

    # Gender form entry update
    @formList = {} if !@formList
    $cache.pkmn.each{|monKey, data|
      if !@formList.keys.include?(monKey) || @formList[monKey][:forms].length != data.forms.length
        newforms = {}
        data.forms.values.each_with_index{|form,idx|
          newforms.store(form,@dexList[monKey][:owned?] && idx == 0)
        }
        @formList[monKey] = {} unless @formList[monKey]
        @formList[monKey][:forms] = newforms 
      end
      if lurerework_has_genderform(monKey) && !@formList[monKey][:gender]
        @formList[monKey][:gender] = {
          "Male" => @dexList[monKey][:owned?] && @dexList[monKey][:gender]["Male"],
          "Female" => @dexList[monKey][:owned?] && @dexList[monKey][:gender]["Female"],
        }
      end
    }
  end

  alias :lurerework_old_refreshDex :refreshDex

  def formList
    if !@formList || $cache.pkmn.length != @formList.length
      refreshDex
    end

    return @formList
  end

  alias :lurerework_old_refreshDex :refreshDex

  def refreshDex
    # Fix issue with removing mods that add pokemon
    (@dexList.keys - $cache.pkmn.keys).each(&@dexList.method(:delete))
    lurerework_old_refreshDex

    # Formdata refresh
    @formList = {} if !@formList
    (@formList.keys - $cache.pkmn.keys).each(&@formList.method(:delete))
    $cache.pkmn.each{|monKey, data|
      next if @formList.keys.include?(monKey) && @formList[monKey][:forms].length == $cache.pkmn[monKey].forms.length

      formListHash = {
        forms: {},
        gender: lurerework_has_genderform(monKey) ? { 
          "Male" => @dexList[monKey][:owned?] && @dexList[monKey][:gender]["Male"],
          "Female" => @dexList[monKey][:owned?] && @dexList[monKey][:gender]["Female"] 
        } : nil
      }
      formNames = data.forms

      for i in 0...formNames.length
        formListHash[:forms].store(formNames[i], @dexList[monKey][:owned?] && i == 0)
      end

      @formList[monKey] = formListHash
    }
  end

  alias :lurerework_old_setOwned :setOwned

  def setOwned(pokemon)
    lurerework_old_setOwned(pokemon)

    lurerework_setFormOwned(pokemon)
  end

  def lurerework_setFormOwned(pokemon)
    # Store encounter info for gender-differentiated pokemon and basculin-white
    return if !pokemon.is_a?(PokeBattle_Pokemon)
    if $game_switches
      return if $game_switches[:NotPlayerCharacter]
    end
    self.formList[pokemon.species][:forms][pokemon.getFormName] = true
    if lurerework_has_genderform(pokemon.species, pokemon.form)
      gender = "Any"
      gender = "Male" if pokemon.gender == 0
      gender = "Female" if pokemon.gender == 1
      self.formList[pokemon.species][:gender][gender] = true
    end
  end
end

module BallHandlers
  class << self
    alias :lurerework_old_onCatch :onCatch
  end
  def self.onCatch(ball, battle, pokemon)
    lurerework_old_onCatch(ball, battle, pokemon)
    $Trainer.pokedex.lurerework_setFormOwned(pokemon)
  end
end

def lurerework_has_genderform(monKey, form=nil)
  return cancelledgenders.include?(monKey) || (monKey == :BASCULIN && (form.nil? || form == 2)) # White Striped
end

### MAGNETIC LURE INTERACTION WITH FORMS

def lurerework_has_form(species)
  return false if !$Trainer.pokedex.dexList[species][:owned?]

  formData = $Trainer.pokedex.formList[species]
  data = $cache.pkmn[species]

  if data.forms.length > 1
    basculinform = nil
    if data.formInit && data.formInit.is_a?(String) && data.formInit[/^proc\{rand\((\d+)\)\}$/]
      totalForms = $1.to_i
      for i in 0...totalForms
        return false unless formData[:forms][data.forms[i]]
      end
    elsif species == :BASCULIN # Has a rand, but isn't the exact proc above
      if $game_map && Basculin.include?($game_map.map_id)
        basculinform = 2 # White striped
        return false unless formData[:forms][data.forms[2]]
      else
        for i in 0...2 # 2 is the rand here
          return false unless formData[:forms][data.forms[i]]
        end
      end
    elsif data.formInit && data.formInit.is_a?(String)
      form = eval(data.formInit).call
      return false unless formData[:forms][data.forms[form]]
    end
  end

  return false if lurerework_has_genderform(species, basculinform) && !formData[:gender].values.all?

  return true
end

# Handle gender generation
Events.onWildPokemonCreate+=proc {|sender,e|
  pokemon=e[0]
  if $PokemonEncounters.pbShouldFilterKnownPkmnFromEncounter? && lurerework_has_genderform(pokemon.species, pokemon.form)
    gender = $Trainer.pokedex.formList[pokemon.species][:gender]
    uncaughtGender = gender.select { |gender,owned| !owned }.keys
    unless uncaughtGender.empty?
      gender = uncaughtGender.sample
      pokemon.setGender(gender)
    end
  elsif $PokemonEncounters.pbShouldFilterOtherPkmnFromEncounter? && lurerework_has_genderform(pokemon.species, pokemon.form)
    gender = $Trainer.party.select { |it| 
      it.species == pokemon.species && it.form == pokemon.form && it.item == :MIRRORLURE 
    }.sample

    pokemon.setGender(gender)
  end
}

class PokeBattle_Battler
  alias :lurerework_old_owned :owned

  def owned
    return false unless lurerework_old_owned
    data = $cache.pkmn[@pokemon.species]
    formData = $Trainer.pokedex.formList[@pokemon.species]
    if lurerework_has_genderform(@pokemon.species, @startform)
      gender = "Any"
      gender = "Male" if @pokemon.gender == 0
      gender = "Female" if @pokemon.gender == 1
      return false unless formData[:gender][gender]
    end
    return false unless formData[:forms][data.forms[@startform]]

    return true
  end
end

# Handle form generation
alias :lurerework_old_pbGenerateWildPokemon :pbGenerateWildPokemon
def pbGenerateWildPokemon(species,level,sos=false)
  oldforminit = nil

  data = $cache.pkmn[species]
  if data
    if $PokemonEncounters.pbShouldFilterKnownPkmnFromEncounter?
      if data.formInit && data.formInit.is_a?(String) && data.formInit[/^proc\{rand\((\d+)\)\}$/]
        formData = $Trainer.pokedex.formList[species]
        unless (0...($1.to_i)).all? { |it| formData[:forms][data.forms[it]] }
          oldforminit = data.formInit
          data.formInit = <<~END
            proc {
              data = $cache.pkmn[:#{species}]
              formData = $Trainer.pokedex.formList[:#{species}]
              next (0...#{$1}).select { |it| !formData[:forms][data.forms[it]] }.sample
            }
          END
        end
      end
    elsif $PokemonEncounters.pbShouldFilterOtherPkmnFromEncounter?
      if data.formInit && data.formInit.is_a?(String) && data.formInit[/^proc\{rand\((\d+)\)\}$/]
        forms = $Trainer.party.select { |it| it.species == species && it.item == :MIRRORLURE }.map(&:form)
        unless forms.empty?
          oldforminit = data.formInit
          data.formInit = "proc {#{forms.inspect}.sample}"
        end
      end
    end
  end

  ret = lurerework_old_pbGenerateWildPokemon(species,level,sos)

  data.formInit = oldforminit if oldforminit

  return ret
end

class PokemonEncounters

  def pbShouldFilterKnownPkmnFromEncounter?
    ### MODDED/
    return false if pbShouldFilterOtherPkmnFromEncounter?
    return true if $game_screen.lurerework_checkIsMagneticLureOn?
    return false
    ### /MODDED
  end

  def pbShouldFilterOtherPkmnFromEncounter?
    ### MODDED/
    return $Trainer.party.any? {|it| it.item == :MIRRORLURE }
    ### /MODDED
  end

  def pbFilterOtherPkmnFromEncounter(chances, encounters)
    uncaptured=[]
    ### MODDED/ check entire party for mirrorlures
    mirrorluremons = $Trainer.party.select { |it| it.item == :MIRRORLURE }.map(&:species)
    ### /MODDED
    for i in 0...encounters.length
      # First, filter out the mons that have no chance of spawning
      # Just in case...
      next if !chances[i]
      next if chances[i] <= 0
      # Then filter out all captured mons
      enc=encounters[i]
      next if !enc
      ### MODDED/ check entire party
      next if !mirrorluremons.include?(enc[0])
      ### /MODDED
      uncaptured.push(enc)
    end
    return nil if uncaptured.length <= 0
    randId=rand(uncaptured.length)
    return uncaptured[randId]
  end

  def pbFilterKnownPkmnFromEncounter(chances, encounters)
    uncaptured=[]
    for i in 0...encounters.length
      # First, filter out the mons that have no chance of spawning
      # Just in case...
      next if !chances[i]
      next if chances[i] <= 0
      # Then filter out all captured mons
      enc=encounters[i]
      next if !enc
      ### MODDED/ use form-discerning check
      next if lurerework_has_form(enc[0])
      ### /MODDED
      uncaptured.push(enc)
    end
    return nil if uncaptured.length <= 0
    randId=rand(uncaptured.length)
    return uncaptured[randId]
  end
end

### ITEM CHANGES

class ItemData < DataObject
  attr_writer :flags
  attr_writer :desc
end

ItemHandlers::UseFromBag.add(:MAGNETICLURE,proc{|item|
  $game_screen.lurerework_toggleLure
  next 1
})

ItemHandlers::UseInField.add(:MAGNETICLURE,proc{|item|
  $game_screen.lurerework_toggleLure
})

$cache.items[:MAGNETICLURE].flags[:keyitem] = true
$cache.items[:MAGNETICLURE].flags[:noUse] = false
$cache.items[:MAGNETICLURE].flags[:utilityhold] = false
$cache.items[:MAGNETICLURE].desc = "A strange device. Draws in uncaught species when activated."

class PokemonMartAdapter
  alias :lurerework_old_getDisplayName :getDisplayName

  def getDisplayName(item)
    old = lurerework_old_getDisplayName(item)
    if item == :MAGNETICLURE
      if $game_screen && defined?($game_screen.lurerework_lureIsOn) && $game_screen.lurerework_lureIsOn
        old += ' (On)'
      else
        old += ' (Off)'
      end
    end
    return old
  end
end

class PokemonBag_Scene
  alias :lurerework_old_pbStartScene :pbStartScene

  def pbStartScene(bag)
    # Pocket 1 is default items
    if bag.pockets[1].include?(:MAGNETICLURE)
      bag.pockets[1].delete(:MAGNETICLURE)

      bag.pockets[pbGetPocket(:MAGNETICLURE)].push(:MAGNETICLURE)
    end

    return lurerework_old_pbStartScene(bag)
  end
end

class Game_Screen

  attr_accessor   :lurerework_lureIsOn

  def lurerework_checkIsMagneticLureOn?
    return false if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    return false if $PokemonBag.pbQuantity(:MAGNETICLURE) == 0
    @lurerework_lureIsOn=false if !defined?(@lurerework_lureIsOn)
    return @lurerework_lureIsOn
  end

  def lurerework_toggleLure
    @lurerework_lureIsOn=!@lurerework_lureIsOn
    if lurerework_checkIsMagneticLureOn?
      Kernel.pbMessage(_INTL('The Magnetic Lure is now \c[1]ON\c[0].'))
    else
      Kernel.pbMessage(_INTL('The Magnetic Lure is now \c[2]OFF\c[0].'))
    end
  end
end

class PokeBattle_Battler
  alias :lurerework_old_hasWorkingItem :hasWorkingItem

  def hasWorkingItem(item,ignorefainted=false)
    return true if item == :SMOKEBALL && lurerework_old_hasWorkingItem(:MIRRORLURE)
    return lurerework_old_hasWorkingItem(item)
  end
end
