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

  alias :ashgreninja_old_pbAceMessage :pbAceMessage

  def pbAceMessage
    trainer = @opponent
    if pbPokemonCount(@party2)==1 && trainer && trainer.trainereffect && trainer.trainereffect[:effectmode] == :AshPlotArmor
      ace_text = trainer.aceline=="" ? nil : trainer.aceline
      return if ace_text == nil
      if ace_text.is_a?(String)
        @scene.pbShowOpponent(0)
        pbDisplayPaused(ace_text)
        pkmn = @battlers[1]
        pkmn = @battlers[3] if pkmn.isFainted?
        side = 1
        owner=pbGetOwnerIndex(pkmn.index)
        if $game_switches[:No_Mega_Evolution]!=true && !pkmn.isMega? && pkmn.hasMega? && pbHasMegaRing(pkmn.index) && @megaEvolution[side][owner]!=-1
          pbDisplayPaused(_INTL("We won't be left behind, {1}!", pkmn.pokemon.name))
        end
        @scene.pbHideOpponent
      end
      @ace_message_handled = true
    else
      ashgreninja_old_pbAceMessage
    end
  end

  alias :ashgreninja_old_runtrainerskills :runtrainerskills

  def runtrainerskills(pkmn,delay=false)
    party = @battle.pbParty(pkmn.index)
    monindex = party.index(pkmn.pokemon)
    trainer = pbPartyGetOwner(pkmn.index,monindex)
    return if trainer.nil?
    return if trainer.trainereffect.nil?
    return if trainer.trainereffect[:effectmode].nil?
    if !delay
      trainer.trainereffectused = [] if !trainer.trainereffectused && trainer.trainereffect[:buffactivation] == :Limited
      if trainer.trainereffect[:effectmode] == :AshPlotArmor
        trainereffect = trainer.trainereffect
      end
    end
    return ashgreninja_old_runtrainerskills(pkmn, delay) if trainereffect.nil?

    return if $game_switches[:No_Mega_Evolution]==true
    return if pkmn.isMega?
    return unless pkmn.hasMega?
    return unless pbHasMegaRing(pkmn.index)
    side=1
    owner=pbGetOwnerIndex(pkmn.index)
    if @megaEvolution[side][owner]!=-1
      if pbPokemonCount(@party2)!=1
        if @opponent.is_a?(Array)
          if @opponent.include?(trainer)
            opponent = @opponent.index(trainer)
            @scene.pbShowOpponent(opponent)
            showtrainer = true
          end
        else
          if @opponent == trainer
            @scene.pbShowOpponent(0)
            showtrainer = true
          end
        end
      end

      pbDisplayPaused(_INTL("We won't be left behind, {1}!", pkmn.pokemon.name)) if showtrainer
      pbAnimation(:HELPINGHAND, pkmn, nil)
      @megaEvolution[side][owner]=-1

      @scene.pbHideOpponent if showtrainer
    end
  end

  alias :ashgreninja_old_updateZMoveIndexBattler :updateZMoveIndexBattler

  def updateZMoveIndexBattler(index,battler)
    if battler.item == :PIKASHUNIUMZ
      speciesblock = !(battler.species==:PIKACHU && battler.form == 3)

      if battler.moves[index].move != :THUNDERBOLT || speciesblock
        battler.zmoves[index] = nil
      else
        zmove = PBMove.new(PBStuff::CRYSTALTOZMOVE[battler.item])
        battler.zmoves[index] = PokeBattle_Move.pbFromPBMove(self,zmove,battler,battler.moves[index])
      end
    else
      ashgreninja_old_updateZMoveIndexBattler(index, battler)
    end
  end

  alias :ashgreninja_old_pbUseZMove :pbUseZMove

  def pbUseZMove(index,choice,crystal,specialZ=false)
    if @battlers[index] && @battlers[index].pokemon && crystal == :PIKASHUNIUMZ && choice[2].move == :ASHTHUNDERBOLT
      if specialZ || (@battlers[index].hasZMove? rescue false)
        owner=pbGetOwner(index)
        if owner && owner.trainertype == :ASHKETCHUM && owner.trainereffect && owner.trainereffect[:effectmode] == :AshPlotArmor

          @ashgreninja_wasspedup = $speed_up
          if $speed_up
            Graphics.frame_rate=40 # It's cinematic!
            $speed_up = false
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

class PokeBattle_AI

  alias :ashgreninja_old_pbRoughDamage :pbRoughDamage
  def pbRoughDamage(move=@move,attacker=@attacker,opponent=@opponent)
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
    ret = ashgreninja_old_pbRoughDamage(move,attacker,opponent)
    attacker.item = :PIKASHUNIUMZ if restoreAttacker
    opponent.item = :PIKASHUNIUMZ if restoreOpponent
    return ret
  end
