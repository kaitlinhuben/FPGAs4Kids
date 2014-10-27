{--
    types.elm
    Sets up all data types
    TODO: 
        - what images actually show for things
        - different gates and their logic (own file?)
--}
module Model_Types where

type GameState = { 
      inputs : [GameInput]
    , outputs : [GameOutput] 
    , gates : [Gate]
    , paths : [Net] -- TODO change
    , mode : Mode -- TODO displayMode
    , running : RunState
    , mousePos : (Int, Int)
}

type Gate = {
      location : (Float, Float)
    , inputs : [Bool] --TODO connections/nets
    , outputs : [Bool] -- TODO connections
    , spinning : SpinDirection
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

type Net = {
      status : Bool
    , location : (Float, Float)
    , gates : [Gate]
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

data GameInput = InputOn | InputOff

data GameOutput = OutputOn | OutputOff

data SpinDirection = None | CW | CCW