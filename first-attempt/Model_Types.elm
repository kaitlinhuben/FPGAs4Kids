{--
    Model_Types.elm
    Sets up all data types for game
--}
module Model_Types where

import Graphics.Input as GInput
import Either (..)

type GameInput = { timeDelta:Float, userInput:UserInput }

type UserInput = { 
      mousePos:(Int,Int)
    , display:Mode
  }

type GameState = { 
      inputGates : [InputGate]
    , outputGates : [OutputGate] 
    , gates : [Gate]
    , nets : [Net]
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

type InputGate = {
      location : (Float, Float)
    , status : Bool
    , outputTo : Maybe Net
    , gameImgOn : String
    , gameImgOff : String
    , schematicImgOn : String
    , schematicImgOff : String
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

type OutputGate = {
      location : (Float, Float)
    , status : Bool
    , inputFrom : Maybe Net
    , gameImgOn : String
    , gameImgOff : String
    , schematicImgOn : String
    , schematicImgOff : String
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

data Net = Net {
      status : Bool
    , location : (Float, Float)
    , inputGate : Either InputGate Gate
    , outputGate : Either OutputGate Gate
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

data SpinDirection = None | CW | CCW

{----------------------------------------------------------
  Set up actual gates
----------------------------------------------------------}
imgPath : String
imgPath = "resources/img/"

inputGate : InputGate
inputGate = {
      location = (0, 0)
    , status = False
    , outputTo = Nothing
    , gameImgOn = imgPath ++ "input-on.png"
    , gameImgOff = imgPath ++ "input-off.png"
    , schematicImgOn = imgPath ++ "input-on.png"
    , schematicImgOff = imgPath ++ "input-off.png"
    , img = imgPath ++ "input-off.png"
    , imgSize = (0, 0)
    , timeDelta = 0
  }

outputGate : OutputGate
outputGate = {
      location = (0,0)
    , status = False
    , inputFrom = Nothing
    , gameImgOn = imgPath ++ "output-on.png"
    , gameImgOff = imgPath ++ "output-off.png"
    , schematicImgOn = imgPath ++ "output-on.png"
    , schematicImgOff = imgPath ++ "output-off.png"
    , img = imgPath ++ "output-off.png"
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