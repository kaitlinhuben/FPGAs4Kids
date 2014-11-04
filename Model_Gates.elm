module Model_Gates where

import Model_Types (..)

imgPath : String
imgPath = "resources/img/"

xorGate : Gate 
xorGate = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = None
  , gameImg = imgPath ++ "XOR.png"
  , schematicImg = imgPath ++ "xor-schematic.png"
  , img = imgPath ++ "XOR.png"
  , imgSize = (0,0)
  , timeDelta = 0
  }