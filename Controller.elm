{--
  Controller.elm
  Updates GameState based on inputs
--}
module Controller where

import Window
import Model_Types (..)
import View (..)

{---------------------------------------------------------- 
  Game processing 
----------------------------------------------------------}
updateGates : [Gate] -> SpinDirection -> [Gate]
updateGates gates spinDir = 
  case gates of 
    [] -> []
    only :: [] -> 
      let td = if | spinDir == CW -> -1/25
                         | spinDir == CCW -> 1/25
                         | otherwise -> 0
      in
        [{ only | spinning <- spinDir 
                , timeDelta <- only.timeDelta + td}]
    first :: rest -> 
      let
        newFirst = { first | spinning <- spinDir }
        newRest = updateGates rest spinDir
      in 
        newFirst :: newRest

-- Changes the game at each fps step
stepGame : GameInput -> GameState -> GameState
stepGame gameInput gameState = 
  let
    oldGates = gameState.gates
    newGates = updateGates oldGates None
    newMode = gameInput.userInput.display
  in
    { gameState | gates <- newGates
                , displayMode <- newMode }

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
  display <~ Window.dimensions ~ userInput ~ (foldGame game userInput)