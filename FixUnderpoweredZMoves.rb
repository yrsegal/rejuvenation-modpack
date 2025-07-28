# fake moves/ Only required for fake z moves

# Not real items, only used for the purposes of mapping these types. The move data will be overwritten.
# AI can't properly handle calling shadow/glitch moves from Nature Power, but that's fine, since none are callable that way.
PBStuff::CRYSTALTOZMOVE[:SHADOWIUMZ] = :BREAKNECKBLITZ
PBStuff::TYPETOZCRYSTAL[:SHADOW] = :SHADOWIUMZ
PBStuff::CRYSTALTOZMOVE[:GLITCHIUMZ] = :BREAKNECKBLITZ
PBStuff::TYPETOZCRYSTAL[:QMARKS] = :GLITCHIUMZ

# Replaces animation, name, and desc of move.
class PokeBattle_Move

  alias :underpowerz_old_initialize :initialize

  def initialize(battle,move,user,zbase=nil)
    underpowerz_old_initialize(battle, move, user, zbase)
    if @move == :BREAKNECKBLITZ && zbase
      ztype = user.is_a?(PokeBattle_Battler) ? zbase.pbType(user, zbase.type) : zbase.type
      if [:SHADOW, :QMARKS].include?(ztype)
        @type = ztype
        if ztype == :SHADOW
          @name = "Malice Manifest"
          @desc = "The user concentrates its hatred into a single strike with the full force of its Z-Power. The power varies, depending on the original move."
        elsif ztype == :QMARKS
          @name = "World Shatter"
          @desc = "The user breaks the bindings of the world around the target with the full force of its Z-Power. The power varies, depending on the original move."
        end
      end
    end
  end
end

class PokeBattle_Move_000
  alias :underpowerz_old_pbShowAnimation :pbShowAnimation

  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if @type == :SHADOW && @move == :BREAKNECKBLITZ
        @battle.pbAnimation(:DARKVOID,attacker,opponent,hitnum)
        @battle.pbCommonAnimation("SilvallyHoly", opponent)
        return
      elsif @type == :QMARKS && @move == :BREAKNECKBLITZ
        @battle.pbCommonAnimation("GlitchE")
        @battle.pbAnimation(:SPACIALREND,attacker,opponent,hitnum)
        return
      end
    end

    underpowerz_old_pbShowAnimation(id, attacker, opponent, hitnum, alltargets, showanimation)
  end
end
# /fake moves

$UNDERPOWERZ_TRUE_BASETYPES = pbHashForwardizer({
  NORMAL: [
    # Weather Ball
    :WEATHERBALLSUN, :WEATHERBALLRAIN, :WEATHERBALLHAIL, :WEATHERBALLSAND,
    # Techno Blast
    :TECHNOBLASTELECTRIC, :TECHNOBLASTFIRE, :TECHNOBLASTICE, :TECHNOBLASTWATER,
    # Multi-Attack
    :MULTIATTACKBUG, :MULTIATTACKDARK, :MULTIATTACKDRAGON, :MULTIATTACKELECTRIC, :MULTIATTACKFAIRY,
    :MULTIATTACKFIGHTING, :MULTIATTACKFIRE, :MULTIATTACKFLYING, :MULTIATTACKGHOST, :MULTIATTACKGLITCH,
    :MULTIATTACKGRASS, :MULTIATTACKGROUND, :MULTIATTACKICE, :MULTIATTACKPOISON, :MULTIATTACKPSYCHIC,
    :MULTIATTACKROCK, :MULTIATTACKSTEEL, :MULTIATTACKWATER,
    # Judgment
    :JUDGMENTBUG, :JUDGMENTDARK, :JUDGMENTDRAGON, :JUDGMENTELECTRIC, :JUDGMENTFAIRY,
    :JUDGMENTFIGHTING, :JUDGMENTFIRE, :JUDGMENTFLYING, :JUDGMENTGHOST, :JUDGMENTQMARKS,
    :JUDGMENTGRASS, :JUDGMENTGROUND, :JUDGMENTICE, :JUDGMENTPOISON, :JUDGMENTPSYCHIC,
    :JUDGMENTROCK, :JUDGMENTSTEEL, :JUDGMENTWATER,
    # Hidden Power
    :HIDDENPOWERNOR, :HIDDENPOWERFIR, :HIDDENPOWERFIG, :HIDDENPOWERWAT, :HIDDENPOWERFLY, :HIDDENPOWERGRA,
    :HIDDENPOWERPOI, :HIDDENPOWERELE, :HIDDENPOWERGRO, :HIDDENPOWERPSY, :HIDDENPOWERROC, :HIDDENPOWERICE,
    :HIDDENPOWERBUG, :HIDDENPOWERDRA, :HIDDENPOWERGHO, :HIDDENPOWERDAR, :HIDDENPOWERSTE, :HIDDENPOWERFAI],
  ELECTRIC: [
    # Aura Wheel
    :AURAWHEELMINUS]
})

