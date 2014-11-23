{--
    Contains all functions to render information
--}
module View where 

import Dict as D
import Gates (..)
import StateInfo (..)

display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
    let
        circuitElement = drawThis gameState
        circuitStateBool = getStatusBool (D.toList gameState.circuitState)
        everything = 
            flow down [
              asText gameState.mousePos
            , [markdown|## Simulated CircuitState|]
            , asText circuitStateBool
            , plainText " "
            , circuitElement
            ]
    in
        container w h middle everything

drawGate : Gate -> Element
drawGate gate = 
    flow down [
      plainText gate.name
    , asText gate.status
    ]

drawThis : GameState -> Element
drawThis gs = 
  let 
    inputsElement = 
      flow right [
        drawGate (D.getOrFail "input1" gs.circuitState)
      , plainText "    "
      , drawGate (D.getOrFail "input2" gs.circuitState)
      , plainText "    "
      , drawGate (D.getOrFail "input3" gs.circuitState)
      ]
    andElement = 
      flow right [
        drawGate (D.getOrFail "andGate" gs.circuitState)
      ]
    and2Element = 
      flow right [
        plainText "              "
      , drawGate (D.getOrFail "andGate2" gs.circuitState)
      ]
    orElement = flow right [drawGate (D.getOrFail "orGate" gs.circuitState)]
    outputElement = flow right [drawGate (D.getOrFail "output" gs.circuitState)]
  in
    flow down [
      inputsElement
    , andElement
    , and2Element
    , orElement
    , outputElement
    ]