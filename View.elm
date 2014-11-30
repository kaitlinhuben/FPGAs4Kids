{--
    Contains all functions to render information
--}
module View where 

import Dict as D
import Graphics.Input as I
import Model (..)

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
    inputGate1 = D.getOrFail "input1" gs.circuitState
    inputGate2 = D.getOrFail "input2" gs.circuitState
    inputGate3 = D.getOrFail "input3" gs.circuitState

    -- get the checkbox Inputs for input gates
    input1 = gs.inputSignals
    {--check2 = D.getOrFail "input1" gs.gateInputs
    check3 = D.getOrFail "input1" gs.gateInputs --}

    -- set up the checkboxes
    checkbox1 = I.checkbox input1.handle identity (D.getOrFail "input1" gs.userInputBools)
    {--checkbox2 = I.checkbox check2.handle identity input2.status
    checkbox3 = I.checkbox check3.handle identity input3.status--}

    -- put everything together
    inputsElement = 
      flow right [
        checkbox1, drawGate inputGate1, plainText "    "
      , drawGate inputGate2, plainText "    "
      , drawGate inputGate3
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