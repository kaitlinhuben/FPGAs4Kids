{--
    Stores information for circuit state
--}
module StateInfo where

import Dict as D
import Array as A
import Gates (..)

{-- Meta game information --}
type GameInput = {
    timeDelta : Float
  , userInput : UserInput
  }
type UserInput = {
    mousePos : (Int, Int)
  }

data GameMode = Game | Schematic

type GameState = {
    networkNames : [String]
  , initialNetwork : Network 
  , circuitState : CircuitState
  , gameMode : GameMode
  , mousePos : (Int, Int)
  }

{-- Circuit information --}
type Network = [Gate]

type CircuitState = D.Dict String Gate

emptyCircuitState : CircuitState
emptyCircuitState = D.empty 

initCircuitState : CircuitState -> Network -> CircuitState
initCircuitState state network = 
    case network of 
        [] -> state
        hd :: [] -> addGate state hd
        hd :: tl -> 
            let
                statePlusHd = addGate state hd 
            in
                initCircuitState statePlusHd tl

addGate : CircuitState -> Gate -> CircuitState
addGate state gate = 
    D.insert gate.name gate state

{-- Update state with network information --}
updateGameState : GameState -> GameState
updateGameState gameState = 
    let
        netNames = gameState.networkNames
        cs = gameState.circuitState
        newCircuitState = updateCircuitState cs netNames
    in
        { gameState | circuitState <- newCircuitState}

updateCircuitState : CircuitState -> [String] -> CircuitState
updateCircuitState state netNames =
    foldl (updateGate) state netNames

updateGate : String -> CircuitState -> CircuitState
updateGate gateName state = 
    let 
        gateToSim = D.getOrFail gateName state
        simulatedGate = simGate gateToSim state

        stateMinusGate = D.remove gateName state
    in
        addGate stateMinusGate simulatedGate

simGate : Gate -> CircuitState -> Gate
simGate gate state = 
    if | gate.gateType == NormalGate -> simNormalGate gate state
       | gate.gateType == InputGate -> gate -- TODO
       | gate.gateType == OutputGate -> simOutputGate gate state

-- Simulate a non-input, non-output gate 
-- (e.g. AND, OR, XOR, etc.)
simNormalGate : Gate -> CircuitState -> Gate
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
        { gate | status <- result } 

-- "Simulate" an output gate (get value of connected gate)
simOutputGate : Gate -> CircuitState -> Gate
simOutputGate gate state = 
    let
        inputNames = gate.inputs
        inputName = A.getOrFail 0 inputNames
        inputGate = D.getOrFail inputName state
        inputStatus = inputGate.status
    in
        { gate | status <- inputStatus }


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