class PokeBattle_Scene

  # Required to update moves that aren't simple transformations, like weather ball
  alias :underpowerz_old_pbFightMenu :pbFightMenu

  def pbFightMenu(index)
    battler=@battle.battlers[index]
    if battler.zmoves
      for i in 0...battler.zmoves.length
        battler.underpowerz_updatez(i)
      end
    end
    return underpowerz_old_pbFightMenu(index)
  end
end

class PokeBattle_Battle

  # I'm making Hidden Power upgrade properly, because it would do so for NPCs with the proper forced-Hidden-Power moves already
  alias :underpowerz_old_updateZMoveIndexBattler :updateZMoveIndexBattler

  def updateZMoveIndexBattler(index,battler)
    underpowerz_old_updateZMoveIndexBattler(index,battler)
    battler.underpowerz_updatez(index)
  end
end

class PokeBattle_Move

  alias :underpowerz_old_ZMoveBaseDamage :ZMoveBaseDamage

  def ZMoveBaseDamage(oldmove)
    case oldmove.move
    # Canonical Z-move powers
    when :LANDSWRATH     then return 185
    when :THOUSANDARROWS then return 180
    when :ENDEAVOR       then return 160
    # LGPE/Gen 8 moves which need handling
    when :MISTYEXPLOSION then return 200 # It's an explosion it gets to be 200
    when :TERRAINPULSE   then return 160 # Same as Weather Ball
    when :DRAGONENERGY   then return 200 # Same as Eruption and Water Spout
    when :BARBBARRAGE    then return 160 # Same as Hex
    when :INFERNALPARADE then return 160 # Same as Hex
    # Rejuv exclusive moves
    when :FEVERPITCH     then return 140 # Same as Magnitude
    end

    if oldmove.function == 0x070 # OHKO
      return 180
    end

    base = nil
    if oldmove.pbIsMultiHit
      factor = 1

      if [0x0BD, # Hit twice
          0x0BE, # Twineedle
          0x17E, # Dragon Darts
          0x20C, # Gilded Helix
          0x778  # Double Iron Bash
         ].include?(oldmove.function)
        factor = 2

      elsif [0x0C0, # 2-5x multihit (use average of 3)
             0x206, # Probopass Special
             0x307, # Scale Shot
             0x319  # Surging Strikes
            ].include?(oldmove.function)
        factor = 3

      elsif oldmove.function == 0x0BF # Triple Kick
        factor = 6 # 1x + 2x + 3x
      end

      if factor > 1
        base = oldmove.basedamage
        oldmove.basedamage *= factor
      end
    end

    ret = underpowerz_old_ZMoveBaseDamage(oldmove)

    oldmove.basedamage = base if base
    return ret
  end
end

