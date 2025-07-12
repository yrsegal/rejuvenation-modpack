
# TODO
# Replace selection with [002] selection menu
# Replace inspect with [003] battler info ui

module MoveHelpDisplay
  #-----------------------------------------------------------------------------
  # White text.
  #-----------------------------------------------------------------------------
  BASE_LIGHT     = Color.new(248, 248, 248)
  SHADOW_LIGHT   = Color.new(32, 32, 32)
  #-----------------------------------------------------------------------------
  # Black text.
  #-----------------------------------------------------------------------------
  BASE_DARK      = Color.new(56, 56, 56)
  SHADOW_DARK    = Color.new(184, 184, 184)
  #-----------------------------------------------------------------------------
  # Green text. Used to display bonuses.
  #-----------------------------------------------------------------------------
  BASE_RAISED    = Color.new(40, 201, 48)
  SHADOW_RAISED  = Color.new(9, 32, 32)
  #-----------------------------------------------------------------------------
  # Red text. Used to display penalties.
  #-----------------------------------------------------------------------------
  BASE_LOWERED   = Color.new(201, 56, 40)
  SHADOW_LOWERED = Color.new(48, 32, 32)

  FLAGS_TO_CHECK = [
    :beammove, 
    [:pulsemove, [:AURASPHERE,:DRAGONPULSE,:DARKPULSE,:WATERPULSE,:ORIGINPULSE,:TERRAINPULSE]],
    [:bitemove, PBStuff::BITEMOVE], 
    [:bulletmove, PBStuff::BULLETMOVE], 
    [:bypassprotect, PBStuff::PROTECTIGNORINGMOVE], 
    :contact, 
    [:dancemove, PBStuff::DANCEMOVE], 
    [:defrost, PBStuff::UNFREEZEMOVE], 
    [:healingmove, [], PBStuff::HEALFUNCTIONS], 
    :highcrit, 
    [:nocopy, PBStuff::NOCOPYMOVE], 
    :punchmove, :sharpmove, 
    [:stabmove, PBStuff::STABBINGMOVE],
    :soundmove, 
    [:tramplemove, [:BODYSLAM, :FLYINGPRESS, :MALICIOUSMOONSAULT], [0x10, 0x137, 0x9B]], 
    :windmove, :intercept, :zmove]

  USES_SMART_DAMAGE_CATEGORY = [0x309, 0x20D, 0x80A, 0x80B] # Shell Side Arm, Super UMD Move, Unleashed Power, Blinding Speed

  @@currentIndex = -1
  @@lastTargetIndex = -1

  def self.currentIndex=(value)
    @@currentIndex=value
  end

  def self.currentIndex
    @@currentIndex
  end

  def self.lastTargetIndex=(value)
    @@lastTargetIndex=value
  end

  def self.lastTargetIndex
    @@lastTargetIndex
  end
end

