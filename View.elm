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
    modeInput = gameState.displayInput
    gatesElement = collage w h (map drawGate gameState.gates)
    inputsElement = collage w h (map drawGate gameState.inputs)
    outputsElement = collage w h (map drawGate gameState.outputs)
    allGatesElement = collage w h [
          toForm gatesElement 
        , toForm inputsElement
        , toForm outputsElement
      ]
    buttonsElement =
      flow right [
        button modeInput.handle Game "Game Mode"
      , button modeInput.handle Schematic "Schematic Mode"
      ]
    otherElements = 
      flow down [
        asText gameState.mousePos
      , buttonsElement
      , flow right [plainText "Mode: ", asText gameState.displayMode]
      ]
    element = layers [otherElements , allGatesElement]
  in
    color lightBrown <| container w h middle element