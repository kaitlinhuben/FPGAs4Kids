{--
    Contains logic to run everything
--}
module Controller.Controller where

import Window
import Signal
import Time (fps)
import Graphics.Element (Element)
import Model.Model (..)
import Model.CircuitFunctions (..)
import View.View (..)

-- Every time the page refreshes, gather needed inputs and update game state
stepGame : UserInput -> GameState -> GameState
stepGame userInput gameState = 
    let
        -- get the user's choices for inputs
        inputs = userInput.inputBools

        -- update game state with user's inputs
        gameStateWithInputs = { gameState | inputStatuses <- inputs}

        -- update game state by simulating everything
        updatedGameState = updateGameState gameStateWithInputs

        -- grab the new mouse position and clicks
        newMousePos = userInput.mousePos
        newMouseClicks = userInput.mouseClicks
    in 
        { updatedGameState | mousePos <- newMousePos
                            ,clicks <- newMouseClicks }

{-----If ever wanted animation ("physics", use this) 
 -----Would also need to change stepGame to take GameInput instead of UserInput
-- For physics
delta : Signal Float
delta = Signal.map (\t -> t / 20) (fps 25)

-- At the fps rate in delta, pick up user input
gatherInput : Signal UserInput -> Signal GameInput
gatherInput userInput = 
  Signal.sampleOn delta (Signal.map2 GameInput delta userInput)

You would also need to add this to Model.Model:
  type alias GameInput = {
    timeDelta : Float
  , userInput : UserInput
  }
--}

-- Only update when inputs change
gatherInput : Signal UserInput -> Signal UserInput
gatherInput userInput = 
  Signal.sampleOn userInput userInput

-- Updates the game state given the user input
foldGame : GameState -> Signal UserInput -> Signal GameState
foldGame game userInput = 
  Signal.foldp stepGame game (gatherInput userInput)

-- Driver
mainDriver : GameState -> Signal UserInput -> Signal Element
mainDriver game userInput = 
  Signal.map2 display Window.dimensions (foldGame game userInput)