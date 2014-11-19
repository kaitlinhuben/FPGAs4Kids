module TestRunner where

import Dict as D
import Array as A
import Gates (..)
import State (..)

-- Set up gates for level
andGate : Gate
andGate = {
      name = "andGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["input1", "input2"]
    , logic = andLogic
  }

input1 : Gate
input1 = {
      name = "input1"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
  }

input2 : Gate
input2 = {
      name = "input2"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
  }

output : Gate
output = {
      name = "output"
    , gateType = OutputGate
    , status = False
    , inputs = A.fromList ["andGate"]
    , logic = inputLogic
  }

-- set up network
network : Network
network = [input1,input2,andGate,output] 

networkNames : [String]
networkNames = ["input1","input2","andGate","output"]

-- initialize state of network
startState : State
startState = initState emptyState network 

-- update state
updatedState : State
updatedState = updateState startState networkNames

-- run level (show text)
main : Element
main = 
    let
      startStateBool = getStatusBool (D.toList startState)
      updatedStateBool = getStatusBool (D.toList updatedState)
    in
      flow down [
        asText "Start state:"
      , asText startStateBool
      , asText "Updated state:"
      , asText updatedStateBool
      ]