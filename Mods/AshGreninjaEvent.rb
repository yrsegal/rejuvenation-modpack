

class PokeBattle_Battle
  attr_accessor :ashgreninja_wasspedup

  alias :ashgreninja_old_pbGetMegaRingName :pbGetMegaRingName

  def pbGetMegaRingName(battlerIndex)
    owner = pbGetOwner(battlerIndex)
    if owner && owner.trainertype == :ASHKETCHUM
      battler = @battlers[battlerIndex]
      if battler && battler.item && [:CHARIZARDITEG, :VENUSAURITEG, :BLASTOISINITEG, :GENGARITEG,
                                     :BUTTERFREENITE, :MACHAMPITE, :PIKACHUTITE, :MEOWTHITE, :KINGLERITE, :LAPRASITE, 
                                     :EEVEETITE, :SNORLAXITE, :GARBODORNITE, :MELMETALITE, :CORVIKNITE, :ORBEETLENITE, 
                                     :DREDNAWTITE, :COALOSSALITE, :FLAPPLETITE, :APPLETUNITE, :SANDACONDITE, :TOXTRICITITE, 
                                     :CENTISKORCHITE, :HATTERENITE, :GRIMMSNARLITE, :ALCREMITE, :COPPERAJITE, :DURALUDONITE, 
                                     :RILLABOOMITE, :INTELEONITE, :CINDERACITE, :URSHIFUTITE].include?(battler.item)
        return _INTL("Dynamax Band")
      else
        return _INTL("Mega Glove")
      end
    end
  
    return ashgreninja_old_pbGetMegaRingName(battlerIndex)
  end

  def ashgreninja_saythelineash(battler)
    if $game_switches[:No_Mega_Evolution] != true && !pkmn.isMega? && pkmn.hasMega? && pbHasMegaRing(pkmn.index) && @megaEvolution[side][owner] != -1
      side = pbIsOpposing?(pursuiter.index) ? 1 : 0
      owner = pbGetOwnerIndex(pursuiter.index)
      @scene.pbShowOpponent(0)
      pbDisplayPaused(_INTL("We won't be left behind, {1}!", pkmn.pokemon.name))
      pbAnimation(:HELPINGHAND, pkmn, nil)
      @megaEvolution[side][owner] = -1
      @scene.pbHideOpponent
    end
  end

  alias :ashgreninja_old_pbUseZMove :pbUseZMove

  def pbUseZMove(index, choice, crystal, specialZ = false)
    if @battlers[index] && @battlers[index].pokemon && crystal == :PIKASHUNIUMZ && choice[2].move == :ASHTHUNDERBOLT
      if specialZ || (@battlers[index].hasZMove? rescue false)
        owner = pbGetOwner(index)
        if owner && owner.trainertype == :ASHKETCHUM && owner.trainereffect && owner.trainereffect[:plotarmor]

          @ashgreninja_wasspedup = $speed_up
          if $speed_up
            Graphics.toggleTurbo # It's cinematic!
          end

          if @opponent.is_a?(Array)
            if @opponent.include?(owner)
              opponent = @opponent.index(owner)
              @scene.pbShowOpponent(opponent)
              showtrainer = true
            end
          else
            if @opponent == owner
              @scene.pbShowOpponent(0)
              showtrainer = true
            end
          end

          pbDisplay(_INTL("{1}!", @battlers[index].pokemon.name))


          pbSEPlay("PRSFX- Catastropika2",100,90)
          pbAnimation(:CHARGE,@battlers[index],nil)

          pbDisplay(_INTL("{1}! We're going to put everything we've got into this attack!", @battlers[index].pokemon.name))

          pbSEPlay("PRSFX- Catastropika2",150,95)
          pbWait(10)
          pbDisplay(_INTL("{1} and {2} surrounded themselves with Z-Power!", owner.name, @battlers[index].pbThis(true)))

          pbCommonAnimation("ZPower",@battlers[index],nil)

          @scene.pbHideOpponent if showtrainer

          return
        end
      end
    end

    ashgreninja_old_pbUseZMove(index,choice,crystal,specialZ)
  end
end

