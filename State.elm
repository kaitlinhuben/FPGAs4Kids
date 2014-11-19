{--
    Stores information for circuit state
--}
module State where

import Debug (..)
import Dict as D
import Array as A
import Gates (..)

type Network = [Gate]

type State = D.Dict String Gate

{-- Initialize state with gates in network --}
emptyState : State
emptyState = D.empty 

initState : State -> Network -> State
initState state network = 
    case network of 
        [] -> state
        hd :: [] -> addGate state hd
        hd :: tl -> 
            let
                statePlusHd = addGate state hd 
            in
                initState statePlusHd tl

addGate : State -> Gate -> State
addGate state gate = 
    D.insert gate.name gate state

{-- Update state with network information --}
updateState : State -> [String] -> State
updateState state netNames =
    foldl (updateGate) state netNames

updateGate : String -> State -> State
updateGate gateName state = 
    let 
        gateToSim = D.getOrFail gateName state
        simulatedGate = simGate gateToSim state

        stateMinusGate = D.remove gateName state
    in
        addGate stateMinusGate simulatedGate

simGate : Gate -> State -> Gate
simGate gate state = 
    if | gate.gateType == NormalGate -> simNormalGate gate state
       | gate.gateType == InputGate -> gate -- TODO
       | gate.gateType == OutputGate -> simOutputGate gate state

-- Simulate a non-input, non-output gate 
-- (e.g. AND, OR, XOR, etc.)
simNormalGate : Gate -> State -> Gate
simNormalGate gate state = 
    let
        logicFunction = gate.logic

        inputNames = gate.inputs
        input1Name = A.getOrFail 0 inputNames
        input2Name = A.getOrFail 1 inputNames

        input1Gate = D.getOrFail input1Name state
        input2Gate = D.getOrFail input2Name state

        input1Status = input1Gate.status
        input2Status = input2Gate.status

        -- run the logic function on inputs
        result = logicFunction input1Status input2Status
    in
        { gate | status <- (log "simNormalGate result" result) } 

-- "Simulate" an output gate (get value of connected gate)
simOutputGate : Gate -> State -> Gate
simOutputGate gate state = 
    let
        inputNames = gate.inputs
        inputName = A.getOrFail 0 inputNames
        inputGate = D.getOrFail inputName state
        inputStatus = inputGate.status
    in
        { gate | status <- (log "simOutputGate result" inputStatus) }


{-- Debugging --}
getStatusBool : [(String,Gate)] -> [(String,Bool)]
getStatusBool stateList = 
    map getStatusOnly stateList

getStatusOnly : (String, Gate) -> (String,Bool)
getStatusOnly (name,gate) = 
    let 
        status = gate.status
    in
        (name,status)