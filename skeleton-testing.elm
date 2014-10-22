import Window
import Mouse
import Graphics.Element as Element
import Graphics.Input (Input, input, button)
import Debug (log)
import Types (..)

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
xorSpinning : Input SpinDirection
xorSpinning = input None

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

{---------------------------------------------------------- 
  Display functions 
----------------------------------------------------------}
-- Draw an individual gate
drawGate : Gate -> Form
drawGate gate = 
  let
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.img)
  in
    rotate gate.timeDelta <| move gate.location imgForm

-- Display everything
display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
  let
    gatesElement = collage w h (map drawGate gameState.gates)
    buttons = flow right 
      [ button xorSpinning.handle (None) "None"
      , button xorSpinning.handle (CW) "Clockwise"
      , button xorSpinning.handle (CCW) "Counterclockwise"
      ]
    otherElements = 
      flow down [
        asText gameState.mousePos
      , asText (w,h)
      , buttons
      , asText gameState.gates
      ]
    element = layers [otherElements , gatesElement]
  in
    color lightBrown <| container w h middle element

{---------------------------------------------------------- 
    Game processing 
----------------------------------------------------------}
updateGates : [Gate] -> SpinDirection -> [Gate]
updateGates gates spinDir = 
  case gates of 
    [] -> []
    only :: [] -> 
      let td = if | spinDir == CW -> -1/25
                         | spinDir == CCW -> 1/25
                         | otherwise -> 0
      in
        [{ only | spinning <- spinDir 
                , timeDelta <- only.timeDelta + td}]
    first :: rest -> 
      let
        newFirst = { first | spinning <- spinDir }
        newRest = updateGates rest spinDir
      in 
        newFirst :: newRest

stepGame : (Float, (Int, Int), SpinDirection) -> GameState -> GameState
stepGame (time, pos, spinDir) gameState =  
  let
    oldGates = gameState.gates
    newGates = updateGates oldGates spinDir
  in
    { gameState | mousePos <- pos 
                , gates <- newGates }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- For grabbing inputs
--gameInput : Signal (Float, (Int, Int))
gameInput = sampleOn delta (lift3 (,,) delta Mouse.position xorSpinning.signal)

-- Driver
main : Signal Element
main  = lift2 display Window.dimensions (foldp stepGame defaultGame gameInput)