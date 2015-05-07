module CadTester where

import Graphics.Element (Element)
import Mouse
import Signal
import Text
import Window

-- +-------+
-- | Model |
-- +-------+
type alias UserInput = {
    mousePos : (Int, Int)
  }

type alias CadFramework = {
    gridSize : Int
  }

type alias CadState = {
    mousePos : (Int, Int)
  }

-- +------+
-- | View |
-- +------+
display : (Int, Int) -> CadState -> Element
display (w,h) cadState = 
    Text.asText cadState

-- +---------+
-- | Updates |
-- +---------+

step : UserInput -> CadState -> CadState
step userInput cadState = { cadState | mousePos <- userInput.mousePos}

-- Driver
mainDriver : CadState -> Signal UserInput -> Signal Element
mainDriver cadFramework userInput = 
  Signal.map2 display Window.dimensions (Signal.foldp step cadState userInput)

cadFramework = { gridSize = 4 }
cadState = {mousePos=(0,0)}
-- Run main
main : Signal Element
main = mainDriver cadState (Signal.map UserInput Mouse.position)