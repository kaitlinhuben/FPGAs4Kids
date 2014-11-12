module Level_1 where

import Mouse
import Graphics.Input as GInput
import Model_Types (..)
import Controller (..)
import Either (..)

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}

userInput : Signal UserInput
userInput = 
  UserInput <~ Mouse.position ~ modeInput.signal ~ topInput.signal

modeInput : GInput.Input Mode
modeInput = GInput.input Game 

topInput : GInput.Input Bool
topInput = GInput.input False

defaultMode : Mode 
defaultMode = Game

net_input1_xor : Net
net_input1_xor = Net {
    status = False
  , location = (0,0)
  , inputGate = Left gameInput1
  , outputGate = Right gameXOR
  }
net_input2_xor : Net
net_input2_xor = Net {
    status = False
  , location = (0,0)
  , inputGate = Left gameInput2
  , outputGate = Right gameXOR
  }
net_xor_output1 : Net
net_xor_output1 = Net {
    status = False
  , location = (0,0)
  , inputGate = Right gameXOR
  , outputGate = Left gameOutput1 
  }

gameInput1 : InputGate
gameInput1 = {
      location = (-100,50)
    , status = False
    , outputTo = Just net_input1_xor
    , gameImgOn = inputGate.gameImgOn
    , gameImgOff = inputGate.gameImgOff
    , schematicImgOn = inputGate.schematicImgOn
    , schematicImgOff = inputGate.schematicImgOff
    , img = inputGate.img
    , imgSize = (100,100)
    , timeDelta = 0
  }
gameInput2 : InputGate
gameInput2 = {
      location = (-100,-50)
    , status = False
    , outputTo = Just net_input2_xor
    , gameImgOn = inputGate.gameImgOn
    , gameImgOff = inputGate.gameImgOff
    , schematicImgOn = inputGate.schematicImgOn
    , schematicImgOff = inputGate.schematicImgOff
    , img = inputGate.img
    , imgSize = (100,100)
    , timeDelta = 0
  }

gameOutput1 : OutputGate
gameOutput1 = {
      location = (100,0)
    , status = False
    , inputFrom = Just net_xor_output1
    , gameImgOn = outputGate.gameImgOn
    , gameImgOff = outputGate.gameImgOff
    , schematicImgOn = outputGate.schematicImgOn
    , schematicImgOff = outputGate.schematicImgOff
    , img = outputGate.img
    , imgSize = (100,100)
    , timeDelta = 0
  }

gameXOR : Gate 
gameXOR = { 
    location = (0,0)
  , inputs = [net_input1_xor, net_input2_xor]
  , outputs = [net_xor_output1]
  , spinning = None
  , gameImg = xorGate.gameImg
  , schematicImg = xorGate.schematicImg
  , img = xorGate.gameImg
  , imgSize = (100,100)
  , timeDelta = 0
  }

thisGame : GameState
thisGame = { 
    inputs = [gameInput1, gameInput2]
  , outputs = [gameOutput1]
  , gates = [gameXOR]
  , displayMode = Game
  , displayInput = modeInput
  , runMode = Designing
  , mousePos = (0,0)
  }

{----------------------------------------------------------
  Run level
----------------------------------------------------------}
main : Signal Element
main = mainDriver thisGame userInput