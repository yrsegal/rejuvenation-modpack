
$MOD = 'Data/Mods/TextureOverrides/'
$SERVICE = 'Data/Mods/ServiceIcons/'
$NPCICONS = 'Graphics/Pictures/'
$MAP = 'Graphics/Pictures/RegionMap/'
$CHARS = 'Graphics/Characters/'
$VS = 'Graphics/Transitions/'
$ICONS = 'Graphics/Icons/'


$DECLARED_OVERRIDES = {
  # Legacy Ana
  $CHARS + 'BGirlAerialDrive_2' => $MOD + 'Ana/Legacy/Flying',
  $CHARS + 'BGirlAquaDrive_2' => $MOD + 'Ana/Legacy/Surfing',
  $CHARS + 'BGirlFishingDrive_2' => $MOD + 'Ana/Legacy/Fishing',
  $CHARS + 'BGirlSurfFishDrive_2' => $MOD + 'Ana/Legacy/SurfFish',
  $CHARS + 'BGirlDiveDrive_2' => $MOD + 'Ana/Legacy/Diving',
  $MAP + 'mapPlayer007_2' => $MOD + 'Ana/Legacy/MapHead',
  $CHARS + 'Trainer007_2' => $MOD + 'Ana/Legacy/Trainer',

  # Star of Hope
  $CHARS + 'BGirlAerialDrive_3' => $MOD + 'Ana/Star/Flying',
  $CHARS + 'BGirlAquaDrive_3' => $MOD + 'Ana/Star/Surfing',
  $CHARS + 'BGirlFishingDrive_3' => $MOD + 'Ana/Star/Fishing',
  $CHARS + 'BGirlSurfFishDrive_3' => $MOD + 'Ana/Star/SurfFish',
  $CHARS + 'BGirlDiveDrive_3' => $MOD + 'Ana/Star/Diving',
  $CHARS + 'BGirlWalk_3' => $MOD + 'Ana/Star/Walk',
  $CHARS + 'BGirlRun2_3' => $MOD + 'Ana/Star/Run',
  $CHARS + 'Trainer007_3' => $MOD + 'Ana/Star/Trainer',
  $CHARS + 'trBack007_3' => $MOD + 'Ana/Star/TrainerBack',
  $MAP + 'mapPlayer007_3' => $MOD + 'Ana/Star/MapHead',
  $VS + 'vsTrainer7_3' => $MOD + 'Ana/Star/VS',
  $CHARS + 'PlayerHeadache_8_3' => $MOD + 'Ana/Star/Headache',
  $CHARS + 'PlayerKnockedOut_8_3' => $MOD + 'Ana/Star/KO',
  $CHARS + 'BattyFriends_Ana_3' => $MOD + 'Ana/Star/BattyFriends',

  # Darchlight Ana
  $CHARS + 'BGirlAerialDrive_4' => $MOD + 'Ana/Darchlight/Drive',
  $CHARS + 'BGirlAquaDrive_4' => $MOD + 'Ana/Darchlight/Drive',
  $CHARS + 'BGirlFishingDrive_4' => $MOD + 'Ana/Darchlight/Drive',
  $CHARS + 'BGirlSurfFishDrive_4' => $MOD + 'Ana/Darchlight/Drive',
  $CHARS + 'BGirlDiveDrive_4' => $MOD + 'Ana/Darchlight/Diving',
  $CHARS + 'BGirlWalk_4' => $MOD + 'Ana/Darchlight/Walk',
  $CHARS + 'BGirlRun2_4' => $MOD + 'Ana/Darchlight/Run',
  $CHARS + 'Trainer007_4' => $MOD + 'Ana/Darchlight/Trainer',
  $CHARS + 'trBack007_4' => $MOD + 'Ana/Darchlight/TrainerBack',
  $MAP + 'mapPlayer007_4' => $MOD + 'Ana/Darchlight/MapHead',
  $VS + 'vsTrainer7_4' => $MOD + 'Ana/Darchlight/VS',
  $CHARS + 'PlayerHeadache_8_4' => $MOD + 'Ana/Darchlight/Headache',
  $CHARS + 'PlayerKnockedOut_8_4' => $MOD + 'Ana/Darchlight/KO',
  $CHARS + 'BattyFriends_Ana_4' => $MOD + 'Ana/Darchlight/BattyFriends',

  # Desolate Ana
  $CHARS + 'BGirlWalk_5' => $MOD + 'Ana/Dark/Ana',
  $CHARS + 'BGirlWalk_66' => $MOD + 'Ana/Dark/LegacyAna',


  # Darchlight Sprites
  $CHARS + 'trBack144' => $MOD + 'Darch/FlorinBack', # Only time Florin is a battle partner, so can replace the base sprite

  # Steel Diamond for better readability
  $ICONS + 'bosstypeSTEEL' => $MOD + 'SteelDiamond',

  # For pc services
  $NPCICONS + 'service_BladestarJoy' => $SERVICE + 'BladestarJoy',
  $NPCICONS + 'service_DayCare' => $SERVICE + 'DayCare',
  $NPCICONS + 'service_DayCareMan' => $SERVICE + 'DayCareMan',
  $NPCICONS + 'service_Eizen' => $SERVICE + 'Eizen',
  $NPCICONS + 'service_GDCCentral' => $SERVICE + 'GDCCentral',
  $NPCICONS + 'service_GearenLabs' => $SERVICE + 'GearenLabs',
  $NPCICONS + 'service_Matthew' => $SERVICE + 'Matthew',
  $NPCICONS + 'service_MoveRelearner' => $SERVICE + 'MoveRelearner',
  $NPCICONS + 'service_Nerta' => $SERVICE + 'Nerta',
  $NPCICONS + 'service_NurseJoy' => $SERVICE + 'NurseJoy',
  $NPCICONS + 'service_Odessa' => $SERVICE + 'Odessa',
  $NPCICONS + 'service_OdessaBlush' => $SERVICE + 'OdessaBlush',
  $NPCICONS + 'service_OdessaConfused' => $SERVICE + 'OdessaConfused',
  $NPCICONS + 'service_RelearnerSister' => $SERVICE + 'RelearnerSister',
  $NPCICONS + 'service_SEC' => $SERVICE + 'SEC',
  $NPCICONS + 'service_SECAnnoyed' => $SERVICE + 'SECAnnoyed',
  $NPCICONS + 'service_TeilaStaff' => $SERVICE + 'TeilaStaff',
  $NPCICONS + 'service_XatuFashion' => $SERVICE + 'XatuFashion'
}


