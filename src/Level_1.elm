module Level_1 where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, foldp)
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

-- set up solution
solution : Dict.Dict String Bool
solution = Dict.fromList [ ("outputGate", True)]

-- directions & link
directions : String
directions = "This is a NOT gate. It flips inputs. Try to get the output to turn on."
nextLink : String
nextLink = "Level_2.html"
par : Int 
par = 1

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict solution directions nextLink par

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map liftToDict (subscribe inputChannel)

liftToDict : Bool -> InputsState
liftToDict bool = Dict.insert "inputGate" bool Dict.empty

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)