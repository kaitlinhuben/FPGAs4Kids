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
    , inputs = ["input1", "input2"]
    , outputs = ["output"]
    , logic = andLogic
  }

input1 : Gate
input1 = {
      name = "input1"
    , gateType = InputGate
    , status = True
    , inputs = []
    , outputs = ["andGate"]
    , logic = inputLogic
  }

input2 : Gate
input2 = {
      name = "input2"
    , gateType = InputGate
    , status = True
    , inputs = []
    , outputs = ["andGate"]
    , logic = inputLogic
  }

output : Gate
output = {
      name = "output"
    , gateType = OutputGate
    , status = False
    , inputs = ["andGate"]
    , outputs = []
    , logic = inputLogic
  }

-- set up network
network : [Gate]
network = [input1,input2,andGate,output] 

-- initialize state of network
startState : State
startState = initState emptyState network 

-- run level (show text)
main : Element
main = 
    flow down [
      asText "Start state:"
    , asText startState
    ]