{--
    View.elm
    Functions for displaying everything
--}
module View where

import Graphics.Input (Input, input, button)
import Model_Types (..)
import Either(..)

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

drawInputGate : InputGate -> Form
drawInputGate gate = 
  let
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.img)
  in
    rotate gate.timeDelta <| move gate.location imgForm

drawOutputGate : OutputGate -> Form
drawOutputGate gate = 
  let
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.img)
  in
    rotate gate.timeDelta <| move gate.location imgForm

drawNet : Net -> Form
drawNet net = 
  let
    inGate = net
    --inGate = net.inputGate 
    {--outGate = net.outputGate
    (w,h) = inGate.location
    (w',h') = outGate.location--}
    netLine = segment (-150,50) (0,0)
  in
    traced (solid black) netLine

-- Display everything
display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
  let
    netsElement = collage w h (map drawNet gameState.nets)
    gatesElement = collage w h (map drawGate gameState.gates)
    inputsElement = collage w h (map drawInputGate gameState.inputGates)
    outputsElement = collage w h (map drawOutputGate gameState.outputGates)
    allGatesElement = collage w h [
          toForm gatesElement 
        , toForm inputsElement
        , toForm outputsElement
      ]
    modeInput = gameState.displayInput
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
    element = layers [otherElements, netsElement, allGatesElement]
  in
    color lightBrown <| container w h middle element