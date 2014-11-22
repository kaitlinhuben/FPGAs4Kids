module View where 

import Dict as D
import Gates (..)
import State (..)

drawGate : Gate -> Element
drawGate gate = 
    flow down [
      plainText gate.name
    , asText gate.status
    ]

drawThis : State -> Element
drawThis state = 
  let 
    inputsElement = 
      flow right [
        drawGate (D.getOrFail "input1" state)
      , plainText "    "
      , drawGate (D.getOrFail "input2" state)
      , plainText "    "
      , drawGate (D.getOrFail "input3" state)
      ]
    andElement = 
      flow right [
        drawGate (D.getOrFail "andGate" state)
      ]
    and2Element = 
      flow right [
        plainText "              "
      , drawGate (D.getOrFail "andGate2" state)
      ]
    orElement = flow right [drawGate (D.getOrFail "orGate" state)]
    outputElement = flow right [drawGate (D.getOrFail "output" state)]
  in
    flow down [
      inputsElement
    , andElement
    , and2Element
    , orElement
    , outputElement
    ]