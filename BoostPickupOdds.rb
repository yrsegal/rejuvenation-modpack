def Kernel.pbPickup(pokemon)
  return if !(pokemon.ability == :PICKUP) || pokemon.isEgg?
  return if !pokemon.item.nil?
  ### MODDED/
  return if rand(3)!=0
  ### /MODDED
  pickupList= PickupNormal

  pickupListRare= PickupRare
  return if pickupList.length != 18
  return if pickupListRare.length != 11
  randlist = [30, 10, 10, 10, 10, 10, 10, 4, 4, 1, 1]
  items = []
  plevel = [100,pokemon.level].min
  rnd = rand(100)
  itemstart = (plevel - 1) / 10
  itemstart = 0 if itemstart < 0
  for i in 0...9
    items.push(pickupList[i + itemstart])
  end
  items.push(pickupListRare[itemstart])
  items.push(pickupListRare[itemstart + 1])
  cumnumber = 0
  for i in 0...11
    cumnumber += randlist[i]
    if rnd < cumnumber
      return items[i]
    end
  end
end