begin
  missing = ['0001.boundedentry.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

module BoxExtensions
  @@currentsearch = nil

  def self.clearSearch
    @@currentsearch = nil
  end

  def self.setSearch(&block)
    @@currentsearch = block
  end

  def self.hasSearch
    !@@currentsearch.nil?
  end

  def self.matchesSearch(pkmn)
    @@currentsearch.call(pkmn)
  end

  module SearchTypes
    @@searchtypes=[]

    def self.gather(&mapper)
      allfound = []
      for box in 0...$PokemonStorage.maxBoxes
        for i in 0...$PokemonStorage[box].length
          poke = $PokemonStorage[box, i]
          if poke
            mapped = mapper.call(poke)
            mapped = [mapped] unless mapped.is_a?(Array)
            for found in mapped
              allfound.push(found) if found && !allfound.include?(found)
            end
          end
        end
      end
      allfound.sort!
      return allfound
    end

    def self.registerTopType(search)
      @@searchtypes.unshift(search)
    end

    def self.registerType(search)
      @@searchtypes.push(search)
    end

    def self.commands(screen)
      commands=[]
      types=[]

      for st in @@searchtypes
        if st.shouldShow(screen)
          commands.push(st.name)
          types.push(st)
        end
      end
      return [commands, types]
    end
  end

  class NameSearchType
    def name
      _INTL("Name")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      pkname = screen.pbEnterPokemonName("Nickname of the Pokémon?",0,15,"").downcase
      return nil if pkname == ""
      return pkname
    end

    def filter(screen, pkmn, params)
      !pkmn.isEgg? && screen.pbNameContains(pkmn.name.downcase, params)
    end
  end

  class SpeciesSearchType
    def name
      _INTL("Species")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the species?", SearchTypes.gather(&:species), "No Pokémon found.", &method(:getMonName))
    end

    def filter(screen, pkmn, params)
      pkmn.species == params
    end
  end

  class ItemSearchType
    def name
      _INTL("Item")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the item?", SearchTypes.gather(&:item), "No items found.", &method(:getItemName))
    end

    def filter(screen, pkmn, params)
      !pkmn.isEgg? && pkmn.item == params
    end
  end

  class AbilitySearchType
    def name
      _INTL("Ability")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the ability?", SearchTypes.gather(&:ability), "No Pokémon found.", &method(:getAbilityName))
    end

    def filter(screen, pkmn, params)
      !pkmn.isEgg? && pkmn.ability == params
    end
  end

  class TypeSearchType
    def name
      _INTL("Type")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_typeEntry("Which types?")
    end

    def filter(screen, pkmn, params)
      if params.length == 2
        return pkmn.type1 == params[0] && pkmn.type2.nil? if params[0] == params[1]
        return (pkmn.type1 == params[0] && pkmn.type2 == params[1]) || (pkmn.type2 == params[0] && pkmn.type1 == params[1])
      end
      return pkmn.type1 == params[0] || pkmn.type2 == params[0] if params.length == 1
    end
  end

  class MoveSearchType
    def name
      _INTL("Move")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the move?", SearchTypes.gather { |p| p.moves.map(&:move) }, "No Pokémon found.", &method(:getMoveName))
    end

    def filter(screen, pkmn, params)
      !pkmn.isEgg? && pkmn.moves.any? { |mv| mv.move == params }
    end
  end

  class CanLearnMoveSearchType
    def name
      _INTL("Learns Move")
    end

    def shouldShow(screen)
      true
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the move?", SearchTypes.gather { |p|
        compats = p.formCheck(:compatiblemoves)
        compats = $cache.pkmn[p.species].compatiblemoves if !compats
        exceptions = p.formCheck(:moveexceptions)
        exceptions = $cache.pkmn[p.species].moveexceptions if !exceptions
        eggmoves = p.getEggMoveList # Should be covered by compatible moves, but just in case
        learnset = p.getMoveList.map { |it| it[1] } # Should be covered by compatible moves, but just in case
        totallist = compats + PBStuff::UNIVERSALTMS + eggmoves + learnset
        totallist.uniq!
        totallist -= exceptions
        next totallist
      }, "No Pokémon found.", &method(:getMoveName))
    end

    def filter(screen, pkmn, params)
      return false if pkmn.isEgg?
      return pkmn.SpeciesCompatible?(params)
    end
  end
end

