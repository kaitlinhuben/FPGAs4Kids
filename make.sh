rm -rf levels/
elm-make src/Level_1.elm --output=Level_1.html
elm-make src/Level_2.elm --output=Level_2.html
elm-make src/Level_3.elm --output=Level_3.html
elm-make src/Level_4.elm --output=Level_4.html
elm-make src/Level_5.elm --output=Level_5.html
mkdir levels/
mv Level_*.html levels/