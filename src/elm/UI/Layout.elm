module UI.Layout exposing (..)

import Html exposing (Html)
import Html.Attributes


stack : List (Html.Attribute msg) -> List (Html msg) -> Html msg
stack attrs children =
    Html.div
        (Html.Attributes.class "flex flex-col" :: attrs)
        children


row : List (Html.Attribute msg) -> List (Html msg) -> Html msg
row attrs children =
    Html.div
        (Html.Attributes.class "flex flex-row" :: attrs)
        children


centred : List (Html.Attribute msg) -> List (Html msg) -> Html msg
centred attrs children =
    Html.div
        (Html.Attributes.class "flex justify-center items-center" :: attrs)
        children
