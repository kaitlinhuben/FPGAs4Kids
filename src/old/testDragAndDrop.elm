import Graphics.Collage
import Graphics.Input
import Signal 
import Text (..)
import Graphics.Element (..)
import Color (..)
import DragAndDrop (..)

hover = Signal.channel False

box = Graphics.Input.hoverable (Signal.send hover)
                               (putInBox (plainText "drag-and-drop me"))

putInBox e =
  let (sx,sy) = sizeOf e
  in layers [e, Graphics.Collage.collage sx sy [Graphics.Collage.outlined (Graphics.Collage.solid black) (Graphics.Collage.rect (toFloat sx) (toFloat sy))]]

moveBy (dx,dy) (x,y) = (x + toFloat dx, y - toFloat dy)

main =
  let update m =
        case m of
          Just (MoveBy (dx,dy)) -> moveBy (dx,dy)
          _                     -> identity
  in Signal.map (\p -> Graphics.Collage.collage 200 200 [Graphics.Collage.move p (Graphics.Collage.toForm box)])
                (Signal.foldp update (0,0) (track False (Signal.subscribe hover)))