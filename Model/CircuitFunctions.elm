{--
    Functions for creating and simulating circuits
--}
module Model.CircuitFunctions where

import Dict
import Array
import List
import Maybe (withDefault)
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
        simulatedCircuitState = List.foldl (updateGate) circuitStateUpdatedInputs netNames
    in
        { gameState | circuitState <- simulatedCircuitState }

{------------------------------------------------------------------------------
    Recursively update CircuitState with new input statuses
------------------------------------------------------------------------------}
updateInputs : CircuitState -> List String -> InputsState -> CircuitState
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
updateStateWithInput : CircuitState -> String -> InputsState -> CircuitState
updateStateWithInput state name inputStatuses = 
    let
        inputStatus = withDefault False (Dict.get name inputStatuses)
        inputGate = getGate name state
        updatedInputGate = { inputGate | status <- inputStatus }
        stateMinusInput = Dict.remove name state
    in
        Dict.insert name updatedInputGate stateMinusInput

{------------------------------------------------------------------------------
    Update a gate in CircuitState by simulating it
------------------------------------------------------------------------------}
updateGate : String -> CircuitState -> CircuitState
updateGate gateName state = 
    let 
        -- get the gate to simulate
        gateToSim = getGate gateName state
        -- simulate the gate
        simulatedGate = simGate gateToSim state
        -- update image for gate
        simGateWithImg = if | simulatedGate.status == True -> 
                                { simulatedGate | imgName <- simulatedGate.imgOnName }
                            | otherwise -> 
                                { simulatedGate | imgName <- simulatedGate.imgOffName }
        -- take the old (name,gate) entry out
        stateMinusGate = Dict.remove gateName state
    in
        -- replace with (name, newGate) entry
        Dict.insert simulatedGate.name simGateWithImg stateMinusGate

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
    if | Array.length gate.inputs == 1 -> simNotGate gate state
       | otherwise ->
        let
            -- get the logic function for the gate (e.g. xor)
            logicFunction = gate.logic

            -- get the names of the inputs to this gate
            inputNames = gate.inputs
            input1Name = getGateName 0 inputNames
            input2Name = getGateName 1 inputNames

            -- get the actual gates that are inputs to this gate
            input1Gate = getGate input1Name state
            input2Gate = getGate input2Name state

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
        input1Name = getGateName 0 inputNames
        input1Gate = getGate input1Name state
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
        inputName = getGateName 0 inputNames
        inputGate = getGate inputName state
        inputStatus = inputGate.status
    in
        { gate | status <- inputStatus }