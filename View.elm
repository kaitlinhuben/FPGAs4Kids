{--
    View.elm
    Functions for displaying everything
--}
module View where

import Graphics.Input (Input, input, button)
import Model_Types (..)

{---------------------------------------------------------- 
  Display functions 
----------------------------------------------------------}
-- Draw an individual gate
--drawGate : Gate -> Form
drawGate gate = 
  let
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.img)
  in
    rotate gate.timeDelta <| move gate.location imgForm

-- Display everything
--display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
  let
    gatesElement = collage w h (map drawGate gameState.gates)
    otherElements = 
      flow down [
        asText (w,h)
      , asText gameState.gates
      ]
    element = layers [otherElements , gatesElement]
  in
    color lightBrown <| container w h middle element