class PokeBattle_Move
  def movehelpdisplay_typeMod(type,attacker,opponent)
    secondtype = getSecondaryType(attacker)
    if opponent.ability == :SAPSIPPER && !(opponent.moldbroken) && (type == :GRASS || (!secondtype.nil? && secondtype.include?(:GRASS)))
      ### MODDED/ No actual effects
      # if opponent.pbCanIncreaseStatStage?(PBStats::ATTACK)
      #   opponent.pbIncreaseStatBasic(PBStats::ATTACK,1)
      #   @battle.pbCommonAnimation("StatUp",opponent,nil)
      #   @battle.pbDisplay(_INTL("{1}'s {2} raised its Attack!",
      #      opponent.pbThis,getAbilityName(opponent.ability)))
      # else
      #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #      opponent.pbThis,getAbilityName(opponent.ability),self.name))
      # end
      ### /MODDED
      return 0
    end
    if ((opponent.ability == :STORMDRAIN && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
       (opponent.ability == :LIGHTNINGROD && (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC))))) && !(opponent.moldbroken)
      ### MODDED/ No actual effects
      # if opponent.pbCanIncreaseStatStage?(PBStats::SPATK)
      #   if (Rejuv && @battle.FE == :SHORTCIRCUIT) && opponent.ability == :LIGHTNINGROD
      #     damageroll = @battle.field.getRoll(maximize_roll: (@battle.state.effects[:ELECTERRAIN] > 0))
      #     statboosts = [1,2,0,1,3]
      #     arrStatTexts=[_INTL("{1}'s {2} raised its Special Attack!",opponent.pbThis,getAbilityName(opponent.ability)), _INTL("{1}'s {2} sharply raised its Special Attack!",opponent.pbThis,getAbilityName(opponent.ability)),
      #       _INTL("{1}'s {2} drastically raised its Special Attack!",opponent.pbThis,getAbilityName(opponent.ability))]
      #     statboost = statboosts[PBStuff::SHORTCIRCUITROLLS.find_index(damageroll)]
      #     if statboost != 0
      #       opponent.pbIncreaseStatBasic(PBStats::SPATK,statboost)
      #       @battle.pbCommonAnimation("StatUp",opponent,nil)
      #       @battle.pbDisplay(arrStatTexts[statboost-1])
      #     else
      #       @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #         opponent.pbThis,getAbilityName(opponent.ability),self.name))
      #     end
      #   else
      #     opponent.pbIncreaseStatBasic(PBStats::SPATK,1)
      #     @battle.pbCommonAnimation("StatUp",opponent,nil)
      #     @battle.pbDisplay(_INTL("{1}'s {2} raised its Special Attack!",
      #       opponent.pbThis,getAbilityName(opponent.ability)))
      #   end
      # else
      #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #      opponent.pbThis,getAbilityName(opponent.ability),self.name))
      # end
      # if @function==0xCB #Dive
      #   @battle.scene.pbUnVanishSprite(attacker)
      # end
      ### /MODDED
      return 0
    end
    if ((opponent.ability == :MOTORDRIVE && !opponent.moldbroken) ||
      (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:SHOCKDRIVE))) &&
      (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC)))
      ### MODDED/ No actual effects
      # negator = getAbilityName(opponent.ability)
      # negator = getItemName(opponent.item) if (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:SHOCKDRIVE))
      # if opponent.pbCanIncreaseStatStage?(PBStats::SPEED)
      #   if (!Rejuv && @battle.FE == :SHORTCIRCUIT) || (Rejuv && @battle.FE == :FACTORY)
      #     opponent.pbIncreaseStatBasic(PBStats::SPEED,2)
      #     @battle.pbCommonAnimation("StatUp",opponent,nil)
      #     @battle.pbDisplay(_INTL("{1}'s {2} sharply raised its Speed!",
      #     opponent.pbThis,negator))
      #   elsif (Rejuv && @battle.FE == :SHORTCIRCUIT)
      #     damageroll = @battle.field.getRoll(maximize_roll: (@battle.state.effects[:ELECTERRAIN] > 0))
      #     statboosts = [1,2,0,1,3]
      #     arrStatTexts=[_INTL("{1}'s {2} raised its Speed!",opponent.pbThis,negator), _INTL("{1}'s {2} sharply raised its Speed!",opponent.pbThis,negator),
      #       _INTL("{1}'s {2} drastically raised its Speed!",opponent.pbThis,negator)]
      #     statboost = statboosts[PBStuff::SHORTCIRCUITROLLS.find_index(damageroll)]
      #     if statboost != 0
      #       opponent.pbIncreaseStatBasic(PBStats::SPEED,statboost)
      #       @battle.pbCommonAnimation("StatUp",opponent,nil)
      #       @battle.pbDisplay(arrStatTexts[statboost-1])
      #     else
      #       @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #         opponent.pbThis,negator,self.name))
      #     end
      #   else
      #     opponent.pbIncreaseStatBasic(PBStats::SPEED,1)
      #     @battle.pbCommonAnimation("StatUp",opponent,nil)
      #     @battle.pbDisplay(_INTL("{1}'s {2} raised its Speed!",
      #     opponent.pbThis,negator))
      #   end
      # else
      #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #   opponent.pbThis,negator,self.name))
      # end
      ### /MODDED
      return 0
    end
    if ((opponent.ability == :DRYSKIN && !(opponent.moldbroken)) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
      (opponent.ability == :VOLTABSORB && !(opponent.moldbroken) && (type == :ELECTRIC || (!secondtype.nil? && secondtype.include?(:ELECTRIC)))) ||
      (opponent.ability == :WATERABSORB && !(opponent.moldbroken) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
      ((Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:DOUSEDRIVE)) && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER)))) ||
      ((Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:CHILLDRIVE)) && (type == :ICE || (!secondtype.nil? && secondtype.include?(:ICE)))) ||
      ((Rejuv && @battle.FE == :DESERT) && (opponent.hasType?(:GRASS) || opponent.hasType?(:WATER)) && @battle.pbWeather == :SUNNYDAY && (type == :WATER || (!secondtype.nil? && secondtype.include?(:WATER))))
      if opponent.effects[:HealBlock]==0
        ### MODDED/ No actual effects
        # negator = getAbilityName(opponent.ability)
        # if ![:WATERABSORB,:VOLTABSORB,:DRYSKIN].include?(opponent.ability)
        #   negator = getItemName(opponent.item) if (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && (opponent.item == :DOUSEDRIVE || opponent.item == :CHILLDRIVE))
        #   negator = "unquenchable thirst" if (Rejuv && @battle.FE == :DESERT) && (opponent.hasType?(:GRASS) || opponent.hasType?(:WATER)) && @battle.pbWeather == :SUNNYDAY
        # end
        # if (Rejuv && @battle.FE == :SHORTCIRCUIT) && opponent.ability == :VOLTABSORB
        #   damageroll = @battle.field.getRoll(maximize_roll: (@battle.state.effects[:ELECTERRAIN] > 0))
        #   if opponent.pbRecoverHP(((opponent.totalhp/4.0)*damageroll).floor,true)>0
        #     @battle.pbDisplay(_INTL("{1}'s {2} restored its HP!",
        #       opponent.pbThis,negator))
        #   else
        #     @battle.pbDisplay(_INTL("{1}'s {2} made {3} useless!",
        #     opponent.pbThis,negator,@name))
        #   end
        # elsif opponent.pbRecoverHP((opponent.totalhp/4.0).floor,true)>0
        #   @battle.pbDisplay(_INTL("{1}'s {2} restored its HP!",
        #       opponent.pbThis,negator))
        # else
        #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} useless!",
        #   opponent.pbThis,negator,@name))
        # end
        # if @function==0xCB #Dive
        #   @battle.scene.pbUnVanishSprite(attacker)
        # end
        ### /MODDED
        return 0
      end
    end
    # Immunity Crests
    case opponent.crested
      when :SKUNTANK
        if (type == :GROUND || (!secondtype.nil? && secondtype.include?(:GROUND)))
          ### MODDED/ No actual effects
          # if opponent.pbCanIncreaseStatStage?(PBStats::ATTACK)
          #   opponent.pbIncreaseStatBasic(PBStats::ATTACK,1)
          #   @battle.pbCommonAnimation("StatUp",opponent,nil)
          #   @battle.pbDisplay(_INTL("{1}'s {2} raised its Attack!",
          #      opponent.pbThis,getItemName(opponent.item)))
          # else
          #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
          #      opponent.pbThis,getItemName(opponent.item),self.name))
          # end
          ### /MODDED
          return 0
        end
      when :DRUDDIGON
        if (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE)))
          if opponent.effects[:HealBlock]==0
            ### MODDED/ No actual effects
            # if opponent.pbRecoverHP((opponent.totalhp/4.0).floor,true)>0
            #   @battle.pbDisplay(_INTL("{1}'s {2} restored its HP!",
            #       opponent.pbThis,getItemName(opponent.item)))
            # else
            #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} useless!",
            #   opponent.pbThis,getItemName(opponent.item),@name))
            # end
            ### /MODDED
            return 0
          end
        end
      when :WHISCASH
        if (type == :GRASS || (!secondtype.nil? && secondtype.include?(:GRASS)))
          ### MODDED/ No actual effects
          # if opponent.pbCanIncreaseStatStage?(PBStats::ATTACK)
          #   opponent.pbIncreaseStatBasic(PBStats::ATTACK,1)
          #   @battle.pbCommonAnimation("StatUp",opponent,nil)
          #   @battle.pbDisplay(_INTL("{1}'s {2} raised its Attack!",
          #      opponent.pbThis,getItemName(opponent.item)))
          # else
          #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
          #      opponent.pbThis,getItemName(opponent.item),self.name))
          # end
          ### /MODDED
          return 0
        end
    end
    if (opponent.ability == :BULLETPROOF) && !(opponent.moldbroken)
      if (PBStuff::BULLETMOVE).include?(@move)
        ### MODDED/ No actual effects
        # @battle.pbDisplay(_INTL("{1}'s {2} blocked the attack!",
        # opponent.pbThis,getAbilityName(opponent.ability),self.name))
        ### /MODDED
        return 0
      end
    end
    if @battle.FE == :ROCKY && (opponent.effects[:Substitute]>0 || opponent.stages[PBStats::DEFENSE] > 0)
      if (PBStuff::BULLETMOVE).include?(@move)
        ### MODDED/ No actual effects
        # @battle.pbDisplay(_INTL("{1} hid behind a rock to dodge the attack!",
        # opponent.pbThis,getAbilityName(opponent.ability),self.name))
        ### /MODDED
        return 0
      end
    end
    if ((opponent.ability == :FLASHFIRE && !opponent.moldbroken) || 
      (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:BURNDRIVE))) && 
      (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE))) && @battle.FE != :FROZENDIMENSION
      ### MODDED/ No actual effects
      # negator = getAbilityName(opponent.ability)
      # negator = getItemName(opponent.item) if (Rejuv && @battle.FE == :GLITCH && opponent.species == :GENESECT && opponent.hasWorkingItem(:BURNDRIVE))
      # if !opponent.effects[:FlashFire]
      #   opponent.effects[:FlashFire]=true
      #   @battle.pbDisplay(_INTL("{1}'s {2} activated!",
      #      opponent.pbThis,negator))
      # else
      #   @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #      opponent.pbThis,negator,self.name))
      # end
      ### /MODDED
      return 0
    end
    if opponent.ability == :MAGMAARMOR && (type == :FIRE || (!secondtype.nil? && secondtype.include?(:FIRE))) &&
      (@battle.FE == :DRAGONSDEN || @battle.FE == :VOLCANICTOP || @battle.FE == :INFERNAL) && !(opponent.moldbroken)
      ### MODDED/ No actual effects
      # @battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
      #  opponent.pbThis,getAbilityName(opponent.ability),self.name))
      ### /MODDED
      return 0
    end
    #Telepathy
    if ((opponent.ability == :TELEPATHY  && !opponent.moldbroken) || @battle.FE == :HOLY) && @basedamage>0
      if opponent.index == attacker.pbPartner.index
        ### MODDED/ No actual effects
        # @battle.pbDisplay(_INTL("{1} avoids attacks by its ally Pokémon!",opponent.pbThis))
        ### /MODDED
        return 0
      end
    end
    # UPDATE Implementing Flying Press + Freeze Dry
    typemod=pbTypeModifier(type,attacker,opponent)
    typemod2= nil
    typemod3= nil
    if type == :FIRE && opponent.effects[:TarShot]
      typemod*=2
    end
    # Resistance-changing Crests
    if opponent.crested
      case opponent.species
      when :LUXRAY
        typemod /= 2 if (type == :GHOST || type == :DARK)
        typemod = 0 if type == :PSYCHIC 
      when :SAMUROTT
        typemod /= 2 if (type == :BUG || type == :DARK || type == :ROCK)
      when :LEAFEON
        typemod /= 4 if (type == :FIRE || type == :FLYING)
      when :GLACEON
        typemod /= 4 if (type == :ROCK || type == :FIGHTING)
      when :SIMISEAR
        typemod /= 2 if [:STEEL, :FIRE,:ICE].include?(type)
        typemod /= 2 if type == :WATER && @battle.FE != :UNDERWATER
      when :SIMIPOUR
        typemod /= 2 if [:GROUND,:WATER,:GRASS,:ELECTRIC].include?(type)
      when :SIMISAGE
        typemod /= 2 if [:BUG,:STEEL,:FIRE,:GRASS,:FAIRY].include?(type)
        typemod /= 2 if type == :ICE && @battle.FE != :GLITCH
      when :TORTERRA
        if !($game_switches[:Inversemode] ^ (@battle.FE == :INVERSE))
          typemod = 16 / typemod if typemod != 0
        end
      end
    end
    typemod *= 4 if @move == :FREEZEDRY && opponent.hasType?(:WATER)
    if @move == :CUT && opponent.hasType?(:GRASS) && ((!Rejuv && @battle.FE == :FOREST) || @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,2,5))
      typemod *= 2
    end
    if @move == :FLYINGPRESS
      if @battle.FE == :SKY
        if ((PBTypes.oneTypeEff(:FLYING, opponent.type1) > 2) || (PBTypes.oneTypeEff(:FLYING, opponent.type1) < 2 && $game_switches[:Inversemode]))
          typemod*=2
        end
        if ((PBTypes.oneTypeEff(:FLYING, opponent.type2) > 2) || (PBTypes.oneTypeEff(:FLYING, opponent.type2) < 2 && $game_switches[:Inversemode]))
          typemod*=2
        end
      else
        typemod2=pbTypeModifier(:FLYING,attacker,opponent)
        typemod3= ((typemod*typemod2)/4)
        typemod=typemod3
      end
    end

    # Field Effect second type changes 
    typemod=fieldTypeChange(attacker,opponent,typemod,false)
    typemod=overlayTypeChange(attacker,opponent,typemod,false)

    # Cutting typemod in half
    if @battle.pbWeather==:STRONGWINDS && (opponent.hasType?(:FLYING) && !opponent.effects[:Roost]) &&
      ((PBTypes.oneTypeEff(type, :FLYING) > 2) || (PBTypes.oneTypeEff(type, :FLYING) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.FE == :SNOWYMOUNTAIN && opponent.ability == :ICESCALES && opponent.hasType?(:ICE) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :ICE) > 2) || (PBTypes.oneTypeEff(type, :ICE) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
      typemod /= 2
    end
    if @battle.FE == :DRAGONSDEN && opponent.ability == :MULTISCALE && opponent.hasType?(:DRAGON) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :DRAGON) > 2) || (PBTypes.oneTypeEff(type, :DRAGON) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,4,5) && opponent.hasType?(:GRASS) && 
      ((PBTypes.oneTypeEff(type, :GRASS) > 2) || (PBTypes.oneTypeEff(type, :GRASS) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
       typemod /= 2
    end
    if @battle.FE == :BEWITCHED && opponent.hasType?(:FAIRY) && (opponent.ability == :PASTELVEIL || opponent.pbPartner.ability == :PASTELVEIL) && !(opponent.moldbroken) &&
      ((PBTypes.oneTypeEff(type, :FAIRY) > 2) || (PBTypes.oneTypeEff(type, :FAIRY) < 2 && ($game_switches[:Inversemode] || (@battle.FE == :INVERSE))))
      typemod /= 2
    end
    if typemod==0
      if @function==0x111
        return 1
      else
        ### MODDED/ No actual effects
        # @battle.pbDisplay(_INTL("It doesn't affect {1}...",opponent.pbThis(true)))
        # if PBStuff::TWOTURNMOVE.include?(@move)
        #   @battle.scene.pbUnVanishSprite(attacker)
        # end
        ### /MODDED
      end
    end
    return typemod
  end

  def movehelpdisplay_calcPower(attacker,opponent,options=0, hitnum: 0) # Based on PokeBattle_Move pbCalcPower
    ### MODDED/ no damagestate
    # opponent.damagestate.critical=false
    # opponent.damagestate.typemod=0
    # opponent.damagestate.calcdamage=0
    # opponent.damagestate.hplost=0
    ### /MODDED
    basedmg=@basedamage # From PBS file
    basedmg = [attacker.happiness,250].min if attacker.crested == :LUVDISC && basedmg != 0
    basedmg=pbBaseDamage(basedmg,attacker,opponent) # Some function codes alter base power
    ### MODDED/ add basedamage to return
    return 0, 0 if basedmg==0
    ### /MODDED
    basedmg = basedmg*0.3 if attacker.crested == :CINCCINO && !pbIsMultiHit
    ### MODDED/ crits only calculate if crit chance is 100%
    critchance = pbCritRate?(attacker,opponent) # 3 is 100%
    ### /MODDED
    stagemul=[2,2,2,2,2,2,2,3,4,5,6,7,8]
    stagediv=[8,7,6,5,4,3,2,2,2,2,2,2,2]
    type=pbType(attacker)
    ##### Calcuate base power of move #####
   
    basemult=1.0
    #classic prep stuff
    attitemworks = attacker.itemWorks?(true)
    oppitemworks = opponent.itemWorks?(true)
    case attacker.ability
      when :TECHNICIAN
        if basedmg<=60
          basemult*=1.5
        elsif (@battle.FE == :FACTORY || @battle.ProgressiveFieldCheck(PBFields::CONCERT)) && basedmg<=80
          basemult*=1.5
        end
      when :STRONGJAW     then basemult*=1.5 if (PBStuff::BITEMOVE).include?(@move)
      when :SHARPNESS     then basemult*=1.5 if sharpMove?
      when :TRUESHOT      then basemult*=1.3 if (PBStuff::BULLETMOVE).include?(@move)
      when :TOUGHCLAWS    then basemult*=1.3 if contactMove?
      when :IRONFIST
        if @battle.FE == :CROWD
          basemult*=1.2 if punchMove?
        else
          basemult*=1.2 if punchMove?
        end
      when :RECKLESS      then basemult*=1.2 if [0xFA,0xFD,0xFE,0x10B,0x506,0x130].include?(@function)
      when :FLAREBOOST    then basemult*=1.5 if (attacker.status== :BURN || @battle.FE == :BURNING || @battle.FE == :VOLCANIC || @battle.FE == :INFERNAL) && pbIsSpecial?(type) && @battle.FE != :FROZENDIMENSION
      when :TOXICBOOST    
        if (attacker.status== :POISON || @battle.FE == :CORROSIVE || @battle.FE == :CORROSIVEMIST || @battle.FE == :WASTELAND || @battle.FE == :MURKWATERSURFACE) && pbIsPhysical?(type)
          if @battle.FE == :CORRUPTED
            basemult*=2.0
          else
            basemult*=1.5
          end
        end
      when :PUNKROCK
        if isSoundBased?
          case @battle.FE
            when :BIGTOP then basemult*=1.5
            when :CAVE then basemult*=1.5
            else
              basemult*=1.3 
          end
        end
      when :RIVALRY       then basemult*= attacker.gender==opponent.gender ? 1.25 : 0.75 if attacker.gender!=2
      when :MEGALAUNCHER  then basemult*=1.5 if [:AURASPHERE,:DRAGONPULSE,:DARKPULSE,:WATERPULSE,:ORIGINPULSE,:TERRAINPULSE].include?(@move)
      when :SANDFORCE     then basemult*=1.3 if (@battle.pbWeather== :SANDSTORM || @battle.FE == :DESERT || @battle.FE == :ASHENBEACH) && (type == :ROCK || type == :GROUND || type == :STEEL)
      when :ANALYTIC      then basemult*=1.3 if (@battle.battlers.find_all {|battler| battler && battler.hp > 0 && !battler.hasMovedThisRound? }).length == 0
      when :SHEERFORCE    then basemult*=1.3 if effect > 0
      when :AERILATE 
        if @type == :NORMAL && type == :FLYING
          case @battle.FE
            when :MOUNTAIN,:SNOWYMOUNTAIN,:SKY then basemult*=1.5
            else
              basemult*=1.2
          end
        end
      when :GALVANIZE
        if @type == :NORMAL && type == :ELECTRIC
          case @battle.FE
            when :ELECTERRAIN,:FACTORY then basemult*=1.5
            when :SHORTCIRCUIT then basemult*=2
            else
              if @battle.state.effects[:ELECTERRAIN] > 0
                basemult*=1.5
              else 
                basemult*=1.2
              end
          end
        end
      when :REFRIGERATE 
        if @type == :NORMAL && type == :ICE
          case @battle.FE
            when :ICY,:SNOWYMOUNTAIN,:FROZENDIMENSION then basemult*=1.5
            else
              basemult*=1.2
          end
        end
      when :PIXILATE 
        if @type == :NORMAL && (type == :FAIRY || (type == :NORMAL && @battle.FE == :GLITCH))
          case @battle.FE
            when :MISTY then basemult*=1.5
            else
              if @battle.state.effects[:MISTY] > 0
                basemult*=1.5
              else 
                basemult*=1.2
              end
          end
        end
      when :DUSKILATE     then basemult*=1.2 if @type == :NORMAL && (type == :DARK || (type == :NORMAL && @battle.FE == :GLITCH))
      when :NORMALIZE     then basemult*=1.2 if !@zmove
      when :TRANSISTOR    then basemult*=1.5 if type == :ELECTRIC
      when :DRAGONSMAW    then basemult*=1.5 if type == :DRAGON
      when :TERAVOLT      then basemult*=1.5 if (Rejuv && @battle.FE == :ELECTERRAIN && type == :ELECTRIC)
      when :INEXORABLE    then basemult*=1.3 if type == :DRAGON && (!opponent.hasMovedThisRound? || @battle.switchedOut[opponent.index])
    end
    case opponent.ability
      when :HEATPROOF     then basemult*=0.5 if !(opponent.moldbroken) && type == :FIRE
      when :DRYSKIN       then basemult*=1.25 if !(opponent.moldbroken) && type == :FIRE
      when :TRANSISTOR    then basemult*=0.5 if (@battle.FE == :ELECTERRAIN && type == :GROUND) && !(opponent.moldbroken)
    end
    if attitemworks
      if $cache.items[attacker.item].checkFlag?(:typeboost) == type
        basemult*=1.2
        if $cache.items[attacker.item].checkFlag?(:gem)
          basemult*=1.0833 #gems are 1.3; 1.2 * 1.0833 = 1.3
          ### MODDED/ don't actually take gem
          # attacker.takegem=true
          # @battle.pbDisplay(_INTL("The {1} strengthened {2}'s power!",getItemName(attacker.item),self.name))
          ### /MODDED
        end
      else
        case attacker.item
          when :MUSCLEBAND then basemult*=1.1 if pbIsPhysical?(type)
          when :WISEGLASSES then basemult*=1.1 if pbIsSpecial?(type)
          when :LUSTROUSORB then basemult*=1.2 if (attacker.pokemon.species == :PALKIA) && (type == :DRAGON || type == :WATER)
          when :ADAMANTORB then basemult*=1.2 if (attacker.pokemon.species == :DIALGA) && (type == :DRAGON || type == :STEEL)
          when :GRISEOUSORB then basemult*=1.2 if (attacker.pokemon.species == :GIRATINA) && (type == :DRAGON || type == :GHOST)
          when :SOULDEW then basemult*=1.2 if (attacker.pokemon.species == :LATIAS || attacker.pokemon.species == :LATIOS) && (type == :DRAGON || type == :PSYCHIC)
        end
      end
    end
    basemult=pbBaseDamageMultiplier(basemult,attacker,opponent)
    # standard crest damage multipliers
    case attacker.crested
      when :FERALIGATR then basemult*=1.5 if (PBStuff::BITEMOVE).include?(@move) 
      when :CLAYDOL then basemult*=1.5 if isBeamMove?
      when :DRUDDIGON then basemult*=1.3 if (type == :DRAGON || type == :FIRE)
      when :BOLTUND then basemult*=1.5 if (PBStuff::BITEMOVE).include?(@move) && (!(opponent.hasMovedThisRound?) || @battle.switchedOut[opponent.index])
      when :FEAROW then basemult*=1.5 if (PBStuff::STABBINGMOVE).include?(@move)
      when :DUSKNOIR then basemult*=1.5 if (basedmg<=60 || ((@battle.FE == :FACTORY || @battle.ProgressiveFieldCheck(PBFields::CONCERT))&& basedmg<=80))
      when :CRABOMINABLE then basemult*=1.5 if attacker.lastHPLost>0
      when :AMPHAROS then basemult*= (attacker.hasType?(type) || attacker.ability == :PROTEAN || attacker.ability == :LIBERO) ? 1.2 : 1.5 if attacker.moves[0] == self
      when :LUXRAY then basemult *= 1.2 if @type == :NORMAL && type == :ELECTRIC
      when :SAWSBUCK  
        case attacker.form
        when 0 then basemult*=1.2 if @type == :NORMAL && type == :WATER
        when 1 then basemult*=1.2 if @type == :NORMAL && type == :FIRE
        when 2 then basemult*=1.2 if @type == :NORMAL && type == :GROUND
        when 3 then basemult*=1.2 if @type == :NORMAL && type == :ICE
        end
    end
    #type mods
    case type
      when :FIRE then basemult*=0.33 if @battle.state.effects[:WaterSport]>0
      when :ELECTRIC 
        basemult*=0.33 if @battle.state.effects[:MudSport]>0
        basemult*=2.0 if attacker.effects[:Charge]>0
      when :DARK 
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.66 : 1.33) if @battle.pbCheckGlobalAbility(:DARKAURA)
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.6 : 1.4) if @battle.pbCheckGlobalAbility(:DARKAURA) && @battle.FE==:DARKNESS1
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.5 : 1.5) if @battle.pbCheckGlobalAbility(:DARKAURA) && @battle.FE==:DARKNESS2
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.33 : 1.66) if @battle.pbCheckGlobalAbility(:DARKAURA) && @battle.FE==:DARKNESS3
      when :FAIRY 
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.66 : 1.33) if @battle.pbCheckGlobalAbility(:FAIRYAURA)
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.7 : 1.30) if @battle.pbCheckGlobalAbility(:FAIRYAURA)&& @battle.FE==:DARKNESS1
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.8 : 1.2) if @battle.pbCheckGlobalAbility(:FAIRYAURA)&& @battle.FE==:DARKNESS2
        basemult*= (@battle.pbCheckGlobalAbility(:AURABREAK) ? 0.9 : 1.1) if @battle.pbCheckGlobalAbility(:FAIRYAURA)&& @battle.FE==:DARKNESS3
    end
    ### MODDED/ helping hand not applied for base power boost
    # basemult*=1.5 if attacker.effects[:HelpingHand]
    ### /MODDED
    basemult*=1.5 if @move == :KNOCKOFF && !opponent.item.nil? && !@battle.pbIsUnlosableItem(opponent,opponent.item)
    basemult*=2.0 if opponent.effects[:Minimize] && @move == :MALICIOUSMOONSAULT # Minimize for z-move
    #Specific Field Effects
    ### MODDED/ prepare for field effect boosts
    oldbasemult = basemult
    ### /MODDED
    if @battle.field.isFieldEffect?
      fieldmult = moveFieldBoost
      if fieldmult != 1
        basemult*=fieldmult
        ### MODDED/ no messages
        # fieldmessage =moveFieldMessage
        # if fieldmessage && !@fieldmessageshown
        #   if [:LIGHTTHATBURNSTHESKY,:ICEHAMMER,:HAMMERARM,:CRABHAMMER].include?(@move) #some moves have a {1} in them and we gotta deal.
        #     @battle.pbDisplay(_INTL(fieldmessage,attacker.pbThis))
        #   elsif [:SMACKDOWN,:THOUSANDARROWS,:ROCKSLIDE,:VITALTHROW,:CIRCLETHROW,:STORMTHROW,:DOOMDUMMY,:BLACKHOLEECLIPSE,:TECTONICRAGE,:CONTINENTALCRUSH,:WHIRLWIND,:CUT].include?(@move)
        #     @battle.pbDisplay(_INTL(fieldmessage,opponent.pbThis))
        #   else
        #     @battle.pbDisplay(_INTL(fieldmessage))
        #   end
        #   @fieldmessageshown = true
        # end
        ### /MODDED
      end
    end
    case @battle.FE
      when :CHESS
        if (CHESSMOVES).include?(@move)
          basemult*=0.5 if [:ADAPTABILITY,:ANTICIPATION,:SYNCHRONIZE,:TELEPATHY].include?(opponent.ability)
          basemult*=2.0 if [:OBLIVIOUS,:KLUTZ,:UNAWARE,:SIMPLE].include?(opponent.ability) || opponent.effects[:Confusion]>0 || (Rejuv && opponent.ability == :DEFEATIST)
          ### MODDED/ no messages
          # @battle.pbDisplay("The chess piece slammed forward!") if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
        # Queen piece boost
        if attacker.pokemon.piece==:QUEEN || attacker.ability == :QUEENLYMAJESTY
          basemult*=1.5
          ### MODDED/ no messages
          # if attacker.pokemon.piece==:QUEEN
          #   @battle.pbDisplay("The Queen is dominating the board!")  && !@fieldmessageshown
          #   @fieldmessageshown = true
          # end
          ### /MODDED
        end

        #Knight piece boost
        if attacker.pokemon.piece==:KNIGHT && opponent.pokemon.piece==:QUEEN
          basemult=(basemult*3.0).round
          ### MODDED/ no messages
          # @battle.pbDisplay("An unblockable attack on the Queen!") if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      when :BIGTOP
        ### MODDED/ Cannot be certain about modifier
        # if ((type == :FIGHTING && pbIsPhysical?(type)) || (STRIKERMOVES).include?(@move)) # Continental Crush
        #   striker = 1+@battle.pbRandom(14)
        #   @battle.pbDisplay("WHAMMO!") if !@fieldmessageshown
        #   @fieldmessageshown = true
        #   if attacker.ability == :HUGEPOWER || attacker.ability == :GUTS || attacker.ability == :PUREPOWER || attacker.ability == :SHEERFORCE
        #     if striker >=9
        #       striker = 15
        #     else
        #       striker = 14
        #     end
        #   end
        #   strikermod = attacker.stages[PBStats::ATTACK]
        #   striker = striker + strikermod
        #   if striker >= 15
        #     @battle.pbDisplay("...OVER 9000!!!")
        #     provimult=3.0
        #   elsif striker >=13
        #     @battle.pbDisplay("...POWERFUL!")
        #     provimult=2.0
        #   elsif striker >=9
        #     @battle.pbDisplay("...NICE!")
        #     provimult=1.5
        #   elsif striker >=3
        #     @battle.pbDisplay("...OK!")
        #     provimult=1
        #   else
        #     @battle.pbDisplay("...WEAK!")
        #     provimult=0.5
        #   end
        #   provimult = ((provimult-1.0)/2.0)+1.0 if $game_variables[:DifficultyModes]==1 && !$game_switches[:FieldFrenzy]
        #   provimult = ((provimult-1.0)*2.0)+1.0 if $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy] && provimult > 1
        #   provimult = provimult/2.0 if $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy] && provimult < 1
        #   basemult*=provimult
        # end
        ### /MODDED
        if isSoundBased?
          provimult=1.5
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay("Loud and clear!") if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      ### MODDED/ doesn't affect damage, not relevant
      # when :ICY
      #   if (@priority >= 1 && @basedamage > 0 && contactMove? && attacker.ability != :LONGREACH) || (@move == :FEINT || @move == :ROLLOUT || @move == :DEFENSECURL || @move == :STEAMROLLER || @move == :LUNGE)
      #     if !attacker.isAirborne?
      #       if attacker.pbCanIncreaseStatStage?(PBStats::SPEED)
      #         attacker.pbIncreaseStatBasic(PBStats::SPEED,1)
      #         @battle.pbCommonAnimation("StatUp",attacker,nil)
      #         @battle.pbDisplay(_INTL("{1} gained momentum on the ice!",attacker.pbThis)) if !@fieldmessageshown
      #         @fieldmessageshown = true
      #       end
      #     end
      #   end
      ### /MODDED
      ### MODDED/ Cannot be certain about modifier
      # when :SHORTCIRCUIT
      #   if type == :ELECTRIC
      #     damageroll = @battle.field.getRoll(maximize_roll:(@battle.state.effects[:ELECTERRAIN] > 0))
      #     messageroll = ["Bzzt.", "Bzzapp!" , "Bzt...", "Bzap!", "BZZZAPP!"][PBStuff::SHORTCIRCUITROLLS.index(damageroll)]
      #     @battle.pbDisplay(messageroll) if !@fieldmessageshown
      #     damageroll = ((damageroll-1.0)/2.0)+1.0 if $game_variables[:DifficultyModes]==1 && !$game_switches[:FieldFrenzy]
      #     damageroll = ((damageroll-1.0)*2.0)+1.0 if $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy] && damageroll > 1
      #     damageroll = damageroll/2.0 if $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy] && damageroll < 1
      #     basemult*=damageroll

      #     @fieldmessageshown = true
      #   end
      ### /MODDED
      when :CAVE
        if isSoundBased?
          provimult=1.5
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("ECHO-Echo-echo!",opponent.pbThis)) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      when :MOUNTAIN
        if (PBFields::WINDMOVES).include?(@move) && @battle.pbWeather== :STRONGWINDS
          provimult=1.5
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The wind strengthened the attack!",opponent.pbThis)) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      when :SNOWYMOUNTAIN
        if (PBFields::WINDMOVES).include?(@move) && @battle.pbWeather== :STRONGWINDS
          provimult=1.5
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The wind strengthened the attack!",opponent.pbThis)) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      when :MIRROR
        if (PBFields::MIRRORMOVES).include?(@move) && opponent.stages[PBStats::EVASION]>0
          provimult=2.0
          provimult=1.5 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The beam was focused from the reflection!",opponent.pbThis)) if !@fieldmessageshown
          # @fieldmessageshown = true
        end
        # @battle.field.counter = 0
        ### /MODDED
      when :DEEPEARTH
        if (priorityCheck(attacker) > 0) && @basedamage > 0
          provimult=0.7
          provimult=0.85 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The intense pull slowed the attack...")) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
        if (priorityCheck(attacker) < 0) && @basedamage > 0
          provimult=1.3
          provimult=1.15 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("Slow and heavy!")) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      when :CONCERT1,:CONCERT2,:CONCERT3,:CONCERT4
        if isSoundBased?
          provimult=1.5
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          basemult*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("Loud and clear!")) if !@fieldmessageshown
          # @fieldmessageshown = true
          ### /MODDED
        end
      ### MODDED/ no messages
      # when :DARKNESS3,:DARKNESS2
      #   if [:LIGHTTHATBURNSTHESKY].include?(@move)
      #     @battle.pbDisplay(_INTL("One brings Shadow, One brings the Light!")) if !@fieldmessageshown
      #     @fieldmessageshown = true
      #   end
      ### /MODDED
    end
    if Rejuv
      for terrain in [:ELECTERRAIN,:GRASSY,:MISTY,:PSYTERRAIN]
        if @battle.state.effects[terrain] > 0
          overlaymult = moveOverlayBoost(terrain)
          if overlaymult != 1
            basemult*=overlaymult
            ### MODDED/ no messages
            # overlaymessage = moveOverlayMessage(terrain)
            # @battle.pbDisplay(_INTL(overlaymessage)) if overlaymessage
            ### /MODDED
          end
        end
      end
    end
    #End S.Field Effects
    ##### Calculate attacker's attack stat #####
    ### MODDED/ Stat stages are not taken into account for calculating power
    # case @function
    #   when 0x121 # Foul Play
    #     atk=opponent.attack
    #     atkstage=opponent.stages[PBStats::ATTACK]+6
    #   when 0x184 # Body Press
    #     atk=attacker.defense
    #     atkstage=attacker.stages[PBStats::DEFENSE]+6
    #   else
    #     atk=attacker.attack
    #     atkstage=attacker.stages[PBStats::ATTACK]+6
    # end
    # if pbIsSpecial?(type)
    #   atk=attacker.spatk
    #   atkstage=attacker.stages[PBStats::SPATK]+6
    #   if @function==0x121 # Foul Play
    #     atk=opponent.spatk
    #     atkstage=opponent.stages[PBStats::SPATK]+6
    #   end
    #   if @battle.FE == :GLITCH
    #     atk = attacker.getSpecialStat(opponent.ability == :UNAWARE)
    #     atkstage = 6 #getspecialstat handles unaware
    #   end
    # end
    # # Stat-Copy Crests, ala Claydol//Dedenne
    # case attacker.crested
    #   when :CLAYDOL then atkstage=attacker.stages[PBStats::DEFENSE]+6 if pbIsSpecial?(type)
    #   when :DEDENNE then atkstage=attacker.stages[PBStats::SPEED]+6 if !pbIsSpecial?(type)
    # end
    # if opponent.ability != :UNAWARE || opponent.moldbroken
    #   atkstage=6 if opponent.damagestate.critical && atkstage<6
    #   atk=(atk*1.0*stagemul[atkstage]/stagediv[atkstage]).floor
    # end
    ### /MODDED
    if attacker.ability == :HUSTLE && pbIsPhysical?(type)
      atk= [:BACKALLEY,:CITY].include?(@battle.FE) ? (atk*1.75).round : (atk*1.5).round
    end
    atkmult=1.0
    if @battle.FE == :HAUNTED || @battle.FE == :BEWITCHED || @battle.FE == :HOLY || @battle.FE == :PSYTERRAIN || @battle.FE == :DEEPEARTH
      atkmult*=1.5 if attacker.pbPartner.ability == :POWERSPOT
    else
      atkmult*=1.3 if attacker.pbPartner.ability == :POWERSPOT
    end
    #pinch abilities
    if (@battle.FE == :BURNING || @battle.FE == :VOLCANIC || @battle.FE == :INFERNAL) && (attacker.ability == :BLAZE && type == :FIRE)
      atkmult*=1.5
    elsif @battle.FE == :VOLCANICTOP && (attacker.ability == :BLAZE && type == :FIRE) && attacker.effects[:Blazed]
      atkmult*=1.5
    elsif (@battle.FE == :FOREST || (Rejuv && @battle.FE == :GRASSY)) && (attacker.ability == :OVERGROW && type == :GRASS)
      atkmult*=1.5
    elsif @battle.FE == :FOREST && (attacker.ability == :SWARM && type == :BUG)
      atkmult*=1.5
    elsif (@battle.FE == :WATERSURFACE || @battle.FE == :UNDERWATER) && (attacker.ability == :TORRENT && type == :WATER)
      atkmult*=1.5
    elsif @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN) && (attacker.ability == :SWARM && type == :BUG)
      atkmult*=1.5 if @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,1,2)
      atkmult*=1.8 if @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,3,4)
      atkmult*=2.0 if @battle.FE == :FLOWERGARDEN5
    elsif @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,2,5) && (attacker.ability == :OVERGROW && type == :GRASS)
      case @battle.FE
        when :FLOWERGARDEN2 then atkmult*=1.5 if attacker.hp<=(attacker.totalhp*0.67).floor
        when :FLOWERGARDEN3 then atkmult*=1.6
        when :FLOWERGARDEN4 then atkmult*=1.8
        when :FLOWERGARDEN5 then atkmult*=2.0
      end
    elsif attacker.hp<=(attacker.totalhp/3.0).floor
      if (attacker.ability == :OVERGROW && type == :GRASS) || (attacker.ability == :BLAZE && type == :FIRE && @battle.FE != :FROZENDIMENSION) ||
        (attacker.ability == :TORRENT && type == :WATER) || (attacker.ability == :SWARM && type == :BUG)
        atkmult*=1.5
      end
    end
    case attacker.ability
      when :GUTS then atkmult*=1.5 if !attacker.status.nil? && pbIsPhysical?(type)
      when :PLUS, :MINUS
        if pbIsSpecial?(type) && @battle.FE != :GLITCH
          partner=attacker.pbPartner
          if partner.ability == :PLUS || partner.ability == :MINUS
            atkmult*=1.5
          elsif @battle.FE == :SHORTCIRCUIT || (Rejuv && @battle.FE == :ELECTERRAIN) || @battle.state.effects[:ELECTERRAIN] > 0
            atkmult*=1.5
          end
        end
      when :DEFEATIST then atkmult*=0.5 if attacker.hp<=(attacker.totalhp/2.0).floor
      when :HUGEPOWER then atkmult*=2.0 if pbIsPhysical?(type)
      when :PUREPOWER
        if @battle.FE == :PSYTERRAIN || @battle.state.effects[:PSYTERRAIN] > 0
          atkmult*=2.0 if pbIsSpecial?(type)
        else
          atkmult*=2.0 if pbIsPhysical?(type)
        end
      when :SOLARPOWER then atkmult*=1.5 if (@battle.pbWeather== :SUNNYDAY && !(attitemworks && attacker.item == :UTILITYUMBRELLA)) && pbIsSpecial?(type) && (@battle.FE != :GLITCH &&  @battle.FE != :FROZENDIMENSION)
      when :SLOWSTART then atkmult*=0.5 if attacker.turncount<5 && pbIsPhysical?(type) && !@battle.FE == :DEEPEARTH
      when :GORILLATACTICS then atkmult*=1.5 if pbIsPhysical?(type)
      when :QUARKDRIVE then atkmult*=1.3 if (attacker.effects[:Quarkdrive][0] == PBStats::ATTACK && pbIsPhysical?(type)) || (attacker.effects[:Quarkdrive][0] == PBStats::SPATK && pbIsSpecial?(type))
    end

    # Mid Battle stat multiplying crests; Spiritomb Crest, Castform Crest
    case attacker.crested
      when :CASTFORM then atkmult*=1.5 if attacker.form == 1 && (@battle.pbWeather== :SUNNYDAY && !(attitemworks && attacker.item == :UTILITYUMBRELLA)) && pbIsSpecial?(type) && (@battle.FE != :GLITCH &&  @battle.FE != :FROZENDIMENSION)
      when :SPIRITOMB
          allyfainted = attacker.pbFaintedPokemonCount
          modifier = (allyfainted * 0.2) + 1.0
          atkmult=(atkmult*modifier).round
    end
    atkmult*=1.5 if attacker.flowerGiftActive? && pbIsPhysical?(type)
    atkmult*=1.5 if attacker.pbPartner.flowerGiftActive? && pbIsPhysical?(type)
    if (@battle.pbWeather== :SUNNYDAY) && pbIsPhysical?(type)
      atkmult*=1.5 if attacker.ability == :SOLARIDOL 
    end
    if (@battle.pbWeather== :HAIL) && pbIsSpecial?(type)
      atkmult*=1.5 if attacker.ability == :LUNARIDOL
    end
    if attacker.pbPartner.ability == (:BATTERY) && pbIsSpecial?(type) && @battle.FE != :GLITCH
      if Rejuv && @battle.FE == :ELECTERRAIN
        atkmult*=1.5
      else
        atkmult*=1.3
      end
    end
    if @battle.FE == :FAIRYTALE
      atkmult*=2.0 if (attacker.pbPartner.ability == :STEELYSPIRIT || attacker.ability == :STEELYSPIRIT) && type == :STEEL
    else
      atkmult*=1.5 if (attacker.pbPartner.ability == :STEELYSPIRIT || attacker.ability == :STEELYSPIRIT) && type == :STEEL
    end
    atkmult*=1.5 if attacker.effects[:FlashFire] && type == :FIRE && @battle.FE != :FROZENDIMENSION

    if attitemworks
      case attacker.item
        when :THICKCLUB then atkmult*=2.0 if attacker.pokemon.species == :CUBONE || attacker.pokemon.species == :MAROWAK && pbIsPhysical?(type)
        when :DEEPSEATOOTH then atkmult*=2.0 if attacker.pokemon.species == :CLAMPERL && pbIsSpecial?(type) && @battle.FE != :GLITCH
        when :LIGHTBALL then atkmult*=2.0 if attacker.pokemon.species == :PIKACHU && @battle.FE != :GLITCH
        when :CHOICEBAND then atkmult*=1.5 if pbIsPhysical?(type)
        when :CHOICESPECS then atkmult*=1.5 if pbIsSpecial?(type) && @battle.FE != :GLITCH
      end
    end
    if @battle.FE != :INDOOR
      if @battle.FE == :STARLIGHT || @battle.FE == :NEWWORLD
        if attacker.ability == :VICTORYSTAR
          atkmult*=1.5
        end
        partner=attacker.pbPartner
        if partner && partner.ability == :VICTORYSTAR
          atkmult*=1.5
        end
      end
      if @battle.FE == :WATERSURFACE
        atkmult*=1.5 if attacker.ability == :PROPELLERTAIL && @priority >= 1 && @basedamage > 0
      end
      if @battle.FE == :UNDERWATER 
        ### MODDED/ treat attacker as though water type if protean using a water move
        atkmult*=0.5 if (!Rejuv || !attacker.hasType?(:WATER) || ((attacker.ability == :PROTEAN || attacker.ability == :LIBERO) && type == :WATER)) && pbIsPhysical?(type) && type != :WATER && attacker.ability != :STEELWORKER && attacker.ability != :SWIFTSWIM
        ### /MODDED
        atkmult*=1.5 if attacker.ability == :PROPELLERTAIL && @priority >= 1 && @basedamage > 0
      end
      if Rejuv && @battle.FE == :CHESS
        atkmult*=1.2 if attacker.ability == :GORILLATACTICS || attacker.ability == :RECKLESS
        atkmult*=1.2 if attacker.ability == :ILLUSION && attacker.effects[:Illusion]!=nil
        if attacker.ability == :COMPETITIVE
          frac = (1.0*attacker.hp)/(1.0*attacker.totalhp)
          multiplier = 1.0  
          multiplier += ((1.0-frac)/0.8)  
          if frac < 0.2  
            multiplier = 2.0  
          end  
          atkmult=(atkmult*multiplier)
        end
      end
      case attacker.ability
        when :QUEENLYMAJESTY then atkmult*=1.5 if @battle.FE == :FAIRYTALE
        when :LONGREACH then atkmult*=1.5 if (@battle.FE == :MOUNTAIN || @battle.FE == :SNOWYMOUNTAIN || @battle.FE == :SKY)
        when :CORROSION then atkmult*=1.5 if (@battle.FE == :CORROSIVE || @battle.FE == :CORROSIVEMIST || @battle.FE == :CORRUPTED)
        when :SKILLLINK then atkmult*=1.2 if (@battle.FE == :COLOSSEUM && (@function == 0xC0 || @function == 0x307 || (attacker.crested == :CINCCINO && !pbIsMultiHit))) #0xC0: 2-5 hits; 0x307: Scale Shot
      end
    end
    atkmult*=0.5 if opponent.ability == :THICKFAT && (type == :ICE || type == :FIRE) && !(opponent.moldbroken)

    ##### Calculate opponent's defense stat #####
    defense=opponent.defense
    defstage=opponent.stages[PBStats::DEFENSE]+6
    # TODO: Wonder Room should apply around here
    
    ### MODDED/ don't apply stat stages
    # applysandstorm=false
    # if pbHitsSpecialStat?(type)
    #   defense=opponent.spdef
    #   defstage=opponent.stages[PBStats::SPDEF]+6
    #   applysandstorm=true
    #   if @battle.FE == :GLITCH
    #     defense = opponent.getSpecialStat(attacker.ability == :UNAWARE)
    #     defstage = 6 # getspecialstat handles unaware
    #     applysandstorm=false # getSpecialStat handles sandstorm
    #   end
    # end
    # if attacker.ability != :UNAWARE
    #   defstage=6 if @function==0xA9 # Chip Away (ignore stat stages)
    #   defstage=6 if opponent.damagestate.critical && defstage>6
    #   defense=(defense*1.0*stagemul[defstage]/stagediv[defstage]).floor
    # end
    if @battle.pbWeather== :SANDSTORM && opponent.hasType?(:ROCK) && pbHitsSpecialStat?(type)
      defense=(defense*1.5).round
    end
    ### /MODDED
    defmult=1.0
    defmult*=0.5 if @battle.FE == :GLITCH && @function==0xE0
    defmult*=0.5 if attacker.crested == :ELECTRODE && pbHitsPhysicalStat?(type)
    # Field Effect defense boost
    defmult*=fieldDefenseBoost(type,opponent)

    #Abilities defense boost
    ### MODDED/ don't count def multipliers
    # case opponent.ability
    #   when :ICESCALES then defmult*=2.0 if pbIsSpecial?(type) && !(opponent.moldbroken)
    #   when :MARVELSCALE then defmult*=1.5 if (pbIsPhysical?(type) && (!opponent.status.nil? || ([:MISTY,:RAINBOW,:FAIRYTALE,:DRAGONSDEN,:STARLIGHT].include?(@battle.FE) || @battle.state.effects[:MISTY] > 0))) && !(opponent.moldbroken)
    #   when :GRASSPELT then defmult*=1.5 if pbIsPhysical?(type) && (@battle.FE == :GRASSY || @battle.FE == :FOREST || @battle.state.effects[:GRASSY] > 0) # Grassy Field
    #   when :FURCOAT then defmult*=2.0 if pbIsPhysical?(type) && !(opponent.moldbroken)
    #   when :PUNKROCK then defmult*=2.0 if isSoundBased? && !(opponent.moldbroken)
    #   when :QUARKDRIVE then defmult*=1.3 if (opponent.effects[:Quarkdrive][0] == PBStats::DEFENSE && pbIsPhysical?(type)) || (opponent.effects[:Quarkdrive][0] == PBStats::SPDEF && pbIsSpecial?(type))
    #   when :FLUFFY
    #     defmult*=2.0 if contactMove? && attacker.ability != :LONGREACH && !(opponent.moldbroken)
    #     defmult*=4.0 if contactMove? && attacker.ability != :LONGREACH && @battle.FE == :CLOUDS  && !(opponent.moldbroken)
    #     defmult*=0.5 if type == :FIRE && !(opponent.moldbroken)
    # end
    # if !opponent.moldbroken && pbIsSpecial?(type)
    #   defmult*=1.5 if opponent.flowerGiftActive?
    #   defmult*=1.5 if opponent.pbPartner.flowerGiftActive?
    # end
    # #Item defense boost
    # if opponent.hasWorkingItem(:EVIOLITE) && !(@battle.FE == :GLITCH && pbIsSpecial?(type)) 
    #   evos=pbGetEvolvedFormData(opponent.pokemon.species,opponent.pokemon)
    #   if evos && evos.length>0
    #     defmult*=1.5
    #   end
    # end
    # if opponent.item == :PIKANIUMZ && opponent.pokemon.species == :PIKACHU && !(@battle.FE == :GLITCH && pbIsSpecial?(type)) 
    #   defmult*=1.5
    # end
    # if opponent.item == :LIGHTBALL && opponent.pokemon.species == :PIKACHU && !(@battle.FE == :GLITCH && pbIsSpecial?(type)) 
    #   defmult*=1.5
    # end
    # if opponent.hasWorkingItem(:ASSAULTVEST) && pbIsSpecial?(type) && @battle.FE != :GLITCH
    #   defmult*=1.5
    # end
    # if opponent.hasWorkingItem(:DEEPSEASCALE) && @battle.FE != :GLITCH && (opponent.pokemon.species == :CLAMPERL) && pbIsSpecial?(type)
    #   defmult*=2.0
    # end
    # if opponent.hasWorkingItem(:METALPOWDER) && (opponent.pokemon.species == :DITTO) && !opponent.effects[:Transform] && pbIsPhysical?(type)
    #   defmult*=2.0
    # end
    ### /MODDED

    #General damage modifiers
    damage = 1.0
    # Multi-targeting attacks

    ### MODDED/ no calculating midway through
    if pbTargetsAll?(attacker)# || attacker.midwayThroughMove
      if attacker.pokemon.piece == :KNIGHT && battle.FE == :CHESS && @target==:AllOpposing
        # @battle.pbDisplay(_INTL("The knight forked the opponents!")) if !attacker.midwayThroughMove
        damage*=1.25
      else
        damage*=0.75
      end
      # attacker.midwayThroughMove = true
    end
    ### /MODDED
    # Field Effects
    fieldBoost = typeFieldBoost(type,attacker,opponent)
    overlayBoost, overlay = typeOverlayBoost(type,attacker,opponent)
    if fieldBoost != 1 || overlayBoost != 1
      if fieldBoost > 1 && overlayBoost > 1
        boost = [fieldBoost,overlayBoost].max
        if $game_variables[:DifficultyModes]==1 && !$game_switches[:FieldFrenzy]
          boost = 1.25 if boost < 1.25
        elsif $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy]
          boost = 2.0 if boost < 2.0
        else
          boost = 1.5 if boost < 1.5
        end
      else
        boost = fieldBoost*overlayBoost
      end
      damage*=boost
      ### MODDED/ no messages
      # fieldmessage = typeFieldMessage(type) if fieldBoost != 1
      # overlaymessage = typeOverlayMessage(type,overlay) if overlay
      # if overlaymessage && !fieldmessage
      #   @battle.pbDisplay(_INTL(overlaymessage)) if !@fieldmessageshown_type
      # else
      #   @battle.pbDisplay(_INTL(fieldmessage)) if fieldmessage && !@fieldmessageshown_type
      # end
      # @fieldmessageshown_type = true
      ### /MODDED
    end
    case @battle.FE
      when :MOUNTAIN,:SNOWYMOUNTAIN
        if type == :FLYING && !pbIsPhysical?(type) && @battle.pbWeather== :STRONGWINDS
          provimult=1.5 
          provimult=1.25 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          damage*=provimult
        end
      when :DEEPEARTH
        if type == :GROUND && opponent.hasType?(:GROUND)
          provimult=0.5
          provimult=0.75 if $game_variables[:DifficultyModes]==1 && !$game_switches[:FieldFrenzy]
          provimult=0.25 if $game_variables[:DifficultyModes]!=1 && $game_switches[:FieldFrenzy]
          damage*=provimult
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The dense earth is difficult to mold...")) if !@fieldmessageshown_type
          # @fieldmessageshown_type = true
          ### /MODDED
        end
    end
    case @battle.pbWeather
      when :SUNNYDAY
        if @battle.state.effects[:HarshSunlight] && type == :WATER
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The Water-type attack evaporated in the harsh sunlight!"))
          # @battle.scene.pbUnVanishSprite(attacker) if @function==0xCB #Dive
          ### /MODDED
          ### MODDED/ add basedamage to return
          return basedmg, 0
          ### /MODDED
        end
      when :RAINDANCE
        if @battle.state.effects[:HeavyRain] && type == :FIRE
          ### MODDED/ no messages
          # @battle.pbDisplay(_INTL("The Fire-type attack fizzled out in the heavy rain!"))
          ### /MODDED
          ### MODDED/ add basedamage to return
          return basedmg, 0
          ### /MODDED
        end
    end
    # FIELD TRANSFORMATIONS
    fieldmove = @battle.field.moveData(@move)
    if fieldmove && fieldmove[:fieldchange]
      change_conditions = @battle.field.fieldChangeData
      handled = change_conditions[fieldmove[:fieldchange]] ? eval(change_conditions[fieldmove[:fieldchange]]) : true
      #don't continue if conditions to change are not met or if a multistage field changes to a different stage of itself
      if handled  && !(@battle.ProgressiveFieldCheck("All") && (PBFields::CONCERT.include?(fieldmove[:fieldchange]) || PBFields::FLOWERGARDEN.include?(fieldmove[:fieldchange]) || PBFields::DARKNESS.include?(fieldmove[:fieldchange])))
        provimult=1.3 
        provimult=1.15 if $game_variables[:DifficultyModes]==1
        provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
        damage*=provimult
      end
    end
    case @battle.FE
      when :FACTORY
        if (@move == :DISCHARGE) || (@move == :OVERDRIVE)
          ### MODDED/ no messages
          # @battle.setField(:SHORTCIRCUIT)
          # @battle.pbDisplay(_INTL("The field shorted out!"))
          ### /MODDED
          provimult=1.3 
          provimult=1.15 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          damage*=provimult
        end
      when :SHORTCIRCUIT
        if (@move == :DISCHARGE) || (@move == :OVERDRIVE)
          ### MODDED/ no messages
          # @battle.setField(:FACTORY)
          # @battle.pbDisplay(_INTL("SYSTEM ONLINE."))
          ### /MODDED
          provimult=1.3 
          provimult=1.15 if $game_variables[:DifficultyModes]==1
          provimult = ((provimult-1.0)*2.0)+1.0 if $game_switches[:FieldFrenzy]
          damage*=provimult
        end
    end

    case type
      when :FIRE
        damage*=1.5 if @battle.weather == :SUNNYDAY
        damage*=0.5 if @battle.weather == :RAINDANCE
        damage*=0.5 if opponent.ability == :WATERBUBBLE
      when :WATER
        damage*=1.5 if @battle.weather == :RAINDANCE
        damage*=0.5 if @battle.weather == :SUNNYDAY
        damage*=2 if attacker.ability == :WATERBUBBLE
    end
    # Critical hits
    ### MODDED/ damagestate -> crit chance
    if critchance == 3
      damage*=1.5
      damage*=1.5 if attacker.ability == :SNIPER
    end
    ### /MODDED
    # STAB-addition from Crests 
    typecrest = false
    case attacker.crested
      when :EMPOLEON then typecrest = true if type == :ICE
      when :LUXRAY then typecrest = true if type == :DARK
      when :SAMUROTT then typecrest = true if type == :FIGHTING
      when :SIMISEAR then typecrest = true if type == :WATER
      when :SIMIPOUR then typecrest = true if type == :GRASS
      when :SIMISAGE then typecrest = true if type == :FIRE
      when :ZOROARK
        party = @battle.pbPartySingleOwner(attacker.index)
        party=party.find_all {|item| item && !item.egg? && item.hp>0 }
        if party[party.length-1] != attacker.pokemon
          typecrest = true if party[party.length-1].hasType?(type)
        end
      end
    # STAB
    ### MODDED/ treat attacker as though move type if protean
    if ((attacker.hasType?(type) || attacker.ability == :PROTEAN || attacker.ability == :LIBERO) && (!attacker.effects[:DesertsMark])|| (attacker.ability == :STEELWORKER && type == :STEEL)  || (attacker.ability == :SOLARIDOL && type == :FIRE) || (attacker.ability == :LUNARIDOL && type == :ICE) || typecrest==true)
      ### /MODDED
      if attacker.ability == :ADAPTABILITY
        damage*=2.0
      elsif (attacker.ability == :STEELWORKER && type == :STEEL) && @battle.FE == :FACTORY # Factory Field
        damage*=2.0
      else
        damage*=1.5
      end
      if attacker.crested == :SILVALLY
        damage*=1.2
      end
    end
    # Type effectiveness
    ### MODDED/ use non-messaging equivalent
    typemod=movehelpdisplay_typeMod(type,attacker,opponent)
    ### /MODDED
    damage=(damage*typemod/4.0)
    ### MODDED/ no damage state
    # opponent.damagestate.typemod=typemod
    if typemod==0
      # opponent.damagestate.calcdamage=0
      # opponent.damagestate.critical=false
      ### MODDED/ add basedamage to return
      return basedmg, 0
      ### /MODDED
    end
    ### /MODDED
    damage*=0.5 if attacker.status== :BURN && pbIsPhysical?(type) && attacker.ability != :GUTS && @move != :FACADE
    ### MODDED/ no random variance accounted for
    # Random Variance
    # if !$game_switches[:No_Damage_Rolls] || @battle.isOnline?
    #   random = 85+@battle.pbRandom(16)
    # elsif $game_switches[:No_Damage_Rolls] || !@battle.isOnline?
    #   random = 93
    # end
    # random = 85 if @battle.FE == :CONCERT1
    # random = 100 if @battle.FE == :CONCERT4
    # damage = (damage*(random/100.0))
    ### /MODDED

    # Final damage modifiers
    finalmult=1.0

    ### MODDED/ no damagestate
    if critchance != 3 && attacker.ability != :INFILTRATOR
      # Screens
      if @category!=:status && opponent.pbOwnSide.screenActive?(betterCategory(type))
        finalmult*= (!opponent.pbPartner.isFainted? || attacker.midwayThroughMove) ? 0.66 : 0.5
      end
      if opponent.pbOwnSide.effects[:AreniteWall] > 0 && typemod>4
        finalmult*= 0.5
      end
    end
    ### /MODDED
    finalmult*=0.67 if opponent.crested == :BEHEEYEM && (!opponent.hasMovedThisRound? || @battle.switchedOut[opponent.index])
    secondtypes = self.getSecondaryType(attacker)
    finalmult*=0.5 if opponent.effects[:Shelter] && @battle.FE != :INDOOR && (type == @battle.field.mimicry || !secondtypes.nil? && secondtypes.include?(@battle.field.mimicry))
    finalmult*=0.5 if ((opponent.ability == :MULTISCALE && !(opponent.moldbroken)) && opponent.hp==opponent.totalhp)
    finalmult*=0.5 if opponent.ability == :SHADOWSHIELD && (opponent.hp==opponent.totalhp || @battle.FE == :DIMENSIONAL)
    finalmult*=0.33 if opponent.ability == :SHADOWSHIELD && (opponent.hp==opponent.totalhp && (@battle.FE == :DARKNESS2 || @battle.FE == :DARKNESS3 ))
    ### MODDED/ no damagestate
    finalmult*=2.0 if attacker.ability == :TINTEDLENS && typemod<4
    ### /MODDED
    finalmult*=2.0 if attacker.ability == :EXECUTION && (opponent.hp <= (opponent.totalhp/2).floor)
    finalmult*=0.75 if opponent.pbPartner.ability == :FRIENDGUARD && !(opponent.moldbroken)
    finalmult*=0.5 if (opponent.ability == :PASTELVEIL || opponent.pbPartner.ability == :PASTELVEIL) && @type == :POISON && (@battle.FE == :MISTY || @battle.FE == :RAINBOW || (@battle.state.effects[:MISTY] > 0))
    if @battle.ProgressiveFieldCheck(PBFields::FLOWERGARDEN,3,5)
      if (opponent.pbPartner.ability == :FLOWERVEIL && opponent.hasType?(:GRASS)) || (opponent.ability == :FLOWERVEIL && !(opponent.moldbroken))
        finalmult*=0.5
        ### MODDED/ no messages
        # @battle.pbDisplay(_INTL("The Flower Veil softened the attack!"))
        ### /MODDED
      end
      if opponent.hasType?(:GRASS)
        case @battle.FE
          when :FLOWERGARDEN3 then finalmult*=0.75
          when :FLOWERGARDEN4 then finalmult*=0.66
          when :FLOWERGARDEN5 then finalmult*=0.5
        end
      end
    end
    ### MODDED/ no damagestate
    finalmult*=0.75 if (((opponent.ability == :SOLIDROCK || opponent.ability == :FILTER) && !opponent.moldbroken) || opponent.ability == :PRISMARMOR) && typemod>4
    ### /MODDED
    finalmult*=0.75 if opponent.ability == :SHADOWSHIELD && [:STARLIGHT, :NEWWORLD, :DARKCRYSTALCAVERN].include?(@battle.FE)
    ### MODDED/ no damagestate
    finalmult*=0.70 if opponent.crested == :AMPHAROS && opponent.damagestate.typemod>4
    ### /MODDED
    finalmult*=2.0 if attacker.ability == :STAKEOUT && @battle.switchedOut[opponent.index]
    finalmult*=[1.0+attacker.effects[:Metronome]*0.2,2.0].min if (attitemworks && attacker.item == :METRONOME) && attacker.movesUsed[-2] == attacker.movesUsed[-1]
    finalmult*=[1.0+attacker.effects[:Metronome]*0.2,2.0].min if @battle.FE == :CONCERT4 && attacker.movesUsed[-2] == attacker.movesUsed[-1]
    ### MODDED/ no damagestate, type berries aren't displayed
    finalmult*=1.2 if (attitemworks && attacker.item == :EXPERTBELT) && typemod > 4
    finalmult*=1.25 if (attacker.ability == :NEUROFORCE) && typemod > 4
    finalmult*=1.3 if (attitemworks && attacker.item == :LIFEORB)
    # if opponent.damagestate.typemod>4 && opponent.itemWorks?
    #   hasberry = false
    #   case type
    #     when :FIGHTING   then hasberry = (opponent.item == :CHOPLEBERRY)
    #     when :FLYING     then hasberry = (opponent.item == :COBABERRY)
    #     when :POISON     then hasberry = (opponent.item == :KEBIABERRY)
    #     when :GROUND     then hasberry = (opponent.item == :SHUCABERRY)
    #     when :ROCK       then hasberry = (opponent.item == :CHARTIBERRY)
    #     when :BUG        then hasberry = (opponent.item == :TANGABERRY)
    #     when :GHOST      then hasberry = (opponent.item == :KASIBBERRY)
    #     when :STEEL      then hasberry = (opponent.item == :BABIRIBERRY)
    #     when :FIRE       then hasberry = (opponent.item == :OCCABERRY)
    #     when :WATER      then hasberry = (opponent.item == :PASSHOBERRY)
    #     when :GRASS      then hasberry = (opponent.item == :RINDOBERRY)
    #     when :ELECTRIC   then hasberry = (opponent.item == :WACANBERRY)
    #     when :PSYCHIC    then hasberry = (opponent.item == :PAYAPABERRY)
    #     when :ICE        then hasberry = (opponent.item == :YACHEBERRY)
    #     when :DRAGON     then hasberry = (opponent.item == :HABANBERRY)
    #     when :DARK       then hasberry = (opponent.item == :COLBURBERRY)
    #     when :FAIRY      then hasberry = (opponent.item == :ROSELIBERRY)
    #   end
    # end
    # hasberry = true if opponent.hasWorkingItem(:CHILANBERRY) && type == :NORMAL
    # if hasberry && !([:UNNERVE,:ASONE].include?(attacker.ability) || [:UNNERVE,:ASONE].include?(attacker.pbPartner.ability))
    #   finalmult*=0.5
    #   finalmult*=0.5 if opponent.ability == :RIPEN
    #   opponent.pbDisposeItem(true)
    #   if !@battle.pbIsOpposing?(attacker.index)
    #     @battle.pbDisplay(_INTL("{2}'s {1} weakened the damage from the attack!",getItemName(opponent.pokemon.itemRecycle),opponent.pbThis))
    #   else
    #     @battle.pbDisplay(_INTL("The {1} weakened the damage to {2}!",getItemName(opponent.pokemon.itemRecycle),opponent.pbThis))
    #   end
    # end
    ### /MODDED
    finalmult*=0.8 if (opponent.crested == :MEGANIUM || opponent.pbPartner.crested == :MEGANIUM)
    if attacker.crested == :SEVIPER
      multiplier = 0.5*(opponent.pokemon.hp*1.0)/(opponent.pokemon.totalhp*1.0)
      multiplier += 1.0
      finalmult=(finalmult*multiplier)
    end
    ### MODDED/ don't take protect into account
    # if @zmove
    #   if (opponent.pbOwnSide.effects[:MatBlock] || opponent.effects[:Protect] || 
    #     opponent.effects[:KingsShield] || opponent.effects[:Obstruct] ||
    #     opponent.effects[:SpikyShield] || opponent.effects[:BanefulBunker] ||
    #     opponent.pbOwnSide.effects[:WideGuard] && (@target == :AllOpposing || @target == :AllNonUsers))
    #     if @move ==:UNLEASHEDPOWER
    #       @battle.pbDisplay(_INTL("The Interceptor's power broke through {1}'s Protect!",opponent.pbThis))
    #     elsif !opponent.effects[:ProtectNegation]
    #       @battle.pbDisplay(_INTL("{1} couldn't fully protect itself!",opponent.pbThis))
    #       finalmult=(finalmult/4)
    #     end
    #   end
    # end
    ### /MODDED
    finalmult=pbModifyDamage(finalmult,attacker,opponent)
    ##### Main damage calculation #####
    ### MODDED/ We want base power
    return basedmg, basedmg*basemult*damage*finalmult
    
    # totaldamage=(((((2.0*attacker.level/5+2).floor*basedmg*atk/defense).floor/50.0).floor+1)*damage*finalmult).round
    # totaldamage=1 if totaldamage < 1
    # return totaldamage
    ### /MODDED
  end

  def movehelpdisplay_calcAccuracy(attacker,opponent=nil)
    baseaccuracy=self.accuracy
    # Field Effects
    fieldmove = @battle.field.moveData(@move)
    baseaccuracy = fieldmove[:accmod] if fieldmove && fieldmove[:accmod]
    ### MODDED/ use -1 instead of true; remove opponent-centric accuracy checks such as no guard (but not minimize!), toxic counts protean
    return -1 if baseaccuracy==0
    return -1 if attacker.ability == :NOGUARD || (attacker.ability == (:FAIRYAURA) && @battle.FE == :FAIRYTALE)
    return -1 if @function==0x0D && @battle.pbWeather== :HAIL # Blizzard
    return -1 if (@function==0x08 || @function==0x15) && @battle.pbWeather== :RAINDANCE # Thunder, Hurricane
    return -1 if @type == :ELECTRIC && @battle.FE == :UNDERWATER
    return -1 if (attacker.hasType?(:POISON) || attacker.ability == :PROTEAN || attacker.ability == :LIBERO) && @move == :TOXIC
    return -1 if opponent && (@function==0x10 || @move == :BODYSLAM ||
                              @function==0x137 || @function==0x9B) &&
                              opponent.effects[:Minimize] # Flying Press, Stomp, DRush
    return -1 if @battle.FE == :MIRROR && (PBFields::BLINDINGMOVES + [:MIRRORSHOT]).include?(@move)
    ### /MODDED
    # One-hit KO accuracy handled elsewhere
    if @function==0x08 || @function==0x15 # Thunder, Hurricane
      baseaccuracy=50 if (@battle.pbWeather== :SUNNYDAY && !attacker.hasWorkingItem(:UTILITYUMBRELLA))
    end
    accstage=attacker.stages[PBStats::ACCURACY]
    ### MODDED/ handle no opponent case
    accstage=0 if opponent && opponent.ability == :UNAWARE && !(opponent.moldbroken)
    ### /MODDED
    accuracy=(accstage>=0) ? (accstage+3)*100.0/3 : 300.0/(3-accstage)
    ### MODDED/ evasion defaults to 0 without opponent
    evastage=0
    evastage=opponent.stages[PBStats::EVASION] if opponent
    evastage-=2 if @battle.state.effects[:Gravity]!=0
    evastage=-6 if evastage<-6
    evastage=0 if (opponent && opponent.effects[:Foresight]) || (opponent && opponent.effects[:MiracleEye]) || @function==0xA9 || # Chip Away
                  (opponent && attacker.ability == :UNAWARE && !(opponent.moldbroken)) # should this be attacker?
    evasion=(evastage>=0) ? (evastage+3)*100.0/3 : 300.0/(3-evastage)
    ### /MODDED
    if attacker.ability == :COMPOUNDEYES
      accuracy*=1.3
    end
    if attacker.hasWorkingItem(:MICLEBERRY)
      if (attacker.ability == :GLUTTONY && attacker.hp<=(attacker.totalhp/2.0).floor) ||
        attacker.hp<=(attacker.totalhp/4.0).floor
        accuracy*=1.2
        ### MODDED/ don't actually dispose of item
        # attacker.pbDisposeItem(true)
        ### /MODDED
      end
    end
    if attacker.ability == :VICTORYSTAR
      accuracy*=1.1
    end
    partner=attacker.pbPartner
    if partner && partner.ability == :VICTORYSTAR
      accuracy*=1.1
    end
    if attacker.hasWorkingItem(:WIDELENS)
      accuracy*=1.1
    end
    # Hypno Crest, Stantler Crest
    if [:HYPNO,:STANTLER,:WYRDEER].include?(attacker.crested)
      accuracy *= 1.5
    end
    ### MODDED/ handle no opponent case
    if attacker.hasWorkingItem(:ZOOMLENS) && (!opponent || attacker.speed < opponent.speed)
      accuracy*=1.2
    end
    ### /MODDED
    if attacker.ability == :HUSTLE && @basedamage>0 && pbIsPhysical?(pbType(attacker))
      accuracy*= [:BACKALLEY,:CITY].include?(@battle.FE) ? 0.67 : 0.8
    end
    if attacker.ability == :LONGREACH && (@battle.FE == :ROCKY || (!Rejuv && @battle.FE == :FOREST)) # Rocky/ Forest Field
      accuracy*=0.9
    end
    ### MODDED/ handle no opponent case
    if opponent && (opponent.ability == :WONDERSKIN || (Rejuv && @battle.FE == :PSYTERRAIN && opponent.ability == :MAGICIAN)) && 
      @basedamage==0 && attacker.pbIsOpposing?(opponent.index) && !(opponent.moldbroken)
      if @battle.FE == :RAINBOW
        accuracy*=0
      else
        accuracy*=0.5
      end
    end
    if opponent && opponent.ability == :TANGLEDFEET && opponent.effects[:Confusion]>0 && !(opponent.moldbroken)
      evasion*=1.2
    end
    if opponent && opponent.ability == :SANDVEIL && (@battle.pbWeather== :SANDSTORM || @battle.FE == :DESERT || @battle.FE == :ASHENBEACH) && !(opponent.moldbroken)
      evasion*=1.2
    end
    if opponent && opponent.ability == :SNOWCLOAK && (@battle.pbWeather== :HAIL || @battle.FE == :ICY || @battle.FE == :SNOWYMOUNTAIN || @battle.FE == :FROZENDIMENSION) && !(opponent.moldbroken)
      evasion*=1.2
    end
    if opponent && opponent.hasWorkingItem(:BRIGHTPOWDER)
      evasion*=1.1
    end
    if opponent && opponent.hasWorkingItem(:LAXINCENSE)
      evasion*=1.1
    end
    ### /MODDED
    evasion = 100 if attacker.ability == :KEENEYE
    ### MODDED/ handle no opponent case
    evasion = 100 if @battle.FE == :ASHENBEACH && (attacker.ability == :OWNTEMPO || attacker.ability == :INNERFOCUS || attacker.ability == :PUREPOWER || attacker.ability == :SANDVEIL || attacker.ability == :STEADFAST) && (!opponent || opponent.ability != :UNNERVE || opponent.ability != :ASONE)
    ### /MODDED
    ### MODDED/ return accuracy rate
    return [100, baseaccuracy*accuracy/evasion].min
    ### /MODDED
  end
