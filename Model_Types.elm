{--
    Model_Types.elm
    Sets up all data types for game
--}
module Model_Types where

import Graphics.Input as GInput

type GameInput = { timeDelta:Float, userInput:UserInput }

type UserInput = { mousePos:(Int,Int), display:Mode, topInput:Bool }

type GameState = { 
      inputs : [Gate]
    , outputs : [Gate] 
    , gates : [Gate]
    , displayMode : Mode
    , displayInput : GInput.Input Mode
    , runMode : RunState
    , mousePos : (Int,Int)
}

type Gate = {
      location : (Float, Float)
    , inputs : [Net]
    , outputs : [Net]
    , spinning : SpinDirection
    , gameImg : String
    , schematicImg : String
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

data Net = Net {
      status : Bool
    , location : (Float, Float)
    , gates : [Gate]
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

data SpinDirection = None | CW | CCW

{----------------------------------------------------------
  Set up actual gates
----------------------------------------------------------}
imgPath : String
imgPath = "resources/img/"

inputGate : Gate
inputGate = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = None
  , gameImg = imgPath ++ "input.png"
  , schematicImg = imgPath ++ "input.png"
  , img = imgPath ++ "input.png"
  , imgSize = (0,0)
  , timeDelta = 0
  }

outputGate : Gate
outputGate = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = None
  , gameImg = imgPath ++ "output.png"
  , schematicImg = imgPath ++ "output.png"
  , img = imgPath ++ "output.png"
  , imgSize = (0,0)
  , timeDelta = 0
  }

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