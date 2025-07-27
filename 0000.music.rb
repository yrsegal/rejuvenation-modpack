module MusicOverrides
  MUSIC_OVERRIDES = {
  }

  def self.registerMusicOverride(from, to)
    MusicOverrides::MUSIC_OVERRIDES[from] = to
  end

  def self.registerMusicOverrides(hashOf)
    hashOf.each_pair { |from, to| registerMusicOverride(from, to) }
  end

  COMPILED_MUSIC_OVERRIDES = {}

  def self.setup
    return if MusicOverrides::COMPILED_MUSIC_OVERRIDES.size != 0
    compileMusicOverrides
  end

  def self.compileMusicOverrides
    MusicOverrides::MUSIC_OVERRIDES.each_pair {|k, v| MusicOverrides::COMPILED_MUSIC_OVERRIDES[k.downcase] = v }
  end

  def self.mapPath(path)
    path = path.downcase

    ext = ''
    noext = path.gsub(/(\.(?:mp3|wav|wma|midi?|ogg))$/,"")
    if noext != path
      ext = $1
    end

    noext = MusicOverrides::COMPILED_MUSIC_OVERRIDES[noext] if MusicOverrides::COMPILED_MUSIC_OVERRIDES[noext]

    return noext + ext
  end
end

# Compile after mod load

class Game_System
  alias :musicoverride_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = musicoverride_old_initialize(*args, **kwargs)
    MusicOverrides.setup
    return ret
  end
end

[:bgm_play, :bgs_play, :me_play, :se_play].each { |it|
  Audio.instance_eval(<<__END__)
    unless defined?(musicoverride_old_#{it})
      alias :musicoverride_old_#{it} :#{it}
    end
    def #{it}(name, *args, **kwargs)
      musicoverride_old_#{it}(MusicOverrides.mapPath(name), *args, **kwargs)
    end
__END__
}

alias :musicoverride_old_pbResolveAudioSE :pbResolveAudioSE

def pbResolveAudioSE(file)
  full = ('Audio/SE/' + file).downcase
  mapped = MusicOverrides.mapPath(full)
  return mapped == full ? musicoverride_old_pbResolveAudioSE(file) : mapped
end