# Last Respects
# Will not factor in Revives, using the rejuv fainted pokemon count method
class PokeBattle_Move_DED < PokeBattle_Move
  def pbBaseDamageMultiplier(damagemult,attacker,opponent)
    return damagemult * (1 + attacker.pbFaintedPokemonCount)
  end

  # Replacement animation till a proper one is made
  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    return if !showanimation 
    @battle.pbAnimation(:SHADOWBONE,attacker,opponent,hitnum) 
  end
end

class PokeBattle_AI
  alias :lastrespects_old_pbBetterBaseDamage :pbBetterBaseDamage

  def pbBetterBaseDamage(move=@move,attacker=@attacker,opponent=@opponent)
    if move.function == 0xDED
      return move.basedamage * (1 + attacker.pbFaintedPokemonCount)
    end
    return lastrespects_old_pbBetterBaseDamage(move,attacker,opponent)
  end
end

$cache.moves[:LASTRESPECTS] = MoveData.new(:LASTRESPECTS, {
  name: "Last Respects",
  function: 0xDED,
  type: :GHOST,
  category: :physical,
  basedamage: 50,
  accuracy: 100,
  maxpp: 10,
  target: :SingleNonUser,
  kingrock: true,
  desc: "The user attacks to avenge its allies. The more defeated allies there are in the user's party, the greater the move's power."
})

begin
  formdata = $cache.pkmn[:BASCULIN].formData["White-Striped"]
  formdata[:EggMoves] = [] unless formdata[:EggMoves]
  formdata[:EggMoves].push(:LASTRESPECTS) unless formdata[:EggMoves].include?(:LASTRESPECTS)
end