class PokeBattle_Battler

  alias :ashgreninja_old_evioliteActive? :evioliteActive?
  def evioliteActive?
    return false unless self.itemWorks?
    return true if ashgreninja_old_evioliteActive?
    return true if species == :PIKACHU && self.form == 3 && self.item == :PIKASHUNIUMZ

    return false
  end
end

class PokeBattle_AI

  alias :ashgreninja_old_pbRoughDamage :pbRoughDamage
  def pbRoughDamage(move = @move, attacker = @attacker, opponent = @opponent, considersub: true)
    restoreAttacker = false
    restoreOpponent = false
    if attacker.item == :PIKASHUNIUMZ && attacker.pokemon.species == :PIKACHU && attacker.pokemon.form == 3
      attacker.item = :LIGHTBALL
      restoreAttacker = true
    end
    if opponent.item == :PIKASHUNIUMZ && opponent.pokemon.species == :PIKACHU && opponent.pokemon.form == 3
      opponent.item = :LIGHTBALL
      restoreOpponent = true
    end
    ret = ashgreninja_old_pbRoughDamage(move, attacker, opponent, considersub: considersub)
    attacker.item = :PIKASHUNIUMZ if restoreAttacker
    opponent.item = :PIKASHUNIUMZ if restoreOpponent
    return ret
  end
end

class PokeBattle_Move
  alias :ashgreninja_old_pbCalcDamage :pbCalcDamage
  def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    restoreAttacker = false
    restoreOpponent = false
    if attacker.item == :PIKASHUNIUMZ && attacker.pokemon.species == :PIKACHU && attacker.pokemon.form == 3
      attacker.item = :LIGHTBALL
      restoreAttacker = true
    end
    if opponent.item == :PIKASHUNIUMZ && opponent.pokemon.species == :PIKACHU && opponent.pokemon.form == 3
      opponent.item = :LIGHTBALL
      restoreOpponent = true
    end
    ret = ashgreninja_old_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
    attacker.item = :PIKASHUNIUMZ if restoreAttacker
    opponent.item = :PIKASHUNIUMZ if restoreOpponent
    return ret
  end
end

################################################################################
# 10,000,000 Volt Thunderbolt
################################################################################
class PokeBattle_Move_F25 < PokeBattle_Move
  def pbCritRate?(attacker,opponent)
    crit = super(attacker,opponent)
    return crit if crit < 0 || crit >= 3
    return crit + 1
  end

  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if id == :ASHTHUNDERBOLT
        @battle.pbAnimation(:CATASTROPIKA,attacker,opponent,hitnum)
      else
        @battle.pbAnimation(id,attacker,opponent,hitnum)
      end
    end

    if @battle.ashgreninja_wasspedup && !$speed_up
      Graphics.toggleTurbo
    end
    @battle.ashgreninja_wasspedup = nil
  end
end

Variables[:Karma] = 129

def ashgreninja_addPokemonNoTimeSet(species, level = nil, seeform = true, form = nil)
  return if !species || !$Trainer

  if pbBoxesFull?
    Kernel.pbMessage(_INTL("There's no more room for Pokémon!\1"))
    Kernel.pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
    return false
  end
  species = $cache.pkmn.keys[species - 1] if species.is_a?(Integer)
  species = PokeBattle_Pokemon::PokemonBuilder.new(species).build if species.is_a?(Hash)
  if !species.is_a?(PokeBattle_Pokemon)
    pokemon = PokeBattle_Pokemon.new(species, level, $Trainer, true, form)
    speciesname = getMonName(pokemon.species, pokemon.form)
    owner=nil
  else
    pokemon = species
    speciesname = getMonName(species.species, pokemon.form)
    owner=[pokemon.trainerID, pokemon.ot]
  end
  ### MODDED/
  # pokemon.timeReceived = Time.new
  ### /MODDED
  if pokemon.ot == ""
    pokemon.ot = $Trainer.name
    pokemon.trainerID = $Trainer.id
  end

  if owner && owner[0] != $Trainer.id && owner[1] != ''
    Kernel.pbMessage(_INTL("{1} obtained {2}'s {3}!\\se[itemlevel]\1",$Trainer.name, owner[1], speciesname))
  else
    Kernel.pbMessage(_INTL("{1} obtained {2}!\\se[itemlevel]\1",$Trainer.name,speciesname))
  end
  pbNicknameAndStore(pokemon)
  $Trainer.pokedex.setSeen(pokemon) if seeform
  return true
