port module Main exposing (main)

-- IMPORTS ---------------------------------------------------------------------

import Browser
import Data.IO exposing (IO)
import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import Html.Events
import Parser
import Ports.Console
import Ren.Compiler exposing (Target(..))
import Ren.Docs
import Ren.Examples
import Ren.Language
import Result.Extra
import UI.Editor
import UI.Layout



-- PORTS -----------------------------------------------------------------------


port toClipboard : String -> Cmd msg


port toJavascript : Maybe String -> Cmd msg



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
    , output : Result String String
    , console : ( Bool, List ( String, String ) )
    , tab : Tab
    }


type Tab
    = Code
    | Docs
    | View
    | Examples


{-| -}
type alias Flags =
    { code : Maybe String
    }


{-| -}
init : Flags -> IO Msg Model
init flags =
    let
        model =
            { source = ""
            , output = Err ""
            , console = ( True, [] )
            , tab = Code
            }
    in
    case flags.code of
        Just source ->
            Data.IO.pure model
                |> Data.IO.map (compileInput source)

        Nothing ->
            Data.IO.pure model
                |> Data.IO.map (compileInput Ren.Examples.bottlesOfBeer)



-- UPDATE ----------------------------------------------------------------------


{-| -}
type Msg
    = Typed Input String
    | Clicked Button
    | FromConsole ( String, String )


{-| -}
type Input
    = Source


{-| -}
type Button
    = Run
      --
    | New
      --
    | Share
      --
    | ToggleConsole
    | ClearConsole
      --
    | SwitchTab Tab


{-| -}
update : Msg -> Model -> IO Msg Model
update msg model =
    case msg of
        Typed Source input ->
            Data.IO.pure model
                |> Data.IO.map (compileInput input)

        Clicked Run ->
            Data.IO.pure model
                |> Data.IO.with (toJavascript <| Result.toMaybe model.output)

        Clicked New ->
            { model | source = "", output = Ok "" }
                |> Data.IO.pure

        Clicked Share ->
            Data.IO.pure model
                |> Data.IO.with (toClipboard model.source)

        Clicked ToggleConsole ->
            { model | console = Tuple.mapFirst Basics.not model.console }
                |> Data.IO.pure

        Clicked ClearConsole ->
            { model | console = ( True, [] ) }
                |> Data.IO.pure

        Clicked (SwitchTab tab) ->
            { model | tab = tab }
                |> Data.IO.pure

        FromConsole message ->
            { model | console = Tuple.mapSecond ((::) message) model.console }
                |> Data.IO.pure


{-| -}
parseInput : String -> Result (List Parser.DeadEnd) Ren.Compiler.Module
parseInput input =
    let
        stdlib =
            [ Ren.Language.Import "ren/array" [ "Array" ] []
            , Ren.Language.Import "ren/compare" [ "Compare" ] []
            , Ren.Language.Import "ren/function" [ "Function" ] []
            , Ren.Language.Import "ren/logic" [ "Logic" ] []
            , Ren.Language.Import "ren/math" [ "Math" ] []
            , Ren.Language.Import "ren/maybe" [ "Maybe" ] []
            , Ren.Language.Import "ren/object" [ "Object" ] []
            , Ren.Language.Import "ren/promise" [ "Promise" ] []
            , Ren.Language.Import "ren/string" [ "String" ] []
            ]

        addStdlib { imports, declarations } =
            { imports = stdlib ++ imports
            , declarations = declarations
            }
    in
    Ren.Compiler.parse input
        |> Result.map addStdlib


{-| -}
compileInput : String -> Model -> Model
compileInput input model =
    let
        lastOutput =
            case model.output of
                Ok output ->
                    Err output

                Err output ->
                    Err output
    in
    parseInput input
        |> Result.map (Ren.Compiler.optimise >> Ren.Compiler.emit ESModule)
        |> Result.map (\code -> { model | source = input, output = Ok code })
        |> Result.withDefault { model | source = input, output = lastOutput }



-- VIEW ------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    UI.Layout.stack
        [ Html.Attributes.class "bg-gray-50 w-full h-full text-sm" ]
        [ viewToolbar
        , UI.Layout.row
            [ Html.Attributes.class "flex-1" ]
            [ viewEditor model
            , Html.hr [ Html.Attributes.class "border border-gray-200" ] []
            , viewSidepanel model
            ]
        ]



-- VIEW: TOOLBAR ---------------------------------------------------------------


viewToolbar : Html Msg
viewToolbar =
    UI.Layout.row
        [ Html.Attributes.class "bg-pink-300 text-white font-mono" ]
        [ viewToolbarButton Run "Run"
        , Html.span [ Html.Attributes.class "m-2 border border-white" ] []
        , viewToolbarButton New "New"
        , viewToolbarButton (SwitchTab Examples) "Examples"
        , Html.span [ Html.Attributes.class "m-2 border border-white" ] []
        , viewToolbarButton (SwitchTab Docs) "Help"
        , viewToolbarButton Share "Share"
        , Html.span [ Html.Attributes.class "m-2 border border-white" ] []
        , viewToolbarButton (SwitchTab Code) "Show JS"
        , viewToolbarButton (SwitchTab View) "Show HTML"
        ]


