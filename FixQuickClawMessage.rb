class PokeBattle_Battle
    def pbPriority(ignorequickclaw = true,megacalc = false)
    return @priority if @usepriority && !megacalc # use stored priority if round isn't over yet (best ged rid of this in gen 8)
    @priority.clear
    priorityarray = []
    quickclawarray = [0,0,0,0]
    # -Move priority take precedence(stored as priorityarray[i][0])
    # -Then Items  (stored as priorityarray[i][1])
    # -Then speed (stored as priorityarray[i][2]) (trick room is applied by just making speed negative.)
    # -The last element is just the battler index (which is otherwise lost when sorting)
    for i in 0..3
      priorityarray[i] = [0,0,0,i] #initializes the array and stores the battler index

      # Move priority
      pri = 0
      if (@choices[i][0] == 2 || @battle.switchedOut[i]) # If switching or has switched
        pri = 12
      end
      if @choices[i][0] == 3 #Used item
        pri = 11
      end
      if @choices[i][0] == 1 # Is a move
        pri = @choices[i][2].priority  #Base move priority
        pri -= 1 if @battle.FE == :DEEPEARTH && @choices[i][2].move == :COREENFORCER
        pri += 1 if @field.effect == :CHESS && @battlers[i].pokemon && @battlers[i].pokemon.piece == :KING
        pri += 1 if @battlers[i].ability == :PRANKSTER && @choices[i][2].basedamage==0 && @battlers[i].effects[:TwoTurnAttack] == 0 # Is status move
        pri += 1 if @battlers[i].ability == :GALEWINGS && @choices[i][2].type==:FLYING && ((@battlers[i].hp == @battlers[i].totalhp) || ((@field.effect == :MOUNTAIN || @field.effect == :SNOWYMOUNTAIN) && @weather == :STRONGWINDS))
        pri += 1 if @choices[i][2].move == :GRASSYGLIDE && (@field.effect == :GRASSY || @battle.state.effects[:GRASSY] > 0)
        pri += 1 if @choices[i][2].move == :QUASH && @field.effect == :DIMENSIONAL
        pri += 1 if @choices[i][2].basedamage != 0 && @battlers[i].crested == :FERALIGATR && @battlers[i].turncount == 1 # Feraligatr Crest
        pri += 3 if @battlers[i].ability == :TRIAGE && (PBStuff::HEALFUNCTIONS).include?(@choices[i][2].function)
      end
      priorityarray[i][0]=pri

      #Item/stall priority (all items overwrite stall priority)
      priorityarray[i][1] = -1 if @battlers[i].ability == :STALL 
      if !ignorequickclaw && @choices[i][0] == 1 # Is a move
        if (@battlers[i].ability == :QUICKDRAW && (pbRandom(100)<30))
          priorityarray[i][1] = 1
          quickclawarray[i] = :QUICKDRAW
        elsif (@battlers[i].itemWorks? && @battlers[i].item == :QUICKCLAW && (pbRandom(100)<20))
          priorityarray[i][1] = 1
          quickclawarray[i] = :QUICKCLAW
        elsif @battlers[i].custap
          priorityarray[i][1] = 1
          quickclawarray[i] = :CUSTAPBERRY
        end
      end
      priorityarray[i][1] = -2 if (@battlers[i].itemWorks? && (@battlers[i].item == :LAGGINGTAIL || @battlers[i].item == :FULLINCENSE))

      #speed priority
      priorityarray[i][2] = @battlers[i].pbSpeed if @trickroom == 0
      priorityarray[i][2] = -@battlers[i].pbSpeed if @trickroom > 0
      
    end
    priorityarray.sort!

    #Speed ties. Only works correctly if two pokemon speed tie
    speedtie = []
    for i in 0..2
      for j in (i+1)..3
        if priorityarray[i][0]==priorityarray[j][0] && priorityarray[i][1]==priorityarray[j][1] && priorityarray[i][2]==priorityarray[j][2]
          if pbRandom(2)==1 
            priorityarray[i],priorityarray[j] = priorityarray[j],priorityarray[i]
          end
        end
      end
    end
    priorityarray.reverse!

    # Quick claw battle message
    for i in 0..3
      @priority[i] = @battlers[priorityarray[i][3]]
      ### MODDED/ replace @battlers[i] with @priority[i]
      if (@priority[i].ability == :QUICKDRAW) && quickclawarray[priorityarray[i][3]]==:QUICKDRAW
        if priorityarray[i][1] == 1 && !ignorequickclaw
          @priority[i].effects[:QuickDrawSnipe] if @battle.FE == :COLOSSEUM
          pbDisplayBrief(_INTL("{1}'s Quick Draw let it move first!",@priority[i].pbThis))
        end
      elsif (@priority[i].itemWorks? && @priority[i].item == :QUICKCLAW) && quickclawarray[priorityarray[i][3]]==:QUICKCLAW
        ### /MODDED
        pbDisplayBrief(_INTL("{1}'s Quick Claw let it move first!",@priority[i].pbThis)) if priorityarray[i][1] == 1 && !ignorequickclaw
      end
    end

    @usepriority=true
    return @priority
  end
end
