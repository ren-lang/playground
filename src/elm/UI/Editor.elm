module UI.Editor exposing (..)

-- IMPORTS ---------------------------------------------------------------------

import Html exposing (Html)
import Html.Attributes



-- ATTRIBUTES ------------------------------------------------------------------


readonly : Bool -> Html.Attribute msg
readonly enabled =
    if enabled then
        Html.Attributes.attribute "readonly" "true"

    else
        Html.Attributes.attribute "readonly" ""


language : String -> Html.Attribute msg
language lang =
    Html.Attributes.attribute "language" lang


linenumbers : Bool -> Html.Attribute msg
linenumbers enabled =
    if enabled then
        Html.Attributes.attribute "line-numbers" "true"

    else
        Html.Attributes.attribute "line-numbers" ""



-- ELEMENTS --------------------------------------------------------------------


view : String -> List (Html.Attribute msg) -> Html msg
view value attrs =
    Html.node "code-editor" (Html.Attributes.value value :: attrs) []
