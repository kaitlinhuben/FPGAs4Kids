{--
    Model_Types.elm
    Sets up all data types for game
--}
module Model_Types where

type GameState = { 
      inputs : [GameInput]
    , outputs : [GameOutput] 
    , gates : [Gate]
    , paths : [Net]
    , displayMode : Mode
    , runMode : RunState
}

type Gate = {
      location : (Float, Float)
    , inputs : [Net]
    , outputs : [Net]
    , spinning : SpinDirection
    , img : String
    , imgSize : (Int, Int)
    , timeDelta : Float
}

data Net = Net {
      status : Bool
    , location : (Float, Float)
    , gates : [Gate]
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

data GameInput = InputOn | InputOff

data GameOutput = OutputOn | OutputOff

data SpinDirection = None | CW | CCW