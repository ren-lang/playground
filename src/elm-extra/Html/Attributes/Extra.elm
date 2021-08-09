module Html.Attributes.Extra exposing (..)

import Html
import Html.Attributes


when : Bool -> Html.Attribute msg -> Html.Attribute msg
when true attr =
    if true then
        attr

    else
        Html.Attributes.class ""
