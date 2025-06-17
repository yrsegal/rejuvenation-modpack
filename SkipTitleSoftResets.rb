# Title Skip after first appearance
if !defined?($skiptitle_skippedfirst)
  $skiptitle_skippedfirst = false
end

alias :skiptitle_old_pbCallTitle :pbCallTitle
def pbCallTitle(*args, **kwargs)
  if !$skiptitle_skippedfirst
    $skiptitle_skippedfirst = true
    return skiptitle_old_pbCallTitle(*args, **kwargs)
  end
  return Scene_DebugIntro.new
end
