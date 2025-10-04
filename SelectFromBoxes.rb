begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

###### SHADOW POKEMON

def selectfromboxes_purifiableInfo()
  for mon in $Trainer.party
    return [true, -1] if pbIsPurifiable?(mon)
  end
  for box in 0...$PokemonStorage.maxBoxes
    for idx in 0...$PokemonStorage[box].length
      mon = $PokemonStorage[box, idx]
      return [true, box] if mon && pbIsPurifiable?(mon)
    end
  end
  return [false]
end

def pbRelicStone()
  ### MODDED/
  purifiableInfo = selectfromboxes_purifiableInfo()
  if purifiableInfo[0]
  ### /MODDED
    Kernel.pbMessage(_INTL("There's a Pokemon that may open the door to its heart!"))
    # Choose a purifiable Pokemon
    ### MODDED/
    pbChoosePokemon(1,2,proc {|poke|
       !poke.isEgg? && poke.hp>0 && poke.isShadow? && poke.heartgauge==0
    },false,false, selectfromboxes_commandText: "Purify", selectfromboxes_partyOpen: purifiableInfo[1] == -1)
    ### /MODDED
    if $game_variables[1]>=0
      pbRelicStoneScreen($Trainer.party[$game_variables[1]])
    end
  else
    Kernel.pbMessage(_INTL("You have no Pokemon that can be purified."))
  end
end

######

###### REPLACING SELECTION WINDOW
alias :selectfromboxes_old_pbChoosePokemon :pbChoosePokemon

def pbChoosePokemon(variableNumber,nameVarNumber,ableProc=nil,allowIneligible=false,giveAway=false,*args,
  ### MODDED/
  selectfromboxes_commandText: "Select", selectfromboxes_partyOpen: ableProc.nil?,
  selectfromboxes_tutorPartialAble: nil, selectfromboxes_tutorMove: nil, **kwargs)

  if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    return selectfromboxes_old_pbChoosePokemon(variableNumber,nameVarNumber,ableProc,allowIneligible,giveAway,*args,**kwargs)
  end

  if !ableProc.nil?
    for mon in $Trainer.party
      if ableProc.call(mon)
        selectfromboxes_partyOpen = true
        break
      end
    end
  end

  chosen=-1
  pbFadeOutIn(99999){
      scene=Selectfromboxes_PokemonStorageScene.new(giveAway, ableProc, allowIneligible, selectfromboxes_tutorPartialAble, selectfromboxes_partyOpen)
      screen=Selectfromboxes_PokemonStorageScreen.new(scene,$PokemonStorage,selectfromboxes_commandText, selectfromboxes_tutorMove)

      chosen = screen.pbChoosePokemon()
      if chosen.nil?
       chosen = -1
      end
  }
  ### /MODDED
  pbSet(variableNumber, chosen)
  if chosen != -1
    pbSet(nameVarNumber, $Trainer.party[chosen].name)
  else
    pbSet(nameVarNumber,"")
  end
end

######

###### CHECKS BOXES TOO
alias :selectfromboxes_old_pbHasSpecies? :pbHasSpecies?

def pbHasSpecies?(species)
  return true if selectfromboxes_old_pbHasSpecies?(species)

  for box in 0...$PokemonStorage.maxBoxes
    for idx in 0...$PokemonStorage[box].length
      mon = $PokemonStorage[box, idx]
      next if !mon || mon.isEgg?
      if mon.species==species
        pbSet(1,[box, idx])
        return true
      end
    end
  end

  return false
end

alias :selectfromboxes_old_pbHasFatefulSpecies? :pbHasFatefulSpecies?

def pbHasFatefulSpecies?(species)
  return true if selectfromboxes_old_pbHasFatefulSpecies?(species)

  for box in 0...$PokemonStorage.maxBoxes
    for idx in 0...$PokemonStorage[box].length
      mon = $PokemonStorage[box, idx]
      next if !mon || mon.isEgg?
      return true if mon.species==species && mon.obtainMode==4
    end
  end

  return false

