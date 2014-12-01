{--
    Stores data, types, and basic functions for gates, circuit, and game state
--}
module Model where

import Array as A
import Dict as D
import Graphics.Input as I

{------------------------------------------------------------------------------
    Gate data, types, and functions
------------------------------------------------------------------------------}
data GateType = InputGate | NormalGate | OutputGate

type Gate = {
      name : String
    , gateType : GateType
    , status : Bool
    , inputs : A.Array String
    , logic : Bool -> Bool -> Bool
    , location : (Float, Float)
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

{------------------------------------------------------------------------------
    Game and circuit data and types
------------------------------------------------------------------------------}
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
  , inputSignals : D.Dict String (I.Input Bool)
  }

type CircuitState = D.Dict String Gate