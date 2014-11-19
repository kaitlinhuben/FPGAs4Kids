{--
    Stores information for circuit state
--}
module State where

import Dict as D
import Array as A
import Gates (..)

type Network = [Gate]

type State = D.Dict String Bool

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
    D.insert gate.name gate.status state

{-- Update state with network information --}
updateState : State -> Network -> State
updateState state network =
    foldl (updateGate) state network

updateGate : Gate -> State -> State
updateGate gate state = 
    let
        gateName = gate.name
        oldStatus = gate.status
        evaluatedGate = simulateGate gate state
        newStatus = evaluatedGate.status
        removedState = D.remove gateName oldStatus state
    in 
        addGate removedState evaluatedGate

updateValue : Maybe a -> Maybe a
updateValue val = val

simulateGate : Gate -> State -> Gate
simulateGate gate state = 
    if | gate.gateType == NormalGate -> gate
       | gate.gateType == InputGate -> gate
       | gate.gateType == OutputGate -> gate