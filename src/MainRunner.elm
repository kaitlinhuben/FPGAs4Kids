module MainRunner where

import Text
import List
import Dict
import Signal (Signal, Channel, channel, subscribe, map)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

type alias GateInfo = {
    name     : String
  , gateType : GateType --TODO gate type should be more than ternary 
  , status   : Bool
  , inputs   : List String
  , logic    : String --TODO function or instantiate
  , location : (Float, Float)
  , imgSize  : (Int, Int)
}

type alias Level = {
    name      : String
  , solution  : List (String, Bool)
  , nextLevel : String
  , par       : Int
  , directions : String
  , gates     : List GateInfo
}

levels : List Level
levels = 
  [
    {
      name = "Level_01"
    , solution = [("outputGate", True)]
    , nextLevel = "Level_02"
    , par = 1
    , directions = "Testing directions"
    , gates = [
        { name = "inputGate"
        , gateType = InputGate
        , status = True
        , inputs = []
        , logic = "inputLogic"
        , location = (-100,0)
        , imgSize = (75,75)
        }, 
        { name = "notGate"
        , gateType = NormalGate
        , status = False
        , inputs = ["inputGate"]
        , logic = "notLogic"
        , location = (0,0)
        , imgSize = (75,75)
        },
        { name = "outputGate"
        , gateType = OutputGate
        , status = False
        , inputs = ["notGate"]
        , logic = "outputLogic"
        , location = (100,0)
        , imgSize = (75,75)
        }
      ]
    } -- end Level_01
  ]

extractGates : List GateInfo -> List Gate
extractGates gatesInfo = 
    case gatesInfo of
        [] -> []
        gateInfo :: [] -> [initGate gateInfo]
        gateInfo :: tl -> (initGate gateInfo) :: extractGates tl

-- TODO generalize
level1_gates : List Gate
level1_gates = 
    let 
        firstLevel = List.head levels 
        firstLevelGateInfo = firstLevel.gates 
    in 
        extractGates firstLevelGateInfo

-- instantiate game state
-- TODO this will change between levels
inputGate = List.head level1_gates
-- set up all Inputs
inputChannel : Channel Bool 
inputChannel = channel inputGate.status

-- set up pre-dicts
inputSignalsPreDict : List (String, Channel Bool)
inputSignalsPreDict = [ ("inputGate", inputChannel) ]

-- put everything into initial GameState
gameState : GameState
gameState = initGameState level1_gates inputSignalsPreDict (List.head levels)

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map liftToDict (subscribe inputChannel)

liftToDict : Bool -> InputsState
liftToDict bool = Dict.insert "inputGate" bool Dict.empty

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)