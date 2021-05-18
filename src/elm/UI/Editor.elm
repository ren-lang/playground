module UI.Editor exposing
    ( editor, viewer
    , language, lineNumbers
    , onInput
    )

{-|

@docs editor, viewer
@docs language, lineNumbers
@docs onInput

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode


editor : List (Html.Attribute msg) -> Html msg
editor attrs =
    Html.node "codeflask-editor" attrs [ Html.text "" ]


viewer : List (Html.Attribute msg) -> Html msg
viewer attrs =
    Html.node "codeflask-viewer" attrs [ Html.text "" ]


language : String -> Html.Attribute msg
language lang =
    Html.Attributes.attribute "language" lang


lineNumbers : Bool -> Html.Attribute msg
lineNumbers enabled =
    if enabled then
        Html.Attributes.attribute "line-numbers" "true"

    else
        Html.Attributes.attribute "" ""


onInput : (String -> msg) -> Html.Attribute msg
onInput handler =
    Html.Events.on "value-changed"
        (Json.Decode.at [ "target", "value" ] Json.Decode.string
            |> Json.Decode.map handler
        )