viewToolbarButton : Button -> String -> Html Msg
viewToolbarButton button text =
    Html.button
        [ Html.Attributes.class "px-2 py-1 hover:bg-pink-400"
        , Html.Events.onClick (Clicked button)
        ]
        [ Html.text text ]



-- VIEW: EDITOR ----------------------------------------------------------------


viewEditor : Model -> Html Msg
viewEditor model =
    Html.div
        [ Html.Attributes.class "flex-1 h-full relative bg-white" ]
        [ UI.Editor.view model.source
            [ Html.Attributes.id "ren"
            , UI.Editor.language "ren"
            , Html.Events.onInput (Typed Source)
            ]
        , viewEditorLanguage "ren"
        ]


viewEditorLanguage : String -> Html Msg
viewEditorLanguage lang =
    Html.span
        [ Html.Attributes.class "absolute right-0 top-0 px-2 py-1"
        , Html.Attributes.class "bg-gray-100 text-black text-xs"
        ]
        [ Html.text <| "." ++ lang ]



-- VIEW: SIDEPANEL -------------------------------------------------------------


viewSidepanel : Model -> Html Msg
viewSidepanel model =
    UI.Layout.stack
        [ Html.Attributes.class "flex-1 relative h-full w-2/5" ]
        [ viewCodeSidepanel model.tab model.output
        , viewOutputSidepanel model.tab
        , viewExamplesSidepanel model.tab
        , viewDocsSidepanel model.tab
        , viewConsole model.console
        ]


viewCodeSidepanel : Tab -> Result String String -> Html Msg
viewCodeSidepanel tab code =
    if tab == Code then
        UI.Layout.stack
            [ Html.Attributes.class "relative flex-1"
            ]
            [ UI.Editor.view (Result.Extra.unwrap code)
                [ Html.Attributes.id "js"
                , UI.Editor.readonly True
                , UI.Editor.language "javascript"
                , Html.Attributes.class "opacity-50 filter blur-sm"
                    |> Html.Attributes.Extra.when (Result.Extra.isErr code)
                ]
            , viewEditorLanguage "js"
            ]

    else
        Html.text ""


viewOutputSidepanel : Tab -> Html Msg
viewOutputSidepanel tab =
    Html.div
        [ Html.Attributes.class "flex-grow h-0 overflow-y-scroll p-2"

        -- This is hidden rather than removed from the DOM because we don't want
        -- elm to re-render this element because it may have HTML injected into
        -- it that elm's vdom doesn't know about!
        , Html.Attributes.Extra.when (tab /= View) (Html.Attributes.class "hidden")
        ]
        [ Html.div
            [ Html.Attributes.id "playground-display"
            , Html.Attributes.class "font-sans prose"
            ]
            []
        ]


viewExamplesSidepanel : Tab -> Html Msg
viewExamplesSidepanel tab =
    if tab == Examples then
        UI.Layout.stack
            [ Html.Attributes.class "flex-1" ]
            []

    else
        Html.text ""


viewDocsSidepanel : Tab -> Html Msg
viewDocsSidepanel tab =
    if tab == Docs then
        Html.div
            [ Html.Attributes.class "flex-grow h-0 overflow-y-scroll py-8"
            , Html.Attributes.class "space-y-8"
            ]
            Ren.Docs.all

    else
        Html.text ""



-- VIEW: CONSOLE ---------------------------------------------------------------


viewConsole : ( Bool, List ( String, String ) ) -> Html Msg
viewConsole ( visible, history ) =
    if visible then
        UI.Layout.stack
            [ Html.Attributes.class "relative h-64 bg-gray-200 overflow-hidden font-mono" ]
            [ UI.Layout.row
                [ Html.Attributes.class "absolute top-0 right-0 justify-end" ]
                [ viewConsoleButton (Clicked ToggleConsole) <|
                    if visible then
                        "Hide"

                    else
                        "Show"
                , viewConsoleButton (Clicked ClearConsole) "Clear"
                ]
            , UI.Layout.stack
                [ Html.Attributes.class "m-2 overflow-y-scroll flex-col-reverse"
                , Html.Attributes.class "hidden"
                    |> Html.Attributes.Extra.when (Basics.not visible)
                ]
                (List.map viewConsoleMessage history)
            ]

    else
        UI.Layout.row
            [ Html.Attributes.class "justify-end" ]
            [ viewConsoleButton (Clicked ToggleConsole) <|
                if visible then
                    "Hide"

                else
                    "Show"
            , viewConsoleButton (Clicked ClearConsole) "Clear"
            ]


viewConsoleButton : Msg -> String -> Html Msg
viewConsoleButton msg text =
    Html.button
        [ Html.Attributes.class "text-xs px-2 py-1 bg-pink-300 hover:bg-pink-400 text-white"
        , Html.Events.onClick msg
        ]
        [ Html.text text ]


viewConsoleMessage : ( String, String ) -> Html Msg
viewConsoleMessage ( timestamp, message ) =
    UI.Layout.row
        [ Html.Attributes.class "mx-4" ]
        [ Html.span
            [ Html.Attributes.class "select-none" ]
            [ Html.text <| timestamp ++ ":" ]
        , Html.span
            [ Html.Attributes.class "ml-2 whitespace-pre" ]
            [ Html.text message ]
        ]



-- SUBSCRIPTIONS ---------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Ports.Console.onMessage (\( _, time, text ) -> FromConsole ( time, text ))
        ]
