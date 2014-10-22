import Window
import Mouse
{-- Setting up all data types for game --}
type GameState = { 
      inputs : [Bool]
    , outputs : [Bool] 
    , gates : [Gate]
    , paths : [Path]
    , mode : Mode
    , running : RunState
}

type Gate = {
      location : (Float, Float)
    , inputs : [Bool]
    , outputs : [Bool]
    , changing : Bool
}

type Path = {
      status : Bool
    , location : (Float, Float)
    , gates : [Gate]
}

data Mode = Game | Schematic

data RunState = Designing | Simulating

{-- Set up default values --}
defaultGame : GameState
defaultGame = { inputs = [], outputs = [], gates = [], paths = [], mode = Game, running = Designing}

stepGame (time, clicks) gameState = gameState

{-- Display things --}
display (w,h) gameState = asText (w,h)

{-- Game processing --}
delta = lift (\t -> t / 20) (fps 25)
input = sampleOn delta (lift2 (,) delta Mouse.clicks)

main  = lift2 display Window.dimensions (foldp stepGame defaultGame input)