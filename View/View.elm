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
import Color (Color, green, black, lightGrey, red, blue)
import Maybe (withDefault)
import Signal (send)
import Html (a, button, text, toElement)
import Html.Attributes (href, id)
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
        circuitContainer = container circuitWidth circuitHeight middle circuitElement
        clicksText = Text.asText gameState.clicks
        nextBtn = a 
                  [href gameState.nextLink] 
                  [button 
                    [id "test-button"] 
                    [text "Go to next level"]
                  ]
        levelNextButton = if | gameState.completed == True -> toElement 150 20 nextBtn
                             | otherwise -> Text.plainText ""
        upperBar = flow down 
                    [ Text.plainText gameState.directions
                    , Text.plainText "Stats"
                    , flow right 
                      [ Text.plainText "Clicks: "
                      , clicksText
                      , Text.plainText "           "
                      , levelNextButton
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
    gate = getGate name circuit 
  in
    if | Array.length gate.inputs == 1 -> drawNetToSingle name gs
       | otherwise -> drawNetsToDouble name gs

drawNetToSingle : String -> GameState -> Form
drawNetToSingle name gs =
  drawSingleNet name 0 gs

drawNetsToDouble : String -> GameState -> Form
drawNetsToDouble name gs =
  let
    input1segment = drawSingleNet name 0 gs
    input2segment = drawSingleNet name 1 gs
    both = collage 300 300 [input1segment,input2segment] -- TODO don't hardcode size
  in 
    toForm both

drawSingleNet : String -> Int -> GameState -> Form
drawSingleNet name index gs =
  let 
    circuit = gs.circuitState
    -- get the location of this gate
    gate = getGate name circuit
    (x,y) = gate.location

    -- get the location of the first input
    inputName = getGateName index gate.inputs
    input1 = getGate inputName circuit
    (x1,y1) = input1.location

    lineColor = if | input1.status == True -> green
                   | otherwise -> black
  in
    if | y == y1 -> drawStraightNet (x,y) (x1,y1) lineColor
       | otherwise -> drawDogLegNet (x,y) (x1,y1) lineColor

drawStraightNet : (Float, Float) -> (Float, Float) -> Color -> Form
drawStraightNet (x,y) (x1,y1) lineColor = 
  traced (solid lineColor) (segment (x,y) (x1,y1))

drawDogLegNet : (Float, Float) -> (Float, Float) -> Color -> Form
drawDogLegNet (x,y) (x1,y1) lineColor = 
  let
    -- find where the dog leg should occur on x axis
    middle = (x + x1)/2
    -- don't have everything go directly down middle line
    y_start = if | y1 > y -> y + 5
               | otherwise -> y - 5

    -- draw three segments (three parts of "leg")
    traced1 = drawStraightNet (x,y_start) (middle,y_start) lineColor
    traced2 = drawStraightNet (middle,y_start) (middle,y1) lineColor
    traced3 = drawStraightNet (middle,y1) (x1,y1) lineColor

    all = collage 300 300 [traced1,traced2,traced3] -- TODO don't hardcode size
  in
    toForm all

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

    -- make the clickable image a link so cursor switches to pointer
    linkedElement = link "#" gateElement
  in 
    move gate.location (toForm linkedElement)