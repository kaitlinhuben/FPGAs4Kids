{--
    Stores data, types, and methods for gates
--}
module Gates where

import Array as A

data GateType = InputGate | NormalGate | OutputGate | DebugGate

type Gate = {
      name : String
    , gateType : GateType
    , status : Bool
    , inputs : A.Array String
    , logic : Bool -> Bool -> Bool
  }

-- Debugging gate --
debugGate = {
      name = "debugGate"
    , gateType = DebugGate
    , status = False
    , inputs = A.fromList []
    , logic = inputLogic
  }

-- Logic functions for gates
andLogic : Bool -> Bool -> Bool
andLogic input1 input2 = 
    input1 && input2

inputLogic : Bool -> Bool -> Bool
inputLogic input1 input2 = 
    input1

outputLogic : Bool -> Bool -> Bool
outputLogic input1 input2 = 
    input1