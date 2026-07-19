def pbFishing(hasencounter,rodtype=1)
  bitechance=50+(15*rodtype)   # 65, 80, 95
  if $Trainer.party.length>0 && !$Trainer.party[0].isEgg?
    bitechance*=2 if ($Trainer.party[0].ability == :STICKYHOLD)
    bitechance*=2 if ($Trainer.party[0].ability == :SUCTIONCUPS)
  end
  hookchance=100
  oldpattern=$game_player.fullPattern
  pbFishingBegin
  msgwindow=Kernel.pbCreateMessageWindow
  loop do
    time=2+rand(10)
    message=""
    time.times do
      message+=".  "
    end
    ### MODDED/
    if pbWaitMessage(msgwindow,time) && Input.trigger?(Input::B)
    ### /MODDED
      pbFishingEnd
      $game_player.setDefaultCharName(nil,oldpattern)
      Kernel.pbMessageDisplay(msgwindow,_INTL("Not even a nibble..."))
      Kernel.pbDisposeMessageWindow(msgwindow)
      return false
    end
    ### MODDED/
    if hasencounter
      frames=rand(21)+25
      Kernel.pbMessageDisplay(msgwindow,message+_INTL("\r\nOh!  A bite!"))
      Kernel.pbMessageDisplay(msgwindow,_INTL("Landed a Pokémon!"))
      Kernel.pbDisposeMessageWindow(msgwindow)
      pbFishingEnd
      $game_player.setDefaultCharName(nil,oldpattern)
      return true
    ### /MODDED
    else
      pbFishingEnd
      $game_player.setDefaultCharName(nil,oldpattern)
      Kernel.pbMessageDisplay(msgwindow,_INTL("Not even a nibble..."))
      Kernel.pbDisposeMessageWindow(msgwindow)
      return false
    end
  end
  Kernel.pbDisposeMessageWindow(msgwindow)
  return false
end
