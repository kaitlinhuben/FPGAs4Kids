{--
    Contains functions to render nets
--}
module View.Nets where 

import Graphics.Collage (Form, collage, toForm, segment, traced, solid)
import Color (Color, green, black, lightGrey)
import Model.Model (..)

-- draw nets when there is only a single net coming into gate
drawNetToSingle : String -> GameState -> Form
drawNetToSingle name gs =
  drawSingleNet name 0 gs

-- draw nets when there are two nets coming into gate
drawNetsToDouble : String -> GameState -> Form
drawNetsToDouble name gs =
  let
    input1segment = drawSingleNet name 0 gs
    input2segment = drawSingleNet name 1 gs
    both = collage 300 300 [input1segment,input2segment] -- TODO don't hardcode size
  in 
    toForm both

-- draw a single net, the index'th listed
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

    -- if on, make line green; else, black
    lineColor = if | input1.status == True -> green
                   | otherwise -> black
  in -- figure out whether drawing straight or dog-leg
    if | y == y1 -> drawStraightNet (x,y) (x1,y1) lineColor
       | otherwise -> drawDogLegNet (x,y) (x1,y1) lineColor

-- draw a straight (horizontal) net
drawStraightNet : (Float, Float) -> (Float, Float) -> Color -> Form
drawStraightNet (x,y) (x1,y1) lineColor = 
  traced (solid lineColor) (segment (x,y) (x1,y1))

-- draw a net that "dog-legs" down/up to meet gate
drawDogLegNet : (Float, Float) -> (Float, Float) -> Color -> Form
drawDogLegNet (x,y) (x1,y1) lineColor = 
  let
    -- find where the dog leg should occur on x axis
    middle = (x + x1)/2
    -- when hit gate, shift up or down a little bit to prevent overlap
    shift = 5
    y_end = if | y1 > y -> y + shift
               | otherwise -> y - shift

    start_point = (x1,y1)
    mid_point_1 = (middle,y1)
    mid_point_2 = (middle,y_end)
    end_point   = (x,y_end)

    -- draw three segments (three parts of "leg")
    input_to_mid = drawStraightNet start_point mid_point_1 lineColor
    mid_down_mid = drawStraightNet mid_point_1 mid_point_2 lineColor
    mid_to_gate  = drawStraightNet mid_point_2 end_point   lineColor

    all = collage 300 300 [input_to_mid,mid_down_mid,mid_to_gate] -- TODO don't hardcode size
  in
    toForm all