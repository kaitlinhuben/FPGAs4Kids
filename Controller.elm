{--
  Controller.elm
  Updates GameState based on inputs
--}
module Controller where

import Window
import Mouse
import Graphics.Element as Element
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
  in
    { gameState | gates <- newGates }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- To pick up user input
gatherInput : Signal UserInput -> Signal GameInput
gatherInput userIn = sampleOn delta (lift2 GameInput delta userIn)

-- Updates the game state
foldGame : GameState -> Signal UserInput -> Signal GameState
foldGame game userIn = foldp stepGame game (gatherInput userIn)

-- Driver
mainDriver : GameState -> Signal UserInput -> Signal Element
mainDriver game userIn = lift2 display Window.dimensions (foldGame game userIn)