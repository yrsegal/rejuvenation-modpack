

# credit to @necrollo on discord for making the original sprites!

Variables[:Outfit] = 259

def darchaxel_transmuteMoveRoute(prevRoute, replaceGraphic)
  newRoute = RPG::MoveRoute.new
  newRoute.repeat = prevRoute.repeat
  newRoute.skippable = prevRoute.skippable
  newRoute.list = prevRoute.list.map { |cmd|
    RPG::MoveCommand.new(cmd.code, cmd.parameters.map { |it|
      it.is_a?(String) ? replaceGraphic : it
    })
  }
  return newRoute
end

def darchaxel_batty_section(outfit)
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      this.set_move_route {
        set_character 'BattyFriends_Axel_' + outfit.to_s
      }
      jump_label 'done'
    }
  }
end


def darchaxel_special_sprite_section(special, outfit, outfitname = outfit)
  return InjectionDSL.parse {
    branch(variables[:Outfit], :==, outfit) {
      branch(switches[:Axel], true) {
        this.set_move_route {
          set_character special + '_' + outfitname.to_s
        }
        jump_label 'End'
      }
    }
  }
end

# Injections

def darchaxel_inject_special_sprite(event, special)
  event.patch(:darchaxel_inject_special_sprite) {
    matched = lookForSequence([:ConditionalBranch, :Variable, :Outfit, :Constant, 0, :==])

    if matched
      insertBefore(matched,
        *darchaxel_special_sprite_section(special, 3, 'int'),
        *darchaxel_special_sprite_section(special, 4))
    end
  }
end

def darchaxel_hotfix_battyfriends(event)
  event.patch(:darchaxel_batty_sprites) {
    matched = lookForSequence([:ConditionalBranch, :Switch, :Axel, true])

    if matched
      insertAfter(matched,
          *darchaxel_batty_section(3),
          *darchaxel_batty_section(4))
    end
  }
end

InjectionHelper.defineCommonPatch(49) { darchaxel_inject_special_sprite(self, 'PlayerHeadache_4') } # Player Dupe Distress
InjectionHelper.defineCommonPatch(50) { darchaxel_inject_special_sprite(self, 'PlayerKnockedOut_4') } # Player Dupe Knocked
InjectionHelper.defineCommonPatch(136, &method(:darchaxel_hotfix_battyfriends)) # Batty Friends