end

# EXCLAMATION_ANIMATION_ID = 3
QUESTION_ANIMATION_ID = 4
ELIPSES_ANIMATION_ID = 16
HEART_ANIMATION_ID = 17
LYRICAL_ANIMATION_ID = 18
HAPPY_ANIMATION_ID = 19
LAUGH_ANIMATION_ID = 29
SWEAT_DROP_ANIMATION_ID = 33

POKE_COME_IN_ANIMATION_ID = 46
POKE_COME_OUT_ANIMATION_ID = 47

SILENT_ANGRY_ANIMATION_ID = 32

KARMA_ANIMATION_ID = 115

InjectionHelper.defineMapPatch(44) { # Neo East Gearen (east)
  # Define in namespace so procs can reference later
  pikachu, ash, greninja = nil, nil, nil 
  
  ash = createNewEvent(63, 76, "Ash Ketchum", "ashgreninja_ashnpc") {
    newPage {
      setGraphic "NPC AshKetchum"
      requiresVariable :Karma, 30

      interact {
        text "???: ..."
        text "???: Ah. So it's you."
        player.show_animation(QUESTION_ANIMATION_ID)
        wait 20
        show_choices {
          choice("What do you mean?") {
            text "???: Just recognizing a kindred spirit."
            text "And hey, you're not being all weird about me."
            text "It's kinda nice to talk to someone who doesn't want autographs."

            player.show_animation(ELIPSES_ANIMATION_ID)
            wait 30
            player.set_move_route {
              animate_steps
              wait 17
              animate_steps false
            }.wait

            branch(player, :Left) {
              events[pikachu.id].set_move_route { face_right }
            }
            this.show_animation(LAUGH_ANIMATION_ID)
            events[pikachu.id].show_animation(LAUGH_ANIMATION_ID)
            wait 20
            branch(player, :Left) {
              events[pikachu.id].set_move_route { face_down }.wait
            }

            text "???: You haven't heard of me? Hah! That's new!"
            text "Let me introduce myself, then!"
            text "My name is \\c[6]Ash Ketchum.\n\\|\\c[0]The \\c[6]World Champion.\1"

            player.show_animation(EXCLAMATION_ANIMATION_ID)
            wait 20
            player.set_move_route {
              animate_steps
              wait 17
              animate_steps false
            }.wait

            text "ASH: Didn't know you were hanging out with THAT Ash, did you!"
            text "Though, after I won, the copycats became way too common..."

            branch(player, :Left) {
              events[pikachu.id].set_move_route { face_right }
            }
            this.show_animation(SWEAT_DROP_ANIMATION_ID)
            events[pikachu.id].show_animation(LAUGH_ANIMATION_ID)
            wait 20
            branch(player, :Left) {
              events[pikachu.id].set_move_route { face_down }.wait
            }

            text "And I know it's Monarch, but that sounds so... bleh. Champion is cooler."
          }

          choice("Who are you?") {
            text "???: Really? That's surprising. I figure everyone would have heard."
            text "My name is \\c[6]Ash Ketchum.\n\\|\\c[0]The \\c[6]World Champion.\1"

            player.show_animation(EXCLAMATION_ANIMATION_ID)
            wait 20
            player.set_move_route {
              animate_steps
              wait 17
              animate_steps false
            }.wait

            text "ASH: Yep!"
          }

          default_choice("Bye dude.") {
            exit_event_processing
          }
        }

        this.set_move_route {
          face_left
          wait 10
        }.wait

        this.show_animation(ELIPSES_ANIMATION_ID)
        wait 40
        this.set_move_route { face_toward_player }.wait

        text "ASH: ... I know what you're wondering. I can't."
        this.show_animation(SWEAT_DROP_ANIMATION_ID)
        text "Evil teams really are everywhere, huh?"
        text "I'd love to help, it's just... \\c[6]I'm not the one who needs to do this."
        events[pikachu.id].set_move_route {
          face_right
        }
        events[pikachu.id].show_animation(HEART_ANIMATION_ID)
        this.set_move_route {
          wait 5
          face_left
        }
        wait 20
        events[pikachu.id].set_move_route {
          face_down
        }.wait

        this.set_move_route { face_toward_player }

        text "ASH: Thanks, Pikachu. I know, I know, there's nothing I can do about it."
        text "But.\\| One of my partners wants to lend a bit of aid.\1"

        branch(player, :Left) {
          player.set_move_route {
            move_down
            move_left
            face_up
          }.wait
        }

        this.set_move_route { face_right }.wait
        events[greninja.id].show_animation(POKE_COME_OUT_ANIMATION_ID)
        play_se '658Cry', 80, 100
        script "pbSetSelfSwitch(#{greninja.id},'A',true)"
        events[greninja.id].set_move_route {
          set_character "pkmn_greninja_ashfight"
          wait 20
        }
        this.set_move_route {
          wait 20
          face_down
        }.wait

        text "ASH: \\c[6]Greninja wants to go with you."
        player.show_animation(EXCLAMATION_ANIMATION_ID)
        wait 20
        show_choices {
          choice("Surely it's not that easy.") {
            this.show_animation(LAUGH_ANIMATION_ID)
            text "ASH: You're right, you're right. He isn't just going to go with you."
            text "No, he's decided he'll only join you if you can \\c[6]beat me."
          }

          choice("Gimme!") {
            this.show_animation(LYRICAL_ANIMATION_ID)
            text "ASH: Eager? I get it. He's really something."
            text "But he wants you to show him who he'd team up with first."
            text "His condition is that he'll join you if you can \\c[6]beat me."
          }
        }
        text "I'll be staying for a while in Aevium. I'll be ready for you all, so just let me know when."
        self_switch["A"] = true
      }
    }


    newPage {
      setGraphic "NPC AshKetchum"
      requiresVariable :Karma, 30
      requiresSelfSwitch "A"

      interact {
        branch(self_switch["B"]) {
          text "ASH: Ready to try again?\n<o=175>Face the World Champion? (Rec. Lv. 85+)</o>\\ch[1,1,No,Yes]"
        }.else {
          text "ASH: Are you ready? I won't hold back.\n<o=175>Face the World Champion? (Rec. Lv. 85+)</o>\\ch[1,1,No,Yes]"
        }

        branch(variables[1], :==, 1) {
          fade_out_bgm seconds: 2
          events[greninja.id].set_move_route {
            move_down
            move_left
            move_left
            move_left
            move_up
            move_up
            face_down
          }
          events[pikachu.id].set_move_route { face_left }
          player.set_move_route {
            move_left
            move_left
            move_left
            move_up
          }
          this.set_move_route {
            wait 20
            face_left
          }.wait
          player.set_move_route { face_right }.wait
          play_bgs 'Amb-Wind'
          wait 20
          branch(self_switch["B"]) {
            text "ASH: It's time! Show me how much you've grown!"
          }.else {
            text "ASH: I've been looking forward to this, you know."
            text "Come at me, \\|\\c[6]my fellow Chosen One."
          }
          branch("pbTrainerBattle(:ASHKETCHUM,'Ash',_I('Amazing.'),false,0,true,0)") {
            events[pikachu.id].set_move_route {
              move_down
              move_right
              move_right
              move_up
              face_left
            }
            text "ASH: Amazing. Just... wow!"
            show_choices("You won! That makes you the World Champion now!") {
              choice("I won't let you down.") {
                this.show_animation(LAUGH_ANIMATION_ID)
                wait 20
                text "ASH: I was kidding! This wasn't a league-sanctioned battle anyway."
                text "Though you might have a good shot at it!"
              }

              choice("That doesn't seem right.") {
                text "ASH: No, it isn't, but I had you going there for a moment, didn't I?"
              }
            }

            wait_for_move_completion

            events[greninja.id].show_animation(HAPPY_ANIMATION_ID)
            play_se '658Cry', 80, 100
            events[greninja.id].set_move_route {
              wait 20
              move_down
              face_right
              animate_steps
              wait 17
              animate_steps false
              wait 20
            }.wait

            text "ASH: You approve, buddy?"
            events[greninja.id].show_animation(LYRICAL_ANIMATION_ID)
            wait 20
            text "ASH: Good! Good. I'm glad."
            wait 20
            events[greninja.id].set_move_route { move_right }.wait

            events[greninja.id].show_animation(POKE_COME_IN_ANIMATION_ID)
            events[greninja.id].set_move_route { 
              remove_graphic
              set_intangible
            }.wait
            wait 20

            script 'Ash=PokeBattle_Trainer.new("Ash",:ASHKETCHUM)
                    Ash.id = 7150
                    poke=PokeBattle_Pokemon.new(:GRENINJA,85,Ash,false,1) # todo this needs fixing
                    poke.iv = [20,20,20,20,20,20] if !$game_switches[:Full_IVs] && !$game_switches[:Empty_IVs_Password]
                    poke.setNature(:MODEST)
                    poke.hptype = :GROUND
                    poke.pbLearnMove(:WATERSHURIKEN)
                    poke.pbLearnMove(:DARKPULSE)
                    poke.pbLearnMove(:EXTRASENSORY)
                    poke.pbLearnMove(:HIDDENPOWER)
                    poke.makeMale

                    # OT Properties
                    timediverge = $Settings.unrealTimeDiverge
                    $Settings.unrealTimeDiverge = 0
                    poke.timeReceived = Time.unrealTime_oldTimeNew(2013, 10, 17, 12, 0, 0) # Air date of episode where he got his Froakie - October 24, 2013 
                    $Settings.unrealTimeDiverge = timediverge
                    poke.obtainText = _INTL("The Alola region")
                    poke.obtainMode = 0
                    poke.obtainLevel = 5
                    pbSet(1,poke)'

            this.set_move_route {
              move_left
              move_left
            }.wait

            branch("ashgreninja_addPokemonNoTimeSet(pbGet(1))") {
              script "pbSetSelfSwitch(#{greninja.id},'B',true)"
            }

            this.set_move_route {
              move_right
              move_right
              face_left
            }.wait

            text "ASH: Take good care of him."
            text "It's about time for me to leave Aevium anyway."
            text "I'm probably going to head back to Galar, give Leon a visit."

            events[pikachu.id].show_animation(EXCLAMATION_ANIMATION_ID)
            this.set_move_route {
              wait 5
              face_right
            }
            wait 20
            events[pikachu.id].show_animation(SILENT_ANGRY_ANIMATION_ID)
            play_se 'PRSFX- Catastropika2', 80, 100
            wait 30
            this.show_animation(LAUGH_ANIMATION_ID)
            wait 20
            text "ASH: Oh, alright. I'll call up Goh. Make a day of it."
            wait 10
            this.set_move_route { face_left }.wait

            text "See you around, \\PN."
            play_se 'Exit Door', 80, 100
            change_tone -255, -255, -255, frames: 10
            wait 10
            script "pbSetSelfSwitch(#{pikachu.id},'A',true)"
            branch("$game_self_switches[[@map_id,#{greninja.id},'B']]!=true") {
              events[greninja.id].set_event_location(x: greninja.x, y: greninja.y, direction: :Down)
              script "pbSetSelfSwitch(#{greninja.id},'C',true)"
              events[greninja.id].set_move_route { 
                set_character "pkmn_greninja_ashfight"
                set_intangible false
              }
            }

            this.set_move_route { remove_graphic }
            events[pikachu.id].set_move_route { remove_graphic }.wait
            change_tone 0, 0, 0, frames: 10
            wait 10

            player.show_animation(ELIPSES_ANIMATION_ID)
            wait 40
            text "(... you never told him your name.)"
            wait 16
            variables[:Karma] += 1
            player.show_animation(KARMA_ANIMATION_ID)
          }.else {
            events[greninja.id].set_move_route {
              move_down
              move_down
              move_right
              move_right
              move_right
              move_up
              face_down
            }
            events[pikachu.id].set_move_route { face_down }
            player.set_move_route {
              wait 30
              move_down
              move_right
              move_right
              move_right
            }
            this.set_move_route {
              wait 40
              face_down
            }.wait
            self_switch["B"] = true

            player.show_animation(SWEAT_DROP_ANIMATION_ID)
            wait 20
            text "ASH: Don't feel too bad. The World Champion title isn't for show!"
            text "Come back whenever you want to try again."
          }
        }.else {
          text "ASH: No worries."
        }
        
      }
    }

    newPage {
      requiresSelfSwitch "C"
    }
  }

  pikachu = createNewEvent(62, 76, "Ash's Pikachu", "ashgreninja_pikachunpc") {
    newPage {
      setGraphic "pkmn_pikachu_ash" 
      requiresVariable :Karma, 30
      self.move_speed -= 1
      interact {
        play_se 'PRSFX- Catastropika2', 80, 100
        text "PIKACHU: Bika!"
      }
    }

    newPage {
      requiresSelfSwitch "A"
    }
  }


  greninja = createNewEvent(64, 76, "Ash's Greninja", "ashgreninja_greninjanpc") {
    newPage {
      requiresVariable :Karma, 30
    }

    newPage {
      setGraphic "pkmn_greninja_ashfight"
      requiresVariable :Karma, 30
      requiresSelfSwitch "A"
      interact {
        play_se '658Cry', 80, 100
        text "GRENINJA: Grenin!"
      }
    }

    newPage {
      setGraphic "pkmn_greninja_ashfight"
      requiresVariable :Karma, 30
      requiresSelfSwitch "C"
      interact {
        play_se '658Cry', 80, 100
        text "GRENINJA: Gre! Nin-ja!"

        script 'Ash=PokeBattle_Trainer.new("Ash",:ASHKETCHUM)
                Ash.id = 7150
                poke=PokeBattle_Pokemon.new(:GRENINJA,85,Ash,false,1) # todo this needs fixing
                poke.iv = [20,20,20,20,20,20] if !$game_switches[:Full_IVs] && !$game_switches[:Empty_IVs_Password]
                poke.setNature(:MODEST)
                poke.hptype = :GROUND
                poke.pbLearnMove(:WATERSHURIKEN)
                poke.pbLearnMove(:DARKPULSE)
                poke.pbLearnMove(:EXTRASENSORY)
                poke.pbLearnMove(:HIDDENPOWER)
                poke.makeMale

                # OT Properties
                timediverge = $Settings.unrealTimeDiverge
                $Settings.unrealTimeDiverge = 0
                poke.timeReceived = Time.unrealTime_oldTimeNew(2013, 10, 17, 12, 0, 0) # Air date of episode where he got his Froakie - October 24, 2013 
                $Settings.unrealTimeDiverge = timediverge
                poke.obtainText = _INTL("The Alola region")
                poke.obtainMode = 0
                poke.obtainLevel = 5
                pbSet(1,poke)'
        branch("ashgreninja_addPokemonNoTimeSet(pbGet(1))") {
          self_switch["B"] = true
          self_switch["C"] = false
        }
      }
    }

    newPage {
      requiresSelfSwitch "B"
    }
  }
}


