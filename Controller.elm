{--
    Contains logic to run everything
--}
module Controller where

import Debug (..)
import Window
import Model (..)
import CircuitFunctions (..)
import View (..)

-- Every time the page refreshes, gather needed inputs and update game state
stepGame : GameInput -> GameState -> GameState
stepGame gameInput gameState = 
    let
        ui = gameInput.userInput
        inputs = ui.inputBools
        gameStateWithInputs = { gameState | userInputBools <- inputs}
        updatedGameState = updateGameState gameStateWithInputs

        newMousePos = ui.mousePos
    in 
        { updatedGameState | mousePos <- newMousePos }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 1) --TODO change to 25

-- At the fps rate in delta, pick up user input
gatherInput : Signal UserInput -> Signal GameInput
gatherInput userInput = 
  sampleOn delta (lift2 GameInput delta userInput)

-- Updates the game state given the user input
foldGame : GameState -> Signal UserInput -> Signal GameState
foldGame game userInput = 
  foldp stepGame game (gatherInput userInput)

-- Driver
mainDriver : GameState -> Signal UserInput -> Signal Element
mainDriver game userInput = 
  display <~ Window.dimensions ~ (foldGame game userInput)