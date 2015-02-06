{--
    Contains all functions to render information
--}
module View.View where 

import Array
import Dict
import List ((::))
import Graphics.Element (..)
import Graphics.Collage (Form, collage, segment, traced, solid, toForm, move)
import Graphics.Input (clickable)
import Color (green, black, lightGrey)
import Maybe (withDefault)
import Signal (send)
import Model.Model (..)

-- don't technically need Text.asText, but clickable doesn't work without it!
import Text

{------------------------------------------------------------------------------
    Display entire page
------------------------------------------------------------------------------}
display : (Int, Int) -> GameState -> Element
display (w,h) gameState = 
    let
        circuitWidth = w
        circuitHeight = h - 50
        circuitElement = drawCircuit (circuitWidth,circuitHeight) gameState
        circuitContainer = container w h middle circuitElement
        clicksText = Text.asText gameState.clicks
        completedText = Text.asText gameState.completed
        --levelDoneText = if | gameState.completed == True -> Text.plainText "      YOU'RE DONE CONGRATS!"
          --                 | otherwise -> Text.plainText "      Not done yet, keep trying!"
        levelNextButton = if | gameState.completed == True -> Text.link gameState.nextLink (Text.fromString "      Go to next level")
                             | otherwise -> Text.fromString ""
        upperBar = flow down [
                    Text.plainText gameState.directions,
                    Text.plainText "Stats",
                    flow right [
                      Text.plainText "Clicks: ",
                      clicksText, 
                      Text.plainText "    Level completed: ", 
                      completedText,
                      Text.leftAligned levelNextButton
                    ]                    
                   ]
    in
        flow down [upperBar, circuitContainer]
    
{------------------------------------------------------------------------------
    Draw the whole circuit
------------------------------------------------------------------------------}
drawCircuit : (Int,Int) -> GameState -> Element
drawCircuit (w,h) gs = 
  let 
    netsForms = drawAll drawNets gs.nonInputNames gs 
    inputsForms = drawAll drawInputGate gs.inputNames gs
    otherForms = drawAll drawGate gs.nonInputNames gs

    allForms = netsForms ++ inputsForms ++ otherForms
  in
    collage w h allForms

{------------------------------------------------------------------------------
    Generic recursive function that allows you to draw all of a certain thing
    Takes as parameters:
      - The function to draw a single item
      - The List of names to iterate over
      - The GameState to pass to the drawSingle function
------------------------------------------------------------------------------}
drawAll : (String->GameState->Form) -> List String -> GameState -> List Form
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
    -- get the location of this gate
    gate = getGate name circuit
    (x,y) = gate.location

    -- get the location of the first input
    input1name = getGateName 0 gate.inputs
    input1 = getGate input1name circuit
    (x1,y1) = input1.location

    -- draw segment from first input to this gate
    segment1 = segment (x,y) (x1,y1)
    lineColor1 = if | input1.status == True -> green
                    | otherwise -> black
    input1segment = traced (solid lineColor1) segment1
  in
    if | Array.length gate.inputs == 1 -> input1segment
       | otherwise ->
          -- if there's a second input, draw that too
          let
            input2name = getGateName 1 gate.inputs
            input2 = getGate input2name circuit
            (x2,y2) = input2.location
            segment2 = segment (x,y) (x2,y2)
            lineColor2 = if | input2.status == True -> green
                            | otherwise -> black
            input2segment = traced (solid lineColor2) segment2
            both = collage 300 300 [input1segment,input2segment] -- TODO don't hardcode size
          in 
            toForm both

-- Draw a single gate
drawGate : String -> GameState -> Form
drawGate name gs = 
  let
    gate = getGate name gs.circuitState
    (w,h) = gate.imgSize
    imgForm = toForm(image w h gate.imgName)
  in 
    move gate.location imgForm

-- Draw a single input gate
drawInputGate : String -> GameState -> Form
drawInputGate name gs = 
  let
    -- get the gate
    gate = getGate name gs.circuitState

    -- get the input channel associated with the gate
    gateChannel = withDefault failedChannel (Dict.get name gs.inputChannels)
    
    -- get the size and set up the image
    (w,h) = gate.imgSize
    gateImage = image w h gate.imgName

    -- if the input is currently True, a click should send False
    -- if input currently False, click should send True
    -- (values should switch)
    updateValue = if | gate.status==True -> False
                     | otherwise -> True

    -- make the image a clickable element
    -- TODO also send this to count of clicks?? --> send a tuple
    gateElement = clickable (send gateChannel updateValue) gateImage

    -- fill the background of the image with status color
    fillColor = if | gate.status == True -> green
                   | gate.status == False -> lightGrey
    coloredElement = color fillColor gateElement

    -- make the clickable image a link so cursor switches to pointer
    linkedElement = link "#" coloredElement
  in 
    move gate.location (toForm linkedElement)