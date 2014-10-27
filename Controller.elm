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

stepGame : (Float, (Int, Int), SpinDirection) -> GameState -> GameState
stepGame (time, pos, spinDir) gameState =  
  let
    oldGates = gameState.gates
    newGates = updateGates oldGates spinDir
  in
    { gameState | mousePos <- pos 
                , gates <- newGates }

-- For physics
delta : Signal Float
delta = lift (\t -> t / 20) (fps 25)

-- Driver
mainDriver : ((Float, (Int, Int), SpinDirection) -> GameState -> GameState) -> GameState -> Signal SpinDirection -> Signal Element
mainDriver step game inputSignal= 
  let 
    gameInput = sampleOn delta (lift3 (,,) delta Mouse.position inputSignal)
  in
    lift2 display Window.dimensions (foldp step game gameInput)