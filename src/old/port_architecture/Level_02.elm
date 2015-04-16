module Level_02 where

import Dict
import Signal (Signal, Channel, channel, subscribe, map, map2)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

-- input ports
port inPort1: InputJSON
port inPort2: InputJSON
port andPort: InputJSON
port outPort: InputJSON
port miscPort: MiscInputJSON

-- Set up gates
inputGate1 = initGate inPort1
inputGate2 = initGate inPort2
andGate = initGate andPort
outputGate = initGate outPort

-- set up array of gates in correct order
gates : List Gate
gates = [inputGate1, inputGate2, andGate, outputGate]

-- set up all Inputs
inputChannel1 : Channel Bool 
inputChannel1 = channel inputGate1.status
inputChannel2 : Channel Bool 
inputChannel2 = channel inputGate2.status

-- set up pre-dicts
inputSignalsPreDict : List (String, Channel Bool)
inputSignalsPreDict = [ ("inputGate1", inputChannel1)
                        , ("inputGate2", inputChannel2) ]

-- put everything into initial GameState
gameState : GameState
gameState = initGameState gates inputSignalsPreDict miscPort

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