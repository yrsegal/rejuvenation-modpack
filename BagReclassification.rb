
class ItemData < DataObject
  attr_writer :flags
end


### Evo stones

EVOSTONES |= [:ANCIENTTEACH, :APOPHYLLPAN, :LINKHEART]

for stone in EVOSTONES
  $cache.items[stone].flags[:evoitem] = true if $cache.items[stone]
end

alias :evostonefix_old_checkEvolution :checkEvolution

def checkEvolution(pokemon,item=nil)
  return pbTradeCheckEvolution(pokemon,item,true) if item == :LINKHEART
  return evostonefix_old_checkEvolution(pokemon,item)
end

### Golden Items

PBStuff::HMTOGOLDITEM.values.each { |goldenitem|
  $cache.items[goldenitem].flags[:niche] = true
}

### Memories

for item in $cache.items.values
  if item.checkFlag?(:memory)
    item.flags[:legendary] = true # Memories *should* be getting sorted on their own, but typo.
  end
end

$cache.items[:BALMMUSHROOM].flags[:justsell] = true
$cache.items[:AMPLIFIELDROCK].flags[:battlehold] = true
$cache.items[:BELLMCHN].flags[:keyitem] = true

for rod in [:OLDROD, :GOODROD, :SUPERROD]
  $cache.items[rod].flags[:important] = true
end

for petal in [:PINKPETAL,:GREENPETAL,:ORANGEPETAL,:BLUEPETAL]
  $cache.items[petal].flags[:nectar] = true
end
