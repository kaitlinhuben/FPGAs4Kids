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
        circuitElement = drawCircuit (w,h) gameState
        everything = 
            flow down [
              asText gameState.mousePos
            , plainText " "
            , circuitElement
            ]
    in
        container w h middle everything
    
-- Draw the circuit and put it in an element
drawCircuit : (Int,Int) -> GameState -> Element
drawCircuit (w,h) gs = 
  let 
    -- get gate view info
    gv = gs.viewInfo

    -- get the input gates
    inputGate1 = D.getOrFail "input1" gs.circuitState
    inputGate2 = D.getOrFail "input2" gs.circuitState
    inputGate3 = D.getOrFail "input3" gs.circuitState

    -- get the checkbox Inputs for input gates
    input1 = D.getOrFail "input1" gs.inputSignals
    input2 = D.getOrFail "input2" gs.inputSignals
    input3 = D.getOrFail "input3" gs.inputSignals

    -- set up the checkboxes
    checkbox1 = I.checkbox input1.handle identity (D.getOrFail "input1" gs.userInputBools)
    checkbox2 = I.checkbox input2.handle identity (D.getOrFail "input2" gs.userInputBools)
    checkbox3 = I.checkbox input3.handle identity (D.getOrFail "input3" gs.userInputBools)
   
    -- put everything together
    inputsElement = 
      collage w h [
        drawInputGate inputGate1 gv checkbox1
      , drawInputGate inputGate2 gv checkbox2
      , drawInputGate inputGate3 gv checkbox3
      ]
    andElement = drawGate (D.getOrFail "andGate" gs.circuitState) gv
    and2Element =  drawGate (D.getOrFail "andGate2" gs.circuitState) gv
    orElement = drawGate (D.getOrFail "orGate" gs.circuitState) gv
    outputElement = drawGate (D.getOrFail "output" gs.circuitState) gv
  in
    collage w h [
      toForm inputsElement
    , andElement
    , and2Element
    , orElement
    , outputElement
    ]

-- Draw a single gate
drawGate : Gate -> D.Dict String GateView -> Form
drawGate gate viewInfo = 
  let
    element = flow down 
              [ plainText gate.name
              , asText gate.status
              ]
    theForm = toForm element

    gateInfo = D.getOrFail gate.name viewInfo
    location = gateInfo.location
  in 
    move location theForm

drawInputGate : Gate -> D.Dict String GateView -> Element -> Form
drawInputGate gate viewInfo ckbox = 
  let
    element = flow down 
              [ plainText gate.name
              , ckbox
              , asText gate.status
              ]
    theForm = toForm element

    gateInfo = D.getOrFail gate.name viewInfo
    location = gateInfo.location
  in 
    move location theForm