end

class PokeBattle_Move
  alias :ashgreninja_old_pbCalcDamage :pbCalcDamage
  def pbCalcDamage(attacker,opponent,options=0, hitnum: 0)
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
    ret = ashgreninja_old_pbCalcDamage(attacker,opponent,options, hitnum: hitnum)
    attacker.item = :PIKASHUNIUMZ if restoreAttacker
    opponent.item = :PIKASHUNIUMZ if restoreOpponent
    return ret
  end

  alias :ashgreninja_old_smartDamageCategory :smartDamageCategory
  def smartDamageCategory(attacker,opponent)
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
    ret = ashgreninja_old_smartDamageCategory(attacker,opponent)
    attacker.item = :PIKASHUNIUMZ if restoreAttacker
    opponent.item = :PIKASHUNIUMZ if restoreOpponent
    return ret
  end
end

class PokeBattle_Battler
  alias :ashgreninja_old_pbCompatibleZMoveFromMove? :pbCompatibleZMoveFromMove?

  def pbCompatibleZMoveFromMove?(move,moveindex = false)
    mv = move
    mv = self.moves[move] if moveindex
    return move.move==:THUNDERBOLT if self.item == :PIKASHUNIUMZ
    return ashgreninja_old_pbCompatibleZMoveFromMove?(move,moveindex)
  end
end

class PokeBattle_Pokemon
  alias :ashgreninja_old_initZmoves :initZmoves
  def initZmoves(crystal,player=false)
    ashgreninja_old_initZmoves(crystal, player)

    if crystal == :PIKASHUNIUMZ
      return if !(@species==:PIKACHU && @form == 3)
      for i in 0...@moves.length
        move = @moves[i]
        next if move.move != :THUNDERBOLT
        @zmoves[i] = PBMove.new(PBStuff::CRYSTALTOZMOVE[crystal])
      end
    end
  end

  alias :ashgreninja_old_updateZMoveIndex :updateZMoveIndex
  def updateZMoveIndex(index)
    if @item == :PIKASHUNIUMZ
      speciesblock = !(@species==:PIKACHU && @form == 3)

      if @moves[index].move != :THUNDERBOLT || speciesblock
        @zmoves[index] = nil
      else
        @zmoves[index] = PBMove.new(PBStuff::CRYSTALTOZMOVE[@item])
      end
    else
      ashgreninja_old_updateZMoveIndex(index)
    end
  end
end

alias :ashgreninja_old_unhashTRlist :unhashTRlist

def unhashTRlist(*args, **kwargs)
  dehashedlist = ashgreninja_old_unhashTRlist(*args, **kwargs)
  fight = $cache.trainers.dig(:ASHKETCHUM, "Ash")[0]
  dehashedlist.push([:ASHKETCHUM, "Ash", fight[1], fight[0], fight[0]])
  return dehashedlist
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
      @battle.ashgreninja_wasspedup = nil
      Graphics.frame_rate=200
      $speed_up = true
    end
  end
end

TextureOverrides.registerTrainerClass(:ASHKETCHUM, {
  :title => "World Champion",
  :trainerID => 63932,
  :skill => 100,
  :moneymult => 120,
  :battleBGM => "Battle - Soul",
  :winBGM => "Gym Battle Victory",
  :replacements => {
    TextureOverrides::CHARS + 'trainer{ID}' => TextureOverrides::MODBASE + 'AshGreninja/AshBattler',
    TextureOverrides::VS + 'vsTrainer{ID}' => TextureOverrides::MODBASE + 'AshGreninja/AshVS',
    TextureOverrides::VS + 'vsBar{ID}' => TextureOverrides::VS + "vsBar#{$cache.trainertypes[:SPIRITJENNER].checkFlag?(:ID)}"
  }
})

Variables[:Karma] = 129

def ashgreninja_addPokemonNoTimeSet(species,level=nil,seeform=true,form=0)
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

# EXCLAMATION_ANIMATION_ID = 3
QUESTION_ANIMATION_ID = 4
ELIPSES_ANIMATION_ID = 16
HEART_ANIMATION_ID = 17
LYRICAL_ANIMATION_ID = 18
HAPPY_ANIMATION_ID = 19
SWEAT_DROP_ANIMATION_ID = 21
LAUGH_ANIMATION_ID = 29
POKE_COME_IN_ANIMATION_ID = 46
POKE_COME_OUT_ANIMATION_ID = 47

SILENT_ANGRY_ANIMATION_ID = 32

KARMA_ANIMATION_ID = 115

