{--
    Stores type, type aliass, and basic functions for gates, circuit, and game state
--}
module Model.Model where

import Array
import Dict
import Maybe (withDefault)
import Signal (Channel, channel)

{------------------------------------------------------------------------------
    Game and circuit type and type aliases
------------------------------------------------------------------------------}
type alias GameInput = {
    timeDelta : Float
  , userInput : UserInput
  }
type alias UserInput = {
    mousePos : (Int, Int)
  , inputBools : Dict.Dict String Bool
  }

type GameMode = Game | Schematic

type alias GameState = {
    networkNames : List String
  , inputNames : List String
  , nonInputNames : List String
  , circuitState : CircuitState
  , gameMode : GameMode
  , mousePos : (Int, Int)
  , inputStatuses : InputsState
  , inputChannels : Dict.Dict String (Channel Bool)
  }

type alias CircuitState = Dict.Dict String Gate

type alias InputsState = Dict.Dict String Bool

{------------------------------------------------------------------------------
    Gate type, type aliases, and functions
------------------------------------------------------------------------------}
type GateType = InputGate | NormalGate | OutputGate

type alias Gate = {
      name : String
    , gateType : GateType
    , status : Bool
    , inputs : Array.Array String
    , logic : Bool -> Bool -> Bool
    , location : (Float, Float)
    , imgName : String
    , imgOnName : String
    , imgOffName : String
    , imgSize : (Int,Int)
  }

{------------------------------------------------------------------------------
    Safe get methods and dummies
------------------------------------------------------------------------------}
getGate : String -> CircuitState -> Gate
getGate name state = withDefault failedGetGate (Dict.get name state)
failedGetGate : Gate
failedGetGate = {
      name = "failedGetGate"
    , gateType = InputGate
    , status = False
    , inputs = Array.empty
    , logic = inputLogic
    , location = (0, 0)
    , imgName = ""
    , imgOnName = ""
    , imgOffName = ""
    , imgSize = (0,0)
  }

getGateName : Int -> Array.Array String -> String
getGateName index names = withDefault "failedGetGate" (Array.get index names)

failedSignal : Channel Bool
failedSignal = channel False

{------------------------------------------------------------------------------
    Logic functions
------------------------------------------------------------------------------}
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
    Paths to images
------------------------------------------------------------------------------}
imgPath : String
imgPath = "assets/img/"

inputOnName : String
inputOnName = imgPath ++ "input-on.png"

inputOffName : String
inputOffName = imgPath ++ "input-off.png"

andImageName : String
andImageName = imgPath ++ "and-schematic-filled.png"

orImageName : String
orImageName = imgPath ++ "or-schematic-filled.png"

notImageName : String
notImageName = imgPath ++ "not-schematic-filled.png"

outputOnName : String
outputOnName = imgPath ++ "output-on.png"

outputOffName : String
outputOffName = imgPath ++ "output-off.png"