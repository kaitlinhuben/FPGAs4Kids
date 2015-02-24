module Level_4 where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, foldp)
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
    , status = False
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
    , status = True
    , inputs = Array.empty
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
    , inputs = Array.fromList ["orGate"]
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
solution = Dict.fromList [ ("output", True)] 

-- directions & link
directions : String
directions = "Now that you know how things work, try to get the output to turn on."
nextLink : String
nextLink = "Level_5.html"

-- Put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputChannelsPreDict solution directions nextLink

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
    
-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)