ModCacheInjection.hook(:trainers) {
  $cache.trainers[:ASHKETCHUM] = {} unless $cache.trainers[:ASHKETCHUM]
  $cache.trainers[:ASHKETCHUM]["Ash"] = {} unless $cache.trainers[:ASHKETCHUM]["Ash"]
  $cache.trainers[:ASHKETCHUM]["Ash"][0] = TeamData.new(0, ["Ash", :ASHKETCHUM, 0], {
    :teamid => ["Ash", :ASHKETCHUM, 0],
    :items => [:MEGARING],
    :mons => [
      {
        species: :PIKACHU,
        form: "World Cap",
        level: 85,
        moves: [:THUNDERBOLT,:SURF,:GRASSKNOT,:FAKEOUT],
        item: :PIKASHUNIUMZ,
        ability: :STATIC,
        gender: "M",
        nature: :MODEST,
        happiness: 255,
        ev: [4,0,0,252,0,252],
        iv: 31,
      },
      {
        species: :DRAGONITE,
        level: 85,
        moves: [:DRAGONDANCE,:EXTREMESPEED,:EARTHQUAKE,:ROOST],
        item: :WEAKNESSPOLICY,
        ability: :MULTISCALE,
        gender: "F",
        nature: :ADAMANT,
        happiness: 255,
        ev: [0,252,4,0,0,252],
        iv: 31,
      },
      {
        species: :SIRFETCHD,
        level: 85,
        moves: [:METEORASSAULT,:KNOCKOFF,:FIRSTIMPRESSION,:SWORDSDANCE],
        item: :STICK,
        ability: :STEADFAST,
        gender: "M",
        nature: :ADAMANT,
        happiness: 255,
        ev: [0,252,0,0,4,252],
        iv: 31,
      },
      {
        species: :GENGAR,
        level: 85,
        moves: [:POLTERGEIST,:DRAINPUNCH,:ICEPUNCH,:GUNKSHOT],
        item: :GENGARITEG, # Giga gengar is physical for. some reason.
        ability: :CURSEDBODY,
        gender: "M",
        nature: :IMPISH,
        happiness: 255,
        ev: [0,252,130,0,126,0],
        iv: 31,
      },
      {
        species: :DRACOVISH,
        level: 85,
        moves: [:FISHIOUSREND,:OUTRAGE,:CRUNCH,:PSYCHICFANGS],
        item: :CHOICESCARF,
        ability: :STRONGJAW,
        nature: :JOLLY,
        ev: [0,252,0,0,4,252],
        iv: 31,
      },
      {
        species: :LUCARIO,
        level: 85,
        moves: [:EARTHQUAKE,:METEORMASH,:CLOSECOMBAT,:BULLETPUNCH],
        ability: :JUSTIFIED,
        item: :LUCARIONITE,
        gender: "M",
        happiness: 255,
        nature: :ADAMANT,
        ev: [0,252,0,0,4,252],
        iv: 31,
      }
    ],
    :ace => "Pushing us to our limits? That's exactly what we wanted to see!",
    :defeat => "Amazing.",
    :trainereffect => {
      effectmode: :Party,
      plotarmor: true,
      buffactivation: :Limited,
      3 => {
        CustomMethod: "ashgreninja_saythelineash(pkmn)"
      },
      5 => {
        CustomMethod: "ashgreninja_saythelineash(pkmn)"
      },
    }
  })
}

