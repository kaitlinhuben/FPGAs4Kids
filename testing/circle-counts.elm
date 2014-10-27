import Graphics.Input (Input, input, clickable)

main = scene <~ clicks.signal

clicks : Input Int
clicks = input 0

scene count = 
  flow down 
    [
      ccircle 100 100 50 count
    , asText(count)
    ]


ccircle w h r count = 
  let 
    c = collage w h [filled red (circle r)]
  in
    clickable clicks.handle (count + 1) c