class PokeBattle_Battler

  def underpowerz_updatez(index)
    zcrystal_to_type = PBStuff::TYPETOZCRYSTAL.invert
    if zcrystal_to_type[@item]
      move = @moves[index]
      type = move.type
      treattype = $UNDERPOWERZ_TRUE_BASETYPES[move.move] || type # The base type to treat the move as.
      truetype = move.pbType(self, type)
      if treattype == zcrystal_to_type[@item] && (type != truetype || type != treattype)
        newmove = PBMove.new(PBStuff::CRYSTALTOZMOVE[PBStuff::TYPETOZCRYSTAL[truetype]])
        @zmoves[index] = PokeBattle_Move.pbFromPBMove(@battle, newmove, self, move)
      end
    end
  end

  alias :underpowerz_old_pbInitPokemon :pbInitPokemon

  def pbInitPokemon(pkmn,pkmnIndex)
    underpowerz_old_pbInitPokemon(pkmn,pkmnIndex)
    if !pkmn.zmoves.nil?
      for i in 0...pkmn.zmoves.length
        zmove = pkmn.zmoves[i]
        @zmoves[i] = PokeBattle_Move.pbFromPBMove(@battle,zmove,self,@moves[i]) if !zmove.nil?
        underpowerz_updatez(index)
      end
    end
  end

  def pbZStatus(move,attacker)
    z_effect_hash = pbHashForwardizer({
      [PBStats::ATTACK,1] => [:BULKUP,:HONECLAWS,:HOWL,:LASERFOCUS,:LEER,:MEDITATE,:ODORSLEUTH,:POWERTRICK,:ROTOTILLER,:SCREECH,:SHARPEN,
        :TAILWHIP, :TAUNT,:TOPSYTURVY,:WILLOWISP,:WORKUP,:COACHING,:POWERSHIFT,:DESERTSMARK],
      [PBStats::ATTACK,2] =>   [:MIRRORMOVE,:OCTOLOCK],
      [PBStats::ATTACK,3] =>   [:SPLASH],
      [PBStats::DEFENSE,1] =>   [:AQUARING,:BABYDOLLEYES,:BANEFULBUNKER,:BLOCK,:CHARM,:DEFENDORDER,:FAIRYLOCK,:FEATHERDANCE,
        :FLOWERSHIELD,:GRASSYTERRAIN,:GROWL,:HARDEN,:MATBLOCK,:NOBLEROAR,:PAINSPLIT,:PLAYNICE,:POISONGAS,
        :POISONPOWDER,:QUICKGUARD,:REFLECT,:ROAR,:SPIDERWEB,:SPIKES,:SPIKYSHIELD,:STEALTHROCK,:STRENGTHSAP,
        :TEARFULLOOK,:TICKLE,:TORMENT,:TOXIC,:TOXICSPIKES,:VENOMDRENCH,:WIDEGUARD,:WITHDRAW,:ARENITEWALL],
      [PBStats::SPATK,1] => [:CONFUSERAY,:ELECTRIFY,:EMBARGO,:FAKETEARS,:GEARUP,:GRAVITY,:GROWTH,:INSTRUCT,:IONDELUGE,
        :METALSOUND,:MINDREADER,:MIRACLEEYE,:NIGHTMARE,:PSYCHICTERRAIN,:REFLECTTYPE,:SIMPLEBEAM,:SOAK,:SWEETKISS,
        :TEETERDANCE,:TELEKINESIS,:MAGICPOWDER],
      [PBStats::SPATK,2] => [:HEALBLOCK,:PSYCHOSHIFT,:TARSHOT],
      [PBStats::SPATK,3] => [],
      [PBStats::SPDEF,1] => [:CHARGE,:CONFIDE,:COSMICPOWER,:CRAFTYSHIELD,:EERIEIMPULSE,:ENTRAINMENT,:FLATTER,:GLARE,:INGRAIN,
        :LIGHTSCREEN,:MAGICROOM,:MAGNETICFLUX,:MEANLOOK,:MISTYTERRAIN,:MUDSPORT,:SPOTLIGHT,:STUNSPORE,:THUNDERWAVE,
        :WATERSPORT,:WHIRLWIND,:WISH,:WONDERROOM,:CORROSIVEGAS,:SHELTER],
      [PBStats::SPDEF,2] => [:AROMATICMIST,:CAPTIVATE,:IMPRISON,:MAGICCOAT,:POWDER],
      [PBStats::SPEED,1] => [:AFTERYOU,:AURORAVEIL,:ELECTRICTERRAIN,:ENCORE,:GASTROACID,:GRASSWHISTLE,:GUARDSPLIT,:GUARDSWAP,
        :HAIL,:HYPNOSIS,:LOCKON,:LOVELYKISS,:POWERSPLIT,:POWERSWAP,:QUASH,:RAINDANCE,:ROLEPLAY,:SAFEGUARD,
        :SANDSTORM,:SCARYFACE,:SING,:SKILLSWAP,:SLEEPPOWDER,:SPEEDSWAP,:STICKYWEB,:STRINGSHOT,:SUNNYDAY,
        :SUPERSONIC,:TOXICTHREAD,:WORRYSEED,:YAWN],
      [PBStats::SPEED,2] => [:ALLYSWITCH,:BESTOW,:MEFIRST,:RECYCLE,:SNATCH,:SWITCHEROO,:TRICK],
      [PBStats::ACCURACY,1]   => [:COPYCAT,:DEFENSECURL,:DEFOG,:FOCUSENERGY,:MIMIC,:SWEETSCENT,:TRICKROOM],
      [PBStats::EVASION,1]   => [:CAMOUFLAGE,:DETECT,:FLASH,:KINESIS,:LUCKYCHANT,:MAGNETRISE,:SANDATTACK,:SMOKESCREEN],
      [:allstat1]  => [:CONVERSION,:FORESTSCURSE,:GEOMANCY,:PURIFY,:SKETCH,:TRICKORTREAT,:CELEBRATE,:TEATIME,:STUFFCHEEKS, :HAPPYHOUR],
      [:crit1]  => [:ACUPRESSURE,:FORESIGHT,:HEARTSWAP,:SLEEPTALK,:TAILWIND],
      [:reset]  => [:ACIDARMOR,:AGILITY,:AMNESIA,:ATTRACT,:AUTOTOMIZE,:BARRIER,:BATONPASS,:CALMMIND,:COIL,:COTTONGUARD,
        :COTTONSPORE,:DARKVOID,:DISABLE,:DOUBLETEAM,:DRAGONDANCE,:ENDURE,:FLORALHEALING,:FOLLOWME,:HEALORDER,
        :HEALPULSE,:HELPINGHAND,:IRONDEFENSE,:KINGSSHIELD,:LEECHSEED,:MILKDRINK,:MINIMIZE,:MOONLIGHT,:MORNINGSUN,
        :NASTYPLOT,:PERISHSONG,:PROTECT,:QUIVERDANCE,:RAGEPOWDER,:RECOVER,:REST,:ROCKPOLISH,:ROOST,:SHELLSMASH,
        :SHIFTGEAR,:SHOREUP,:SHELLSMASH,:SHIFTGEAR,:SHOREUP,:SLACKOFF,:SOFTBOILED,:SPORE,:SUBSTITUTE,:SWAGGER,
        :SWALLOW,:SWORDSDANCE,:SYNTHESIS,:TAILGLOW,:CLANGOROUSSOUL,:NORETREAT,:OBSTRUCT,:COURTCHANGE,:JUNGLEHEALING,
        :VICTORYDANCE,:AQUABATICS],
      [:heal]   => [:AROMATHERAPY,:BELLYDRUM,:CONVERSION2,:HAZE,:HEALBELL,:MIST,:PSYCHUP,:REFRESH,:SPITE,:STOCKPILE,
        :TELEPORT,:TRANSFORM,:DECORATE,:LIFEDEW,:LUNARBLESSING],
      [:heal2]  => [:MEMENTO,:PARTINGSHOT],
      [:centre] => [:DESTINYBOND,:GRUDGE],
    })
    z_effect_hash.default=[]
    z_effect = z_effect_hash[move]

    ### MODDED/ Handle Curse
    if move == :CURSE
      if attacker.hasType?(:GHOST)
        z_effect = [:heal]
      else
        z_effect = [PBStats::ATTACK,1]
      end
    end
    ### /MODDED

    # Single stat boosting z-move
    if z_effect.length==2
      if attacker.pbCanIncreaseStatStage?(z_effect[0],false)
      attacker.pbIncreaseStat(z_effect[0],z_effect[1],abilitymessage:false)
      boostlevel = ["","sharply ", "drastically "]
      @battle.pbDisplayBrief(_INTL("{1}'s Z-Power {2}boosted its {3}!",attacker.pbThis,boostlevel[z_effect[1]-1],attacker.pbGetStatName(z_effect[0])))
      return
      end
    end

    #Special effect
    case z_effect[0]
    when :allstat1
      increment = 1
      increment = 2 if @battle.FE == :CITY && [:CONVERSION,:HAPPYHOUR,:CELEBRATE].include?(move)
      increment = 2 if @battle.FE == :BACKALLEY && move == :CONVERSION
      for stat in [PBStats::ATTACK,PBStats::DEFENSE,PBStats::SPATK,PBStats::SPDEF,PBStats::SPEED]
        if attacker.pbCanIncreaseStatStage?(stat,false)
          attacker.pbIncreaseStat(stat,increment,abilitymessage:false)
        end
      end
      @battle.pbDisplayBrief(_INTL("{1}'s Z-Power boosted its stats!",attacker.pbThis)) if increment == 1
      @battle.pbDisplayBrief(_INTL("{1}'s Z-Power sharply boosted its stats!",attacker.pbThis)) if increment == 2
    when :crit1
      if attacker.effects[:FocusEnergy]<3
        attacker.effects[:FocusEnergy]+=2
        attacker.effects[:FocusEnergy]=3 if attacker.effects[:FocusEnergy]>3
        @battle.pbDisplayBrief(_INTL("{1}'s Z-Power is getting it pumped!",attacker.pbThis))
      end
    when :reset
      for i in [PBStats::ATTACK,PBStats::DEFENSE,
                PBStats::SPEED,PBStats::SPATK,PBStats::SPDEF,
                PBStats::EVASION,PBStats::ACCURACY]
        if attacker.stages[i]<0
          attacker.stages[i]=0
        end
      end
      @battle.pbDisplayBrief(_INTL("{1}'s Z-Power returned its decreased stats to normal!",attacker.pbThis))
    when :heal
      attacker.pbRecoverHP(attacker.totalhp,false)
      @battle.pbDisplayBrief(_INTL("{1}'s Z-Power restored its health!",attacker.pbThis))
    when :heal2
      attacker.effects[:ZHeal]=true
    when :centre
      attacker.effects[:FollowMe]=true
      if !attacker.pbPartner.isFainted?
        attacker.pbPartner.effects[:FollowMe]=false
        attacker.pbPartner.effects[:RagePowder]=false
        @battle.pbDisplayBrief(_INTL("{1}'s Z-Power made it the centre of attention!",attacker.pbThis))
      end
    end
  end
end
