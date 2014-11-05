module Level_1 where

import Mouse
import Graphics.Input as GInput
import Model_Types (..)
import Controller (..)

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
  , gates = [gameInput1, gameXOR]
  }
net_input2_xor : Net
net_input2_xor = Net {
    status = False
  , location = (0,0)
  , gates = [gameInput2, gameXOR]
  }
net_xor_output1 : Net
net_xor_output1 = Net {
    status = False
  , location = (0,0)
  , gates = [gameXOR, gameOutput1]
  }

gameInput1 : Gate
gameInput1 = { 
    location = (-100,50)
  , inputs = []
  , outputs = [net_input1_xor]
  , spinning = None
  , gameImg = inputGate.gameImg
  , schematicImg = inputGate.schematicImg
  , img = inputGate.gameImg
  , imgSize = (100,100)
  , timeDelta = 0
  }
gameInput2 : Gate
gameInput2 = { 
    location = (-100,-50)
  , inputs = []
  , outputs = [net_input2_xor]
  , spinning = None
  , gameImg = inputGate.gameImg
  , schematicImg = inputGate.schematicImg
  , img = inputGate.gameImg
  , imgSize = (100,100)
  , timeDelta = 0
  }

gameOutput1 : Gate
gameOutput1 = { 
    location = (100,0)
  , inputs = [net_xor_output1]
  , outputs = []
  , spinning = None
  , gameImg = outputGate.gameImg
  , schematicImg = outputGate.schematicImg
  , img = outputGate.gameImg
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