module TestRunner where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map2, map3, foldp)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

-- Set up gates for level
andGate : Gate
andGate = {
      name = "andGate"
    , gateType = NormalGate
    , status = False
    , inputs = Array.fromList ["input1", "input2"]
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
    , inputs = Array.fromList ["input3", "andGate"]
    , logic = andLogic
    , location = (0,-50)
    , imgName = andImageName
    , imgOnName = andImageName
    , imgOffName = andImageName
    , imgSize = (75,75)
  }

notGate : Gate
notGate = {
      name = "notGate"
    , gateType = NormalGate
    , status = False
    , inputs = Array.fromList ["input3"]
    , logic = notLogic
    , location = (0,-125)
    , imgName = notImageName
    , imgOnName = notImageName
    , imgOffName = notImageName
    , imgSize = (75,75)
  }

orGate : Gate
orGate = {
      name = "orGate"
    , gateType = NormalGate
    , status = False
    , inputs = Array.fromList ["andGate", "andGate2"]
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
    , status = False
    , inputs = Array.empty
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
    , inputs = Array.empty
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
    , inputs = Array.empty
    , logic = inputLogic
    , location = (-200,-100)
    , imgName = inputOffName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

output1 : Gate
output1 = {
      name = "output1"
    , gateType = OutputGate
    , status = False
    , inputs = Array.fromList ["orGate"]
    , logic = inputLogic
    , location = (175,0)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
  }

output2 : Gate
output2 = {
      name = "output2"
    , gateType = OutputGate
    , status = False
    , inputs = Array.fromList ["andGate2"]
    , logic = inputLogic
    , location = (175,-100)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
  }

output3 : Gate
output3 = {
      name = "output3"
    , gateType = OutputGate
    , status = False
    , inputs = Array.fromList ["notGate"]
    , logic = inputLogic
    , location = (175,-175)
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
  , notGate
  , orGate
  , output1
  , output2
  , output3
  ] 

-- set up all Inputs
inputChannel1 : Channel Bool 
inputChannel1 = channel input1.status
inputChannel2 : Channel Bool 
inputChannel2 = channel input2.status
inputChannel3 : Channel Bool 
inputChannel3 = channel input3.status

-- set up list of (String, Input Bool) to change to dict
inputChannelsPreDict : List (String, Channel Bool) 
inputChannelsPreDict = 
  [ ("input1", inputChannel1)
  , ("input2", inputChannel2)
  , ("input3", inputChannel3)
  ]

-- set up solution
solution : Dict.Dict String Bool
solution = Dict.fromList [ ("output1", True), ("output2",True), ("output3",False)] 

-- Put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputChannelsPreDict solution

-- lift all input signals into user input
userInputs : Signal (InputsState)
userInputs = map3 liftToDict (subscribe inputChannel1) (subscribe inputChannel2) (subscribe inputChannel3)

liftToDict : Bool -> Bool -> Bool -> InputsState
liftToDict bool1 bool2 bool3 = 
  let
    emptyDict = Dict.empty 
    dict1 = Dict.insert "input1" bool1 emptyDict
    dict2 = Dict.insert "input2" bool2 dict1
  in 
    Dict.insert "input3" bool3 dict2
    
-- count clicks
countClick: Signal Int 
countClick = foldp (\clk count -> count + 1) 0 Mouse.clicks
-- lift mouse position/clicks and all input signals into UserInput
userInput : Signal UserInput
userInput = map3 UserInput Mouse.position countClick userInputs


-- run level
main : Signal Element
main = mainDriver gameState userInput