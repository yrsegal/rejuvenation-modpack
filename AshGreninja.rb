$cache.abil[:BATTLEBOND] = AbilityData.new(:BATTLEBOND, {
  name: "Battle Bond",
  desc: "Becomes powerful after knocking out a foe...",
  fullDesc: "Defeating an opposing Pokémon strengthens the Pokémon's bond with its Trainer, and it becomes Ash-Greninja. Water Shuriken gets stronger."
})

TextureOverrides.registerTextureOverrides({
  TextureOverrides::ICONS + "icon658_2" => TextureOverrides::MODBASE + "AshGreninja/Icon",
  TextureOverrides::BATTLER + "658_2" => TextureOverrides::MODBASE + "AshGreninja/GreninjaFront",
  TextureOverrides::BATTLER + "658b_2" => TextureOverrides::MODBASE + "AshGreninja/GreninjaBack",
  TextureOverrides::BATTLER + "658s_2" => TextureOverrides::MODBASE + "AshGreninja/GreninjaSFront",
  TextureOverrides::BATTLER + "658sb_2" => TextureOverrides::MODBASE + "AshGreninja/GreninjaSBack"
})

PBStuff::ABILITYBLACKLIST.push(:BATTLEBOND)

alias :ashgreninja_old_pbIconBitmap :pbIconBitmap
alias :ashgreninja_old_pbPokemonIconBitmap :pbPokemonIconBitmap

def pbPokemonIconBitmap(pokemon,egg=false)
  if (pokemon.species == :GRENINJA && pokemon.form == 2) || (pokemon.species == :PIKACHU && pokemon.form == 3)
    shiny = pokemon.isShiny?
    girl = pokemon.isFemale? ? "f" : ""
    form = pokemon.form
    egg = egg ? "egg" : ""
    species = $cache.pkmn[pokemon.species].dexnum 
    name = pokemon.species.downcase
    filename=sprintf("Graphics/Icons/icon%03d%s%s_%s",species,girl,egg,form)
    filename=sprintf("Graphics/Icons/icon%03d%s_%s", species,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/%s%s%s_%s",name,girl,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/%s%s_%s",name,egg,form) if !pbResolveBitmap(filename)
    if pbResolveBitmap(filename)
      iconbitmap = RPG::Cache.load_bitmap(filename)
      bitmap=Bitmap.new(128,64)
      x = shiny ? 128 : 0
      y = 0 # No form differentiation
      y = 0 if iconbitmap.height <= y
      rectangle = Rect.new(x,y,128,64)
      bitmap.blt(0,0,iconbitmap,rectangle)
      bitmap = makeShadowBitmap(bitmap, 128, 64) if pokemon.isShadow?
      return bitmap
    end
  end

  return ashgreninja_old_pbPokemonIconBitmap(pokemon,egg)
end


def pbIconBitmap(species,form=0,shiny=false,girl=false,egg=false)
  if (species == :GRENINJA && form == 2) || (species == :PIKACHU && form == 3)
    filename=sprintf("Graphics/Icons/icon%03d%s%s_%s",species,girl,egg,form)
    filename=sprintf("Graphics/Icons/icon%03d%s_%s", species,egg,form) if !pbResolveBitmap(filename)
    filename=sprintf("Graphics/Icons/icon%03d_%s",species, form) if !pbResolveBitmap(filename)
    if pbResolveBitmap(filename)
      iconbitmap = RPG::Cache.load_bitmap(filename)
      bitmap=Bitmap.new(128,64)
      x = shiny ? 128 : 0
      y = 0 # No form differentiation
      y = 0 if iconbitmap.height <= y
      rectangle = Rect.new(x,y,128,64)
      return bitmap
    end
  end

  return ashgreninja_old_pbIconBitmap(species,form,shiny,girl,egg)
end

$cache.pkmn[:GRENINJA].formData["Battle Bond"] = {
  Abilities: [:BATTLEBOND],
  :ExcludeDex => true,
}

$cache.pkmn[:GRENINJA].formData["Ash-Greninja"] = {
  Abilities: [:BATTLEBOND],
  :BaseStats => [72, 145, 67, 153, 71, 132],
  :toobig => true,
}

$cache.pkmn[:GRENINJA].forms[1] = "Battle Bond"
$cache.pkmn[:GRENINJA].forms[2] = "Ash-Greninja"

class PokeBattle_Battle
  alias :ashgreninja_old_pbEndOfBattle :pbEndOfBattle
  def pbEndOfBattle(*args,**kwargs)
    decision=ashgreninja_old_pbEndOfBattle(*args,**kwargs)
    for i in @battlers
      next if i.nil?
      i.ashgreninja_restoreform
    end
    return decision
  end
end

class PokeBattle_Battler
  def ashgreninja_restoreform
    if self.species == :GRENINJA && self.form == 2
      self.form = 1
    end
  end


  alias :ashgreninja_old_pbFaint :pbFaint
  def pbFaint(*args,**kwargs)
    dogreninja = self.isFainted? && !@fainted
    ret = ashgreninja_old_pbFaint(*args,**kwargs)
    ashgreninja_restoreform if dogreninja
    return ret
  end

  alias :ashgreninja_old_pbProcessMoveAgainstTarget :pbProcessMoveAgainstTarget
  def pbProcessMoveAgainstTarget(basemove,user,target,*args,**kwargs)
    ret = ashgreninja_old_pbProcessMoveAgainstTarget(basemove,user,target,*args,**kwargs)
    if !user.isFainted? && target.isFainted?
      if self.species == :GRENINJA && self.form == 1 && self.ability == :BATTLEBOND
        @battle.pbDisplay(_INTL("{1} became fully charged due to its bond with its Trainer!", pbThis))

        @battle.pbCommonAnimation("MegaEvolution",self,nil)

        self.form=2
        backupability = @pokemon.ability
        pbUpdate
        @battle.scene.pbChangePokemon(self,@pokemon) if self.effects[:Substitute]==0

        @battle.pbDisplay(_INTL("{1} became Ash-Greninja!",pbThis))
      end
    end

    return ret
  end
end
class PokeBattle_Move_0C0 # Water Shuriken
  alias :ashgreninja_old_pbNumHits :pbNumHits
  def pbNumHits(attacker)
    return 3 if @move == :WATERSHURIKEN && attacker.species == :GRENINJA && attacker.form == 2 && attacker.ability == :BATTLEBOND
    return ashgreninja_old_pbNumHits(attacker)
  end

  def pbBaseDamage(basedmg,attacker,opponent)
    return 20 if @move == :WATERSHURIKEN && attacker.species == :GRENINJA && attacker.form == 2 && attacker.ability == :BATTLEBOND
    return basedmg
  end
end

