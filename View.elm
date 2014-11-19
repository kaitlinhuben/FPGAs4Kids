module View where 

import Gates (..)

drawGate : Gate -> Element
drawGate gate = 
    flow down [
      plainText gate.name
    , asText gate.status
    ]
