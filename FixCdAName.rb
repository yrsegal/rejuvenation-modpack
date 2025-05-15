# For unknown reasons, Castillo De Ángel's name is broken. let's fix that.
$cache.mapinfos.each_value { |mapinfo|
  if /Castillo De(la )? \S?ngel/.match?(mapinfo.name)
    mapinfo.name = mapinfo.name.gsub(/\S?ngel/, 'Ángel')
  end
}