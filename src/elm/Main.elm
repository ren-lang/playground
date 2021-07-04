port module Main exposing (main)

-- IMPORTS ---------------------------------------------------------------------

import Browser
import Data.IO exposing (IO)
import FeatherIcons
import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import Html.Events
import Html.Extra
import Parser
import Ren.Compiler exposing (Target(..))
import Ren.Data.Module
import Ren.Examples
import UI.Button
import UI.Layout



-- PORTS -----------------------------------------------------------------------


port toClipboard : String -> Cmd msg


port toJavascript : Maybe String -> Cmd msg


port toConsole : (( String, String ) -> msg) -> Sub msg



-- MAIN ------------------------------------------------------------------------


{-| -}
main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL -----------------------------------------------------------------------


{-| -}
type alias Model =
    { source : String
    , output : Maybe String
    , lastSuccessfulOutput : String
    , console : List ( String, String )
    , size : String
    }


{-| -}
type alias Flags =
    { code : Maybe String
    }


{-| -}
init : Flags -> IO Msg Model
init flags =
    case flags.code of
        Just source ->
            Data.IO.pure (Model "" Nothing "" [] "1/2")
                |> Data.IO.map (compileInput source)

        Nothing ->
            Data.IO.pure (Model "" Nothing "" [] "1/2")
                |> Data.IO.map (compileInput Ren.Examples.helloworld)



-- UPDATE ----------------------------------------------------------------------


{-| -}
type Msg
    = Typed Input String
    | Clicked Button
    | ToConsole ( String, String )


{-| -}
type Input
    = Source


{-| -}
type Button
    = New
      --
    | HelloWorld
    | LetExample
    | FunExample
    | PrimitivesExample
      --
    | Run
    | Share
    | Expand
    | Shrink


{-| -}
update : Msg -> Model -> IO Msg Model
update msg model =
    case msg of
        Typed Source input ->
            Data.IO.pure model
                |> Data.IO.map (compileInput input)

        Clicked New ->
            Data.IO.pure model
                |> Data.IO.map (\m -> { m | source = "", output = Just "" })

        Clicked HelloWorld ->
            Data.IO.pure model
                |> Data.IO.map (compileInput Ren.Examples.helloworld)

        Clicked LetExample ->
            Data.IO.pure model
                |> Data.IO.map (compileInput Ren.Examples.letExample)

        Clicked FunExample ->
            Data.IO.pure model
                |> Data.IO.map (compileInput Ren.Examples.funExample)

        Clicked PrimitivesExample ->
            Data.IO.pure model
                |> Data.IO.map (compileInput Ren.Examples.primitivesExample)

        Clicked Run ->
            Data.IO.pure model
                |> Data.IO.with (toJavascript model.output)

        Clicked Share ->
            Data.IO.pure model
                |> Data.IO.with (toClipboard model.source)

        Clicked Expand ->
            Data.IO.pure model
                |> Data.IO.map (\m -> { m | size = "full" })

        Clicked Shrink ->
            Data.IO.pure model
                |> Data.IO.map (\m -> { m | size = "1/2" })

        ToConsole message ->
            Data.IO.pure model
                |> Data.IO.map (\m -> { m | console = message :: m.console })


{-| -}
parseInput : String -> Result (List Parser.DeadEnd) Ren.Compiler.Module
parseInput input =
    let
        stdlib =
            [ Ren.Data.Module.import_ "ren/array" [ "$Array" ] []
            , Ren.Data.Module.import_ "ren/compare" [ "$Compare" ] []
            , Ren.Data.Module.import_ "ren/function" [ "$Function" ] []
            , Ren.Data.Module.import_ "ren/logic" [ "$Logic" ] []
            , Ren.Data.Module.import_ "ren/math" [ "$Math" ] []
            , Ren.Data.Module.import_ "ren/object" [ "$Object" ] []
            ]
    in
    Ren.Compiler.parse input
        |> Result.map (\m -> List.foldl Ren.Data.Module.addImport m stdlib)


{-| -}
compileInput : String -> Model -> Model
compileInput input model =
    case parseInput input |> Result.map Ren.Compiler.optimise |> Result.map (Ren.Compiler.emit ESModule) of
        Ok code ->
            { model
                | source = input
                , output = Just code
                , lastSuccessfulOutput = code
            }

        Err _ ->
            { model
                | source = input
                , output = Nothing
            }



