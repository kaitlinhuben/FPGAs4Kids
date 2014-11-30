{--
    Stores information for circuit state
--}
module StateInfo where

import Dict as D
import Array as A
import Graphics.Input as I
import Gates (..)

{----------------------------------------------------------
    Meta game information 
----------------------------------------------------------}
type GameInput = {
    timeDelta : Float
  , userInput : UserInput
  }
type UserInput = {
    mousePos : (Int, Int)
  , inputBools : D.Dict String Bool
  }

data GameMode = Game | Schematic

type GameState = {
    networkNames : [String]
  , inputNames : [String]
  , circuitState : CircuitState
  , gameMode : GameMode
  , mousePos : (Int, Int)
  , userInputBools : D.Dict String Bool
  , inputSignals : I.Input Bool
  }

{----------------------------------------------------------
    Circuit information 
----------------------------------------------------------}
type CircuitState = D.Dict String Gate

-- Recursively initialize circuit state given array of gates
initCircuitState : CircuitState -> [Gate] -> CircuitState
initCircuitState state network = 
    case network of 
        -- if empty, return state as-is
        [] -> state

        -- if single gate, insert (name,gate) into state
        gate :: [] -> D.insert gate.name gate state

        -- if more than one gate, insert (name,gate) into state
        -- and then call again on the tail
        gate :: tl -> 
            let
                statePlusGate = D.insert gate.name gate state
            in
                initCircuitState statePlusGate tl

-- Update state with network information
updateGameState : GameState -> GameState
updateGameState gameState = 
    let
        -- first, update circuit with user inputs
        circuitState = gameState.circuitState
        inputNames = gameState.inputNames
        userInputBools = gameState.userInputBools
        circuitStateUpdatedInputs = updateInputs circuitState inputNames userInputBools

        -- next, simulate the circuit with updated user inputs
        netNames = gameState.networkNames
        simulatedCircuitState = foldl (updateGate) circuitStateUpdatedInputs netNames
    in
        { gameState | circuitState <- simulatedCircuitState }

-- Update inputs with userInputBools
updateInputs : CircuitState -> [String] -> D.Dict String Bool -> CircuitState
updateInputs state inputNames userInputBools = 
    case inputNames of 
        -- if empty, return state as-is
        [] -> state

        -- if a single input, update that input
        name :: [] -> updateStateWithInput state name userInputBools
            
        -- if more than single input, update that input and call on tail
        name :: tl ->
            let
                updatedState = updateStateWithInput state name userInputBools
            in
                updateInputs updatedState tl userInputBools

-- Update circuit state with single input change
updateStateWithInput : CircuitState -> String -> D.Dict String Bool -> CircuitState
updateStateWithInput state name userInputBools = 
    let
        inputStatus = D.getOrFail name userInputBools
        inputGate = D.getOrFail name state
        updatedInputGate = { inputGate | status <- inputStatus }
        stateMinusInput = D.remove name state
    in
        D.insert name updatedInputGate stateMinusInput

-- Update a single gate in the CircuitState
updateGate : String -> CircuitState -> CircuitState
updateGate gateName state = 
    let 
        -- get the gate to simulate
        gateToSim = D.getOrFail gateName state
        -- simulate the gate
        simulatedGate = simGate gateToSim state 
        -- take the old (name,gate) entry out
        stateMinusGate = D.remove gateName state
    in
        -- replace with (name, newGate) entry
        D.insert simulatedGate.name simulatedGate stateMinusGate

-- Simulate a single gate: decide which simulation function to use
simGate : Gate -> CircuitState -> Gate
simGate gate state = 
    if | gate.gateType == NormalGate -> simNormalGate gate state
       | gate.gateType == InputGate -> gate -- this should already be updated
       | gate.gateType == OutputGate -> simOutputGate gate state

-- Simulate a non-input, non-output gate (e.g. AND, OR, XOR, etc.)
simNormalGate : Gate -> CircuitState -> Gate
simNormalGate gate state = 
    let
        -- get the logic function for the gate (e.g. xor)
        logicFunction = gate.logic

        -- get the names of the inputs to this gate
        inputNames = gate.inputs
        input1Name = A.getOrFail 0 inputNames
        input2Name = A.getOrFail 1 inputNames

        -- get the actual gates that are inputs to this gate
        input1Gate = D.getOrFail input1Name state
        input2Gate = D.getOrFail input2Name state

        -- get the status of the input gates
        input1Status = input1Gate.status
        input2Status = input2Gate.status

        -- run the logic function on inputs
        result = logicFunction input1Status input2Status
    in
        -- update the gate with its simulated result
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


{----------------------------------------------------------
    Debugging
----------------------------------------------------------}
getStatusBool : [(String,Gate)] -> [(String,Bool)]
getStatusBool stateList = 
    map getStatusOnly stateList

getStatusOnly : (String, Gate) -> (String,Bool)
getStatusOnly (name,gate) = 
    let 
        status = gate.status
    in
        (name,status)