module TestRunner_View where

import Dict
import Model (..)

andGateView : GateView
andGateView = {
      name = "andGate"
    , location = (-50,50)
  }

andGate2View : GateView
andGate2View = {
      name = "andGate2"
    , location = (0,0)
  }

orGateView : GateView
orGateView = {
      name = "orGate"
    , location = (-50,-50)
  }

input1View : GateView
input1View = {
      name = "input1"
    , location = (-100,100)
  }

input2View : GateView
input2View = {
      name = "input2"
    , location = (0,100)
  }

input3View : GateView
input3View = {
      name = "input3"
    , location = (100,100)
  }

outputView : GateView
outputView = {
      name = "output"
    , location = (-50,-100)
  }

viewInfo : Dict.Dict String GateView
viewInfo = 
    let
        list = 
            [ ("input1", input1View)
            , ("input2", input2View)
            , ("input3", input3View)
            , ("andGate", andGateView)
            , ("andGate2", andGate2View)
            , ("orGate", orGateView)
            , ("output", outputView)
            ]
    in 
        Dict.fromList list