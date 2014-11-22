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
      name = "andGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["input1", "input2"]
    , logic = andLogic
  }

andGate2 : Gate
andGate2 = {
      name = "andGate2"
    , gateType = NormalGate
    , status = True
    , inputs = A.fromList ["input3", "andGate"]
    , logic = andLogic
  }

orGate : Gate
orGate = {
      name = "orGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["andGate", "andGate2"]
    , logic = orLogic
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

input3 : Gate
input3 = {
      name = "input3"
    , gateType = InputGate
    , status = False
    , inputs = A.empty
    , logic = inputLogic
  }

output : Gate
output = {
      name = "output"
    , gateType = OutputGate
    , status = False
    , inputs = A.fromList ["orGate"]
    , logic = inputLogic
  }

-- set up network
network : Network
network = [input1,input2,input3,andGate,andGate2,orGate,output] 

networkNames : [String]
networkNames = [
    "input1"
  , "input2"
  , "input3"
  , "andGate"
  , "andGate2"
  , "orGate"
  , "output"
  ]

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
      updatedStateBool = getStatusBool (D.toList updatedState)
  in
    flow down [
        [markdown|## Simulated State|]
      , asText updatedStateBool
      , plainText "   "
      , drawThis updatedState
    ]