{--
    Contains logic to run everything
--}
module Controller where

import Window
import StateInfo (..)
import View (..)

stepGame : GameInput -> GameState -> GameState
stepGame gameInput gameState = 
    let
        ui = gameInput.userInput
        newMousePos = ui.mousePos
    in 
        { gameState | mousePos <- newMousePos}

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- To pick up user input
gatherInput : Signal UserInput -> Signal GameInput
gatherInput userInput = 
  sampleOn delta (lift2 GameInput delta userInput)

-- Updates the game state
foldGame : GameState -> Signal UserInput -> Signal GameState
foldGame game userInput = 
  foldp stepGame game (gatherInput userInput)

-- Driver
mainDriver : GameState -> Signal UserInput -> Signal Element
mainDriver game userInput = 
  display <~ Window.dimensions ~ (foldGame game userInput)