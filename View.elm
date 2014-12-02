{--
    Contains all functions to render information
--}
module View where 

import Debug (..)
import Array as A
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
    netsElement = 
      collage w h (drawAllNets gs.networkNames gs)

    inputsElement = 
      collage w h (drawInputGates gs.inputNames gs)

    otherGatesElement = 
      collage w h (map drawGate (D.values gs.circuitState))
  in
    layers [netsElement, otherGatesElement, inputsElement]

-- Draw all incoming nets to all non-input gates
drawAllNets : [String] -> GameState -> [Form]
drawAllNets netNames gs = 
  case netNames of 
    [] -> []
    name :: [] -> [drawNets name gs]
    name :: tl -> 
      let
        gateForm = drawNets name gs
        tlForms = drawAllNets tl gs
      in
        gateForm :: tlForms

-- Draw incoming nets to a gate
drawNets : String -> GameState -> Form
drawNets name gs =
  let 
    circuit = gs.circuitState
    gate = D.getOrFail name circuit
  in
    if | gate.gateType == InputGate -> toForm (plainText "")
       | otherwise -> 
          let 
            (x,y) = gate.location

            input1name = A.getOrFail 0 gate.inputs
            input1 = D.getOrFail input1name circuit
            (x1,y1) = input1.location
            segment1 = segment (x,y) (x1,y1)
            lineColor1 = if | input1.status == True -> green
                            | otherwise -> black
            input1segment = traced (solid lineColor1) segment1
          in
            if | A.length gate.inputs == 1 -> input1segment
               | otherwise ->
                  let
                    input2name = A.getOrFail 1 gate.inputs
                    input2 = D.getOrFail input2name circuit
                    (x2,y2) = input2.location
                    segment2 = segment (x,y) (x2,y2)
                    lineColor2 = if | input2.status == True -> green
                                    | otherwise -> black
                    input2segment = traced (solid lineColor2) segment2
                    both = collage 300 300 [input1segment,input2segment]
                  in 
                    toForm both
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