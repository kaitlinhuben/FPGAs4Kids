{--
    Contains all functions to render information
--}
module View where 

import Debug (..)
import Dict as D
import Graphics.Input as I
import Model (..)

-- Display the entire page
display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
    let
        circuitElement = drawCircuit (w,h) gameState
        everything = 
            flow down [
              asText gameState.mousePos
            , plainText " "
            , circuitElement
            ]
    in
        container w h middle everything
    
-- Draw the circuit and put it in an element
drawCircuit : (Int,Int) -> GameState -> Element
drawCircuit (w,h) gs = 
  let 
    inputsElement = 
      collage w h (drawInputGates gs.inputNames gs)

    everythingElseElement = 
      collage w h (map drawGate (D.values gs.circuitState))
  in
    layers [everythingElseElement, inputsElement]

-- Draw a single gate
drawGate : Gate -> Form
drawGate gate = 
  if | gate.gateType == InputGate -> toForm (plainText "") --drawn separately
     | otherwise ->
        let
          element = flow down 
                    [ plainText gate.name
                    , asText gate.status
                    ]
          fillColor = if | gate.status == True -> green
                         | gate.status == False -> lightGrey

          coloredElement = color fillColor element
        in 
          move gate.location (toForm coloredElement)

-- Recursively draw all input gates
drawInputGates : [String] -> GameState -> [Form]
drawInputGates inputNames gs = 
  case inputNames of 
    [] -> []
    name :: [] -> [drawInputGate name gs]
    name :: tl -> 
      let
        gateForm = drawInputGate name gs
        tlForms = drawInputGates tl gs
      in
        gateForm :: tlForms

-- Draw a single input gate
drawInputGate : String -> GameState -> Form
drawInputGate name gs = 
  let
    -- get the gate
    gate = D.getOrFail name gs.circuitState
    -- get the input associated with the gate
    gateInput = D.getOrFail name gs.inputSignals
    -- set up the checkbox 
    gateCheckbox = I.checkbox gateInput.handle identity (D.getOrFail name gs.userInputBools)
    
    element = flow down 
              [ plainText name
              , gateCheckbox
              , asText gate.status
              ]

    fillColor = if | gate.status == True -> green
                   | gate.status == False -> lightGrey

    coloredElement = color fillColor element
  in 
    move gate.location (toForm coloredElement)