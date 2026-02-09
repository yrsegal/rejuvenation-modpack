begin
  missing = ['0000.injection.rb', '0000.formattedchoices.rb', '0000.textures.rb', '0001.pcservices.rb', 'ServiceIcons'].select { |f| !File.exist?(File.join(__dir__, f)) }
  missing.map! { |it| it[/\./] ? it : "folder " + it }
  print "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  print "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
  raise "Missing dependencies for mod #{__FILE__}, cannot load" unless missing.empty?
end
Switches[:MoveRelearner] = 1444

TextureOverrides.registerServiceSprites('MoveRelearner', 'RelearnerSister')

HAPPY_ANIMATION_ID = 19

class MoveRelearnerPC_EggMoveLearnerScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon)
    moves=moverelearnerpc_getEggMoveList(pokemon)
    @scene.pbStartScene(pokemon,moves)
    loop do
      move=@scene.pbChooseMove
      if !move.is_a?(Symbol)
        if @scene.pbConfirm(
          _INTL("Give up trying to teach a new move to {1}?",pokemon.name))
          @scene.pbEndScene
          return false
        end
      else
        if @scene.pbConfirm(_INTL("Teach {1}?",getMoveName(move)))
          if pbLearnMove(pokemon,move)
            @scene.pbEndScene
            return true
          end
        end
      end
    end
  end
end

alias :moverelearnerpc_old_pbGetRelearnableMoves :pbGetRelearnableMoves

alias :moverelearnerpc_old_pbRelearnMoveScreen :pbRelearnMoveScreen

def pbRelearnMoveScreen(pokemon)
  if !pbHasRelearnableMove?(pokemon) # In some circumstances, this can happen
    Kernel.pbMessage(_INTL("{1} has no moves it can relearn.", pokemon.name))
    return false
  end
  return moverelearnerpc_old_pbRelearnMoveScreen(pokemon)
end


def pbGetRelearnableMoves(pokemon)
  return moverelearnerpc_old_pbGetRelearnableMoves(pokemon).select { |mv| !pokemon.knowsMove?(mv) }
end

def moverelearnerpc_getEggMoveList(pokemon)
  return pokemon.getEggMoveList(false).select{|i| !pokemon.knowsMove?(i) }
end

def moverelearnerpc_pbEggMoveScreen(pokemon)
  retval=true
  pbFadeOutIn(99999){
     scene=MoveRelearnerScene.new
     screen=MoveRelearnerPC_EggMoveLearnerScreen.new(scene)
     retval=screen.pbStartScreen(pokemon)
  }
  return retval
end

class Game_Screen
  attr_accessor :relearnerpc_used
  attr_accessor :relearnerpc_scales
end

def moverelearnerpc_conversationTakeScale(evt, sister, window)
  $PokemonBag.pbDeleteItem(:HEARTSCALE)
  ServicePCList.updateWindowQuantity(window, :HEARTSCALE) if window && !window.disposed?
  Kernel.pbMessage(_I("\\PN handed over one Heart Scale in exchange.\1"))
  $game_screen.relearnerpc_scales += 1
  if $game_screen.relearnerpc_scales >= 10
    pbExclaim(evt)
    Kernel.pbMessage(_I("BRIE: Oh! That's a lot of Heart Scales you've given me!\1"))
    Kernel.pbMessage(_I("I can't justify the price for someone my sister is so fond of.\1"))
    Kernel.pbMessage(_I("Tell you what. I'm helping you for free now, and I won't take no for an answer!"))
    sister.turn_toward_player
    pbExclaim(sister)
    pbWait(20)
    pbExclaim(sister, HAPPY_ANIMATION_ID)
    Kernel.pbMessage(_I("SAMANTHA: Wow! Thanks, sis! Enjoy, \\PN!"))
    window.dispose
    return true
  end
  return false
end

