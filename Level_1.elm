module Level_1 where

import Mouse
import Dict as D
import Array as A
import Graphics.Input as I
import Signal
import Graphics.Element (..)
import Model.Model (..)
import Model.CircuitFunctions (..)
import Controller.Controller (..)
import Controller.InstantiationHelper (..)

-- Set up gates
inputGate : Gate
inputGate = {
      name = "inputGate"
    , gateType = InputGate
    , status = True
    , inputs = A.empty
    , logic = inputLogic
    , location = (-100,0)
    , imgName = inputOnName
    , imgOnName = inputOnName
    , imgOffName = inputOffName
    , imgSize = (75,75)
  }

notGate : Gate
notGate = {
      name = "notGate"
    , gateType = NormalGate
    , status = False
    , inputs = A.fromList ["inputGate"]
    , logic = notLogic
    , location = (0,0)
    , imgName = notImageName
    , imgOnName = notImageName
    , imgOffName = notImageName
    , imgSize = (75,75)
  }

outputGate : Gate
outputGate = {
      name = "outputGate"
    , gateType = OutputGate
    , status = False
    , inputs = A.fromList ["notGate"]
    , logic = inputLogic
    , location = (100,0)
    , imgName = outputOffName
    , imgOnName = outputOnName
    , imgOffName = outputOffName
    , imgSize = (75,75)
  }

-- set up array of gates in correct order
gates : List Gate
gates = [inputGate, notGate, outputGate]

-- set up all Inputs
inputBool : Signal.Channel Bool 
inputBool = Signal.channel inputGate.status

-- set up pre-dicts
inputSignalsPreDict : List (String, Signal.Channel Bool)
inputSignalsPreDict = [ ("inputGate", inputBool) ]

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict

-- lift input signals into user input
userInputs : Signal (D.Dict String Bool)
userInputs = Signal.map liftToDict (Signal.subscribe inputBool)

liftToDict : Bool -> D.Dict String Bool
liftToDict bool = D.insert "inputGate" bool D.empty

-- lift mouse position and all input signals into UserInput
userInput : Signal UserInput
userInput = Signal.map2 UserInput Mouse.position userInputs


-- Run main
main : Signal Element
main = mainDriver gameState userInput