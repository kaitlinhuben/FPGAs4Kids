module Level_1 where

import Mouse
import Dict as D
import Array as A
import Graphics.Input as I
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
gates : [Gate]
gates = [inputGate, notGate, outputGate]

-- set up all Inputs
inputBool : I.Input Bool 
inputBool = I.input inputGate.status

-- set up pre-dicts
inputSignalsPreDict : [ (String, I.Input Bool) ]
inputSignalsPreDict = [ ("inputGate", inputBool) ]

-- lift input signals into user input
userInputs : Signal (D.Dict String Bool)
userInputs = liftToDict <~ inputBool.signal

liftToDict : Bool -> D.Dict String Bool
liftToDict bool = D.insert "inputGate" bool D.empty

-- lift mouse position and all input signals into UserInput
userInput : Signal UserInput
userInput = UserInput <~ Mouse.position ~ userInputs

-- put everything into initial GameState
gameState : GameState
gameState = instantiateGameState gates inputSignalsPreDict

main : Signal Element
main = mainDriver gameState userInput