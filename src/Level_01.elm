module Level_01 where

import Mouse
import Array
import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, foldp)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)


-- input ports
port inPort : InputJSON
port notPort: InputJSON
port outPort: InputJSON
port miscPort: MiscInputJSON

-- Set up gates
inputGate : Gate
inputGate = initGate inPort

notGate : Gate
notGate = initGate notPort

outputGate : Gate
outputGate = initGate outPort

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

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict solution miscPort

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map liftToDict (subscribe inputChannel)

liftToDict : Bool -> InputsState
liftToDict bool = Dict.insert "inputGate" bool Dict.empty

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)