end

######

###### REPLACING MOVE TUTOR WINDOW

alias :selectfromboxes_old_pbMoveTutorChoose :pbMoveTutorChoose

def pbMoveTutorChoose(move,movelist=nil,bymachine=false,bytutor=false,*args,**kwargs)
  ret=false

  ### MODDED/

  if Rejuv && $game_switches[:NotPlayerCharacter] && !$game_switches[:InterceptorsWish]
    return selectfromboxes_old_pbMoveTutorChoose(move, movelist, bymachine, bytutor,*args,**kwargs)
  end

  if $Trainer.tutorlist.length>0 && ($Trainer.tutorlist.include?(move)) && bytutor==false
    Kernel.pbMessage('(' + _INTL("You've already bought {1}. Check out the app on the Cybernav!",getMoveName(move)) + ')')
  else
    pbChoosePokemon(1, 2, proc {|pkmn|
      !pkmn.isEgg? &&
      !(pkmn.isShadow? rescue false) &&
      !(movelist && !movelist.any?{|j| j==pkmn.species }) &&
      pkmn.SpeciesCompatible?(move)
    },
    selectfromboxes_commandText: "Teach",
    selectfromboxes_partyOpen: PokemonBag.pbPartyCanLearnThisMove?(move),
    selectfromboxes_tutorPartialAble: proc {|pkmn|
      pkmn.moves.any? { |pkmnMove| pkmnMove.move == move }
    },
    selectfromboxes_tutorMove: move)

    result = pbGet(1)
    if result != -1
      pokemon = $Trainer.party[result]
      if pbLearnMove(pokemon,move,false,bymachine)
        pbMoveTutorListAdd(move) if bymachine==false
        ret=true
      end
    end
  end
  ### /MODDED
  return ret # Returns whether the move was learned by a Pokemon
end

######

###### ALLOW SCRIPTS TO DELETE POKEMON IN BOXES

alias :selectfromboxes_old_pbRemovePokemonAt :pbRemovePokemonAt

def pbRemovePokemonAt(idx)
  if idx.is_a?(Array)
    if idx[0] != -1
      $PokemonStorage.pbDelete(idx[0], idx[1])
      return true
    else
      idx = idx[1]
    end
  end
  return selectfromboxes_old_pbRemovePokemonAt(idx)
end

###### SELECTION WINDOW

class Selectfromboxes_PokemonStorageScreen < PokemonStorageScreen

  attr_accessor :command_text
  attr_accessor :tutor_move

  def initialize(scene,storage,command_text,tutor_move)
    super(scene, storage)
    @command_text = command_text
    @tutor_move = tutor_move
    @choseFromParty = scene.partyOpen
  end

  def hasProc
    !@scene.ableProc.nil?
  end

  def isEligible(pkmn)
    hasProc && @scene.ableProc.call(pkmn)
  end

  def pbChoosePokemon(party=nil)
    @heldpkmn=nil
    @scene.pbStartBox(self,2)
    retval=-1
    loop do
      selected=@scene.pbSelectBox(@storage.party)
      if selected && selected[0]==-3 # Close box
        if pbConfirm(_INTL("Exit from the Box?"))
          break
        else
          next
        end
      end
      if selected==nil
        if pbConfirm(_INTL("Continue Box operations?"))
          next
        else
          break
        end
      elsif selected[0]==-4 # Box name
        pbBoxCommands
      else
        pokemon=@storage[selected[0],selected[1]]
        ### MODDED/
        next if !pokemon
        next if !@scene.allowIneligible && @scene.ableProc && !@scene.ableProc.call(pokemon)

        if @tutor_move && @scene.tutorPartialAble && @scene.tutorPartialAble.call(pokemon)
          pbDisplay(_INTL("{1} already knows\r\n{2}.",pokemon.name,getMoveName(@tutor_move)))
          next
        end

        commands=[
           _INTL(@command_text),
           _INTL("Summary"),
           _INTL("Cancel")
        ]
        helptext=_INTL("{1} is selected.",pokemon.name)
        command=pbShowCommands(helptext,commands)
        case command
          when 0 # Move/Shift/Place
            if pokemon

              if @scene.giveAway &&
               selected[0] == -1 && # Party
               $Trainer.ablePokemonCount == 1 &&
               $Trainer.ablePokemonParty.include?(pokemon)
                pbDisplay(_INTL("You can't give away your last non-fainted Pokémon."))
              else
                retval=selected
                break
              end
            end
          when 1 # Summary
            pbSummary(selected,nil)
        end
        ### /MODDED
      end
    end
    @scene.pbCloseBox
    return retval
  end
