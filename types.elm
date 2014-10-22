{--
    types.elm
    Sets up all data types
    TODO: 
        - what images actually show for things
        - different gates and their logic (own file?)
--}
module Types where

type GameState = { 
      inputs : [GameInput]
    , outputs : [GameOutput] 
    , gates : [Gate]
    , paths : [Path]
    , mode : Mode
    , running : RunState
    , mousePos : (Int, Int)
}

type Gate = {
      location : (Float, Float)
    , inputs : [Bool]
    , outputs : [Bool]
    , spinning : SpinDirection
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

type Path = {
      status : Bool
    , location : (Float, Float)
    , gates : [Gate]
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

data GameInput = InputOn | InputOff

data GameOutput = OutputOn | OutputOff

data SpinDirection = None | CW | CCW