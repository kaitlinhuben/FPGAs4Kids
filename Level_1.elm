module Model_Level_1 where
import Model_Types (..)
import Controller (..)
import Mouse

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}
imgPath : String
imgPath = "resources/img/"

defaultUserInput : Signal UserInput
defaultUserInput = lift UserInput Mouse.position

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

{----------------------------------------------------------
  Run level
----------------------------------------------------------}
main : Signal Element
main = mainDriver defaultGame defaultUserInput