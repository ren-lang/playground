module Html.Extra exposing (..)

import Html exposing (Html)


when : Html msg -> Bool -> Html msg
when element true =
    if true then
        element

    else
        Html.text ""


toggle : Html msg -> Html msg -> Bool -> Html msg
toggle a b true =
    if true then
        a

    else
        b
