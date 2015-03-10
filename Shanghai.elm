module Shanghai where

import Result (..)
import Signal (..)
import Dict
import List (sum)

 -- Input ports

port coordinates  : (Int,Int)
port incomingShip : Signal { name:String, capacity:Int }
port outgoingShip : Signal String

ships = merge (Ok <~ incomingShip) (Err <~ outgoingShip)

updateDocks ship docks =
    case ship of
      Ok {name,capacity} -> Dict.insert name capacity docks
      Err name -> Dict.remove name docks

dock = foldp updateDocks Dict.empty ships

 -- Output ports

port totalCapacity : Signal Int
port totalCapacity = (sum << Dict.values) <~ dock