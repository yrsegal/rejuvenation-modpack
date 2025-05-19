module TextureOverrides
  MOD = 'Data/Mods/TextureOverrides/'
  SERVICE = 'Data/Mods/ServiceIcons/'
  NPCICONS = 'Graphics/Pictures/'
  MAP = 'Graphics/Pictures/RegionMap/'
  SUMMARY = 'Graphics/Pictures/Summary/'
  CHARS = 'Graphics/Characters/'
  VS = 'Graphics/Transitions/'
  ICONS = 'Graphics/Icons/'


  TEXTURE_OVERRIDES = {
    # Misc builtin overrides

    # Steel Diamond for better readability
    TextureOverrides::ICONS + 'bosstypeSTEEL' => TextureOverrides::MOD + 'SteelDiamond',

    # Missing Summary ball
    TextureOverrides::SUMMARY + 'summaryballDREAMBALL' => TextureOverrides::MOD + 'DreamBallSummary',
    # Fix Lure Ball colors
    TextureOverrides::SUMMARY + 'summaryballLUREBALL' => TextureOverrides::MOD + 'LureBallSummary',
    # Fix the misshappen Beast Ball summary (sprite from Caruban's gen 9 compilation)
    TextureOverrides::SUMMARY + 'summaryballBEASTBALL' => TextureOverrides::MOD + 'BeastBallSummary'
  }


  def self.registerServiceSprites(*spriteNames)
    for spriteName in spriteNames
      registerTextureOverride(TextureOverrides::NPCICONS + 'service_' + spriteName, TextureOverrides::SERVICE + spriteName)
    end
  end

  def self.registerTextureOverride(from, to)
    TextureOverrides::TEXTURE_OVERRIDES[from] = to
  end

  def self.registerTextureOverrides(hashOf)
    hashOf.each_pair { |k, v|
      registerTextureOverride(k, v)
    }
  end

  # Replacing Trainer Classes to get a different sprite

  TCLASSES = {}

  def self.registerTrainerClass(className, classData)
    TextureOverrides::TCLASSES[className] = classData
  end

  TCLASS_REPLACEMENTS = {}

  def self.replaceTrainerClass(trainerName, trainerClass, teamID, newTrainerName: nil, newTrainerClass: nil, newTeamID: nil)
    TextureOverrides::TCLASS_REPLACEMENTS[[trainerName, trainerClass, teamID]] = [
      newTrainerName.nil? ? trainerName : newTrainerName,
      newTrainerClass.nil? ? trainerClass : newTrainerClass,
      newTeamID.nil? ? teamID : newTeamID
    ]
  end


  COMPILED_TEXTURE_OVERRIDES = {}

  def self.setup
    return if TextureOverrides::COMPILED_TEXTURE_OVERRIDES.size != 0
    trainerClassSetup
    compileTextureOverrides
  end

  def self.compileTextureOverrides
    TextureOverrides::TEXTURE_OVERRIDES.each_pair {|k, v| COMPILED_TEXTURE_OVERRIDES[k.downcase] = v }
  end

  def self.trainerClassSetup
    # Apply trainer class changes

    highestIdTtype = 0
    $cache.trainertypes.each_value { |tclass|
      id = tclass.checkFlag?(:ID,0)
      highestIdTtype = id if id > highestIdTtype
    }

    TextureOverrides::TCLASSES.each { |classsym, data|
      replacements = data[:replacements] || {}
      data.delete(:replacements)

      id = data[:ID]

      if !id
        highestIdTtype += 1
        data[:ID] = highestIdTtype
        id = highestIdTtype
      end
      $cache.trainertypes[classsym] = TrainerData.new(classsym,data)
      replacements.each { |fromPath, toPath|
        registerTextureOverride(fromPath.gsub('{ID}', id.to_s), toPath)
      }
    }

    TextureOverrides::TCLASS_REPLACEMENTS.each { |key, replacement| 
      symkey = key[1]
      namekey = key[0]
      idkey = key[2]

      symrepl = replacement[1]
      namerepl = replacement[0]
      idrepl = replacement[2]

      trainer = nil
      trainerarray = $cache.trainers.dig(symkey,namekey)
      for trainerCandidate in trainerarray
        if trainerCandidate[0] == idkey
          trainer = trainerCandidate
          break
        end
      end

      if trainer
        trainer[0] = idrepl
        if namekey != namerepl || symkey != symrepl
          trainerarray.delete(trainer)
          $cache.trainers[symrepl] = {} if !$cache.trainers[symrepl]
          $cache.trainers[symrepl][namerepl] = [] if !$cache.trainers[symrepl][namerepl]

          injected = false

          for replacementCandidate in $cache.trainers[symrepl][namerepl]
            if replacementCandidate[0] == idrepl
              injected = true
              replacementCandidate[1] = trainer[1]
              break
            end
          end

          $cache.trainers[symrepl][namerepl] = [trainer] if !injected
        end
      end
    }
  end

  def self.mapKey(key)
    if key.kind_of?(String)
      key = mapPath(key)
    elsif key.kind_of?(Array)
      key[0] = mapPath(key[0])
      downcased = key[0].downcase
      key[0] = TextureOverrides::COMPILED_TEXTURE_OVERRIDES[downcased] if TextureOverrides::COMPILED_TEXTURE_OVERRIDES[downcased]
    end

    return key
  end

  def self.mapPath(path)
    path = path.downcase

    ext = ''
    noext = path.gsub(/(\.(?:bmp|png|gif|jpg|jpeg))$/,"")
    if noext != path
      ext = $1
    end

    noext = TextureOverrides::COMPILED_TEXTURE_OVERRIDES[noext] if TextureOverrides::COMPILED_TEXTURE_OVERRIDES[noext]

    return noext + ext
  end
