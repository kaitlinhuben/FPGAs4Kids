{--
    Helps instantiate a GameState by minimizing amount of parameters needed
--}
module Controller.InstantiationHelper where

import Array
import Dict
import List ((::))
import Signal (Signal, Channel, channel, subscribe, map, map2, map3, constant)
import Mouse (clicks)
import Model.Model (..)

initGate : GateInfo -> Gate
initGate gateInfo = 
    { name = gateInfo.name
    , gateType = gateInfo.gateType
    , status = gateInfo.status
    , inputs = Array.fromList gateInfo.inputs
    , logic = 
        if | gateInfo.logic == "inputLogic" -> inputLogic
           | gateInfo.logic == "notLogic" -> notLogic
           | gateInfo.logic == "outputLogic" -> outputLogic
           | gateInfo.logic == "andLogic" -> andLogic
           | gateInfo.logic == "orLogic" -> orLogic
    , location = gateInfo.location
    , imgName = findImageName gateInfo.status gateInfo.logic
    , imgOnName = findImageName True gateInfo.logic
    , imgOffName = findImageName False gateInfo.logic
    , imgSize = gateInfo.imgSize
    }

findImageName : Bool -> String -> String
findImageName status logicString =
    if | status == True  && logicString == "inputLogic" -> inputOnName
       | status == False && logicString == "inputLogic" -> inputOffName
       | status == True  && logicString == "outputLogic" -> outputOnName
       | status == False && logicString == "outputLogic" -> outputOffName
       | logicString == "notLogic" -> notImageName
       | logicString == "andLogic" -> andImageName
       | logicString == "orLogic" -> orImageName
       | otherwise -> outputBadName
{------------------------------------------------------------------------------
    main function to instantiate a game state; utilizes helper functions
    to extract all needed information
------------------------------------------------------------------------------}
extractGates : List GateInfo -> List Gate
extractGates gatesInfo = 
  case gatesInfo of
    [] -> []
    gateInfo :: [] -> [initGate gateInfo]
    gateInfo :: tl -> (initGate gateInfo) :: extractGates tl

initGameState : Level -> GameState
initGameState level = 
  let
    gates = extractGates level.gateInfo
  in
    { 
      networkNames = extractGateNames gates
    , inputNames = extractInputGateNames gates
    , nonInputNames = extractNonInputGateNames gates
    , circuitState = extractCircuitState gates Dict.empty
    , gameMode = Schematic
    , mousePos = (0,0)
    , inputStatuses = extractInputStatuses gates Dict.empty
    , inputChannels = level.channels
    , clicks = 0
    , completed = False
    , solution = Dict.fromList level.solution 
    , nextLink = "TODO"
    , clicksPar = level.par
    }

{------------------------------------------------------------------------------
    helper extraction functions
------------------------------------------------------------------------------}
-- recursively extract gate names from list of gates
extractGateNames : List Gate -> List String
extractGateNames gates =
    case gates of 
        [] -> []
        gate :: [] -> [gate.name]
        gate :: tl -> gate.name :: extractGateNames tl

-- recursively extract input gate names from list of gates
extractInputGateNames : List Gate -> List String
extractInputGateNames gates = 
    case gates of 
        [] -> []
        gate :: [] ->
            if | gate.gateType == InputGate -> [gate.name]
               | otherwise -> []
        gate :: tl ->
            if | gate.gateType == InputGate -> gate.name :: extractInputGateNames tl
               | otherwise -> extractInputGateNames tl

-- recursively extract non-input gate names from list of gates
extractNonInputGateNames : List Gate -> List String
extractNonInputGateNames gates = 
    case gates of 
        [] -> []
        gate :: [] ->
            if | gate.gateType == InputGate -> []
               | otherwise -> [gate.name]
        gate :: tl ->
            if | gate.gateType == InputGate -> extractNonInputGateNames tl
               | otherwise -> gate.name :: extractNonInputGateNames tl

-- recursively build CircuitState (Dict String Gate) from list of gates
extractCircuitState : List Gate -> CircuitState -> CircuitState
extractCircuitState gates cs = 
    case gates of 
        [] -> cs
        gate :: [] -> Dict.insert gate.name gate cs
        gate :: tl ->
            let
                updatedCS = extractCircuitState tl cs
            in
                Dict.insert gate.name gate updatedCS

-- recursively build input statuses (Dict String Bool) from list of gates
extractInputStatuses : List Gate -> InputsState -> InputsState
extractInputStatuses gates dict = 
    case gates of
        [] -> dict
        gate :: [] -> 
            if | gate.gateType == InputGate -> Dict.insert gate.name gate.status dict
               | otherwise -> dict
        gate :: tl ->
            let 
                updatedDict = extractInputStatuses tl dict
            in 
                if | gate.gateType == InputGate -> Dict.insert gate.name gate.status updatedDict
                   | otherwise -> updatedDict

{--
  Create the initial inputs state from the given channels
--}
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

getEmptySignalInputsState : Signal (InputsState)
getEmptySignalInputsState = map2 liftToDict (constant "") (subscribe (channel False))