InjectionHelper.defineMapPatch(44) { |map| # Neo East Gearen (east)
  baseid = map.events.values.max { |a, b| a.id <=> b.id }.id

  ash = RPG::Event.new(63, 76)
  ash.pages.push(RPG::Event::Page.new, RPG::Event::Page.new)
  ash.name = "Ash Ketchum"
  ash.id = baseid + 1

  pikachu = RPG::Event.new(62, 76)
  pikachu.pages.push(RPG::Event::Page.new)
  pikachu.name = "Ash's Pikachu"
  pikachu.id = baseid + 2

  greninja = RPG::Event.new(64, 76)
  greninja.pages.push(RPG::Event::Page.new, RPG::Event::Page.new, RPG::Event::Page.new)
  greninja.id = baseid + 3


  ash.pages[0].graphic.character_name = "NPC AshKetchum"
  ash.pages[0].condition.variable_valid = true
  ash.pages[0].condition.variable_id = Variables[:Karma]
  ash.pages[0].condition.variable_value = 30
  ash.pages[0].trigger = 0 # Action button
  ash.pages[0].list = InjectionHelper.parseEventCommands(
    [:ShowText, "???: ..."],
    [:ShowText, "???: Ah. So it's you."],
    [:ShowAnimation, :Player, QUESTION_ANIMATION_ID],
    [:Wait, 20],
    [:ShowChoices, ["What do you mean?", "Who are you?", "Bye dude."], 3],
    [:When, 0, "What do you mean?"],
      [:ShowText, "???: Just recognizing a kindred spirit."],
      [:ShowText, "And hey, you're not being all weird about me."],
      [:ShowText, "It's kinda nice to talk to someone who doesn't want autographs."],
      [:ShowAnimation, :Player, ELIPSES_ANIMATION_ID],
      [:Wait, 30],
      [:SetMoveRoute, :Player, [false,
        :AnimateSteps,
        [:Wait, 17],
        :DontAnimateSteps,
        :Done]],
      :WaitForMovement,
      [:ConditionalBranch, :Character, :Player, :Left],
        [:SetMoveRoute, pikachu.id, [false,
          :FaceRight,
          :Done]],
      :Done,
      [:ShowAnimation, :This, LAUGH_ANIMATION_ID],
      [:ShowAnimation, pikachu.id, LAUGH_ANIMATION_ID],
      [:Wait, 20],
      [:ConditionalBranch, :Character, :Player, :Left],
        [:SetMoveRoute, pikachu.id, [false,
          :FaceDown,
          :Done]],
        :WaitForMovement,
      :Done,
      [:ShowText, "???: You haven't heard of me? Hah! That's new!"],
      [:ShowText, "Let me introduce myself, then!"],
      [:ShowText, "My name is \\c[6]Ash Ketchum.\n\\|\\c[0]The \\c[6]World Champion."],
      [:ShowAnimation, :Player, EXCLAMATION_ANIMATION_ID],
      [:Wait, 20],
      [:SetMoveRoute, :Player, [false,
        :AnimateSteps,
        [:Wait, 17],
        :DontAnimateSteps,
        :Done]],
      :WaitForMovement,
      [:ShowText, "ASH: Didn't know you were hanging out with THAT Ash, did you!"],
      [:ShowText, "Though, after I won, the copycats became way too common..."],
      [:ConditionalBranch, :Character, :Player, :Left],
        [:SetMoveRoute, pikachu.id, [false,
          :FaceRight,
          :Done]],
      :Done,
      [:ShowAnimation, :This, SWEAT_DROP_ANIMATION_ID],
      [:ShowAnimation, pikachu.id, LAUGH_ANIMATION_ID],
      [:Wait, 20],
      [:ConditionalBranch, :Character, :Player, :Left],
        [:SetMoveRoute, pikachu.id, [false,
          :FaceDown,
          :Done]],
        :WaitForMovement,
      :Done,
      [:ShowText, "And I know it's Monarch, but that sounds so... bleh. Champion is cooler."],
    :Done,
    [:When, 1, "Who are you?"],
      [:ShowText, "???: Really? That's surprising. I figure everyone would have heard."],
      [:ShowText, "My name is \\c[6]Ash Ketchum.\n\\|\\c[0]The \\c[6]World Champion."],
      [:ShowAnimation, :Player, EXCLAMATION_ANIMATION_ID],
      [:Wait, 20],
      [:SetMoveRoute, :Player, [false,
        :AnimateSteps,
        [:Wait, 17],
        :DontAnimateSteps,
        :Done]],
      :WaitForMovement,
      [:ShowText, "ASH: Yep!"],
    :Done,
    [:When, 2, "Bye dude."],
      :ExitEventProcessing,
    :Done,
    [:SetMoveRoute, :This, [false,
      :FaceLeft,
      [:Wait, 10],
      :Done]],
    :WaitForMovement,
    [:ShowAnimation, :This, ELIPSES_ANIMATION_ID],
    [:Wait, 40],
    [:SetMoveRoute, :This, [false,
      :FaceTowardsPlayer,
      :Done]],
    :WaitForMovement,
    [:ShowText, "ASH: ... I know what you're wondering. I can't."],
    [:ShowText, "Evil teams really are everywhere, huh?"],
    [:ShowText, "I'd love to help, it's just... \\c[6]I'm not the one who needs to do this."],
    [:SetMoveRoute, pikachu.id, [false,
      :FaceRight,
      :Done]],
    [:ShowAnimation, pikachu.id, HEART_ANIMATION_ID],
    [:Wait, 20],
    [:SetMoveRoute, pikachu.id, [false,
      :FaceDown,
      :Done]],
    :WaitForMovement,
    [:ShowText, "ASH: Thanks, Pikachu. I know, I know, there's nothing I can do about it."],
    [:ShowText, "But.\\| One of my partners wants to lend a bit of aid."],
    [:ConditionalBranch, :Character, :Player, :Left],
      [:SetMoveRoute, :Player, [false,
        :MoveDown,
        :MoveLeft,
        :FaceUp,
        :Done]],
      :WaitForMovement,
    :Done,
    [:SetMoveRoute, :This, [false,
      :FaceRight,
      :Done]],
    :WaitForMovement,
    [:ShowAnimation, greninja.id, POKE_COME_OUT_ANIMATION_ID],
    [:PlaySoundEvent, '658Cry', 80, 100],
    [:Script, "pbSetSelfSwitch(#{greninja.id},'A',true)"],
    [:SetMoveRoute, greninja.id, [false,
      [:SetCharacter, "pkmn_greninja_ashfight", 0, :Down, 0],
      [:Wait, 20],
      :Done]],
    [:SetMoveRoute, :This, [false,
      [:Wait, 20],
      :FaceDown,
      :Done]],
    :WaitForMovement,
    [:ShowText, "ASH: \\c[6]Greninja wants to go with you."],
    [:ShowAnimation, :Player, EXCLAMATION_ANIMATION_ID],
    [:Wait, 20],
    [:ShowChoices, ["Surely it's not that easy.", "Gimme!"], 0],
    [:When, 0, "Surely it's not that easy."],
      [:ShowAnimation, :This, LAUGH_ANIMATION_ID],
      [:ShowText, "ASH: You're right, you're right. He isn't just going to go with you."],
      [:ShowText, "No, he's decided he'll only join you if you can \\c[6]beat me."],
    :Done,
    [:When, 1, "Gimme!"],
      [:ShowAnimation, :This, LYRICAL_ANIMATION_ID],
      [:ShowText, "ASH: Eager? I get it. He's really something."],
      [:ShowText, "But he wants you to show him who he'd team up with first."],
      [:ShowText, "His condition is that he'll join you if you can \\c[6]beat me."],
    :Done,
    [:ShowText, "I'll be staying for a while in Aevium. I'll be ready for you all, so just let me know when."],
    [:ControlSelfSwitch, "A", true],
    :Done)

  ash.pages[1].graphic.character_name = "NPC AshKetchum"
  ash.pages[1].condition.variable_valid = true
  ash.pages[1].condition.variable_id = Variables[:Karma]
  ash.pages[1].condition.variable_value = 30
  ash.pages[1].condition.self_switch_valid = true
  ash.pages[1].condition.self_switch_ch = "A"
  ash.pages[1].trigger = 0 # Action button
  ash.pages[1].list = InjectionHelper.parseEventCommands(
    [:ConditionalBranch, :SelfSwitch, "B", true],
      [:ShowText, "ASH: Ready to try again?\n<o=175>Face the World Champion? (Rec. Lv. 85+)</o>\\ch[1,1,No,Yes]"],
    :Else,
      [:ShowText, "ASH: Are you ready? I won't hold back.\n<o=175>Face the World Champion? (Rec. Lv. 85+)</o>\\ch[1,1,No,Yes]"],
    :Done,
    [:ConditionalBranch, :Variable, 1, :Constant, 1, :Equals],
      [:FadeOutBackgroundMusic, 2],
      [:SetMoveRoute, greninja.id, [false,
        :MoveDown,
        :MoveLeft,
        :MoveLeft,
        :MoveLeft,
        :MoveUp,
        :MoveUp,
        :FaceDown,
        :Done]],
      [:SetMoveRoute, pikachu.id, [false,
        :FaceLeft,
        :Done]],
      [:SetMoveRoute, :Player, [false,
        :MoveLeft,
        :MoveLeft,
        :MoveLeft,
        :MoveUp,
        :Done]],
      [:SetMoveRoute, :This, [false,
        [:Wait, 20],
        :FaceLeft,
        :Done]],
      :WaitForMovement,
      [:SetMoveRoute, :Player, [false,
        :FaceRight,
        :Done]],
      :WaitForMovement,
      [:PlayBackgroundSound, 'Amb-Wind', 100, 100],
      [:Wait, 20],
      [:ConditionalBranch, :SelfSwitch, "B", true],
        [:ShowText, "ASH: It's time! Show me how much you've grown!"],
      :Else,
        [:ShowText, "ASH: I've been looking forward to this, you know."],
        [:ShowText, "Come at me, \\|\\c[6]my fellow Chosen One."],
      :Done,
      [:ConditionalBranch, :Script, "pbTrainerBattle(:ASHKETCHUM,'Ash',_I('Amazing.'),false,0,true,0)"],
        [:SetMoveRoute, pikachu.id, [false,
          :MoveDown,
          :MoveRight,
          :MoveRight,
          :MoveUp,
          :FaceLeft,
          :Done]],
        [:ShowText, "ASH: Amazing. Just... wow!"],
        [:ShowText, "You won! That makes you the World Champion now!"],
        [:ShowChoices, ["I won't let you down.", "That doesn't seem right."], 0],
        [:When, 0, "I won't let you down."],
          [:ShowAnimation, :This, LAUGH_ANIMATION_ID],
          [:Wait, 20],
          [:ShowText, "ASH: I was kidding! This wasn't a league-sanctioned battle anyway."],
          [:ShowText, "Though you might have a good shot at it!"],
        :Done,
        [:When, 1, "That doesn't seem right."],
          [:ShowText, "ASH: No, it isn't, but I had you going there for a moment, didn't I?"],
        :Done,
        :WaitForMovement,
        [:ShowAnimation, greninja.id, HAPPY_ANIMATION_ID],
        [:PlaySoundEvent, '658Cry', 80, 100],
        [:SetMoveRoute, greninja.id, [false,
          [:Wait, 20],
          :MoveDown,
          :FaceRight,
          :AnimateSteps,
          [:Wait, 17],
          :DontAnimateSteps,
          [:Wait, 20],
          :Done]],
        :WaitForMovement,
        [:ShowText, "ASH: You approve, buddy?"],
        [:ShowAnimation, greninja.id, LYRICAL_ANIMATION_ID],
        [:Wait, 20],
        [:ShowText, "ASH: Good! Good. I'm glad."],
        [:Wait, 20],
        [:SetMoveRoute, greninja.id, [false,
          :MoveRight,
          :Done]],
        :WaitForMovement,
        [:ShowAnimation, greninja.id, POKE_COME_IN_ANIMATION_ID],
        [:SetMoveRoute, greninja.id, [false,
          [:SetCharacter, '', 0, :Down, 0],
          :SetIntangible,
          :Done]],
        :WaitForMovement,
        [:Wait, 20],
        [:Script,          'poke=PokeBattle_Pokemon.new(:GRENINJA,85,$Trainer,false,1)'],
        [:ScriptContinued, 'poke.iv = [20,20,20,20,20,20] if !$game_switches[:Full_IVs] && !$game_switches[:Empty_IVs_Password]'],
        [:ScriptContinued, 'poke.setNature(:MODEST)'],
        [:ScriptContinued, 'poke.hptype = :GROUND'],
        [:ScriptContinued, 'poke.pbLearnMove(:WATERSHURIKEN)'],
        [:ScriptContinued, 'poke.pbLearnMove(:DARKPULSE)'],
        [:ScriptContinued, 'poke.pbLearnMove(:EXTRASENSORY)'],
        [:ScriptContinued, 'poke.pbLearnMove(:HIDDENPOWER)'],
        [:ScriptContinued, 'poke.makeMale'],

        # OT Properties
        [:ScriptContinued, 'timediverge = $Settings.unrealTimeDiverge'],
        [:ScriptContinued, '$Settings.unrealTimeDiverge = 0'],
        [:ScriptContinued, 'poke.timeReceived = Time.unrealTime_oldTimeNew(2013, 10, 17, 12, 0, 0)'], # Air date of episode where he got his Froakie - October 24, 2013 
        [:ScriptContinued, '$Settings.unrealTimeDiverge = timediverge'],
        [:ScriptContinued, 'poke.obtainText = _INTL("The Alola region")'],
        [:ScriptContinued, 'poke.obtainMode = 0'],
        [:ScriptContinued, 'poke.obtainLevel = 5'],
        [:ScriptContinued, 'poke.ot = _INTL("Ash")'],
        [:ScriptContinued, 'poke.trainerID = 7150'],
        [:ScriptContinued, 'pbSet(1,poke)'],
        [:SetMoveRoute, :This, [false,
          :MoveLeft,
          :MoveLeft,
          :Done]],
        :WaitForMovement,
        [:ConditionalBranch, :Script, 'ashgreninja_addPokemonNoTimeSet(pbGet(1))'],
          [:Script, "pbSetSelfSwitch(#{greninja.id},'B',true)"],
        :Done,
        [:SetMoveRoute, :This, [false,
          :MoveRight,
          :MoveRight,
          :FaceLeft,
          :Done]],
        :WaitForMovement,
        [:ShowText, "ASH: Take good care of him."],
        [:ShowText, "It's about time for me to leave Aevium anyway."],
        [:ShowTextContinued, "I'm probably going to head back to Galar, give Leon a visit."],
        [:ShowAnimation, pikachu.id, EXCLAMATION_ANIMATION_ID],
        [:SetMoveRoute, :This, [false,
          [:Wait, 5],
          :FaceRight,
          :Done]],
        [:Wait, 20],
        [:ShowAnimation, pikachu.id, SILENT_ANGRY_ANIMATION_ID],
        [:PlaySoundEvent, 'PRSFX- Catastropika2', 80, 100],
        [:Wait, 30],
        [:ShowAnimation, :This, LAUGH_ANIMATION_ID],
        [:Wait, 20],
        [:ShowText, "ASH: Oh, alright. I'll call up Goh. Make a day of it."],
        [:Wait, 10],
        [:SetMoveRoute, :This, [false,
          :FaceLeft,
          :Done]],
        :WaitForMovement,
        [:ShowText, "See you around, \\PN."],
        [:PlaySoundEvent, 'Exit Door', 80, 100],
        [:ChangeScreenColorTone, Tone.new(-255,-255,-255,0), 10],
        [:Wait, 10],

        [:ControlSelfSwitch, "C", true],
        [:Script, "pbSetSelfSwitch(#{pikachu.id},'A',true)"],
        [:ConditionalBranch, :Script, "$game_self_switches[[@map_id,#{greninja.id},'B']]!=true"],
          [:SetEventLocation, greninja.id, :Constant, greninja.x, greninja.y, greninja.pages[1].graphic.direction],
          [:Script, "pbSetSelfSwitch(#{greninja.id},'C',true)"],
          [:SetMoveRoute, greninja.id, [false,
            [:SetCharacter, "pkmn_greninja_ashfight", 0, :Down, 0],
            :SetTangible,
            :Done]],
        :Done,
        [:SetMoveRoute, :This, [false,
          [:SetCharacter, '', 0, :Down, 0],
          :Done]],
        [:SetMoveRoute, pikachu.id, [false,
          [:SetCharacter, '', 0, :Down, 0],
          :Done]],
        :WaitForMovement,

        [:ChangeScreenColorTone, Tone.new(0,0,0,0), 10],
        [:Wait, 10],
        [:ShowAnimation, :Player, ELIPSES_ANIMATION_ID],
        [:Wait, 40],
        [:ShowText, "(... you never told him your name.)"],
        [:Wait, 16],
        [:ControlVariable, :Karma, :Add, :Constant, 1],
        [:ShowAnimation, :Player, KARMA_ANIMATION_ID],
      :Else,
        [:SetMoveRoute, greninja.id, [false,
          :MoveDown,
          :MoveDown,
          :MoveRight,
          :MoveRight,
          :MoveRight,
          :MoveUp,
          :FaceDown,
          :Done]],
        [:SetMoveRoute, pikachu.id, [false,
          :FaceDown,
          :Done]],
        [:SetMoveRoute, :Player, [false,
          [:Wait, 30],
          :MoveDown,
          :MoveRight,
          :MoveRight,
          :MoveRight,
          :FaceUp,
          :Done]],
        [:SetMoveRoute, :This, [false,
          [:Wait, 40],
          :FaceDown,
          :Done]],
        :WaitForMovement,
        [:ControlSelfSwitch, "B", true],
        [:ShowAnimation, :Player, SWEAT_DROP_ANIMATION_ID],
        [:Wait, 20],
        [:ShowText, "ASH: Don't feel too bad. The World Champion title isn't for show!"],
        [:ShowText, "Come back whenever you want to try again."],
      :Done,
    :Else,
      [:ShowText, "ASH: No worries."],
    :Done,
    :Done)

  ash.pages[2].condition.self_switch_valid = true
  ash.pages[2].condition.self_switch_ch = "C"

  pikachu.pages[0].graphic.character_name = "pkmn_pikachu_ash"
  pikachu.pages[0].condition.variable_valid = true
  pikachu.pages[0].condition.variable_id = Variables[:Karma]
  pikachu.pages[0].condition.variable_value = 30
  pikachu.pages[0].move_speed = 2 # Slower
  pikachu.pages[0].trigger = 0 # Action button
  pikachu.pages[0].list = InjectionHelper.parseEventCommands(
    [:PlaySoundEvent, 'PRSFX- Catastropika2', 80, 100],
    [:ShowText, "PIKACHU: Bika!"],
    :Done)

  pikachu.pages[1].condition.self_switch_valid = true
  pikachu.pages[1].condition.self_switch_ch = "A"

  greninja.pages[0].condition.variable_valid = true
  greninja.pages[0].condition.variable_id = Variables[:Karma]
  greninja.pages[0].condition.variable_value = 30

  greninja.pages[1].graphic.character_name = "pkmn_greninja_ashfight"
  greninja.pages[1].condition.variable_valid = true
  greninja.pages[1].condition.variable_id = Variables[:Karma]
  greninja.pages[1].condition.variable_value = 30
  greninja.pages[1].condition.self_switch_valid = true
  greninja.pages[1].condition.self_switch_ch = "A"
  greninja.pages[1].move_speed = 2 # Slower
  greninja.pages[1].trigger = 0 # Action button
  greninja.pages[1].list = InjectionHelper.parseEventCommands(
    [:PlaySoundEvent, '658Cry', 80, 100],
    [:ShowText, "GRENINJA: Grenin!"],
    :Done)

  greninja.pages[2].graphic.character_name = "pkmn_greninja_ashfight"
  greninja.pages[2].condition.variable_valid = true
  greninja.pages[2].condition.variable_id = Variables[:Karma]
  greninja.pages[2].condition.variable_value = 30
  greninja.pages[2].condition.self_switch_valid = true
  greninja.pages[2].condition.self_switch_ch = "C"
  greninja.pages[2].move_speed = 2 # Slower
  greninja.pages[2].trigger = 0 # Action button
  greninja.pages[2].list = InjectionHelper.parseEventCommands(
    [:PlaySoundEvent, '658Cry', 80, 100],
    [:ShowText, "GRENINJA: Gre! Nin-ja!"],

    [:Script,          'poke=PokeBattle_Pokemon.new(:GRENINJA,85,$Trainer,false,1)'],
    [:ScriptContinued, 'poke.iv = [20,20,20,20,20,20] if !$game_switches[:Full_IVs] && !$game_switches[:Empty_IVs_Password]'],
    [:ScriptContinued, 'poke.setNature(:MODEST)'],
    [:ScriptContinued, 'poke.hptype = :GROUND'],
    [:ScriptContinued, 'poke.pbLearnMove(:WATERSHURIKEN)'],
    [:ScriptContinued, 'poke.pbLearnMove(:DARKPULSE)'],
    [:ScriptContinued, 'poke.pbLearnMove(:EXTRASENSORY)'],
    [:ScriptContinued, 'poke.pbLearnMove(:HIDDENPOWER)'],
    [:ScriptContinued, 'poke.makeMale'],

    # OT Properties
    [:ScriptContinued, 'timediverge = $Settings.unrealTimeDiverge'],
    [:ScriptContinued, '$Settings.unrealTimeDiverge = 0'],
    [:ScriptContinued, 'poke.timeReceived = Time.unrealTime_oldTimeNew(2013, 10, 17, 12, 0, 0)'], # Air date of episode where he got his Froakie - October 24, 2013 
    [:ScriptContinued, '$Settings.unrealTimeDiverge = timediverge'],
    [:ScriptContinued, 'poke.obtainText = _INTL("The Alola region")'],
    [:ScriptContinued, 'poke.obtainMode = 0'],
    [:ScriptContinued, 'poke.obtainLevel = 5'],
    [:ScriptContinued, 'poke.ot = _INTL("Ash")'],
    [:ScriptContinued, 'poke.trainerID = 7150'],
    [:ScriptContinued, 'pbSet(1,poke)'],

    [:ConditionalBranch, :Script, 'ashgreninja_addPokemonNoTimeSet(pbGet(1))'],
      [:ControlSelfSwitch, "B", true],
      [:ControlSelfSwitch, "C", false],
    :Done,
    :Done)

  greninja.pages[3].condition.self_switch_valid = true
  greninja.pages[3].condition.self_switch_ch = "B"

  map.events[ash.id] = ash
  map.events[pikachu.id] = pikachu
  map.events[greninja.id] = greninja
  next true
}


