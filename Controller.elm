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
-- Update a single gate
updateGate : Gate -> Mode -> Gate
updateGate gate m = 
  let
    newImg = if | m == Game -> gate.gameImg
                | m == Schematic -> gate.schematicImg
  in
    { gate | img <- newImg }

-- Update an array of gates
updateGates : [Gate] -> Mode -> [Gate]
updateGates gates m = 
  case gates of 
    -- if empty array, return empty
    [] -> []

    -- if one element in array, update that element
    hd :: [] ->
      let
        newHd = updateGate hd m
      in
        newHd :: []

    -- if more than one element in array, update head element and tail array
    hd :: tl ->
      let 
        newHd = updateGate hd m
        newTl = updateGates tl m
      in
        newHd :: newTl

-- Changes the game at each fps step
stepGame : GameInput -> GameState -> GameState
stepGame gameInput gameState = 
  let
    -- extract user input from game input
    ui = gameInput.userInput 

    -- figure out which mode we're in
    newMode = ui.display

    -- update gates
    oldGates = gameState.gates
    newGates = updateGates oldGates newMode

    -- get mouse position
    newMousePos = ui.mousePos
    
  -- update game state
  in
    { gameState | gates <- newGates
                , displayMode <- newMode
                , mousePos <- newMousePos }

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