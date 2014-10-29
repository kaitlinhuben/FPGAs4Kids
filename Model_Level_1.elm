module Model_Level_1 where
import Model_Types (..)

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}
imgPath : String
imgPath = "resources/img/"


defaultUserInput : Signal UserInput
defaultUserInput = constant { mousePos=(0,0), gameMode=Game }

defaultInput : Input 
defaultInput = InputOff

defaultOutput : Output
defaultOutput = OutputOn 

defaultMode : Mode 
defaultMode = Game

xorGate : Gate 
xorGate = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = None
  , img = imgPath ++ "XOR.png"
  , imgSize = (100,100)
  , timeDelta = 0
  }

defaultGame : GameState
defaultGame = { 
    inputs = [defaultInput]
  , outputs = [defaultOutput]
  , gates = [xorGate]
  , paths = []
  , displayMode = Game
  , runMode = Designing
  }