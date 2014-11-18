module TestRunner where

import Dict as D
import Gates (..)
import State (..)

andGate : Gate
andGate = {
      name = "testingAndGate"
    , status = False
    , inputs = ["a"]
    , outputs = ["b"]
    , logic = "No AND logic yet"
    }

updateFunc : Maybe Bool -> Maybe Bool
updateFunc currentVal = currentVal

startState : D.Dict String Bool
startState = emptyState

nextState = addGate startState andGate
main = 
    let 
        initialGate = andGate
        initialState = startState
    in
        flow down [
            asText initialGate
        ,  asText initialState
        ,  asText nextState
        ]