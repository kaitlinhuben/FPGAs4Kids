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
    in
        container w h middle circuitElement
    
-- Draw the circuit and put it in an element
drawCircuit : (Int,Int) -> GameState -> Element
drawCircuit (w,h) gs = 
  let 
    netsForms = drawAll drawNets gs.nonInputNames gs 
    inputsForms = drawAll drawInputGate gs.inputNames gs
    otherForms = drawAll drawGate gs.nonInputNames gs

    allForms = netsForms ++ inputsForms ++ otherForms
  in
    collage w h allForms

-- Recursively draw everything in names with drawSingle function
drawAll : (String->GameState->Form) -> [String] -> GameState -> [Form]
drawAll drawSingle names gs =
  case names of 
    [] -> []
    name :: [] -> [drawSingle name gs]
    name :: tl -> 
      let
        singleForm = drawSingle name gs
        tlForms = drawAll drawSingle tl gs 
      in
        singleForm :: tlForms

-- Draw incoming nets to a gate
drawNets : String -> GameState -> Form
drawNets name gs =
  let 
    circuit = gs.circuitState
    gate = D.getOrFail name circuit
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
drawGate : String -> GameState -> Form
drawGate name gs = 
  let
    gate = D.getOrFail name gs.circuitState
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.imgName)
  in 
    move gate.location imgForm

-- Draw a single input gate
drawInputGate : String -> GameState -> Form
drawInputGate name gs = 
  let
    -- get the gate
    gate = D.getOrFail name gs.circuitState
    -- get the input associated with the gate
    gateInput = D.getOrFail name gs.inputSignals
    
    -- get the size and set up the image
    (w,h) = gate.imgSize
    gateImage = image w h gate.imgName

    updateValue = if | gate.status==True -> False
                     | otherwise -> True

    gateElement = I.clickable gateInput.handle updateValue gateImage

    fillColor = if | gate.status == True -> green
                   | gate.status == False -> lightGrey

    coloredElement = color fillColor gateElement
    linkedElement = link "#" coloredElement
  in 
    move gate.location (toForm linkedElement)