end

# Compile after mod load

class Game_System
  if !defined?(textureoverride_old_initialize)
    alias :textureoverride_old_initialize :initialize
  end

  def initialize(*args, **kwargs)
    ret = textureoverride_old_initialize(*args, **kwargs)
    TextureOverrides.setup
    return ret
  end
end


if !defined?(textureoverride_old_pbLoadTrainer)
  alias :textureoverride_old_pbLoadTrainer :pbLoadTrainer
end

def pbLoadTrainer(type,tname,id=0,noscaling=false)
  key = [tname, type, id]
  replclass = TextureOverrides::TCLASS_REPLACEMENTS[key]
  if replclass
    type = replclass[1]
    tname = replclass[0]
    id = replclass[2]
  end
  return textureoverride_old_pbLoadTrainer(type,tname,id,noscaling)
end

if !defined?(textureoverride_old_pbRegisterPartner)
  alias :textureoverride_old_pbRegisterPartner :pbRegisterPartner
end

def pbRegisterPartner(trainerid,trainername,partyid=0)
  key = [trainername, trainerid, partyid]
  replclass = TextureOverrides::TCLASS_REPLACEMENTS[key]
  if replclass
    trainerid = replclass[1]
    trainername = replclass[0]
    partyid = replclass[2]
  end
  return textureoverride_old_pbRegisterPartner(trainerid,trainername,partyid)
end

# Replacement code

module RPG
  module Cache
    singleton_class.class_eval do
      if !defined?(textureoverride_old_fromCache)
        alias :textureoverride_old_fromCache :fromCache
      end
      if !defined?(textureoverride_old_setKey)
        alias :textureoverride_old_setKey :setKey
      end
      if !defined?(textureoverride_old_load_bitmap)
        alias :textureoverride_old_load_bitmap :load_bitmap
      end
      if !defined?(textureoverride_old_tileEx)
        alias :textureoverride_old_tileEx :tileEx
      end
    end
        
    def self.setKey(key, obj)
      return self.textureoverride_old_setKey(TextureOverrides::mapKey(key), obj)
    end

    def self.load_bitmap(filename, hue = 0)
      return self.textureoverride_old_load_bitmap(TextureOverrides::mapKey(filename), hue)
    end

    def self.tileEx(filename, tile_id, hue, width = 1, height = 1)
      return self.textureoverride_old_tileEx(TextureOverrides::mapKey(filename), tile_id, hue, width, height) { |it| yield it }
    end
    
    def self.fromCache(i)
      return self.textureoverride_old_fromCache(TextureOverrides.mapKey(i))
    end
  end
end

if !defined?(textureoverride_old_pbResolveBitmap)
  alias :textureoverride_old_pbResolveBitmap :pbResolveBitmap
end

def pbResolveBitmap(x)
  return textureoverride_old_pbResolveBitmap(TextureOverrides.mapKey(x))
end
