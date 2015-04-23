module CadTester where

import Text
import List
import Dict
import Maybe (withDefault)
import Signal (Signal, Channel, channel, map)
import Graphics.Element (Element)
import Model.Model (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

levels : List Level
levels = 
  [
    {
      name = "Level_01"
    , solution = [("outputGate", True)]
    , nextLevel = "Level_02"
    , par = 1
    , directions = "Testing directions"
    , gateInfo = [
        { name = "inputGate1"
        , gateType = InputGate
        , status = False
        , inputs = []
        , logic = "inputLogic"
        , location = (-100,0)
        , imgSize = (75,75)
        }, 
        { name = "inputGate2"
        , gateType = InputGate
        , status = False
        , inputs = []
        , logic = "inputLogic"
        , location = (-100,-100)
        , imgSize = (75,75)
        }, 
        { name = "orGate"
        , gateType = NormalGate
        , status = False
        , inputs = ["inputGate1","inputGate2"]
        , logic = "orLogic"
        , location = (0,0)
        , imgSize = (75,75)
        },
        { name = "outputGate"
        , gateType = OutputGate
        , status = False
        , inputs = ["orGate"]
        , logic = "outputLogic"
        , location = (100,0)
        , imgSize = (75,75)
        }
      ]
    , channels = [("inputGate1", channel False), ("inputGate2", channel False)]
    } -- end Level_01
  ]

-- instantiate game state
-- TODO this will change between levels - keep list of levels left

-- put everything into initial GameState
gameState : GameState
gameState = initGameState (List.head levels)

firstLevel = List.head levels

userInputs : Signal (InputsState)
userInputs = fillInputsState firstLevel.channels getEmptySignalInputsState

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)