import Window
import Mouse
import Types (..)

{-- Set up default values --}
defaultInput : GameInput 
defaultInput = InputOff

defaultOutput : GameOutput
defaultOutput = OutputOn 

defaultGame : GameState
defaultGame = { 
    inputs = [defaultInput]
  , outputs = [defaultOutput]
  , gates = []
  , paths = []
  , mode = Game
  , running = Designing 
  , mousePos = (0,0)
  }

{-- Display --}
display (w,h) gameState = 
  let 
    element = 
      flow down [
        asText gameState.mousePos
      , asText (w,h)
      ]
  in
    color lightBrown <| container w h middle element

{-- 
    Game processing 
--}
stepGame (time, pos) gameState = 
  { gameState | mousePos <- pos }

-- For physics
delta = lift (\t -> t / 20) (fps 25)
-- For grabbing inputs
gameInput = sampleOn delta (lift2 (,) delta Mouse.position)
-- Driver
main  = lift2 display Window.dimensions (foldp stepGame defaultGame gameInput)