module Html.Attributes.Extra exposing (..)

import Html
import Html.Attributes


classWhen : String -> Bool -> Html.Attribute msg
classWhen classes true =
    Html.Attributes.class <|
        if true then
            classes

        else
            ""
