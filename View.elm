module View where

import Graphics.Input (Input, input, button)
import Model_Types (..)

xorSpinning : Input SpinDirection
xorSpinning = input None

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