# To make it not strictly inferior but instead equivalent to service.
# technically clashes with Vendor Quantity Display, but handled gracefully
def relearnerService_relearnerConversation(evt, sister)
  $game_screen.relearnerpc_scales = 0 if !$game_screen.relearnerpc_scales
  noScaleNeeded = $game_screen.relearnerpc_scales >= 10
  if noScaleNeeded || $PokemonBag.pbQuantity(:HEARTSCALE) > 0
    if noScaleNeeded
      window = ServicePCList.quantityWindow(:HEARTSCALE)
      choice = Kernel.pbMessage(_I("BRIE: So, what'll it be?"), [_I("Relearn"), _I("Forget"), _I("Rare Moves"), _I("Cancel")])
    else
      Kernel.pbMessage(_I("BRIE: Ah, is that a Heart Scale?\1"))
      Kernel.pbMessage(_I("If you give me that Heart Scale, I'll help your Pokémon remember moves they've forgotten!\1"))
      Kernel.pbMessage(_I("Afterwards, they'll be able to remember moves on their own too.\1"))
      Kernel.pbMessage(_I("I can also teach them some rare moves, or help them forget a move.\1"))
      Kernel.pbMessage(_I("And I hear that once trainers get far enough, their Pokemon can even remember these moves on their own!\1"))
      window = ServicePCList.quantityWindow(:HEARTSCALE)
      choice = Kernel.pbMessage(_I("So, what'll it be?"), [_I("Relearn"), _I("Forget"), _I("Rare Moves"), _I("Cancel")])
    end

    if choice == 0 # Relearn
      subchoice = 0
      Kernel.pbMessage(_I("Which Pokemon needs tutoring?"))
      while subchoice >= 0
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && pbHasRelearnableMove?(p)},true)
        subchoice = pbGet(1)
        if subchoice < 0
          if noScaleNeeded
            Kernel.pbMessage(_I("Come back any time!"))
          else
            Kernel.pbMessage(_I("If you want me to reteach your Pokémon any move, come back with a Heart Scale!"))
          end
        else
          pkmn = $Trainer.party[subchoice]
          if pkmn.egg?
            Kernel.pbMessage(_I("Um, that's an egg.\1"))
            Kernel.pbMessage(_I("Unless you want me to teach your Pokémon scrambled, or sunny-side...\1"))
            Kernel.pbMessage(_I("Come back with a Pokémon."))
          elsif (pkmn.isShadow? rescue false)
            Kernel.pbMessage(_I("What is this thing?! It isn't natural, get it out of here!"))
          elsif !pbHasRelearnableMove?(pkmn)
            Kernel.pbMessage(_I("Uhh...\1"))
            Kernel.pbMessage(_I("This Pokémon doesn't have any move that it can relearn. Sorry, \\v[3]."))
          else
            if pkmn.canRelearnAll?
              Kernel.pbMessage(_I("\\v[3] can already remember all its moves! Just do it from the party screen.\1"))
              if !noScaleNeeded
                Kernel.pbMessage(_I("No reason I can't just help you here, though. Free of charge."))
              else
                Kernel.pbMessage(_I("No reason I can't just help you here, though."))
              end
            end

            if pbRelearnMoveScreen(pkmn)
              couldRelearnAll = pkmn.canRelearnAll?
              pkmn.relearner = [true, 3]
              if !noScaleNeeded
                return if !couldRelearnAll && moverelearnerpc_conversationTakeScale(evt, sister, window)
                Kernel.pbMessage(_I("If your Pokémon ever need a move taught, come back with a Heart Scale!"))
              else
                Kernel.pbMessage(_I("Come back any time!"))
              end
              window.dispose
              return
            else
              Kernel.pbMessage(_I("Which Pokemon needs tutoring?"))
            end
          end
        end
      end
    elsif choice == 1 # Forget
      subchoice = 0
      window.dispose
      Kernel.pbMessage(_I("Which Pokemon needs to forget a move?"))
      while subchoice >= 0
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && p.moves.length > 1},true)
        subchoice = pbGet(1)
        if subchoice < 0
          Kernel.pbMessage(_I("Come back any time!"))
        else
          pkmn = $Trainer.party[subchoice]
          if pkmn.egg?
            Kernel.pbMessage(_I("Um, that's an egg.\1"))
            Kernel.pbMessage(_I("You need to know moves in the first place to forget them."))
          elsif (pkmn.isShadow? rescue false)
            Kernel.pbMessage(_I("What is this thing?! It isn't natural, get it out of here!"))
          elsif pkmn.moves.length == 1
            Kernel.pbMessage(_I("\\v[3] only has one move left!"))
          else
            pbChooseMove(pkmn,2,4)
            movechoice = pbGet(2)
            if movechoice < 0
              Kernel.pbMessage(_I("Which Pokemon needs to forget a move?"))
            elsif Kernel.pbConfirmMessage(_I("\\v[3]'s \\v[4]? No problem!"))
              pbDeleteMove(pkmn, movechoice)
              Kernel.pbMessage(_I("And...\\|\\se[balldrop] done! \\v[3] has forgotten \\v[4]!\1"))
              Kernel.pbMessage(_I("Come back any time!"))
              return
            end
          end
        end
      end
    elsif choice == 2 # Rare Moves
      subchoice = 0
      Kernel.pbMessage(_I("Which Pokemon needs tutoring?"))
      while subchoice >= 0
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && moverelearnerpc_getEggMoveList(p).size > 0},true)
        subchoice = pbGet(1)
        if subchoice < 0
          if noScaleNeeded
            Kernel.pbMessage(_I("Come back any time!"))
          else
            Kernel.pbMessage(_I("If you want me to teach your Pokémon a rare move, come back with a Heart Scale!"))
          end
        else
          pkmn = $Trainer.party[subchoice]
          if pkmn.egg?
            Kernel.pbMessage(_I("Um, that's an egg.\1"))
            Kernel.pbMessage(_I("Unless you want me to teach your Pokémon scrambled, or sunny-side...\1"))
            Kernel.pbMessage(_I("Come back with a Pokémon."))
          elsif (pkmn.isShadow? rescue false)
            Kernel.pbMessage(_I("What is this thing?! It isn't natural, get it out of here!"))
          elsif moverelearnerpc_getEggMoveList(pkmn).size == 0
            Kernel.pbMessage(_I("This Pokémon doesn't have any rare moves to learn. Sorry, \\v[3]."))
          else
            if pkmn.canRelearnAll? && Rejuv && $PokemonBag.pbHasItem?(:HM02)
              Kernel.pbMessage(_I("\\v[3] can already remember all its moves! Just do it from the party screen.\1"))
              if !noScaleNeeded
                Kernel.pbMessage(_I("No reason I can't just help you here, though. Free of charge."))
              else
                Kernel.pbMessage(_I("No reason I can't just help you here, though."))
              end
            end

            if moverelearnerpc_pbEggMoveScreen(pkmn)
              couldRelearnAll = pkmn.canRelearnAll? && $PokemonBag.pbHasItem?(:HM02)
              pkmn.relearner = [true, 3]
              if !noScaleNeeded
                return if !couldRelearnAll && moverelearnerpc_conversationTakeScale(evt, sister, window)
                Kernel.pbMessage(_I("If your Pokémon ever need a move taught, come back with a Heart Scale!"))
              else
                Kernel.pbMessage(_I("Come back any time!"))
              end
              window.dispose
              return
            else
              Kernel.pbMessage(_I("Which Pokemon needs tutoring?"))
            end
          end
        end
      end
    else # Cancel
      if noScaleNeeded
        Kernel.pbMessage(_I("Come back any time!"))
      else
        Kernel.pbMessage(_I("If your Pokémon ever need a move taught, come back with a Heart Scale!"))
      end
      window.dispose
    end
  end
