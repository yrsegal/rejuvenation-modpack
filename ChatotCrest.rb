begin
  missing = ['0000.injection.rb', '0000.textures.rb', '0000.music.rb', 'TetoSwears'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end

PBStuff::POKEMONTOCREST[:CHATOT] = :CHATCREST

$cache.items[:CHATCREST] = ItemData.new(:CHATCREST, {
  name: "Chatot Crest",
  desc: "It swears to demoralize the opponent. 30% Speed boost. Berserk.",
  price: 0,
  crest: true,
  noUseInBattle: true,
  noUse: true,
})

HiddenMoveHandlers::CanUseMove.add(:CHATTER,lambda{|move,pkmn|
  if pkmn.species == :CHATOT
    if pkmn.item == :CHATCREST
      return true
    else
      Kernel.pbMessage(_INTL("Only crested Chatot can swear."))
      return false
    end
  end
  Kernel.pbMessage(_INTL("Only Chatot can Chatter."))
  return false
})

HiddenMoveHandlers::UseMove.add(:CHATTER,lambda{|move,pokemon|
  currentSwear = pokemon.chatotSwearType
  return false unless currentSwear
  swearIDs = [:SHIT,:ASS,:FUCK,:DAMN,:BITCH]
  swears = [_INTL("Shit"),_INTL("Ass"),_INTL("Fuck"),_INTL("Damn"),_INTL("Bitch")]
  british = [_INTL("Bollocks"),_INTL("Arse"),_INTL("Twat"),_INTL("Donkey"),_INTL("Wanker")]
  commands = pokemon.isShiny? ? british : swears
  swear = Kernel.pbMessage(_INTL("Which swear do you want to teach {1}?", pokemon.name), commands, -1, nil, swearIDs.index(currentSwear))
  if swear != -1 && swearIDs[swear] != currentSwear
    pokemon.chatotSwearType = swearIDs[swear]
    if !pbHiddenMoveAnimation(pokemon)
      Kernel.pbMessage(_INTL("{1} used {2}.",pokemon.name,getMoveName(move)))
      pbPlayCry(pokemon)
    end
    Kernel.pbMessage(_INTL("{1} learned how to say {2}!", pokemon.name, commands[swear]))
  end
  return true
})

alias :chatotcrest_old_pbCryFile :pbCryFile

def pbCryFile(pokemon)
  if pokemon && !pokemon.is_a?(Numeric) && !pokemon.isEgg? && pokemon.species == :CHATOT && pokemon.item == :CHATCREST

    swearIDs = [:SHIT,:ASS,:FUCK,:DAMN,:BITCH]
    swears = ["Shit", "Ass", "Fuck", "Damn", "Bitch"]
    british = ["Bollocks", "Arse", "Twat", "Donkey", "Wanker"]
    swear = (pokemon.isShiny? ? british : swears)[swearIDs.index(pokemon.chatotSwearType)]
    filename=sprintf("%03dTeto%sCry",pokemon.dexnum,swear)
    return filename if pbResolveAudioSE(filename)
  end
  return chatotcrest_old_pbCryFile(pokemon)
end

alias :chatotcrest_old_unhashTRlist :unhashTRlist

def unhashTRlist(*args, **kwargs)
  dehashedlist = chatotcrest_old_unhashTRlist(*args, **kwargs)
  $cache.trainers.dig(:CHATOTGIRL, "Girl").each {|fight|
    dehashedlist.push([:CHATOTGIRL, "Girl", fight[1], fight[0], fight[0]])
  }
  return dehashedlist
end

Variables[:Chatot] = 452

ELIPSES_ANIMATION_ID = 16
LYRICAL_ANIMATION_ID = 18
EXPLOSION_ANIMATION_ID = 42

InjectionHelper.defineMapPatch(28, 8) { # Festival Plaza, Ass Chatot
  newPage { requiresSelfSwitch "A" }
}

InjectionHelper.defineMapPatch(28, 9) { # Festival Plaza, Chatot Girl
  idx = -1
  pages[1].patch(:chatotcrest_fight) {
    insertBeforeEnd {
      wait 10
      player.show_animation(ELIPSES_ANIMATION_ID)
      wait 30
      show_choices("GIRL: What?") {
        choice("Is it possible to learn this power?") {
          text "GIRL: Not from a Jedi. Or a Sith."
          text "Lucky for you, I'm not a Sith. I'm a shit!\\.\\^"
          branch("pbTrainerBattle(:CHATOTGIRL,'Girl',_I('Haha! Fuck!'))") {
            text "GIRL: Nice. Here, I made this with the souls of my Chatot."
            script "Kernel.pbReceiveItem(:CHATCREST)"
            text "GIRL: Bye lol."
            this.show_animation(EXPLOSION_ANIMATION_ID)
            this.set_move_route { remove_graphic }
            self_switch["A"] = true
            wait 10
            player.show_animation(ELIPSES_ANIMATION_ID)
            wait 30
            play_se "PRSFX- Chatter"
            text "CHATOT: AAASSSSSSSS-\\.\\^"
            # event 8 is Chatot
            events[8].show_animation(EXPLOSION_ANIMATION_ID)
            events[8].set_move_route { remove_graphic }
            script "pbSetSelfSwitch(8,'A',true)"
            erase_event 
          }
        }
        default_choice("Nice.") {
          this.show_animation(LYRICAL_ANIMATION_ID)
        }
      }
    }
  }

  pages[2].patch(:chatotcrest_itemball) {
    setGraphic 'Object ball', hueShift: 310
    interact {
      branch(variables[452], :>=, 2) {
        text "Did she leave this behind?"
      }.else {
        text "...?"
      }
      branch("Kernel.pbItemBall(:CHATCREST)") {
        self_switch["A"] = true
      }
    }
  }

  newPage { requiresSelfSwitch 'A' }
}

TextureOverrides.registerTrainerClass(:CHATOTGIRL, {
  title: "Vulgarity Enthusiast",
  skill: 90,
  moneymult: 1,
  replacements: {
    TextureOverrides::CHARS + 'Trainer{ID}' => TextureOverrides::CHARS + "Trainer#{$cache.trainertypes[:AXISSTUDENT_FW].checkFlag?(:ID)}"
  }
})

TextureOverrides.registerTextureOverride(TextureOverrides::ICONS + "chatcrest", TextureOverrides::MODBASE + "TetoSwears/Crest")

["Shit", "Ass", "Fuck", "Damn", "Bitch", "Bollocks", "Arse", "Twat", "Donkey", "Wanker"].each { |swear|
  MusicOverrides.registerMusicOverride("Audio/SE/441Teto#{swear}Cry", MusicOverrides::MODBASE + "TetoSwears/#{swear}")
}

$cache.trainers[:CHATOTGIRL] = {
  "Girl" => [[0, 
    [{
      species: :CHATOT,
      level: 80,
      moves: [:BOOMBURST,:CHATTER,:ROOST,:PARTINGSHOT],
      item: :CHATCREST,
      obtainText: "Ass",
      ability: :BIGPECKS,
      nature: :MODEST,
      happiness: 255,
      ev: [4,0,0,252,0,252],
      iv: 31,
    },
    {
      species: :CHATOT,
      level: 80,
      moves: [:BOOMBURST,:CHATTER,:ROOST,:PARTINGSHOT],
      item: :CHATCREST,
      obtainText: "Shit",
      ability: :BIGPECKS,
      nature: :MODEST,
      happiness: 255,
      ev: [4,0,0,252,0,252],
      iv: 31,
    },
    {
      species: :CHATOT,
      level: 80,
      moves: [:BOOMBURST,:CHATTER,:ROOST,:PARTINGSHOT],
      item: :CHATCREST,
      obtainText: "Fuck",
      ability: :BIGPECKS,
      nature: :MODEST,
      happiness: 255,
      ev: [4,0,0,252,0,252],
      iv: 31,
    },
    {
      species: :CHATOT,
      level: 80,
      moves: [:BOOMBURST,:CHATTER,:ROOST,:PARTINGSHOT],
      item: :CHATCREST,
      obtainText: "Damn",
      ability: :BIGPECKS,
      nature: :MODEST,
      happiness: 255,
      ev: [4,0,0,252,0,252],
      iv: 31,
    },
    {
      species: :CHATOT,
      level: 80,
      moves: [:BOOMBURST,:CHATTER,:ROOST,:PARTINGSHOT],
      item: :CHATCREST,
      obtainText: "Bitch",
      ability: :BIGPECKS,
      nature: :MODEST,
      happiness: 255,
      ev: [4,0,0,252,0,252],
      iv: 31,
    }],
    [], # items
    nil, # ace quote
    "Haha! Fuck!", # defeat quote
    nil]] # trainer effect
}

class PokeBattle_Pokemon
  attr_writer :chatotSwearType

  def chatotSwearType
    return nil if @species != :CHATOT
    if !defined?(@chatotSwearType)
      swears = ["Shit","Ass","Fuck","Damn","Bitch"]
      swearIDs = [:SHIT,:ASS,:FUCK,:DAMN,:BITCH]

      if @obtainText && swears.include?(@obtainText)
        @chatotSwearType = swearIDs[swears.index(@obtainText)]
      else
        @chatotSwearType = swearIDs.sample 
      end
    end
    return @chatotSwearType
  end
end

class PokeBattle_Battler
  alias :chatotcrest_old_crestStats :crestStats
  def crestStats
    if @crested == :CHATOT
      @speed = (@speed * 1.3).floor
      @ability = :BERSERK
    end
    chatotcrest_old_crestStats
  end


  def chatotSwear
    return nil unless @crested == :CHATOT
    return pokemon.chatotSwearType
  end
end

class PokeBattle_Move

  def chatotcresteffect(attacker, opponent, hitnum, showanimation=true)
    if isSoundBased? && attacker.crested == :CHATOT
      pbPlayCry(attacker.pokemon, attacker.hp<=(attacker.totalhp/2.0).floor ? 135 : 90)
      if !opponent.isFainted?
        if ((opponent.ability != :SHIELDDUST && opponent.ability != :OBLIVIOUS) || opponent.moldbroken) && attacker.ability != (:SHEERFORCE)
          case attacker.chatotSwear
          when :SHIT
            if opponent.pbCanReduceStatStage?(PBStats::DEFENSE,abilitymessage:false)
              opponent.pbReduceStat(PBStats::DEFENSE,1,abilitymessage:false)
            end
            if opponent.pbCanReduceStatStage?(PBStats::SPDEF,abilitymessage:false)
              opponent.pbReduceStat(PBStats::SPDEF,1,abilitymessage:false)
            end
            if opponent.ability == :CONTRARY && !opponent.moldbroken
              @battle.pbDisplay(_INTL("{1} is emboldened by the insult!",opponent.pbThis))
            else
              if attacker.isShiny?
                @battle.pbDisplay(_INTL("{1}'s stats are absolute bollocks!",opponent.pbThis))
              else
                @battle.pbDisplay(_INTL("{1}'s stats are shit!",opponent.pbThis))
              end
            end
          when :ASS
            if opponent.pbCanReduceStatStage?(PBStats::SPEED,abilitymessage:false)
              opponent.pbReduceStat(PBStats::SPEED,1,abilitymessage:false)
            end
            if opponent.ability == :CONTRARY && !opponent.moldbroken
              @battle.pbDisplay(_INTL("{1} is emboldened by the insult!",opponent.pbThis))
            else
              if attacker.isShiny?
                @battle.pbDisplay(_INTL("{1}'s speed is arse!",opponent.pbThis))
              else
                @battle.pbDisplay(_INTL("{1}'s speed is ass!",opponent.pbThis))
              end
            end
          when :FUCK
            if opponent.pbCanReduceStatStage?(PBStats::ATTACK,abilitymessage:false)
              opponent.pbReduceStat(PBStats::ATTACK,1,abilitymessage:false)
            end
            if opponent.pbCanReduceStatStage?(PBStats::SPATK,abilitymessage:false)
              opponent.pbReduceStat(PBStats::SPATK,1,abilitymessage:false)
            end
            if opponent.ability == :CONTRARY && !opponent.moldbroken
              @battle.pbDisplay(_INTL("{1} is emboldened by the insult!",opponent.pbThis))
            else
              if attacker.isShiny?
                @battle.pbDisplay(_INTL("{1} feels like a twat!",opponent.pbThis))
              else
                @battle.pbDisplay(_INTL("{1} feels like a fuck-up!",opponent.pbThis))
              end
            end
          when :DAMN
            if opponent.pbCanPetrify?(false)
              @battle.pbAnimation(:DECIMATION, attacker, opponent, hitnum) if showanimation
              opponent.pbPetrify(attacker)
              opponent.effects[:Petrification]=attacker.index
              if attacker.isShiny?
                @battle.pbDisplay(_INTL("{1} is an utter donkey!",opponent.pbThis))
              else
                @battle.pbDisplay(_INTL("{1} has been damned!",opponent.pbThis))
              end
            end
          when :BITCH
            if opponent.effects[:Taunt]<=0 && 
             (@battle.pbCheckSideAbility(:AROMAVEIL,opponent).nil? || opponent.moldbroken) &&
             (opponent.ability != :OBLIVIOUS || opponent.moldbroken)

              @battle.pbAnimation(:TAUNT, attacker, opponent, hitnum) if showanimation
              opponent.effects[:Taunt]=4
              @battle.pbDisplay(_INTL("{1} fell for the taunt!",opponent.pbThis))
            end
          end
          if @move == :CHATTER
            if !opponent.effects[:Torment] && 
             (@battle.pbCheckSideAbility(:AROMAVEIL,opponent).nil? || opponent.moldbroken)
              @battle.pbAnimation(:TORMENT, attacker, opponent, hitnum) if showanimation
              opponent.effects[:Torment]=true
              @battle.pbDisplay(_INTL("{1} is tormented by {2}'s voice!",opponent.pbThis, attacker.pbThis(true)))
            end
          end
        end
      end
    end
  end

  alias :chatotcrest_old_pbEffect :pbEffect
  def pbEffect(attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)

    origBaseDamage = @basedamage

    if origBaseDamage > 0 && isSoundBased? && attacker.ability == (:SHEERFORCE) && attacker.crested == :CHATOT
      @basedamage *= 1.3
    end

    dmg = chatotcrest_old_pbEffect(attacker,opponent,hitnum,alltargets,showanimation)

    if origBaseDamage > 0 && isSoundBased? && attacker.ability == (:SHEERFORCE) && attacker.crested == :CHATOT
      @basedamage = origBaseDamage
    end

    chatotcresteffect(attacker, opponent, hitnum, showanimation)

    return dmg
  end
end
