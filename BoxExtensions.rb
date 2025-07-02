
module BoxExtensions
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

    def self.registerType(search)
      @@searchtypes.push(search)
    end

    def self.commands
      commands=[]
      types=[]

      for st in @@searchtypes
        commands.push(st.name)
        types.push(st)
      end
      return [commands, types]
    end
  end

  class NameSearchType
    def name
      _INTL("Name")
    end

    def gatherParameters(screen)
      pkname = screen.pbEnterPokemonName("Nickname of the Pokémon?",0,15,"").downcase
      return nil if pkname == ""
      return pkname
    end

    def filter(screen, pkmn, params)
      screen.pbNameContains(pkmn.name.downcase, params)
    end
  end

  class SpeciesSearchType
    def name
      _INTL("Species")
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the species?", SearchTypes.gather(&:species), &method(:getMonName))
    end

    def filter(screen, pkmn, params)
      pkmn.species == params
    end
  end

  class ItemSearchType
    def name
      _INTL("Item")
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the item?", SearchTypes.gather(&:item), &method(:getItemName))
    end

    def filter(screen, pkmn, params)
      pkmn.item == params
    end
  end

  class AbilitySearchType
    def name
      _INTL("Ability")
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the ability?", SearchTypes.gather(&:ability), &method(:getAbilityName))
    end

    def filter(screen, pkmn, params)
      pkmn.ability == params
    end
  end

  class TypeSearchType
    def name
      _INTL("Type")
    end

    def gatherParameters(screen)
      boundedentry_typeEntry("Which types?")
    end

    def filter(screen, pkmn, params)
      return pkmn.type1 == params[0] || pkmn.type2 == params[0] if params.length == 1
      return (pkmn.type1 == params[0] && pkmn.type2 == params[1]) || (pkmn.type2 == params[0] && pkmn.type1 == params[1]) if params.length == 2
    end
  end

  class MoveSearchType
    def name
      _INTL("Move")
    end

    def gatherParameters(screen)
      boundedentry_textEntry("Name of the move?", SearchTypes.gather { |p| p.moves.map(&:move) }, &method(:getMoveName))
    end

    def filter(screen, pkmn, params)
      pkmn.moves.any? { |mv| mv.move == params }
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
      imagepos=[["Data/Mods/BoxExtensions/BallBackground",2,46,0,0,-1,-1]]
      ballused = pokemon.ballused ? pokemon.ballused : :POKEBALL
      ballimage=sprintf("Graphics/Pictures/Summary/summaryball" + ballused.to_s)
      imagepos.push([ballimage,4,46,0,0,-1,-1])
      pbDrawImagePositions(overlay,imagepos)
    end
  end

  def boxextensions_applyTone(&block)
    @sprites["box"].boxextensions_applyTone(&block)
  end
end

class PokemonBoxSprite
  def boxextensions_applyTone(&block)
    for i in 0...30
      if @pokemonsprites[i] && !@pokemonsprites[i].disposed?
        pokemon = @storage[@boxnumber,i]
        if pokemon && !block.call(pokemon)
          @pokemonsprites[i].tone = Tone.new(0,0,0,255)
        end
      end
    end
  end

  alias :boxextensions_old_grabPokemon :grabPokemon

  def grabPokemon(index,arrow)
    for sprite in @pokemonsprites
      if sprite
        sprite.tone = Tone.new(0,0,0)
      end
    end
    return boxextensions_old_grabPokemon(index,arrow)
  end
end

class PokemonStorageScreen
  # Complete override
  def pbFindPokemon
    commands, searchtypes = BoxExtensions::SearchTypes.commands

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
      @scene.pbJumpToBox(boxesFound[box]) if box >= 0
      @scene.boxextensions_applyTone { |p| searchtype.filter(self, p, params) }
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
