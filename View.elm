{--
    Contains all functions to render information
--}
module View where 

import Dict as D
import Graphics.Input as I
import Gates (..)
import StateInfo (..)

-- Display the entire page
display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
    let
        circuitElement = drawCircuit gameState
        everything = 
            flow down [
              asText gameState.mousePos
            , plainText " "
            , circuitElement
            ]
    in
        container w h middle everything

check1 : I.Input Bool 
check1 = I.input True

check2 : I.Input Bool 
check2 = I.input True

check3 : I.Input Bool 
check3 = I.input True
-- Draw the circuit and put it in an element
drawCircuit : GameState -> Element
drawCircuit gs = 
  let 
    input1 = D.getOrFail "input1" gs.circuitState
    input2 = D.getOrFail "input2" gs.circuitState
    input3 = D.getOrFail "input3" gs.circuitState
    checkbox1 = I.checkbox check1.handle identity input1.status
    checkbox2 = I.checkbox check2.handle identity input2.status
    checkbox3 = I.checkbox check3.handle identity input3.status
    inputsElement = 
      flow right [
        checkbox1, drawGate input1, plainText "    "
      , checkbox2, drawGate input2, plainText "    "
      , checkbox3, drawGate input3
      ]
    andElement = drawGate (D.getOrFail "andGate" gs.circuitState)
    and2Element = 
      flow right [
        plainText "              "
      , drawGate (D.getOrFail "andGate2" gs.circuitState)
      ]
    orElement = drawGate (D.getOrFail "orGate" gs.circuitState)
    outputElement = drawGate (D.getOrFail "output" gs.circuitState)
  in
    flow down [
      inputsElement
    , andElement
    , and2Element
    , orElement
    , outputElement
    ]

-- Draw a single gate
drawGate : Gate -> Element
drawGate gate = 
    flow down [
      plainText gate.name
    , asText gate.status
    ]
