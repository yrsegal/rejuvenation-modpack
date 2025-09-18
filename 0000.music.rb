module MusicOverrides
  MODBASE = __dir__[Dir.pwd.length+1..] + '/'
  
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
    begin
      missing = MusicOverrides::MUSIC_OVERRIDES.values.select { |f| !FileTest.audio_exist?(f) }
      print "Missing asset #{missing[0]}. Please download it." if missing.length == 1
      print "Assets #{missing.join(", ")} are missing. Please download them." if missing.length > 1
    end
  end

  def self.mapPath(origPath, pathbase=nil)
    path = origPath.downcase

    ext = ''
    noext = path.gsub(/(\.(?:mp3|wav|wma|midi?|ogg))$/,"")
    if noext != path
      ext = $1
    end

    fullpath = noext
    fullpath = "audio/#{pathbase}/" + noext if pathbase && !fullpath.start_with?("audio/#{pathbase}/")

    if MusicOverrides::COMPILED_MUSIC_OVERRIDES[fullpath]
      return MusicOverrides::COMPILED_MUSIC_OVERRIDES[fullpath] + ext
    else
      return origPath
    end
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

[:bgm, :bgs, :me, :se].each { |it|
  Audio.instance_eval(<<~END)
    unless defined?(musicoverride_old_#{it}_play)
      alias :musicoverride_old_#{it}_play :#{it}_play
    end
    def #{it}_play(name, *args, **kwargs)
      musicoverride_old_#{it}_play(MusicOverrides.mapPath(name, '#{it}'), *args, **kwargs)
    end
  END
}

FileTest.instance_eval do 
  unless defined?(musicoverride_old_audio_exist?)
    alias :musicoverride_old_audio_exist? :audio_exist?
  end

  def audio_exist?(name)
    musicoverride_old_audio_exist?(MusicOverrides.mapPath(name))
  end
end

alias :musicoverride_old_pbResolveAudioSE :pbResolveAudioSE

def pbResolveAudioSE(file)
  return nil if !file

  mapped = MusicOverrides.mapPath(file, 'se')
  if mapped != file && RTP.exists?(mapped,["",".wav",".mp3",".ogg"])
    return RTP.getPath(mapped,["",".wav",".mp3",".ogg"])
  end

  return musicoverride_old_pbResolveAudioSE(file)
end