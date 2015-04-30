module MainRunner where

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
    , channels = [("inputGate", channel True)]
    } -- end Level_01
    {-- {
      name = "Level_02"
    , solution = [("outputGate", True)]
    , nextLevel = "Level_03"
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
    } -- end Level_02 --}
  ]

-- put everything into initial GameState
gameState : GameState
gameState = initGameState (List.head levels)

-- TODO this will change between levels - keep list of levels left
firstLevel = List.head levels

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = fillInputsState firstLevel.channels getEmptySignalInputsState

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputs)