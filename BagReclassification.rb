
class ItemData < DataObject
  attr_accessor :flags
end


### Evo stones

EVOSTONES |= [:ANCIENTTEACH, :APOPHYLLPAN, :LINKHEART]

for stone in EVOSTONES
  $cache.items[stone].flags[:evoitem] = true if $cache.items[stone]
end

if !defined?(evostonefix_old_checkEvolution)
  alias :evostonefix_old_checkEvolution :checkEvolution
end

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

$cache.items[:OLDROD].flags[:important] = true
$cache.items[:GOODROD].flags[:important] = true
$cache.items[:SUPERROD].flags[:important] = true