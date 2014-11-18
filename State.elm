module State where

import Dict as D
import Array as A
import Gates (..)

emptyState : D.Dict String Bool
emptyState = D.empty 

initState : D.Dict String Bool -> [Gate] -> D.Dict String Bool
initState state network = 
    case network of 
        [] -> state
        hd :: [] -> addGate state hd
        hd :: tl -> 
            let
                statePlusHd = addGate state hd 
            in
                initState statePlusHd tl

addGate : D.Dict String Bool -> Gate -> D.Dict String Bool
addGate state gate = 
    D.insert gate.name gate.status state