end

InjectionHelper.defineMapPatch(425, 16) { |event| # Sheridan Interiors, Move Relearner
  for page in event.pages # Move Relearner
    patchName = :VendorQuantityDisplay
    patchName = :PCServiceParity if page.patched?(:VendorQuantityDisplay)
    # this overrides vendor quantity display, so use same patch key to cut it off
    page.patch(patchName) {
      page.insertAtStart(
        [:ConditionalBranch, :Switch, :MoveRelearner, true],
          [:Script, 'relearnerService_relearnerConversation(get_character(0), get_character(15))'],
          [:Script, 'ServicePCList.cleanupLeftoverSprites'],
          :ExitEventProcessing,
        :Done)
      next true
    }
  end
}

class RelearnerPCService

  def shouldShow?
    return $game_switches[:MoveRelearner]
  end

  def name
    return _INTL("Move Relearner")
  end

  def help
    return _INTL("Relearn moves, delete them, or learn egg moves.")
  end

  def relearner(text, *args)
    return _INTL("\\f[service_MoveRelearner]" + text, *args)
  end

  def sister(text, *args)
    return _INTL("\\f[service_RelearnerSister]" + text, *args)
  end

  def takeScale
    $PokemonBag.pbDeleteItem(:HEARTSCALE)
    ServicePCList.updateWindowQuantity(@heartscalewindow, :HEARTSCALE) if @heartscalewindow && !@heartscalewindow.disposed?
    Kernel.pbMessage(_INTL("\\PN sent over one Heart Scale in exchange."))
    $game_screen.relearnerpc_scales += 1
    if $game_screen.relearnerpc_scales >= 10
      ServicePCList.exclaimSound
      Kernel.pbMessage(relearner("BRIE: Oh! That's a lot of Heart Scales you've given me!\1"))
      Kernel.pbMessage(relearner("I can't justify the price for someone my sister speaks so fondly of.\1"))
      Kernel.pbMessage(relearner("Tell you what. This service is free for you, now, and I won't take no for an answer!\1"))
      ServicePCList.happySound
      Kernel.pbMessage(sister("SAMANTHA: Wow! Thanks, sis! Enjoy, \\PN!"))
      return true
    end
    return false
  end

  def access
    if ServicePCList.offMap? || ServicePCList.inRift? || inPast? || ServicePCList.darchlightCaves?
      Kernel.pbMessage(_INTL("\\se[SFX - Dialtone:60]...\1"))
      Kernel.pbMessage(_INTL("There's no response..."))
      return
    end

    if !$game_screen.relearnerpc_scales || $game_screen.relearnerpc_scales < 10
      @heartscalewindow = ServicePCList.quantityWindow(:HEARTSCALE)
      @heartscalewindow.visible = true
    end

    Kernel.pbMessage(sister("SAMANTHA: Hello, you've reached the Sheridan Move Reminder...\1"))
    Kernel.pbMessage(sister("Oh, it's \\PN! How've you been?\1"))
    if !$game_screen.relearnerpc_used
      if !$game_self_switches[[425, 15, 'A']] # Sister
        Kernel.pbMessage(sister("Thank you for finding my sister!\1"))
        Kernel.pbMessage(sister("She's always forgetting that she has a duty here in Sheridan!\1"))
        Kernel.pbMessage(sister("Um, don't tell her I sent you this, but-"))
        if Kernel.pbReceiveItem(:HEARTSCALE)
          ServicePCList.updateWindowQuantity(@heartscalewindow, :HEARTSCALE) if @heartscalewindow && !@heartscalewindow.disposed?
          Kernel.pbMessage(sister("You earned that.\1"))
          Kernel.pbMessage(sister("Put it to good use, okay?"))
          $game_self_switches[[425, 15, 'A']] = true
        end
      else
        Kernel.pbMessage(sister("Thank you again for finding my sister!\1"))
      end
      Kernel.pbMessage(sister("I'm still in training for Move Relearner services, but I'm handling the phone.\1"))
      Kernel.pbMessage(sister("I can do Move Deleting, though! And I can call my sister over for Relearning, or learning rare moves.\1"))
      Kernel.pbMessage(sister("And we've got a special promotion! If you Relearn a move via this service, we'll teach your Pokemon to relearn moves on their own!\1"))
      $game_screen.relearnerpc_used = true
    end
    $game_screen.relearnerpc_scales = 0 if !$game_screen.relearnerpc_scales

    choice = Kernel.pbMessage(sister("So, what'll it be?"), [_INTL("Move Relearner"),_INTL("Move Deleter"),_INTL("Rare Moves")], -1)
    if choice < 0
      Kernel.pbMessage(sister("SAMANTHA: Oh, just calling to catch up? I appreciate it! Talk to you later!"))
      return
    elsif choice == 0
      Kernel.pbMessage(_INTL("\\sh\\c[7]SAMANTHA: HEY, BRIE! CUSTOMER! IT'S \\PNUpper!\\wtnp[50]"))
      Kernel.pbMessage(relearner("BRIE: Good to hear from you, \\PN. Relearner services? Sure!\1"))
      if $game_screen.relearnerpc_scales < 10
        if $PokemonBag.pbQuantity(:HEARTSCALE)>0
          Kernel.pbMessage(relearner("You've got a Heart Scale, so I can teach a Pokemon.\1"))
        elsif
          Kernel.pbMessage(relearner("... Actually, sorry, you need to come back with a Heart Scale.\1"))
          Kernel.pbMessage(sister("SAMANTHA: Oh well! Talk to you later!"))
          return
        end
      end
      Kernel.pbMessage(relearner("Which Pokemon needs tutoring?"))

      loop do
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && pbHasRelearnableMove?(p)},true)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(relearner("BRIE: Ah, okay. Changed your mind?\1"))
          Kernel.pbMessage(sister("SAMANTHA: Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(relearner("BRIE: Um, that's an egg.\1"))
          Kernel.pbMessage(relearner("Unless you want me to teach your Pokémon scrambled, or sunny-side..."))
          next
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(relearner("BRIE: What is this thing?! It isn't natural, get it out of here!"))
          next
        elsif !pbHasRelearnableMove?(pkmn)
          Kernel.pbMessage(relearner("BRIE: This Pokémon doesn't have any move that it can relearn. Sorry, \\v[3]."))
          next
        elsif pkmn.canRelearnAll?
          Kernel.pbMessage(relearner("BRIE: \\v[3] can already remember all its moves! Just do it from the party screen.\1"))
          if $game_screen.relearnerpc_scales < 10
            Kernel.pbMessage(relearner("No reason I can't help you out from here, though. Free of charge."))
          else
            Kernel.pbMessage(relearner("No reason I can't help you out from here, though."))
          end
        end

        if pbRelearnMoveScreen(pkmn)
          couldRelearnAll = pkmn.canRelearnAll?
          pkmn.relearner = [true, 3]
          if !couldRelearnAll && $game_screen.relearnerpc_scales < 10
            return if takeScale
            Kernel.pbMessage(sister("SAMANTHA: Thanks for doing business with us, \\PN! Call soon!"))
            return
          else
            Kernel.pbMessage(sister("SAMANTHA: Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        else
          Kernel.pbMessage(relearner("BRIE: Which Pokemon needs tutoring?"))
        end
      end
    elsif choice == 1
      Kernel.pbMessage(sister("SAMANTHA: Which Pokemon needs to forget a move?"))

      loop do
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && p.moves.length > 1},true)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(sister("SAMANTHA: Changed your mind? That's fine.\1"))
          Kernel.pbMessage(sister("Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(sister("SAMANTHA: You... know eggs don't <i>know</i> moves, right?"))
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(sister("SAMANTHA: Oh, I'm not licensed to work with affronts to Arceus."))
        elsif pkmn.moves.length == 1
          Kernel.pbMessage(sister("SAMANTHA: \\v[3] only knows one move!"))
        else
          Kernel.pbMessage(sister("SAMANTHA: Alright, and which move should \\v[3] forget?"))
          pbChooseMove(pkmn,2,4)
          moveresult = pbGet(2)
          if moveresult < 0
            Kernel.pbMessage(sister("SAMANTHA: Which Pokemon needs to forget a move?"))
          elsif Kernel.pbConfirmMessage(sister("SAMANTHA: \\v[3]'s \\v[4]? No problem!"))
            pbDeleteMove(pkmn, moveresult)
            Kernel.pbMessage(sister("And...\\|\\se[balldrop] done! \\v[3] has forgotten \\v[4]!\1"))
            Kernel.pbMessage(sister("Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        end
      end
    elsif choice == 2
      Kernel.pbMessage(_INTL("\\sh\\c[7]SAMANTHA: HEY, BRIE! CUSTOMER! IT'S \\PNUpper!\\wtnp[50]"))
      Kernel.pbMessage(relearner("BRIE: Good to hear from you, \\PN. Rare moves? Sure!\1"))
      if $game_screen.relearnerpc_scales < 10
        if $PokemonBag.pbQuantity(:HEARTSCALE)>0
          Kernel.pbMessage(relearner("You've got a Heart Scale, so I can teach a Pokemon.\1"))
        elsif
          Kernel.pbMessage(relearner("... Actually, sorry, you need to come back with a Heart Scale.\1"))
          Kernel.pbMessage(sister("SAMANTHA: Oh well! Talk to you later!"))
          return
        end
      end
      Kernel.pbMessage(relearner("Which Pokemon needs tutoring?"))

      loop do
        pbChoosePokemon(1,3,proc{|p| !p.isEgg? && !(p.isShadow? rescue false) && moverelearnerpc_getEggMoveList(p).size > 0},true)
        result = pbGet(1)
        if result < 0
          Kernel.pbMessage(relearner("BRIE: Ah, okay. Changed your mind?\1"))
          Kernel.pbMessage(sister("SAMANTHA: Always nice to hear from you, though! Bye!"))
          return
        end

        pkmn = $Trainer.party[result]

        if pkmn.isEgg?
          Kernel.pbMessage(relearner("BRIE: Um, that's an egg.\1"))
          Kernel.pbMessage(relearner("Unless you want me to teach your Pokémon scrambled, or sunny-side..."))
        elsif (pkmn.isShadow? rescue false)
          Kernel.pbMessage(relearner("BRIE: What is this thing?! It isn't natural, get it out of here!"))
        elsif moverelearnerpc_getEggMoveList(pkmn).size == 0
          Kernel.pbMessage(relearner("BRIE: This Pokémon doesn't have any rare moves to learn. Sorry, \\v[3]."))
        elsif moverelearnerpc_pbEggMoveScreen(pkmn)
          couldRelearnAll = pkmn.canRelearnAll? && $PokemonBag.pbHasItem?(:HM02)
          pkmn.relearner = [true, 3]
          if !couldRelearnAll && $game_screen.relearnerpc_scales < 10
            return if takeScale
            Kernel.pbMessage(sister("SAMANTHA: Thanks for doing business with us, \\PN! Call soon!"))
            return
          else
            Kernel.pbMessage(sister("SAMANTHA: Thanks for calling, \\PN! Talk to you soon!"))
            return
          end
        else
          Kernel.pbMessage(relearner("BRIE: Which Pokemon needs tutoring?"))
        end
      end
    end
  end
end

ServicePCList.registerService(RelearnerPCService.new)
