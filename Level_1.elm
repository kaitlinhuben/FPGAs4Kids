module Level_1 where

import Mouse
import Graphics.Input as GInput
import Model_Types (..)
import Model_Gates (..)
import Controller (..)

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}

userInput : Signal UserInput
userInput = 
  UserInput <~ Mouse.position ~ modeInput.signal

modeInput : GInput.Input Mode
modeInput = GInput.input Game 

levelInput : Input 
levelInput = InputOff

levelOutput : Output
levelOutput = OutputOn 

defaultMode : Mode 
defaultMode = Game

gameXOR : Gate 
gameXOR = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = None
  , gameImg = xorGate.gameImg
  , schematicImg = xorGate.schematicImg
  , img = xorGate.gameImg
  , imgSize = (100,100)
  , timeDelta = 0
  }

gameXOR2 : Gate
gameXOR2 = { 
    location = (75,75)
  , inputs = []
  , outputs = []
  , spinning = None
  , gameImg = xorGate.gameImg
  , schematicImg = xorGate.schematicImg
  , img = xorGate.gameImg
  , imgSize = (100,100)
  , timeDelta = 0
  }

thisGame : GameState
thisGame = { 
    inputs = [levelInput]
  , outputs = [levelOutput]
  , gates = [gameXOR, gameXOR2]
  , paths = []
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