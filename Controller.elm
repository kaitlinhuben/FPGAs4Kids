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

{-------------------------------------------------}
type UserInput = { mousePos:(Float,Float)}

userInput : Signal UserInput
userInput = constant { mousePos=(0,0) }

type GameInput = { timeDelta:Float, userInput:UserInput }
{-------------------------------------------------}

stepGame : GameInput -> GameState -> GameState
stepGame {timeDelta, userInput} gameState = 
  let
    oldGates = gameState.gates
    newGates = updateGates oldGates CW
  in
    { gameState | gates <- newGates }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- Driver
mainDriver : (GameInput -> GameState -> GameState) -> GameState -> Signal Element
mainDriver step game = 
  let 
    gameInput = sampleOn delta (lift2 GameInput delta userInput)
  in
    lift2 display Window.dimensions (foldp step game gameInput)