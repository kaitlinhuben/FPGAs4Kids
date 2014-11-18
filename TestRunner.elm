module TestRunner where

import Dict as D
import Array as A
import Gates (..)
import State (..)

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
    , status = False
    , inputs = []
    , outputs = ["andGate"]
    , logic = inputLogic
  }

input2 : Gate
input2 = {
      name = "input2"
    , gateType = InputGate
    , status = False
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

network : [Gate]
network = [input1,input2,andGate,output] 

startState : D.Dict String Bool
startState = initState emptyState network 
    {--let
        initState = emptyState
        addFirst = addGate emptyState input1
        addSecond = addGate addFirst input2
        addThird = addGate addSecond output
    in 
        addGate addThird andGate --}

main : Element
main = 
    flow down [
      asText input1
    , asText andGate
    , asText startState
    ]