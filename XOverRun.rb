class PokeBattle_Scene
  def pbCommandMenuEx(index,texts,mode=0)      # Mode: 0 - regular battle
    pbShowWindow(COMMANDBOX)                   #       1 - Shadow Pokémon battle
    cw=@sprites["commandwindow"]               #       2 - Safari Zone
    cw.setTexts(texts)                         #       3 - Bug Catching Contest
    cw.index=0 if @lastcmd[index]==2
    cw.mode=mode
    pbSelectBattler(index)
    pbRefresh
    update_menu=true
    loop do
      pbGraphicsUpdate
      Input.update
      pbFrameUpdate(cw,update_menu)
      update_menu=false
      # Update selected command
      if Input.trigger?(Input::CTRL)
        pbToggleStatsBoostsVisibility
        pbPlayCursorSE()
        update_menu=true
      elsif Input.trigger?(Input::LEFT) && (cw.index&1)==1
        pbPlayCursorSE()
        cw.index-=1
        update_menu=true
      elsif Input.trigger?(Input::RIGHT) &&  (cw.index&1)==0
        pbPlayCursorSE()
        cw.index+=1
        update_menu=true
      elsif Input.trigger?(Input::UP) &&  (cw.index&2)==2
        pbPlayCursorSE()
        cw.index-=2
        update_menu=true
      elsif Input.trigger?(Input::DOWN) &&  (cw.index&2)==0
        pbPlayCursorSE()
        cw.index+=2
        update_menu=true
      ### MODDED/
      elsif Input.trigger?(Input::B) && index==0 && cw.index != 3
        pbPlayDecisionSE()
        cw.index=3
        update_menu=true
      ### /MODDED
      elsif Input.trigger?(Input::Y)  #Show Battle Stats feature made by DemICE
        statstarget=pbStatInfo(index)
        return -1 if statstarget==-1      
        if !pbInSafari?
          pbShowBattleStats(statstarget)
        end
      end
      if Input.trigger?(Input::C)   # Confirm choice
        pbPlayDecisionSE()
        ret=cw.index
        @lastcmd[index]=ret
        cw.index=0 if $Settings.remember_commands==0
        return ret
      elsif Input.trigger?(Input::B) && index==2 #&& @lastcmd[0]!=2 # Cancel #Commented out for cancelling switches in doubles
        pbPlayDecisionSE()
        return -1
      end
    end
  end
end