ModCacheInjection.hook(:trainertypes) {
  $cache.trainertypes[:ASHKETCHUM] = TrainerData.new(:ASHKETCHUM, {
    ID: "Ash",
    title: "World Champion",
    trainerID: 7150,
    skill: 100,
    moneymult: 120,
    battleBGM: "Battle - Soul",
    winBGM: "Gym Battle Victory"
  })
}

ModCacheInjection.hook(:moves) {
  $cache.moves[:ASHTHUNDERBOLT] = MoveData.new(:ASHTHUNDERBOLT, {
    name: "10MV Thunderbolt",
    longname: "10,000,000 Volt Thunderbolt",
    function: 0xF25,
    type: :ELECTRIC,
    category: :special,
    basedamage: 195,
    highcrit: true,
    accuracy: 0,
    maxpp: 0,
    target: :SingleNonUser,
    kingrock: true,
    zmove: true,
    desc: "The user, Pikachu wearing a cap, powers up a jolt of electricity using its Z-Power and unleashes it. Critical hits land more easily.",
    zmovedata: {
      basemove: :THUNDERBOLT,
      species: [[:PIKACHU, 3]]
    }
  })
  PBStuff::ZMOVES.push(:ASHTHUNDERBOLT) unless PBStuff::ZMOVES.include?(:ASHTHUNDERBOLT)
  PBStuff::BLACKLISTS.values.each {|ls| ls.push(:ASHTHUNDERBOLT) unless ls.include?(:ASHTHUNDERBOLT) }
}

ModCacheInjection.hook(:items) {
  $cache.items[:PIKASHUNIUMZ] = ItemData.new(:PIKASHUNIUMZ, {
    name: "Pikashunium-Z",
    unit: "piece of Pikashunium Z",
    desc: "It converts Z-Power into crystals that upgrade a Thunderbolt by Pikachu in a cap to an exclusive Z-Move.",
    price: 0,
    crystal: true,
    zcrystal: :ASHTHUNDERBOLT,
    noUseInBattle: true,
  })
}
ItemHandlers::UseOnPokemon.copy(:NORMALIUMZ, :PIKASHUNIUMZ)


ModCacheInjection.hook(:pkmn) {
  addFormDataAtRuntime(:PIKACHU, "World Cap", {
    BaseStats: [55, 80, 50, 75, 60, 120],
    evolutions: [],
  })
}
