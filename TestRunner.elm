module TestRunner where

import Mouse
import Debug (..)
import Dict as D
import Array as A
import Graphics.Input as I
import Model (..)
import CircuitFunctions (..)
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

inputNetNames : [String]
inputNetNames = ["input1"]

inputBool1 : I.Input Bool 
inputBool1 = I.input False

inputSignals : [I.Input Bool]
inputSignals = [inputBool1]

-- Put everything into GameState
gameState : GameState
gameState = {
    networkNames = netNames
  , inputNames = inputNetNames
  , circuitState = initCircuitState D.empty gates
  , gameMode = Schematic
  , mousePos = (0,0)
  , userInputBools = D.singleton "input1" False
  , inputSignals = inputBool1
  }

userInputs : Signal (D.Dict String Bool)
userInputs = liftToList <~ inputBool1.signal

liftToList : Bool -> D.Dict String Bool
liftToList bool1 = 
  let
    emptyDict = D.empty 
  in 
    D.insert "input1" bool1 emptyDict

userInput : Signal UserInput
userInput = UserInput <~ Mouse.position ~ userInputs

-- run level (show text)
main : Signal Element
main = mainDriver gameState userInput