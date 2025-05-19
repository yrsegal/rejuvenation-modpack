###### MOD ######
class RestToWaitPC
  def shouldShow?
    return true
  end

  def name
    return _INTL("Rest to Wait")
  end

  def access
    swm_pbRest
  end
end

PokemonPCList.registerPC(RestToWaitPC.new)
###### MOD ######