-- VIEW ------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    UI.Layout.centred
        [ Html.Attributes.class "w-full h-full bg-gray-50"
        ]
        [ UI.Layout.stack
            [ Html.Attributes.class "transition-all duration-300 ease-in-out"
            , Html.Attributes.class <| "w-full xl:w-" ++ model.size
            , Html.Attributes.class <| "h-full xl:h-" ++ model.size
            , Html.Attributes.class "rounded-bl rounded-br shadow-lg"
            ]
            [ viewToolbar model
            , viewSplitEditor model
            , UI.Layout.stack
                [ Html.Attributes.class "bg-gray-100 flex-col-reverse overflow-y-scroll"
                , Html.Attributes.class "transition-all duration-300 ease-in-out"
                , Html.Attributes.class "font-mono p-1 max-h-64"
                , Html.Attributes.class <|
                    if model.size == "full" then
                        "flex-1"

                    else
                        "h-16"
                ]
                (List.map
                    (\( time, message ) ->
                        UI.Layout.row
                            [ Html.Attributes.class "" ]
                            [ Html.span
                                [ Html.Attributes.class "mr-2 text-gray-400" ]
                                [ "[{time}] >"
                                    |> String.replace "{time}" time
                                    |> Html.text
                                ]
                            , Html.pre
                                [ Html.Attributes.class "flex-1" ]
                                [ Html.text message ]
                            ]
                    )
                    model.console
                )
            ]
        ]


viewToolbar : Model -> Html Msg
viewToolbar model =
    UI.Layout.row
        [ Html.Attributes.class "bg-ren-500 text-white justify-between" ]
        [ UI.Layout.row []
            [ Html.span
                [ Html.Attributes.class "p-2 font-bold" ]
                [ Html.text "Ren Playground" ]
            , Html.span
                [ Html.Attributes.class "p-2 text-gray-200 select-none cursor-default" ]
                [ Html.text "|" ]
            , UI.Button.text (Clicked New) "New" []
            , viewToolbarDropdownMenu "Examples"
                [ Button "Hello world" (Clicked HelloWorld)
                , Separator
                , Button "Language: let" (Clicked LetExample)
                , Button "Language: fun" (Clicked FunExample)
                , Button "Language: primitives" (Clicked PrimitivesExample)
                ]
            , Html.span
                [ Html.Attributes.class "p-2 text-gray-200 select-none cursor-default" ]
                [ Html.text "|" ]
            ]
        , UI.Layout.row
            [ Html.Attributes.class "p-2 text-white" ]
            [ UI.Button.icon (Clicked Run) FeatherIcons.play [ Html.Attributes.class "mr-2" ]
            , UI.Button.icon (Clicked Share) FeatherIcons.share [ Html.Attributes.class "mr-2" ]
            , Html.Extra.toggle
                (UI.Button.icon (Clicked Shrink) FeatherIcons.minimize2 [])
                (UI.Button.icon (Clicked Expand) FeatherIcons.maximize2 [])
                (model.size == "full")
            ]
        ]


viewToolbarDropdownMenu : String -> List ToolbarMenuItem -> Html Msg
viewToolbarDropdownMenu label items =
    Html.div
        [ Html.Attributes.class "group inline-block relative" ]
        [ Html.span
            [ Html.Attributes.class "inline-block p-2 select-none cursor-default" ]
            [ Html.text label ]
        , UI.Layout.stack
            [ Html.Attributes.class "absolute hidden group-hover:block bg-ren-500 z-10 shadow-md rounded-b-lg" ]
            (List.map viewToolbarDropdownMenuItem items)
        ]


type ToolbarMenuItem
    = Button String Msg
    | Separator


viewToolbarDropdownMenuItem : ToolbarMenuItem -> Html Msg
viewToolbarDropdownMenuItem item =
    case item of
        Button label msg ->
            UI.Button.text msg
                label
                [ Html.Attributes.class "hover:bg-ren-600 py-2 w-full block whitespace-nowrap text-left rounded-b-lg " ]

        Separator ->
            Html.hr [] []


viewSplitEditor : Model -> Html Msg
viewSplitEditor model =
    UI.Layout.row
        [ Html.Attributes.class "flex-1 bg-white font-mono"
        ]
        [ Html.textarea
            [ Html.Attributes.class "flex-1 border-r resize-none p-2"
            , Html.Attributes.value model.source
            , Html.Attributes.spellcheck False
            , Html.Events.onInput (Typed Source)
            ]
            []
        , Html.textarea
            [ Html.Attributes.class "flex-1 border-l resize-none p-2"
            , Html.Attributes.Extra.classWhen "opacity-25" <|
                model.output
                    == Nothing
            , Html.Attributes.value <|
                Maybe.withDefault model.lastSuccessfulOutput model.output
            , Html.Attributes.readonly True
            ]
            []
        ]



-- [ UI.Editor.editor
--     [ UI.Editor.language "ren"
--     , Html.Attributes.value model.source
--     , Html.Attributes.class "flex-1 border-r"
--     , UI.Editor.onInput (Typed Source)
--     ]
-- , UI.Editor.viewer
--     [ UI.Editor.language "javascript"
--     , Html.Attributes.value <| Maybe.withDefault model.lastSuccessfulOutput model.output
--     , Html.Attributes.Extra.classWhen "opacity-25" (model.output == Nothing)
--     , Html.Attributes.class "flex-1 border-l"
--     , Html.Attributes.readonly True
--     ]
-- ]
-- SUBSCRIPTIONS ---------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ toConsole ToConsole
        ]
