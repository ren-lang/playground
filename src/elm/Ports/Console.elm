port module Ports.Console exposing (..)

-- IMPORTS ---------------------------------------------------------------------

import Json.Decode
import Json.Encode



-- PORTS -----------------------------------------------------------------------


port toConsole : Json.Encode.Value -> Cmd msg


port fromConsole : (Json.Decode.Value -> msg) -> Sub msg



-- TYPES -----------------------------------------------------------------------


type LogLevel
    = Log
    | Info
    | Warn
    | Error


type alias Message =
    ( LogLevel, String, String )



-- LOGGING MESSAGES ------------------------------------------------------------


log : String -> Cmd msg
log message =
    toConsole
        (Json.Encode.object
            [ ( "$", Json.Encode.string "Log" )
            , ( "message", Json.Encode.string message )
            ]
        )


info : String -> Cmd msg
info message =
    toConsole
        (Json.Encode.object
            [ ( "$", Json.Encode.string "Info" )
            , ( "message", Json.Encode.string message )
            ]
        )


warn : String -> Cmd msg
warn message =
    toConsole
        (Json.Encode.object
            [ ( "$", Json.Encode.string "Warn" )
            , ( "message", Json.Encode.string message )
            ]
        )


error : String -> Cmd msg
error message =
    toConsole
        (Json.Encode.object
            [ ( "$", Json.Encode.string "Error" )
            , ( "message", Json.Encode.string message )
            ]
        )



-- RECEIVING MESSAGES ----------------------------------------------------------


onMessage : (Message -> msg) -> Sub msg
onMessage msg =
    let
        toMessage tag timestamp message =
            ( tag, timestamp, message )

        logLevelDecoder =
            Json.Decode.string
                |> Json.Decode.andThen
                    (\tag ->
                        case tag of
                            "Log" ->
                                Json.Decode.succeed Log

                            "Info" ->
                                Json.Decode.succeed Info

                            "Warn" ->
                                Json.Decode.succeed Warn

                            "Error" ->
                                Json.Decode.succeed Error

                            _ ->
                                Json.Decode.fail ""
                    )
    in
    fromConsole
        (Json.Decode.decodeValue
            (Json.Decode.map3
                toMessage
                (Json.Decode.field "$" logLevelDecoder)
                (Json.Decode.field "timestamp" Json.Decode.string)
                (Json.Decode.field "message" Json.Decode.string)
            )
            >> Result.withDefault ( Log, "", "" )
            >> msg
        )