end

def selectfromboxes_tone(prevtone, pokemon, ableProc, tutorPartialAble)
  if tutorPartialAble && tutorPartialAble.call(pokemon)
    return Tone.new(0, 0, -128, prevtone.gray)
  elsif ableProc && !ableProc.call(pokemon)
    return Tone.new(0, 0, 0, 255)
  else
    return Tone.new(0, 0, 0, prevtone.gray)
  end
end

class Selectfromboxes_PokemonStorageScene < PokemonStorageScene
  attr_accessor :ableProc
  attr_accessor :tutorPartialAble
  attr_accessor :allowIneligible
  attr_accessor :giveAway
  attr_accessor :partyOpen

  def initialize(giveAway, ableProc, allowIneligible, tutorPartialAble, partyOpen)
    super()
    @giveAway = giveAway
    @ableProc = ableProc
    @allowIneligible = allowIneligible
    @tutorPartialAble = tutorPartialAble
    @partyOpen = partyOpen
  end

  def pbSelectBox(party)
    ### MODDED/ (treat as if allowed to choose from party)
    ret=nil
    loop do
      if !@choseFromParty
        ret=pbSelectBoxInternal(party)
      end
      if @choseFromParty || (ret && ret[0]==-2) # Party Pokémon
        if !@choseFromParty
          pbDropDownPartyTab
          @selection=0
        end
        ret=pbSelectPartyInternal(party,false)
        if ret<0
          pbHidePartyTab
          @selection=0
          @choseFromParty=false
        else
          @choseFromParty=true
          ret = [-1,ret]
          ret.extend(Comparable)
          ret.extend(LevelRestriction)
          return ret
        end
      else
        if ret.is_a?(Array)
          ret.extend(Comparable)
          ret.extend(LevelRestriction)
        end
        return ret
      end
    end
    ### /MODDED
  end

  def pbStartBox(screen,command)
    @screen=screen
    @storage=screen.storage
    @bgviewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @bgviewport.z=99999
    @boxviewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @boxviewport.z=99999
    @boxsidesviewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @boxsidesviewport.z=99999
    @arrowviewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @arrowviewport.z=99999
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @quickswap = false
    @sprites={}
    @choseFromParty=false
    @command=command
    addBackgroundPlane(@sprites,"background","Storage/boxbg",@bgviewport)
    ### MODDED/
    @sprites["box"]=Selectfromboxes_PokemonBoxSprite.new(@ableProc,@tutorPartialAble,@storage,@storage.currentBox,@boxviewport)
    ### /MODDED
    @sprites["boxsides"]=IconSprite.new(0,0,@boxsidesviewport)
    @sprites["boxsides"].setBitmap("Graphics/Pictures/Storage/boxsides")
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@boxsidesviewport)
    @sprites["pokemon"]=AutoMosaicPokemonSprite.new(@boxsidesviewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    ### MODDED/
    @sprites["boxparty"]=Selectfromboxes_PokemonBoxPartySprite.new(@ableProc,@tutorPartialAble,@storage.party,@boxsidesviewport)
    # if command!=1 # Drop down tab only on Deposit
    @choseFromParty = @partyOpen
    if !@partyOpen
    ### /MODDED
      @sprites["boxparty"].x=182
      @sprites["boxparty"].y=Graphics.height
    end
    @sprites["arrow"]=PokemonBoxArrow.new(@arrowviewport)
    @sprites["arrow"].z+=1
    ### MODDED/
    # if command!=1
    if !@partyOpen
    ### /MODDED
      pbSetArrow(@sprites["arrow"],@selection)
      pbUpdateOverlay(@selection)
      pbSetMosaic(@selection)
    else
      pbPartySetArrow(@sprites["arrow"],@selection)
      pbUpdateOverlay(@selection,@storage.party)
      pbSetMosaic(@selection)
    end
    pbFadeInAndShow(@sprites)
  end

  def pbHardRefresh
    oldPartyY=@sprites["boxparty"].y
    @sprites["box"].dispose
    @sprites["boxparty"].dispose
    ### MODDED/
    @sprites["box"]=Selectfromboxes_PokemonBoxSprite.new(@ableProc,@tutorPartialAble,@storage,@storage.currentBox,@boxviewport)
    @sprites["boxparty"]=PokemonBoxPartySprite.new(@ableProc,@tutorPartialAble,@storage.party,@boxsidesviewport)
    ### /MODDED
    @sprites["boxparty"].y=oldPartyY
  end

  def pbSwitchBoxToRight(newbox)
    iNewBox = newbox # Multi-Select

    ### MODDED/
    newbox=Selectfromboxes_PokemonBoxSprite.new(@ableProc,@tutorPartialAble,@storage,newbox,@boxviewport)
    ### /MODDED
    newbox.x=520
    Graphics.frame_reset
    begin
      Graphics.update
      Input.update
      @sprites["box"].x-=32
      newbox.x-=32
      pbUpdateSpriteHash(@sprites)
    end until newbox.x<=184
    diff=newbox.x-184
    newbox.x=184; @sprites["box"].x-=diff
    @sprites["box"].dispose
    @sprites["box"]=newbox

    aUpdateMultiSelectOverlay(iNewBox) # Multi-Select
  end

  def pbSwitchBoxToLeft(newbox)
    iNewBox = newbox # Multi-Select

    ### MODDED/
    newbox=Selectfromboxes_PokemonBoxSprite.new(@ableProc,@tutorPartialAble,@storage,newbox,@boxviewport)
    ### /MODDED
    newbox.x=-152
    Graphics.frame_reset
    begin
      Graphics.update
      Input.update
      @sprites["box"].x+=32
      newbox.x+=32
      pbUpdateSpriteHash(@sprites)
    end until newbox.x>=184
    diff=newbox.x-184
    newbox.x=184; @sprites["box"].x-=diff
    @sprites["box"].dispose
    @sprites["box"]=newbox

    aUpdateMultiSelectOverlay(iNewBox) # Multi-Select
  end
end

######

###### SPRITES

class Selectfromboxes_PokemonBoxPartySprite < PokemonBoxPartySprite
  attr_accessor :ableProc
  attr_accessor :tutorPartialAble

  def initialize(ableProc,tutorPartialAble,party,viewport=nil)
    super(party,viewport)
    @ableProc = ableProc
    @tutorPartialAble = tutorPartialAble
    updateTone
  end

  def update
    super
    updateTone
  end

  def updateTone
    if ableProc || tutorPartialAble
      for i in 0...6
        if @pokemonsprites[i] && !@pokemonsprites[i].disposed?
          pokemon = @party[i]
          if pokemon
            @pokemonsprites[i].tone = selectfromboxes_tone(@pokemonsprites[i].tone, pokemon, ableProc, tutorPartialAble)
          end
        end
      end
    end
  end
end

class Selectfromboxes_PokemonBoxSprite < PokemonBoxSprite
  attr_accessor :ableProc
  attr_accessor :tutorPartialAble

  def initialize(ableProc,tutorPartialAble,storage,boxnumber,viewport=nil)
    super(storage,boxnumber,viewport)
    @ableProc = ableProc
    @tutorPartialAble = tutorPartialAble
    updateTone
  end

  def update
    super
    updateTone
  end

  def updateTone
    if ableProc || tutorPartialAble
      for i in 0...30
        if @pokemonsprites[i] && !@pokemonsprites[i].disposed?
          pokemon = @storage[@boxnumber,i]
          if pokemon
            @pokemonsprites[i].tone = selectfromboxes_tone(@pokemonsprites[i].tone, pokemon, ableProc, tutorPartialAble)
          end
        end
      end
    end
  end
end

######


###### FOLLOWING CODE IS TO ENABLE COMPARISON

####### THIS IS BAD BUT NECESSARY
# This is very bad code discipline, but I can't think of another way to make this save-safe.
# "LevelRestriction" is being used here as a module present in the basegame, so it'll save/load safely.
# I really wish I had a better answer for this.
class PokeBattle_Trainer
  alias :selectfromboxes_old_party :party

  def party
    ret = selectfromboxes_old_party
    ret.extend(LevelRestriction) if ret.is_a?(Array)
    return ret
  end
end

module LevelRestriction 
  def [](i)
    if i.is_a?(Array)
      return $PokemonStorage[i[0], i[1]]
    end
    return super(i)
  end

  def []=(i,val)
    if i.is_a?(Array)
      return $PokemonStorage[i[0], i[1]] = val
    end
    return super(i,val)
  end
  
  def <=>(other)
    0.01 <=> other
  end
end

# This will convert old code using Selectfromboxes_PartyArray to LevelRestriction, and SelectionArray to regular arrays
Selectfromboxes_PartyArray = LevelRestriction
Selectfromboxes_SelectionArray = Array

####### END BAD CODE

######

###### PATCHING DAY CARE

def selectfromboxes_patch_partycheck(event)
  event.patch(:selectfromboxes_patch_partycheck) { |page|
    matched = page.lookForAll(
      [:ConditionalBranch, :Script, proc{|script| script == '$Trainer.pokemonCount<=1' || script == '$Trainer.party.length>=6'}])

    for insn in matched
      insn[0] = 'false'
    end
  }
end

def selectfromboxes_patch_daycarelady(event)
  selectfromboxes_patch_partycheck(event)

  event.patch(:selectfromboxes_patch_daycarelady) { |page|
      matched = page.lookForSequence(
        [:Script, 'pbDayCareWithdraw(pbGet(1))'],
        [:ShowText, "\\GExcellent\\nHere's your Pokémon."])

      if !matched.nil?
        page.delete(matched[0])
        page.insertAfter(matched[1], matched[0])
      end
  }
end

InjectionHelper.defineMapPatch(425) { |map| # Sheridan Interiors
  selectfromboxes_patch_daycarelady(map.events[1]) # Day Care Lady
  selectfromboxes_patch_partycheck(map.events[59]) # Day Care Man
}
InjectionHelper.defineMapPatch(9, 14, &method(:selectfromboxes_patch_partycheck)) # Dream District, pseudo-Day Care Man
InjectionHelper.defineMapPatch(282, 13, &method(:selectfromboxes_patch_daycarelady)) # Dream District Interiors, pseudo-Day Care Lady

######

###### INTEGRATION WITH BoxExtensions

class EligibleSearchType
  def name
    _INTL("Eligible")
  end

  def shouldShow(screen)
    screen.is_a?(Selectfromboxes_PokemonStorageScreen) && screen.hasProc
  end

  def gatherParameters(screen)
    return true
  end

  def filter(screen, pkmn, params)
    screen.isEligible(pkmn)
  end
end

BoxExtensions::SearchTypes.registerTopType(EligibleSearchType.new) if defined?(BoxExtensions)

######
