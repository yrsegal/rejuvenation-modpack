module TextureOverrides
  MODBASE = __dir__[Dir.pwd.length+1..] + '/'
  MOD = MODBASE + 'TextureOverrides/'
  SERVICE = MODBASE + 'ServiceIcons/'
  SKINS = MODBASE + 'Windowskins/'
  NPCICONS = 'Graphics/Pictures/'
  MAP = 'Graphics/Pictures/RegionMap/'
  SUMMARY = 'Graphics/Pictures/Summary/'
  BATTLER = 'Graphics/Battlers/'
  BATTLEICON = 'Graphics/Pictures/Battle/'
  CHARS = 'Graphics/Characters/'
  VS = 'Graphics/Transitions/'
  ICONS = 'Graphics/Icons/'
  SPEECH = 'Graphics/Windowskins/'


  TEXTURE_OVERRIDES = {
    # Misc builtin overrides

    # Steel Diamond for better readability
    TextureOverrides::ICONS + 'bosstypeSTEEL' => TextureOverrides::MOD + 'SteelDiamond',

    # Missing Summary ball
    TextureOverrides::SUMMARY + 'summaryballDREAMBALL' => TextureOverrides::MOD + 'Pokeballs/DreamBallSummary',
    # Fix Lure Ball colors
    TextureOverrides::SUMMARY + 'summaryballLUREBALL' => TextureOverrides::MOD + 'Pokeballs/LureBallSummary',
    TextureOverrides::BATTLEICON + 'LUREBALL' => TextureOverrides::MOD + 'Pokeballs/LureBallThrow',
    TextureOverrides::BATTLEICON + 'LUREBALL_open' => TextureOverrides::MOD + 'Pokeballs/LureBallOpen',
    # Fix the misshappen Beast Ball sprites (sprite from Caruban's gen 9 compilation)
    TextureOverrides::SUMMARY + 'summaryballBEASTBALL' => TextureOverrides::MOD + 'Pokeballs/BeastBallSummary',
    TextureOverrides::BATTLEICON + 'BEASTBALL' => TextureOverrides::MOD + 'Pokeballs/BeastBallThrow',
    TextureOverrides::BATTLEICON + 'BEASTBALL_open' => TextureOverrides::MOD + 'Pokeballs/BeastBallOpen',
    # Fix some misshappen/miscolored summary sprites
    TextureOverrides::SUMMARY + 'summaryballMINERALBALL' => TextureOverrides::MOD + 'Pokeballs/MineralBallSummary',
    TextureOverrides::SUMMARY + 'summaryballNETBALL' => TextureOverrides::MOD + 'Pokeballs/NetBallSummary',
    TextureOverrides::SUMMARY + 'summaryballSTEAMBALL' => TextureOverrides::MOD + 'Pokeballs/SteamBallSummary',

    # Fix typos
    TextureOverrides::ICONS + "jynnobikey" => TextureOverrides::ICONS + "lightkey",
    TextureOverrides::ICONS + "blackshard2" => TextureOverrides::ICONS + "blackshard",
    TextureOverrides::ICONS + "blkapricorn" => TextureOverrides::ICONS + "blackapricorn",

    TextureOverrides::CHARS + "trchar117_bike" => TextureOverrides::MOD + 'MissingTextures/ErinRide',
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
    hashOf.each_pair { |from, to| registerTextureOverride(from, to) }
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
    $cache.metadata[:Players][17][:bike] = "trchar117_bike"
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
  alias :textureoverride_old_initialize :initialize

  def initialize(*args, **kwargs)
    ret = textureoverride_old_initialize(*args, **kwargs)
    TextureOverrides.setup
    return ret
  end
end


alias :textureoverride_old_pbLoadTrainer :pbLoadTrainer

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

alias :textureoverride_old_pbRegisterPartner :pbRegisterPartner

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

RPG::Cache.instance_eval do
  alias :textureoverride_old_fromCache :fromCache
  alias :textureoverride_old_setKey :setKey
  alias :textureoverride_old_load_bitmap :load_bitmap
  alias :textureoverride_old_tileEx :tileEx

  def setKey(key, obj)
    return textureoverride_old_setKey(TextureOverrides::mapKey(key), obj)
  end

  def load_bitmap(filename, hue = 0)
    return textureoverride_old_load_bitmap(TextureOverrides::mapKey(filename), hue)
  end

  def tileEx(filename, tile_id, hue, width = 1, height = 1, &block)
    return textureoverride_old_tileEx(TextureOverrides::mapKey(filename), tile_id, hue, width, height, &block)
  end

  def fromCache(i)
    return textureoverride_old_fromCache(TextureOverrides.mapKey(i))
  end
end

alias :textureoverride_old_pbResolveBitmap :pbResolveBitmap

def pbResolveBitmap(x)
  return textureoverride_old_pbResolveBitmap(TextureOverrides.mapKey(x))
end