class PokemonStorageScene
  alias :boxextensions_old_pbUpdateOverlay :pbUpdateOverlay

  def pbUpdateOverlay(selection,party=nil)
    boxextensions_old_pbUpdateOverlay(selection, party)

    overlay=@sprites["overlay"].bitmap
    pokemon=nil
    if @screen.pbHeldPokemon
      pokemon=@screen.pbHeldPokemon
    elsif selection>=0
      pokemon=(party) ? party[selection] : @storage[@storage.currentBox,selection]
    end

    if pokemon
      imagepos=[["#{__dir__[Dir.pwd.length+1..]}/BoxExtensions/BallBackground",2,46,0,0,-1,-1]]
      ballused = pokemon.ballused ? pokemon.ballused : :POKEBALL
      ballimage=sprintf("Graphics/Pictures/Summary/summaryball" + ballused.to_s)
      imagepos.push([ballimage,4,46,0,0,-1,-1])
      pbDrawImagePositions(overlay,imagepos)
    end
  end

  def boxextensions_applyTone
    @sprites["box"].boxextensions_applyTone
  end

  alias :boxextensions_old_pbCloseBox :pbCloseBox

  def pbCloseBox
    boxextensions_old_pbCloseBox
    BoxExtensions::clearSearch
  end
end

class PokemonBoxSprite
  attr_accessor :applied_tone

  def boxextensions_clearTone
    for i in 0...30
      if @pokemonsprites[i] && !@pokemonsprites[i].disposed?
        pokemon = @storage[@boxnumber,i]
        if pokemon
          @pokemonsprites[i].tone = Tone.new(0,0,0)
        end
      end
    end
  end

  def boxextensions_applyTone
    return unless BoxExtensions.hasSearch

    for i in 0...30
      if @pokemonsprites[i] && !@pokemonsprites[i].disposed?
        pokemon = @storage[@boxnumber,i]
        if pokemon && !BoxExtensions.matchesSearch(pokemon)
          @pokemonsprites[i].tone = Tone.new(0,0,0,255)
        elsif pokemon
          @pokemonsprites[i].tone = Tone.new(0,0,0)
        end
      end
    end
  end

  alias :boxextensions_old_grabPokemon :grabPokemon

  def grabPokemon(index,arrow)
    if BoxExtensions.hasSearch
      BoxExtensions::clearSearch
      boxextensions_clearTone
      update
    end
    return boxextensions_old_grabPokemon(index, arrow)
  end

  alias :boxextensions_old_initialize :initialize

  def initialize(*args, **kwargs)
    boxextensions_old_initialize(*args, **kwargs)
    boxextensions_applyTone
  end

  alias :boxextensions_old_update :update

  def update(*args, **kwargs)
    boxextensions_old_update(*args, **kwargs)
    boxextensions_applyTone
  end
end

class PokemonStorageScreen
  # Complete override
  def pbFindPokemon
    commands, searchtypes = BoxExtensions::SearchTypes.commands(self)

    searchtype = pbShowCommands(_INTL("Search by what?"), commands)

    return if searchtype == -1 # Cancel

    searchtype = searchtypes[searchtype]

    params = searchtype.gatherParameters(self)

    return unless params # nil params means don't search

    commandsFound = []
    boxesFound = []
    boxesCount = []
    for box in 0...$PokemonStorage.maxBoxes
      foundAny = false
      for i in 0...$PokemonStorage[box].length
        poke = $PokemonStorage[box, i]
        if poke
          if searchtype.filter(self, poke, params)
            if foundAny
              boxesCount[boxesCount.length-1] = boxesCount[boxesCount.length-1]+1
            else
              commandsFound.push($PokemonStorage[box].name)
              boxesFound.push(box)
              boxesCount.push(1)
              foundAny = true
            end
          end
        end
      end
    end

    if commandsFound.length > 0
      for i in 0...commandsFound.length
        commandsFound[i] = _INTL("{1} ({2})", commandsFound[i], boxesCount[i])
      end

      if commandsFound.length == 1
        boxesStr = _INTL("Match found in {1} box.", commandsFound.length)
      else
        boxesStr = _INTL("Matches found in {1} boxes.", commandsFound.length)
      end

      box = pbShowCommands(boxesStr, commandsFound)
      BoxExtensions.setSearch { |p| searchtype.filter(self, p, params) }
      @scene.boxextensions_applyTone
      @scene.pbJumpToBox(boxesFound[box]) if box >= 0
    else
      pbDisplay(_INTL("No match was found."))
    end
  end
end

BoxExtensions::SearchTypes.registerType(BoxExtensions::NameSearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::SpeciesSearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::ItemSearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::AbilitySearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::TypeSearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::MoveSearchType.new)
BoxExtensions::SearchTypes.registerType(BoxExtensions::CanLearnMoveSearchType.new)