end


class PokeBattle_Scene

  def pbToggleMoveInfo(battler, cw)
    @sprites["bbui_moveinfo"].visible = !@sprites["bbui_moveinfo"].visible
    pbUpdateMoveInfoWindow(battler, cw)
  end

  alias :movehelpdisplay_old_pbUpdateSelected :pbUpdateSelected

  def pbUpdateSelected(index)
    movehelpdisplay_old_pbUpdateSelected(index)

    cw = @sprites["fightwindow"]
    if index != -1 && cw.visible && MoveHelpDisplay.currentIndex != -1 && index != MoveHelpDisplay.lastTargetIndex
      pbUpdateMoveInfoWindow(@battle.battlers[MoveHelpDisplay.currentIndex], cw, index)
    end
  end

  alias :movehelpdisplay_old_pbChooseTarget :pbChooseTarget

  def pbChooseTarget(index)
    MoveHelpDisplay.currentIndex = index
    ret = movehelpdisplay_old_pbChooseTarget(index)
    MoveHelpDisplay.currentIndex = -1
    return ret
  end

  alias :movehelpdisplay_old_pbChooseTargetAcupressure :pbChooseTargetAcupressure
  def pbChooseTargetAcupressure(index)
    MoveHelpDisplay.currentIndex = index
    ret = movehelpdisplay_old_pbChooseTargetAcupressure(index)
    MoveHelpDisplay.currentIndex = -1
    return ret
  end

  #-----------------------------------------------------------------------------
  # Draws the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbUpdateMoveInfoWindow(battler, cw, foeindex=-1)
    MoveHelpDisplay.lastTargetIndex = foeindex
    bm = @sprites["bbui_moveinfo"].bitmap
    bm.clear
    return if !@sprites["bbui_moveinfo"].visible
    xpos = 0
    ypos = 76
    move = battler.moves[cw.index].clone
    if cw.zButton == 2 && !battler.zmoves.nil? && !battler.zmoves[cw.index].nil?
      move = battler.zmoves[cw.index]
    end
    powBase   = accBase   = priBase   = effBase   = MoveHelpDisplay::BASE_LIGHT
    powShadow = accShadow = priShadow = effShadow = MoveHelpDisplay::SHADOW_LIGHT
    basePower = move.basedamage

    if basePower != 0 && battler.crested == :CINCCINO && !move.pbIsMultiHit
      basePower *= 0.3 
    end

    knownFoe = nil

    if @battle.doublebattle
      if foeindex != -1
        knownFoe = @battle.battlers[foeindex]
      end
      knownFoe = battler.pbOpposing2 if battler.pbOpposing1.isFainted?
      knownFoe = battler.pbOpposing1 if battler.pbOpposing2.isFainted?
    else
      knownFoe = battler.pbOpposing1
      knownFoe = battler.pbOpposing2 if knownFoe.isFainted? && !battler.pbOpposing2.isFainted?
    end

    betterBattleUI_withForm(battler) do
      if knownFoe.nil?
        power = defined?(hpSummary_trueDamage) ? hpSummary_trueDamage(move, battler.pokemon) : move.basedamage
      else
        basePower, power = move.movehelpdisplay_calcPower(battler, knownFoe)

        if move.function == 0x91 && battler.effects[:FuryCutter] < 4 # Fury Cutter
          basePower *= 2
          power *= 2
        end
      end

      category = move.betterCategory
      if MoveHelpDisplay::USES_SMART_DAMAGE_CATEGORY.include?(move.function) # Moves which basically choose category but don't pretend to
        if knownFoe.nil?
          category = PokeBattle_Move.pbFromPBMove(battler.battle, PBMove.new(:PHOTONGEYSER), battler).betterCategory
        else
          tempMove = PokeBattle_Move.pbFromPBMove(battler.battle, PBMove.new(:UNLEASHEDPOWER), battler)
          tempMove.smartDamageCategory(battler, knownFoe)
          category = tempMove.betterCategory
        end
      end

      type = move.pbType(battler)
      secondtype = move.getSecondaryType(battler)

      #---------------------------------------------------------------------------
      cattype = 2
      case category
        when :physical then cattype = 0
        when :special  then cattype = 1
        when :status   then cattype = 2
      end

      # Draws images.
      if secondtype.nil?
        imagePos = [[sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type),          xpos,       ypos,     0, 0,            512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type),          xpos,       ypos,     0, 168,          512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type),          xpos,       ypos,     0, 336,          512, 168],
                    [sprintf("Graphics/Icons/type%s", type),                              xpos + 282, ypos + 8, 0, 0,            64,  28],
                    ["Graphics/Pictures/category",                                        xpos + 350, ypos + 8, 0, cattype * 28, 64,  28]]
      elsif secondtype.length == 1
        imagePos = [[sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type),          xpos,       ypos,     0, 0,            512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", secondtype[0]), xpos,       ypos,     0, 168,          512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", secondtype[0]), xpos,       ypos,     0, 336,          512, 168],
                    [sprintf("Graphics/Icons/type%s", type),                              xpos + 284, ypos + 8, 0, 0,            64,  28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[0]),                 xpos + 348, ypos + 8, 0, 0,            28,  28],
                    ["Data/Mods/BetterBattleUI/minicategory",                             xpos + 384, ypos + 8, 0, cattype * 28, 28,  28]]
      else

        imagePos = [[sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", type),          xpos,       ypos,     0, 0,            512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", secondtype[0]), xpos,       ypos,     0, 168,          512, 168],
                    [sprintf("Data/Mods/BetterBattleUI/MoveBGs/moveBg%s", secondtype[1]), xpos,       ypos,     0, 336,          512, 168],
                    [sprintf("Graphics/Icons/minitype%s", type),                          xpos + 282, ypos + 8, 0, 0,            28,  28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[0]),                 xpos + 310, ypos + 8, 0, 0,            28,  28],
                    [sprintf("Graphics/Icons/minitype%s", secondtype[1]),                 xpos + 338, ypos + 8, 0, 0,            28,  28],
                    ["Data/Mods/BetterBattleUI/minicategory",                             xpos + 386, ypos + 8, 0, cattype * 28, 28,  28]]
      end

      pbDrawMoveFlagIcons(battler, xpos, ypos, move, imagePos)
      pbDrawImagePositions(bm, imagePos)
      #---------------------------------------------------------------------------
      # Final move attribute calculations.
      acc = move.movehelpdisplay_calcAccuracy(battler, knownFoe)
      pri = move.priorityCheck(battler)
      chance = move.effect
      baseChance = chance
      if basePower > 1
        if power > basePower
          powBase, powShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
        elsif power < basePower
          powBase, powShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
        end
      end

      if acc > 0
        if acc > move.accuracy
          accBase, accShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
        elsif acc < move.accuracy
          accBase, accShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
        end
      elsif move.accuracy != 0
        accBase, accShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
      end

      if pri != 0
        if pri > move.priority
          priBase, priShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
        elsif pri < move.priority
          priBase, priShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
        end
      end

      if chance > 0
        if chance > baseChance
          effBase, effShadow = MoveHelpDisplay::BASE_RAISED, MoveHelpDisplay::SHADOW_RAISED
        elsif chance < baseChance
          effBase, effShadow = MoveHelpDisplay::BASE_LOWERED, MoveHelpDisplay::SHADOW_LOWERED
        end
      end
      #---------------------------------------------------------------------------
      # Draws text.
      textPos = []
      displayPower    = (power  == 0 && basePower == 0) ? "-" : (power == 1) ? "?" : power.ceil.to_s
      displayAccuracy = (acc    <= 0)                   ? "-" : acc.ceil.to_s
      displayPriority = (pri    == 0)                   ? "-" : (pri > 0) ? "+" + pri.to_s : pri.to_s
      displayChance   = (chance == 0 || chance == 100)  ? "-" : chance.ceil.to_s + "%"
      textPos.push(
        [move.getMoveUseName, xpos + 10,  ypos + 14, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT, true],
        [_INTL("Pow"),        xpos + 256, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
        [displayPower,        xpos + 309, ypos + 44, 2, powBase,                  powShadow],
        [_INTL("Acc"),        xpos + 348, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
        [displayAccuracy,     xpos + 401, ypos + 44, 2, accBase,                  accShadow],
        [_INTL("Pri"),        xpos + 442, ypos + 44, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
        [displayPriority,     xpos + 484, ypos + 44, 2, priBase,                  priShadow],
        [_INTL("Eff"),        xpos + 428, ypos + 14, 0, MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT],
        [displayChance,       xpos + 484, ypos + 14, 2, effBase,                  effShadow]
      )
      # textPos.push([bonus[0], xpos + 8, ypos + 132, 0, bonus[1], bonus[2], true]) if bonus
      pbDrawTextPositions(bm, textPos)

      desc = getMoveDesc(move.move)
      desc.gsub! /—/, '-'
      desc.strip!

      normtext=getLineBrokenChunks(bm,desc,Graphics.width - 12,nil,true)
      linecount = normtext[-1][2] / 32 + 1
      textheight = 26
      textheight = 21 if linecount > 3
      for i in normtext
        i[2] = (i[2] >> 5) * textheight
      end
      renderLineBrokenChunksWithShadow(bm,xpos + 8,ypos+70,normtext,84,
         MoveHelpDisplay::BASE_LIGHT, MoveHelpDisplay::SHADOW_LIGHT)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Draws the move flag icons for each move in the Move Info UI.
  #-----------------------------------------------------------------------------
  def pbDrawMoveFlagIcons(battler, xpos, ypos, move, imagePos)
    flagX = xpos + 6
    flagY = ypos + 40
    icons = 0
    flags = []
    for flag in MoveHelpDisplay::FLAGS_TO_CHECK
      if flag.is_a?(Array)
        if flag.length == 2
          flags.push(flag[0]) if move.hasFlag?(flag[0]) || flag[1].include?(move.move)
        elsif flag.length == 3
          flags.push(flag[0]) if move.hasFlag?(flag[0]) || flag[1].include?(move.move) || flag[2].include?(move.function)
        end
      else
        flags.push(flag) if move.hasFlag?(flag)
      end
    end
    flags.push(:bypassprotect) if move.move == :FIRSTIMPRESSION && battler.battle.FE == :COLOSSEUM
    flags.delete(:zmove) if flags.include?(:intercept)
    flags.each do |flag|
      break if icons > 8
      path = sprintf("Data/Mods/BetterBattleUI/MoveFlags/%s", flag)
      next if !pbResolveBitmap(path)
      imagePos.push([path, flagX + (icons * 26), flagY, 0, 0, 26, 28])
      icons += 1
    end
  end
end