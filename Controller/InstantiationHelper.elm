{--
    Helps instantiate a GameState by minimizing amount of parameters needed
--}
module Controller.InstantiationHelper where

import Dict as D
import List ((::))
import Signal
import Graphics.Input as I
import Model.Model (..)

{------------------------------------------------------------------------------
    main function to instantiate a game state; utilizes helper functions
    to extract all needed information
------------------------------------------------------------------------------}
instantiateGameState : List Gate -> List (String, Signal.Channel Bool) -> GameState
instantiateGameState gates inputSignalsPreDict = { 
      networkNames = extractGateNames gates
    , inputNames = extractInputGateNames gates
    , nonInputNames = extractNonInputGateNames gates
    , circuitState = extractCircuitState gates D.empty
    , gameMode = Schematic
    , mousePos = (0,0)
    , inputStatuses = extractInputStatuses gates D.empty
    , inputSignals = D.fromList inputSignalsPreDict
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
        gate :: [] -> D.insert gate.name gate cs
        gate :: tl ->
            let
                updatedCS = extractCircuitState tl cs
            in
                D.insert gate.name gate updatedCS

-- recursively build input statuses (Dict String Bool) from list of gates
extractInputStatuses : List Gate -> D.Dict String Bool -> D.Dict String Bool
extractInputStatuses gates dict = 
    case gates of
        [] -> dict
        gate :: [] -> 
            if | gate.gateType == InputGate -> D.insert gate.name gate.status dict
               | otherwise -> dict
        gate :: tl ->
            let 
                updatedDict = extractInputStatuses tl dict
            in 
                if | gate.gateType == InputGate -> D.insert gate.name gate.status updatedDict
                   | otherwise -> updatedDict
    