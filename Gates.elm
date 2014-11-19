{--
    Stores data, types, and methods for gates
--}
module Gates where

data GateType = InputGate | NormalGate | OutputGate

type Gate = {
      name : String
    , gateType : GateType
    , status : Bool
    , inputs : [String]
    , outputs : [String]
    , logic : Bool -> Bool -> Bool
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