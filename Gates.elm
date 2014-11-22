{--
    Stores data, types, and methods for gates
--}
module Gates where

import Array as A

data GateType = InputGate | NormalGate | OutputGate

type Gate = {
      name : String
    , gateType : GateType
    , status : Bool
    , inputs : A.Array String
    , logic : Bool -> Bool -> Bool
  }

-- Logic functions for gates
inputLogic : Bool -> Bool -> Bool
inputLogic input mockInput = input

outputLogic : Bool -> Bool -> Bool
outputLogic input mockInput = input

andLogic : Bool -> Bool -> Bool
andLogic input1 input2 = input1 && input2

orLogic : Bool -> Bool -> Bool
orLogic input1 input2 = input1 || input2

xorLogic : Bool -> Bool -> Bool
xorLogic input1 input2 = xor input1 input2

notLogic : Bool -> Bool -> Bool
notLogic input mockInput = not input

nandLogic : Bool -> Bool -> Bool
nandLogic input1 input2 = not (input1 && input2)

norLogic : Bool -> Bool -> Bool
norLogic input1 input2 = not (input1 || input2)
