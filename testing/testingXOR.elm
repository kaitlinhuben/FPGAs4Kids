{-- Imports --}
import Graphics.Input (Input, input, clickable, checkbox)

{-- Driver --}
main = page <~ clicks.signal ~ flowTop.signal ~ flowBottom.signal

{-- Set up clicks signal handler --}
clicks : Input Int
clicks = input 0

{-- Set up signal handlers for flowTop and flowBottom checkboxes --}
flowTop : Input Bool
flowTop = input False

flowBottom : Input Bool
flowBottom = input False

{-- Set up the page --}
page count top bottom = 
    flow down [
        flow right 
        [
            flow down [
                container 100 100 middle (boxTop top)
            ,   container 100 100 middle (boxBottom bottom)
            ]
            , flipImage 200 200 count top bottom
        ]
        , flow right [asText("Number clicks: "), asText(count) ]
    ]

{-- Set up flippable image with handler --}
flipImage w h count top bottom = 
    let 
        result = if | top == True && bottom == True -> 0
                    | top == False && bottom == False -> 0
                    | top == True && bottom == False -> -1
                    | top == False && bottom == True -> 1
        dg = 90 * result
        c = collage w h 
            [
                rotate (degrees dg) (toForm((image w h "/XOR.png")))
            ]
    in
        clickable clicks.handle (count + 1) c

{-- Set up checkboxes with respective handlers --}
boxTop checked = 
    let box = container 15 15 middle (checkbox flowTop.handle identity checked)
    in flow right [asText("Top:"), box]

boxBottom checked = 
    let box = container 15 15 middle (checkbox flowBottom.handle identity checked)
    in flow right [asText("Bottom:"), box]


{-- OLD FUNCTIONS --}
{-- Set up the clickable image with the handler --}
{--clickImage w h count = 
    let 
        dg = 90 * count
        c = collage w h 
            [
                rotate (degrees dg) (toForm((image w h "/XOR.png")))
            ]
    in
        clickable clicks.handle (count + 1) c--}