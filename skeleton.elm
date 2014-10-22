import Window
import Mouse
import Graphics.Element as Element
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
  , changing = False 
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
    otherElements = 
      flow down [
        asText gameState.mousePos
      , asText (w,h)
      ]
    element = layers [otherElements , gatesElement]
  in
    color lightBrown <| container w h middle element

{---------------------------------------------------------- 
    Game processing 
----------------------------------------------------------}
updateGateTime gate = { gate | timeDelta <- gate.timeDelta + 1/25 }

stepGame : (Float, (Int, Int)) -> GameState -> GameState
stepGame (time, pos) gameState = 
  let
    updatedGates = map updateGateTime gameState.gates
  in 
    { gameState | mousePos <- pos
                , gates <- updatedGates }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- For grabbing inputs
gameInput : Signal (Float, (Int, Int))
gameInput = sampleOn delta (lift2 (,) delta Mouse.position)

-- Driver
main : Signal Element
main  = lift2 display Window.dimensions (foldp stepGame defaultGame gameInput)