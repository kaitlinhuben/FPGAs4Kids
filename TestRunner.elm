module TestRunner where

import Debug (..)
import Dict as D
import Array as A
import Gates (..)
import State (..)
import View (..)

-- Set up gates for level
andGate : Gate
andGate = {
      name = "Gate 4: andGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["Gate 1: input1", "Gate 2: input2"]
    , logic = andLogic
  }

andGate2 : Gate
andGate2 = {
      name = "Gate 5: andGate2"
    , gateType = NormalGate
    , status = True
    , inputs = A.fromList ["Gate 3: input3", "Gate 4: andGate"]
    , logic = andLogic
  }

orGate : Gate
orGate = {
      name = "Gate 6: orGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["Gate 4: andGate", "Gate 5: andGate2"]
    , logic = orLogic
  }

input1 : Gate
input1 = {
      name = "Gate 1: input1"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
  }

input2 : Gate
input2 = {
      name = "Gate 2: input2"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
  }

input3 : Gate
input3 = {
      name = "Gate 3: input3"
    , gateType = InputGate
    , status = False
    , inputs = A.empty
    , logic = inputLogic
  }

output : Gate
output = {
      name = "Gate 7: output"
    , gateType = OutputGate
    , status = False
    , inputs = A.fromList ["Gate 6: orGate"]
    , logic = inputLogic
  }

-- set up network
network : Network
network = [input1,input2,input3,andGate,andGate2,orGate,output] 

networkNames : [String]
networkNames = [
    "Gate 1: input1"
  , "Gate 2: input2"
  , "Gate 3: input3"
  , "Gate 4: andGate"
  , "Gate 5: andGate2"
  , "Gate 6: orGate"
  , "Gate 7: output"
  ]

-- initialize state of network
startState : State
startState = initState emptyState network

-- update state
updatedState : State
updatedState = updateState startState networkNames

drawThis : State -> Element
drawThis state = 
  let 
    inputsElement = 
      flow right [
        drawGate (D.getOrFail "Gate 1: input1" state)
      , plainText "    "
      , drawGate (D.getOrFail "Gate 2: input2" state)
      , plainText "    "
      , drawGate (D.getOrFail "Gate 3: input3" state)
      ]
    andElement = 
      flow right [
        drawGate (D.getOrFail "Gate 4: andGate" state)
      ]
    and2Element = 
      flow right [
        plainText "              "
      , drawGate (D.getOrFail "Gate 5: andGate2" state)
      ]
    orElement = flow right [drawGate (D.getOrFail "Gate 6: orGate" state)]
    outputElement = flow right [drawGate (D.getOrFail "Gate 7: output" state)]
  in
    flow down [
      inputsElement
    , andElement
    , and2Element
    , orElement
    , outputElement
    ]
-- run level (show text)
main : Element
main = 
  flow down [
    [markdown|## Start State|]
  , drawThis startState
  , [markdown|## Simulated State|]
  , drawThis updatedState
  ]
    {--let
      startStateBool = getStatusBool (D.toList startState)
      updatedStateBool = getStatusBool (D.toList updatedState)
    in
      flow down [
        asText "Start state:"
      , asText startStateBool
      , asText "Updated state:"
      , asText updatedStateBool
      ]--}