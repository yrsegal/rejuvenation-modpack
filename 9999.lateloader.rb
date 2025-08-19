if defined?($WIRE_LATE_LOAD) && $WIRE_LATE_LOAD.is_a?(Array)
  $WIRE_LATE_LOAD.each(&:call)
end

$WIRE_LATE_LOAD = Class.new do
  def <<(p1)
    p1.call
  end
end.new

class Game_System
  alias :lateloader_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = lateloader_old_initialize(*args, **kwargs)
    $WIRE_LATE_LOAD = [] # You should not be registering to this after it's been built!
    return ret
  end
end
