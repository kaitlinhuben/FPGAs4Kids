module Model_Level_1 where
import Model_Types (..)

{----------------------------------------------------------
  Set up default values
----------------------------------------------------------}
defaultInput : GameInput 
defaultInput = InputOff

defaultOutput : GameOutput
defaultOutput = OutputOn 

xorGate : Gate 
xorGate = { 
    location = (0,0)
  , inputs = [False, False]
  , outputs = [False]
  , spinning = None 
  , img = "/XOR.png"
  , imgSize = (100,100)
  , timeDelta = 0
  }

defaultGame : GameState
defaultGame = { 
    inputs = [defaultInput]
  , outputs = [defaultOutput]
  , gates = [xorGate]
  , paths = []
  , mode = Game
  , running = Designing 
  , mousePos = (0,0)
  }