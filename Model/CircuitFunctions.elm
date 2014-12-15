{--
    Functions for creating and simulating circuits
--}
module Model.CircuitFunctions where

import Dict as D
import Array as A
import Graphics.Input as I
import Model.Model (..)

{------------------------------------------------------------------------------
    Update GameState by pulling statuses and updating/simulating circuit
    (note that user inputs must have already been updated in GameState)
------------------------------------------------------------------------------}
updateGameState : GameState -> GameState
updateGameState gameState = 
    let
        -- first, update circuit with user inputs
        circuitState = gameState.circuitState
        inputNames = gameState.inputNames
        inputStatuses = gameState.inputStatuses
        circuitStateUpdatedInputs = updateInputs circuitState inputNames inputStatuses

        -- next, simulate the circuit with updated user inputs
        netNames = gameState.networkNames
        simulatedCircuitState = foldl (updateGate) circuitStateUpdatedInputs netNames
    in
        { gameState | circuitState <- simulatedCircuitState }

{------------------------------------------------------------------------------
    Recursively update CircuitState with new input statuses
------------------------------------------------------------------------------}
updateInputs : CircuitState -> [String] -> D.Dict String Bool -> CircuitState
updateInputs state inputNames inputStatuses = 
    case inputNames of 
        -- if empty, return state as-is
        [] -> state

        -- if a single input, update that input
        name :: [] -> updateStateWithInput state name inputStatuses
            
        -- if more than single input, update that input and call on tail
        name :: tl ->
            let
                updatedState = updateStateWithInput state name inputStatuses
            in
                updateInputs updatedState tl inputStatuses

-- helper function: update CircuitState with single input status
updateStateWithInput : CircuitState -> String -> D.Dict String Bool -> CircuitState
updateStateWithInput state name inputStatuses = 
    let
        inputStatus = D.getOrFail name inputStatuses
        inputGate = D.getOrFail name state
        updatedInputGate = { inputGate | status <- inputStatus }
        stateMinusInput = D.remove name state
    in
        D.insert name updatedInputGate stateMinusInput

{------------------------------------------------------------------------------
    Update a gate in CircuitState by simulating it
------------------------------------------------------------------------------}
updateGate : String -> CircuitState -> CircuitState
updateGate gateName state = 
    let 
        -- get the gate to simulate
        gateToSim = D.getOrFail gateName state
        -- simulate the gate
        simulatedGate = simGate gateToSim state
        -- update image for gate
        simGateWithImg = if | simulatedGate.status == True -> 
                                { simulatedGate | imgName <- simulatedGate.imgOnName }
                            | otherwise -> 
                                { simulatedGate | imgName <- simulatedGate.imgOffName }
        -- take the old (name,gate) entry out
        stateMinusGate = D.remove gateName state
    in
        -- replace with (name, newGate) entry
        D.insert simulatedGate.name simGateWithImg stateMinusGate

{------------------------------------------------------------------------------
    Gate simulation functions
------------------------------------------------------------------------------}
-- figure out which kind of gate we're updating
simGate : Gate -> CircuitState -> Gate
simGate gate state = 
    if | gate.gateType == NormalGate -> simNormalGate gate state
       | gate.gateType == InputGate -> gate -- this should already be updated
       | gate.gateType == OutputGate -> simOutputGate gate state

-- Simulate a non-input, non-output gate (e.g. AND, OR, XOR, etc.)
simNormalGate : Gate -> CircuitState -> Gate
simNormalGate gate state = 
    if | A.length gate.inputs == 1 -> simNotGate gate state
       | otherwise ->
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

-- NOT must be simulated separately because only one input
simNotGate : Gate -> CircuitState -> Gate
simNotGate gate state = 
    let
        -- get logic function
        logicFunction = gate.logic

        inputNames = gate.inputs
        input1Name = A.getOrFail 0 inputNames
        input1Gate = D.getOrFail input1Name state
        input1Status = input1Gate.status

        result = logicFunction input1Status input1Status
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