{--
    Model_Types.elm
    Sets up all data types for game
--}
module Model_Types where

import Graphics.Input as GInput

type GameInput = { timeDelta:Float, userInput:UserInput }

type UserInput = { mousePos:(Int,Int), display:Mode }

type GameState = { 
      inputs : [Input]
    , outputs : [Output] 
    , gates : [Gate]
    , paths : [Net]
    , displayMode : Mode
    , displayInput : GInput.Input Mode
    , runMode : RunState
    , mousePos : (Int,Int)
}

type Gate = {
      location : (Float, Float)
    , inputs : [Net]
    , outputs : [Net]
    , spinning : SpinDirection
    , gameImg : String
    , schematicImg : String
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

data Input = InputOn | InputOff

data Output = OutputOn | OutputOff

data SpinDirection = None | CW | CCW