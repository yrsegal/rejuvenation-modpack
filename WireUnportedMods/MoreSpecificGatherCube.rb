Variables[:Z_Cells_Floria] = 364
Variables[:Z_Cells_Terajuma] = 365
Variables[:Z_Cells_Terrial] = 366

def pbInfoBox(number)
  unrealbackup = $unrealClock.visible
  $unrealClock.visible = false
  clues = [
    # 0
    [
      "1. Underneath Chrisola Hotel.",
      "2. Underneath Dr. Jenkel's Laboratory.",
      "3. Underneath the largest fountain."
    ],
    # 1
    [
      "Rules of the Land:",
      "8. Thou shalt not have better Ice-type Pokemon than me.",
      "Me as in Angie.",
      "10. People shall remain a 6 foot distance from each",
      "other at all times.",
      "12. Thou shalt not pour the milk before the cereal.",
      "16. Thou shalt not wake up at 7:01 on the dot.",
      "23. Thou shalt not fish for compliments.",
      "34. Thou shalt not be mean to Lady Angie.",
      "40. Thou shalt not look at the moon with a grimace.",
      "43. Thou shalt not boogie like a maniac a quarter past midnight.",
      "49. Thou shalt not be hungry after a workout.",
      "55. Thou shalt not use emojis in text messages.",

    ],
    # 2
    [
      "Zygarde Cells found: #{$game_variables[:Z_Cells]}",
      "Zygarde Cores found: #{$game_variables[:Z_Cores]}",
      "Red Essence collected: #{$game_variables[:RedEssence]}",
      "Spiritomb Wisps collected: #{$game_variables[:SpiritombWisps]}",
    ],
  ]

  ### MODDED/
  if number == 2
    pushedAny = false
    if $game_variables[:Z_Cells_Floria] > 0
      if !pushedAny
        pushedAny = true
        clues[number].push("")
      end
      clues[number].push("Zygarde Cells found in the Floria Region: #{$game_variables[:Z_Cells_Floria]}")
    end

    if $game_variables[:Z_Cells_Terajuma] > 0
      if !pushedAny
        pushedAny = true
        clues[number].push("")
      end
      clues[number].push("Zygarde Cells found in the Terajuma Region: #{$game_variables[:Z_Cells_Terajuma]}")
    end

    if $game_variables[:Z_Cells_Terrial] > 0
      if !pushedAny
        pushedAny = true
        clues[number].push("")
      end
      clues[number].push("Zygarde Cells found in the Terrial Region: #{$game_variables[:Z_Cells_Terrial]}")
    end
  end
  ### /MODDED

  cmdwin=pbListWindow(clues[number],Graphics.width)
  cmdwin.rowHeight = 20
  cmdwin.refresh
  Graphics.update
  loop do
    Graphics.update
    Input.update
    cmdwin.update
    break if Input.trigger?(Input::C) || Input.trigger?(Input::B)
  end
  cmdwin.dispose
  $unrealClock.visible = unrealbackup
end
