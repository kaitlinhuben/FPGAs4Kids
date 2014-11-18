module State where

import Dict as D
import Gates (..)

emptyState : D.Dict String Bool
emptyState = D.empty 

addGate : D.Dict String Bool -> Gate -> D.Dict String Bool
addGate state gate = 
    D.insert gate.name gate.status state