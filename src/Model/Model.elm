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
type alias InputJSON = { 
    name: String
  , gateType: String
  , status: Bool
  , inputs: Array.Array String
  , logic: String
  , location: (Float, Float)
  , imgSize: (Int, Int)
  }
type alias MiscInputJSON = {
    solution: List (String, Bool)
  , nextLink: String
  , par: Int
  }

type alias UserInput = {
    inputBools : Dict.Dict String Bool
  }

type GameMode = Game | Schematic

type alias GameState = {
    networkNames : List String
  , inputNames : List String
  , nonInputNames : List String
  , solution : Dict.Dict String Bool
  , circuitState : CircuitState
  , gameMode : GameMode
  , mousePos : (Int, Int)
  , inputStatuses : InputsState
  , inputChannels : Dict.Dict String (Channel Bool)
  , clicks : Int
  , completed : Bool
  , nextLink : String
  , clicksPar : Int
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

failedChannel : Channel Bool
failedChannel = channel False

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
imgPath = "../assets/img/"

inputOnName : String
inputOnName = imgPath ++ "switch-on.png"

inputOffName : String
inputOffName = imgPath ++ "switch-off.png"

andImageName : String
andImageName = imgPath ++ "and-schematic-filled.png"

orImageName : String
orImageName = imgPath ++ "or-schematic-filled.png"

notImageName : String
notImageName = imgPath ++ "not-schematic-filled.png"

outputOnName : String
outputOnName = imgPath ++ "light-on.png"

outputOffName : String
outputOffName = imgPath ++ "light-off.png"

outputGoodName: String
outputGoodName = imgPath ++ "output-good.png"

outputBadName : String
outputBadName = imgPath ++ "output-bad.png"

restartName : String
restartName = imgPath ++ "restart.png"

nextLevelBtn : String
nextLevelBtn = imgPath ++ "next-level.png"

nextLevelNotYetBtn : String
nextLevelNotYetBtn = imgPath ++ "next-level-not-yet.png"

solutionSize : (Int, Int)
solutionSize = (25,25)