$cache.trainers[:ASHKETCHUM] = {
  "Ash" => [[0, 
    [{
      :species => :PIKACHU,
      :form => 3,
      :level => 85,
      :moves => [:THUNDERBOLT,:SURF,:GRASSKNOT,:FAKEOUT],
      :item => :PIKASHUNIUMZ,
      :ability => :STATIC,
      :gender => "M",
      :nature => :MODEST,
      :happiness => 255,
      :ev => [4,0,0,252,0,252],
      :iv => 31,
    },
    {
      :species => :DRAGONITE,
      :level => 85,
      :moves => [:DRAGONDANCE,:EXTREMESPEED,:EARTHQUAKE,:ROOST],
      :item => :HEAVYDUTYBOOTS,
      :ability => :MULTISCALE,
      :gender => "F",
      :nature => :ADAMANT,
      :happiness => 255,
      :ev => [0,252,4,0,0,252],
      :iv => 31,
    },
    {
      :species => :SIRFETCHD,
      :level => 85,
      :moves => [:METEORASSAULT,:KNOCKOFF,:FIRSTIMPRESSION,:SWORDSDANCE],
      :item => :STICK,
      :ability => :STEADFAST,
      :gender => "M",
      :nature => :ADAMANT,
      :happiness => 255,
      :ev => [0,252,0,0,4,252],
      :iv => 31,
    },
    {
      :species => :GENGAR,
      :level => 85,
      :moves => [:POLTERGEIST,:DRAINPUNCH,:ICEPUNCH,:GUNKSHOT], # No, it can't learn Gunk Shot. Ash is built different.
      :item => :GENGARITEG, # Giga gengar is physical for. some reason.
      :ability => :CURSEDBODY,
      :gender => "M",
      :nature => :IMPISH,
      :happiness => 255,
      :ev => [0,252,130,0,126,0],
      :iv => 31,
    },
    {
      :species => :DRACOVISH,
      :level => 85,
      :moves => [:FISHIOUSREND,:OUTRAGE,:CRUNCH,:PSYCHICFANGS],
      :item => :CHOICESCARF,
      :ability => :STRONGJAW,
      :nature => :JOLLY,
      :ev => [0,252,0,0,4,252],
      :iv => 31,
    },
    {
      :species => :LUCARIO,
      :level => 85,
      :moves => [:EARTHQUAKE,:METEORMASH,:CLOSECOMBAT,:BULLETPUNCH],
      :ability => :JUSTIFIED,
      :item => :LUCARIONITE,
      :gender => "M",
      :happiness => 255,
      :nature => :ADAMANT,
      :ev => [0,252,0,0,4,252],
      :iv => 31,
    }],
    [], # items
    "Pushing us to our limits? That's exactly what we wanted to see!", # ace quote
    "Amazing.", # defeat quote
    { # trainer effect
      :effectmode => :AshPlotArmor,
      :buffactivation => :Always
    }]] 
}

