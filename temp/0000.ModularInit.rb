DEBUGMODULARTRIGGER 					= false
RELEARNMOVESANYWHEREMOD      	= false
FASTHATCHMOD       						= false
CHANGEHIDDENPOWERMOD          = false
ITEMRESTOREREPLACE            = false

def swm_pbRest
  if !swm_canRest?()
    Kernel.pbMessage(_INTL('You feel uneasy, and are unable to sleep.\n(Unreal Time is turned off!)'))
    return
  end
  timePast=swm_getHowLongToRestFor() # Returns the number of real time seconds that are supposed to have been passed
  return nil if timePast == 0
  $gameTimeLastCheck-=timePast
  $game_screen.getTimeCurrent() # Will update the time
  Kernel.pbMessage(_INTL('Please exit the area to properly update its events.'))
end

def swm_canRest?
  return false if !$game_switches[:Unreal_Time]
  return $Settings.unrealTimeDiverge != 0
end

def swm_getHowLongToRestFor
  choice=Kernel.pbMessage(
    _INTL('Do you wish to rest for a while or until some time?'),
    [
      _INTL('For a while'),
      _INTL('Until some time'),
      _INTL('I changed my mind')
    ],
    3
  )
  return swm_getHowLongToRestForAsPeriod if choice == 0
  return swm_getHowLongToRestForAsPointInTime if choice == 1
  return 0
end

def swm_getHowLongToRestForAsPeriod
  params=ChooseNumberParams.new
  params.setRange(0,9999)
  params.setDefaultValue(0)
  hours=Kernel.pbMessageChooseNumber(_INTL('How many hours would you like to rest?'), params)
  seconds=hours*3600
  return seconds.to_f / $game_screen.getTimeScale().to_f
end

def swm_getHowLongToRestForAsPointInTime
  now=$game_screen.getTimeCurrent()
  # Get the target weekday
  choiceWday=Kernel.pbMessage(
    _INTL('When would you like to wake up?'),
    [
      _INTL('Sunday'),
      _INTL('Monday'),
      _INTL('Tuesday'),
      _INTL('Wednesday'),
      _INTL('Thursday'),
      _INTL('Friday'),
      _INTL('Saturday'),
      _INTL('Never')
    ],
    8
  )
  if choiceWday == 7
    Kernel.pbMessage(_INTL("Oh.\nI... I'll leave you alone now."))
    return 0
  end
  daysPast=choiceWday-now.wday
  while daysPast < 0
    daysPast+=7
  end
  # Get the target hour
  params=ChooseNumberParams.new
  params.setRange(0,23)
  params.setDefaultValue(now.hour)
  choiceHour=Kernel.pbMessageChooseNumber(_INTL('At which hour?'), params)
  hoursPast=choiceHour-now.hour
  # Combine the two
  hours=daysPast*24+hoursPast
  while hours < 0
    # Go to the next week
    hours+=168 # 24*7 = 168
  end
  seconds=hours*3600 # 60*60 = 3600
  return seconds.to_f / $game_screen.getTimeScale().to_f
end

def mod_HiddenPowerChanger(mon)
  pbHiddenPower(mon) if !mon.hptype
  oldtype=mon.hptype
  typechoices = [_INTL("Bug"),_INTL("Dark"),_INTL("Dragon"),_INTL("Electric"),_INTL("Fairy"),_INTL("Fighting"),_INTL("Fire"),_INTL("Flying"),_INTL("Ghost"),_INTL("Grass"),_INTL("Ground"),_INTL("Ice"),_INTL("Poison"),_INTL("Psychic"),_INTL("Rock"),_INTL("Steel"),_INTL("Water"),_INTL("Cancel")]
  choosetype = Kernel.pbMessage(_INTL("Which type should Hidden Power become?"),typechoices,18)
  case choosetype
    when 0 then newtype=:BUG
    when 1 then newtype=:DARK
    when 2 then newtype=:DRAGON
    when 3 then newtype=:ELECTRIC
    when 4 then newtype=:FAIRY
    when 5 then newtype=:FIGHTING
    when 6 then newtype=:FIRE
    when 7 then newtype=:FLYING
    when 8 then newtype=:GHOST
    when 9 then newtype=:GRASS
    when 10 then newtype=:GROUND
    when 11 then newtype=:ICE
    when 12 then newtype=:POISON
    when 13 then newtype=:PSYCHIC
    when 14 then newtype=:ROCK
    when 15 then newtype=:STEEL
    when 16 then newtype=:WATER
    else newtype=-1
  end
  if newtype == -1
    Kernel.pbMessage(_INTL("Changed your mind?"))
    return false
  end
  if (choosetype >= 0) && (choosetype < 17) && newtype!=oldtype
    mon.hptype=newtype
    Kernel.pbMessage(_INTL("Hidden Power is now {1} type.", mon.hptype))
    return true
  end
  if newtype==oldtype
    Kernel.pbMessage(_INTL("Hidden Power is already that type!"))
  else
    Kernel.pbMessage(_INTL("Changed your mind?"))
  end
  return false
end