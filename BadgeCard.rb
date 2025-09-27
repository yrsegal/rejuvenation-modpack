
class ItemData < DataObject
  attr_writer :flags
end

$cache.items[:BADGECARD].flags[:noUse] = false

Variables[:OnlineLeague] = 79

ItemHandlers::UseFromBag.add(:BADGECARD,proc{|item|
   Kernel.pbMessage(_INTL("Virtual Badges: {1}",$game_variables[:OnlineLeague] - 1))
   next 1 # Continue
})
