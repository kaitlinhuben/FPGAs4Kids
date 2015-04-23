module MainRunner where

import Text
import List
import Dict
import Maybe (withDefault)
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, constant)
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
    , channels = Dict.fromList [("inputGate1", channel False), ("inputGate2", channel False)]
    } -- end Level_01
  ]

-- instantiate game state
-- TODO this will change between levels - keep list of levels left

-- put everything into initial GameState
gameState : GameState
gameState = initGameState (List.head levels)

firstLevel = List.head levels
{-firstLevelChannels = firstLevel.channels
firstLevelInputChannel1 = withDefault failedChannel (Dict.get "inputGate1" firstLevelChannels)
firstLevelInputChannel2 = withDefault failedChannel (Dict.get "inputGate2" firstLevelChannels)

-- lift input signals into user input
userInputs : Signal (InputsState)
userInputs = map2 liftToDict (subscribe firstLevelInputChannel1) (subscribe firstLevelInputChannel2)--TODO these channels are hardcoded

liftToDict : Bool -> Bool -> InputsState
liftToDict bool1 bool2 =  Dict.insert "inputGate1" bool1 Dict.empty

userInputsTest : Signal (InputsState)
userInputsTest = map3 liftAddToDict userInputs (subscribe firstLevelInputChannel1) (subscribe firstLevelInputChannel2)

liftAddToDict : InputsState -> Bool -> Bool -> InputsState
liftAddToDict inState bool1 bool2 = Dict.insert "inputGate2" bool2 inState
-}

userInputsTest : Signal (InputsState)
userInputsTest = 
    let 
        channelsList = Dict.toList firstLevel.channels
        emptyDict = map2 liftToDict (constant "") (subscribe (channel False))
    in 
        fillInputsState channelsList emptyDict
    
fillInputsState : List (String, Channel Bool) -> Signal (InputsState) -> Signal (InputsState)
fillInputsState channelsList inState = 
    case channelsList of
        [] -> constant Dict.empty
        (name,chan) :: [] -> 
            map3 liftAddToDict (constant name) (subscribe chan) inState
        (name,chan) :: tl -> 
            let
                newInState = map3 liftAddToDict (constant name) (subscribe chan) inState
            in 
                fillInputsState tl newInState

liftToDict : String -> Bool -> InputsState
liftToDict name bool = Dict.insert name bool Dict.empty

liftAddToDict : String -> Bool -> InputsState -> InputsState
liftAddToDict name bool inState = Dict.insert name bool inState

-- Run main
main : Signal Element
main = mainDriver gameState (map UserInput userInputsTest)
--main = Text.plainText "hello!"