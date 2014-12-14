module Controller.InstantiationHelper where

import Dict as D
import Graphics.Input as I
import Model.Model (..)

instantiateGameState : [Gate] -> [ (String, I.Input Bool) ] -> GameState
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

extractGateNames : [Gate] -> [String]
extractGateNames gates =
    case gates of 
        [] -> []
        gate :: [] -> [gate.name]
        gate :: tl -> gate.name :: extractGateNames tl

extractInputGateNames : [Gate] -> [String]
extractInputGateNames gates = 
    case gates of 
        [] -> []
        gate :: [] ->
            if | gate.gateType == InputGate -> [gate.name]
               | otherwise -> []
        gate :: tl ->
            if | gate.gateType == InputGate -> gate.name :: extractInputGateNames tl
               | otherwise -> extractInputGateNames tl

extractNonInputGateNames : [Gate] -> [String]
extractNonInputGateNames gates = 
    case gates of 
        [] -> []
        gate :: [] ->
            if | gate.gateType == InputGate -> []
               | otherwise -> [gate.name]
        gate :: tl ->
            if | gate.gateType == InputGate -> extractNonInputGateNames tl
               | otherwise -> gate.name :: extractNonInputGateNames tl

extractCircuitState : [Gate] -> CircuitState -> CircuitState
extractCircuitState gates cs = 
    case gates of 
        [] -> cs
        gate :: [] -> D.insert gate.name gate cs
        gate :: tl ->
            let
                updatedCS = extractCircuitState tl cs
            in
                D.insert gate.name gate updatedCS

extractInputStatuses : [Gate] -> D.Dict String Bool -> D.Dict String Bool
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
    