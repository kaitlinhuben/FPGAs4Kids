module MainRunner where

import Text
import List
import Dict
import Maybe (withDefault)
import Signal (Signal, Channel, channel, subscribe, map, map2)
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
    , channels = Dict.fromList [("inputGate", channel True)]
    } -- end Level_01
  ]

-- instantiate game state
-- TODO this will change between levels - keep list of levels left

-- put everything into initial GameState
gameState : GameState
gameState = initGameState (List.head levels)

firstLevel = List.head levels
firstLevelChannels = firstLevel.channels
firstLevelInputChannel = withDefault failedChannel (Dict.get "inputGate" firstLevelChannels)

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map liftToDict (subscribe firstLevelInputChannel) --TODO these channels are hardcoded

liftToDict : Bool -> InputsState
liftToDict bool = Dict.insert "inputGate" bool Dict.empty

userInputsTest : Signal (InputsState)
userInputsTest = map2 liftAddToDict userInputs (subscribe firstLevelInputChannel)

liftAddToDict : InputsState -> Bool -> InputsState
liftAddToDict inState bool = Dict.insert "test" bool inState

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputsTest)
--main = Text.plainText "hello!"