module Level_3 where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, foldp)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

-- Set up gates
inputGate1 : Gate
inputGate1 = {
      name = "inputGate1"
    , gateType = InputGate
    , status = False
    , inputs = Array.empty
    , logic = inputLogic
    , location = (-100,0)
    , imgName = inputOffName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

-- Set up gates
inputGate2 : Gate
inputGate2 = {
      name = "inputGate2"
    , gateType = InputGate
    , status = False
    , inputs = Array.empty
    , logic = inputLogic
    , location = (-100,-100)
    , imgName = inputOffName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

-- Set up gates for level
orGate : Gate
orGate = {
      name = "orGate"
    , gateType = NormalGate
    , status = False
    , inputs = Array.fromList ["inputGate1", "inputGate2"]
    , logic = orLogic
    , location = (0,0)
    , imgName = orImageName
    , imgOnName = orImageName
    , imgOffName = orImageName
    , imgSize = (75,75)
  }

outputGate : Gate
outputGate = {
      name = "outputGate"
    , gateType = OutputGate
    , status = False
    , inputs = Array.fromList ["orGate"]
    , logic = inputLogic
    , location = (100,0)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
  }

-- set up array of gates in correct order
gates : List Gate
gates = [inputGate1, inputGate2, orGate, outputGate]

-- set up all Inputs
inputChannel1 : Channel Bool 
inputChannel1 = channel inputGate1.status
inputChannel2 : Channel Bool 
inputChannel2 = channel inputGate2.status

-- set up pre-dicts
inputSignalsPreDict : List (String, Channel Bool)
inputSignalsPreDict = [ ("inputGate1", inputChannel1)
                        , ("inputGate2", inputChannel2) ]

-- set up solution
solution : Dict.Dict String Bool
solution = Dict.fromList [ ("outputGate", True)]

-- directions & link
directions : String
directions = "This is an OR gate. It needs at least one input on. Try to get the output to turn on."
nextLink : String
nextLink = "Level_4.html"
par : Int 
par = 1

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict solution directions nextLink par

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map2 liftToDict (subscribe inputChannel1) (subscribe inputChannel2)

liftToDict : Bool -> Bool -> InputsState
liftToDict bool1 bool2 = 
    let
        firstDict = Dict.insert "inputGate1" bool1 Dict.empty
    in 
        Dict.insert "inputGate2" bool2 firstDict

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)