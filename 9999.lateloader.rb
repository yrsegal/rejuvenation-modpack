if defined?($WIRE_LATE_LOAD) && $WIRE_LATE_LOAD.is_a?(Array)
  $WIRE_LATE_LOAD.each(&:call)
end

$WIRE_LATE_LOAD = Class.new do
  def <<(p1)
    p1.call
  end
end.new
