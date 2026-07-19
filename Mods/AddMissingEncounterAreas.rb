
InjectionHelper.defineMapPatch(257) { # GDC Scholar's District
  fillArea(33, 19, 
    ["   ",
     "___",
     "YGY",
     "RGY",
     "RRG"], 
    {
      ' ' => [nil,  0,    0], # Remove anything above the ground
      '_' => [nil,  3588, 0], # Remove anything above the ground, add a down-facing border
      'R' => [4870, 0,    0], # Remove anything above the ground, replace ground with red flower encounterable grass
      'Y' => [4877, 0,    0], # Remove anything above the ground, replace ground with yellow flower encounterable grass
      'G' => [704,  0,    0], # Remove anything above the ground, replace ground with red flower encounterable grass
    })
}
