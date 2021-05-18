module UI.Button exposing (..)

-- IMPORTS ---------------------------------------------------------------------

import FeatherIcons exposing (Icon)
import Html exposing (Html)
import Html.Attributes
import Html.Events



-- TEXT BUTTONS ----------------------------------------------------------------


text : msg -> String -> List (Html.Attribute msg) -> Html msg
text handler content attrs =
    Html.button
        (Html.Attributes.class "px-2"
            :: Html.Events.onClick handler
            :: attrs
        )
        [ Html.text content ]



-- ICON BUTTONS ----------------------------------------------------------------


icon : msg -> Icon -> List (Html.Attribute msg) -> Html msg
icon handler content attrs =
    Html.button
        (Html.Attributes.class ""
            :: Html.Events.onClick handler
            :: attrs
        )
        [ FeatherIcons.toHtml [] content ]