TextureOverrides.registerTextureOverrides({
  TextureOverrides::CHARS + 'NPC AshKetchum' => TextureOverrides::MODBASE + 'AshGreninja/AshNPC',
  TextureOverrides::CHARS + 'pkmn_pikachu_ash' => TextureOverrides::MODBASE + 'AshGreninja/AshPikachuNPC',
  TextureOverrides::CHARS + 'pkmn_greninja_ashfight' => TextureOverrides::MODBASE + 'AshGreninja/OverworldGreninja',
  TextureOverrides::BATTLER + '025_3' => TextureOverrides::MODBASE + 'AshGreninja/AshPikachu',
  TextureOverrides::ICONS + 'icon025_3' => TextureOverrides::MODBASE + 'AshGreninja/AshPikachuIcon',
  TextureOverrides::ICONS + 'pikashuniumz' => TextureOverrides::MODBASE + 'AshGreninja/PikashuniumZ'
})

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
  desc: "The user, Pikachu wearing a cap, powers up a jolt of electricity using its Z-Power and unleashes it. Critical hits land more easily."
})

$cache.items[:PIKASHUNIUMZ] = ItemData.new(:PIKASHUNIUMZ, {
  name: "Pikashunium-Z",
  desc: "It converts Z-Power into crystals that upgrade a Thunderbolt by Pikachu in a cap to an exclusive Z-Move.",
  :price => 0,
  :crystal => true,
  :zcrystal => true,
  :noUseInBattle => true,
})
ItemHandlers::UseOnPokemon.copy(:NORMALIUMZ, :PIKASHUNIUMZ)

PBStuff::CRYSTALTOZMOVE[:PIKASHUNIUMZ] = :ASHTHUNDERBOLT

$cache.pkmn[:PIKACHU].formData["World Cap"] = {
  :BaseStats => [55, 80, 50, 75, 60, 120],
  :ExcludeDex => true,
  :toobig => true,
  :evolutions => [],
}

$cache.pkmn[:PIKACHU].forms[3] = "World Cap"