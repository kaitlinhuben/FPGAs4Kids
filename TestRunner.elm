module TestRunner where

import Mouse
import Dict as D
import Array as A
import Graphics.Input as I
import Signal
import Graphics.Element (..)
import Model.Model (..)
import Model.CircuitFunctions (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

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
    , imgOffName = inputOffName
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

-- list of gates
gates : List Gate
gates = [
    input1
  , input2
  , input3
  , andGate
  , andGate2
  , orGate
  , output
  ] 

-- set up all Inputs
inputChannel1 : Signal.Channel Bool 
inputChannel1 = Signal.channel input1.status
inputChannel2 : Signal.Channel Bool 
inputChannel2 = Signal.channel input2.status
inputChannel3 : Signal.Channel Bool 
inputChannel3 = Signal.channel input3.status

-- set up list of (String, Input Bool) to change to dict
inputChannelsPreDict : List (String, Signal.Channel Bool) 
inputChannelsPreDict = 
  [ ("input1", inputChannel1)
  , ("input2", inputChannel2)
  , ("input3", inputChannel3)
  ]

-- lift all input signals into user input
userInputs : Signal (D.Dict String Bool)
userInputs = Signal.map3 liftToDict (Signal.subscribe inputChannel1) (Signal.subscribe inputChannel2) (Signal.subscribe inputChannel3)

liftToDict : Bool -> Bool -> Bool -> D.Dict String Bool
liftToDict bool1 bool2 bool3 = 
  let
    emptyDict = D.empty 
    dict1 = D.insert "input1" bool1 emptyDict
    dict2 = D.insert "input2" bool2 dict1
  in 
    D.insert "input3" bool3 dict2
    
-- lift mouse position and all input signals into UserInput
userInput : Signal UserInput
userInput = Signal.map2 UserInput Mouse.position userInputs

-- Put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputChannelsPreDict


-- run level
main : Signal Element
main = mainDriver gameState userInput