# Replacing Trainer Classes to get a different sprite

$TCLASSES = {
  :CANDIDGIRLDARCH => {
    :title => "Candid Girl",
    :trainerID => 63932,
    :skill => 100,
    :moneymult => 15,
    :battleBGM => "Battle - Rival.mp3",
    :winBGM => "Gym Battle Victory.mp3",
    :replacements => {
      $CHARS + 'trBack{ID}' => $MOD + 'Darch/ErinBack'
    }
  }
}

$TCLASS_REPLACEMENTS = {
  ["Erin",:CANDIDGIRL,0] => ["Erin",:CANDIDGIRLDARCH,0]
}

# Apply trainer class changes

$highestIdTtype = 0
$cache.trainertypes.each_value { |tclass|
  id = tclass.checkFlag?(:ID,0)
  $highestIdTtype = id if id > $highestIdTtype
}
$TCLASSES.each { |classsym, data|
  replacements = data[:replacements] || {}
  data.delete(:replacements)

  id = data[:ID]

  if !id
    $highestIdTtype += 1
    data[:ID] = $highestIdTtype
    id = $highestIdTtype
  end
  $cache.trainertypes[classsym] = TrainerData.new(classsym,data)
  replacements.each { |fromPath, toPath|
    $DECLARED_OVERRIDES[fromPath.gsub('{ID}', id.to_s)] = toPath
  }
}

$TCLASS_REPLACEMENTS.each { |key, replacement| 
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


if !defined?(textureoverride_old_pbLoadTrainer)
  alias :textureoverride_old_pbLoadTrainer :pbLoadTrainer
end

def pbLoadTrainer(type,tname,id=0,noscaling=false)
  key = [tname, type, id]
  replclass = $TCLASS_REPLACEMENTS[key]
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
  replclass = $TCLASS_REPLACEMENTS[key]
  if replclass
    trainerid = replclass[1]
    trainername = replclass[0]
    partyid = replclass[2]
  end
  return textureoverride_old_pbRegisterPartner(trainerid,trainername,partyid)
end

# Replacement code

$COMPILED_TEXTURE_OVERRIDES = Hash[$DECLARED_OVERRIDES.map {|k, v| [k.downcase, v] }]

def textureoverride_mapKey(key)
  if key.kind_of?(String)
    key = key.downcase
    key = $COMPILED_TEXTURE_OVERRIDES[key] if $COMPILED_TEXTURE_OVERRIDES[key]
  elsif key.kind_of?(Array)
    downcased = key[0].downcase
    key[0] = $COMPILED_TEXTURE_OVERRIDES[downcased] if $COMPILED_TEXTURE_OVERRIDES[downcased]
  end

  return key
end

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
      return self.textureoverride_old_setKey(textureoverride_mapKey(key), obj)
    end

    def self.load_bitmap(filename, hue = 0)
      return self.textureoverride_old_load_bitmap(textureoverride_mapKey(filename), hue)
    end

    def self.tileEx(filename, tile_id, hue, width = 1, height = 1)
      return self.textureoverride_old_tileEx(textureoverride_mapKey(filename), tile_id, hue, width, height) { |it| yield it }
    end
    
    def self.fromCache(i)
      return self.textureoverride_old_fromCache(textureoverride_mapKey(i))
    end
  end
end

if !defined?(textureoverride_old_pbResolveBitmap)
  alias :textureoverride_old_pbResolveBitmap :pbResolveBitmap
end

def pbResolveBitmap(x)
  return textureoverride_old_pbResolveBitmap(textureoverride_mapKey(x))
end
