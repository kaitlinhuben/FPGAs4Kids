module Level_1 where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

-- Set up gates
inputGate : Gate
inputGate = {
      name = "inputGate"
    , gateType = InputGate
    , status = True
    , inputs = Array.empty
    , logic = inputLogic
    , location = (-100,0)
    , imgName = inputOnName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

notGate : Gate
notGate = {
      name = "notGate"
    , gateType = NormalGate
    , status = False
    , inputs = Array.fromList ["inputGate"]
    , logic = notLogic
    , location = (0,0)
    , imgName = notImageName
    , imgOnName = notImageName
    , imgOffName = notImageName
    , imgSize = (75,75)
  }

outputGate : Gate
outputGate = {
      name = "outputGate"
    , gateType = OutputGate
    , status = False
    , inputs = Array.fromList ["notGate"]
    , logic = inputLogic
    , location = (100,0)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
  }

-- set up array of gates in correct order
gates : List Gate
gates = [inputGate, notGate, outputGate]

-- set up all Inputs
inputChannel : Channel Bool 
inputChannel = channel inputGate.status

-- set up pre-dicts
inputSignalsPreDict : List (String, Channel Bool)
inputSignalsPreDict = [ ("inputGate", inputChannel) ]

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map liftToDict (subscribe inputChannel)

liftToDict : Bool -> InputsState
liftToDict bool = Dict.insert "inputGate" bool Dict.empty

-- lift mouse position and all input signals into UserInput
userInput : Signal UserInput
userInput = map2 UserInput Mouse.position userInputs


-- Run main
main : Signal Element
main = mainDriver gameState userInput