module Model_Level_1 where
import Model_Types (..)

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}
imgPath : String
imgPath = "resources/img/"

defaultInput : GameInput 
defaultInput = InputOff

defaultOutput : GameOutput
defaultOutput = OutputOn 

xorGate : Gate 
xorGate = { 
    location = (0,0)
  , inputs = []
  , outputs = []
  , spinning = CW 
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