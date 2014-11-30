{--
    Contains all functions to render information
--}
module View where 

import Array as A
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
    
-- Draw the circuit and put it in an element
drawCircuit : GameState -> Element
drawCircuit gs = 
  let 
    -- get the input gates
    input1 = D.getOrFail "input1" gs.circuitState
    input2 = D.getOrFail "input2" gs.circuitState
    input3 = D.getOrFail "input3" gs.circuitState

    -- get the checkbox Inputs for input gates
    {--check1 = D.getOrFail "input1" gs.gateInputs
    check2 = D.getOrFail "input1" gs.gateInputs
    check3 = D.getOrFail "input1" gs.gateInputs

    -- set up the checkboxes
    checkbox1 = I.checkbox check1.handle identity input1.status
    checkbox2 = I.checkbox check2.handle identity input2.status
    checkbox3 = I.checkbox check3.handle identity input3.status--}

    -- put everything together
    inputsElement = 
      flow right [
        drawGate input1, plainText "    "
      , drawGate input2, plainText "    "
      , drawGate input3
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