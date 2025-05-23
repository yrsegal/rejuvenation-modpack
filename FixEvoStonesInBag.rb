
class ItemData < DataObject
  attr_accessor :flags
end

EVOSTONES |= [:ANCIENTTEACH, :APOPHYLLPAN, :LINKHEART]

for stone in EVOSTONES
  $cache.items[stone].flags[:evoitem] = true if $cache.items[stone]
end

for item in $cache.items.values
  if item.checkFlag?(:memory)
    item.flags[:legendary] = true
  end
end

if !defined?(evostonefix_old_checkEvolution)
  alias :evostonefix_old_checkEvolution :checkEvolution
end

def checkEvolution(pokemon,item=nil)
  return pbTradeCheckEvolution(pokemon,item,true) if item == :LINKHEART
  return evostonefix_old_checkEvolution(pokemon,item)
end
