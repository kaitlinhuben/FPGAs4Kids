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
    , location = (-100,50)
    , imgName = andImageName
    , imgOnName = andImageName
    , imgOffName = andImageName
    , imgSize = (75,75)
  }

andGate2 : Gate
andGate2 = {
      name = "andGate2"
    , gateType = NormalGate
    , status = True
    , inputs = A.fromList ["input3", "andGate"]
    , logic = andLogic
    , location = (0,-50)
    , imgName = andImageName
    , imgOnName = andImageName
    , imgOffName = andImageName
    , imgSize = (75,75)
  }

orGate : Gate
orGate = {
      name = "orGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["andGate", "andGate2"]
    , logic = orLogic
    , location = (100,0)
    , imgName = orImageName
    , imgOnName = orImageName
    , imgOffName = orImageName
    , imgSize = (75,75)
  }

input1 : Gate
input1 = {
      name = "input1"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
    , location = (-200,100)
    , imgName = inputOnName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

input2 : Gate
input2 = {
      name = "input2"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
    , location = (-200,0)
    , imgName = inputOnName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

input3 : Gate
input3 = {
      name = "input3"
    , gateType = InputGate
    , status = False
    , inputs = A.empty
    , logic = inputLogic
    , location = (-200,-100)
    , imgName = inputOffName
    , imgOnName = inputOnName
    , imgOffName = inputOnName
    , imgSize = (75,75)
  }

output : Gate
output = {
      name = "output"
    , gateType = OutputGate
    , status = False
    , inputs = A.fromList ["orGate"]
    , logic = inputLogic
    , location = (175,0)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
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
nonInputNetNames : [String]
nonInputNetNames = ["andGate", "andGate2", "orGate", "output"]

inputNetNames : [String]
inputNetNames = ["input1","input2","input3"]

inputBool1 : I.Input Bool 
inputBool1 = I.input input1.status
inputBool2 : I.Input Bool 
inputBool2 = I.input input2.status
inputBool3 : I.Input Bool 
inputBool3 = I.input input3.status

inputSignalsPreDict : [ (String, I.Input Bool) ]
inputSignalsPreDict = 
  [ ("input1", inputBool1)
  , ("input2", inputBool2)
  , ("input3", inputBool3)
  ]

inputBoolsPreDict : [ (String,Bool) ]
inputBoolsPreDict = 
  [ ("input1", input1.status)
  , ("input2", input2.status)
  , ("input3", input3.status)
  ]

-- Put everything into GameState
gameState : GameState
gameState = {
    networkNames = netNames
  , inputNames = inputNetNames
  , nonInputNames = nonInputNetNames
  , circuitState = initCircuitState D.empty gates
  , gameMode = Schematic
  , mousePos = (0,0)
  , userInputBools = D.fromList inputBoolsPreDict
  , inputSignals = D.fromList inputSignalsPreDict
  }


userInputs : Signal (D.Dict String Bool)
userInputs = liftToList <~ inputBool1.signal ~ inputBool2.signal ~ inputBool3.signal

liftToList : Bool -> Bool -> Bool -> D.Dict String Bool
liftToList bool1 bool2 bool3 = 
  let
    emptyDict = D.empty 
    dict1 = D.insert "input1" bool1 emptyDict
    dict2 = D.insert "input2" bool2 dict1
  in 
    D.insert "input3" bool3 dict2
    

userInput : Signal UserInput
userInput = UserInput <~ Mouse.position ~ userInputs


-- run level (show text)
main : Signal Element
main = mainDriver gameState userInput