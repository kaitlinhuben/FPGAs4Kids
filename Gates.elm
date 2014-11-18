module Gates where

type Gate = {
      name : String
    , status : Bool
    , inputs : [String]
    , outputs: [String]
    , logic  : String
  }