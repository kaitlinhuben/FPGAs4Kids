module TestRunner where

import Mouse
import Debug (..)
import Dict as D
import Array as A
import Gates (..)
import StateInfo (..)
import View (..)
import Controller (..)

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
gates : [Gate]
gates = [input1,input2,input3,andGate,andGate2,orGate,output] 

netNames : [String]
netNames = [
    "input1"
  , "input2"
  , "input3"
  , "andGate"
  , "andGate2"
  , "orGate"
  , "output"
  ]

-- Put everything into GameState
gameState : GameState
gameState = {
    networkNames = netNames
  , circuitState = initCircuitState D.empty gates
  , gameMode = Schematic
  , mousePos = (0,0)
  }

userInput : Signal UserInput
userInput = UserInput <~ Mouse.position

-- run level (show text)
main : Signal Element
main = mainDriver gameState userInput