module Result.Extra exposing (..)


unwrap : Result a a -> a
unwrap result =
    case result of
        Ok a ->
            a

        Err a ->
            a


isErr : Result e a -> Bool
isErr result =
    case result of
        Ok _ ->
            False

        Err _ ->
            True
