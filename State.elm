{--
    Stores information for circuit state
--}
module State where

import Dict as D
import Array as A
import Gates (..)

type State = D.Dict String Bool

emptyState : State
emptyState = D.empty 

initState : State -> [Gate] -> State
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