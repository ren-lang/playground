module Data.IO exposing
    ( IO
    , pure, empty
    , map, map2, mapCmd, mapBoth
    , with, andThen, andCmd
    , extract, extractCmd
    )

{-|


# The `IO` type

@docs IO


# Creating an `IO`

@docs pure, empty


# Manipulating an `IO`

@docs map, map2, mapCmd, mapBoth


# Additional pipe-friendly functions

@docs with, andThen, andCmd


# Getting values out of an `IO`

@docs extract, extractCmd

-}


{-| -}
type alias IO msg a =
    ( a, Cmd msg )



-- CREATING AN UPDATE ----------------------------------------------------------


{-| Take a plain old value and turn it into our `IO` monad. Anywhere you
would normally write

    ( model, Cmd.none )

could now be written as

    IO.pure model

-}
pure : a -> IO msg a
pure model =
    ( model
    , Cmd.none
    )


{-| Similar to `Cmd.none` but for `IO`, gives you no model and no Cmd.

This is like writing

    ( (), Cmd.none )

-}
empty : IO msg ()
empty =
    pure ()



-- MANIPULATING AN UPDATE ------------------------------------------------------


{-| Map the model wrapped in an `IO`. If you focus on writing many small
functions that update some part of your model, you can acheive a very nice
pipeline with this.

    IO.pure model
        |> IO.map (setFoo 42)
        |> IO.map (updateBar someFunc)

-}
map : (a -> b) -> IO msg a -> IO msg b
map f ( model, cmd ) =
    ( f model
    , cmd
    )


{-| Take two `IO` values with the same `msg` type but different `model`
types, and combine them using some function.
-}
map2 : (a -> b -> c) -> IO msg a -> IO msg b -> IO msg c
map2 f ( modelA, cmdA ) ( modelB, cmdB ) =
    ( f modelA modelB
    , Cmd.batch [ cmdA, cmdB ]
    )


{-| Map the Cmds wrapped in an `IO`. This essentially "proxies" `Cmd.map`.
-}
mapCmd : (x -> y) -> IO x a -> IO y a
mapCmd f ( model, cmd ) =
    ( model
    , Cmd.map f cmd
    )


{-| Supply functions to map both the model and Cmd of an `IO`. Useful when
you update a sub-page or a component and need to map it to the parent.

    IO.update componentMsg componentModel
        |> IO.mapBoth (\m -> { model | componentModel = m }) ComponentMsg

-}
mapBoth : (a -> b) -> (x -> y) -> IO x a -> IO y b
mapBoth modelF cmdF ( model, cmd ) =
    ( modelF model
    , Cmd.map cmdF cmd
    )



-- PIPE FRIENDLY FUNCTIONS -----------------------------------------------------


{-| -}
with : Cmd msg -> IO msg a -> IO msg a
with cmd ( model, cmds ) =
    ( model
    , Cmd.batch [ cmd, cmds ]
    )


{-| Chain together computations that update the model and produce a Cmd at the
same time. Maybe you're calling out to a port and want to update your model to
indicate some loading status? Now you can write

    IO.pure model
        |> IO.andThen loadFromLocalStorage

    loadFromLocalStorage : Model -> UpdateM msg Model
    loadFromLocalStorage model =
        ( { model | status = Loading }
        , getFromLocalStorage "data"
        )

instead of

    IO.pure model
        |> IO.with (getFromLocalStorage "data")
        |> IO.map (\m -> { m | status = Loading })

-}
andThen : (a -> IO msg b) -> IO msg a -> IO msg b
andThen f updateM =
    join (map f updateM)


{-| It's quite common to have Cmds that depend on some value stored in the model.
Maybe you need to make a HTTP request and the API endpoint is stored in the model,
or you want to send some data our of a port.
-}
andCmd : (a -> Cmd msg) -> IO msg a -> IO msg a
andCmd f ( model, cmd ) =
    ( model
    , Cmd.batch [ f model, cmd ]
    )



-- EXTRACTING AN UPDATE --------------------------------------------------------


{-| -}
extract : IO msg a -> a
extract ( model, _ ) =
    model


{-| -}
extractCmd : IO msg a -> Cmd msg
extractCmd ( _, cmd ) =
    cmd



-- UTILS -----------------------------------------------------------------------


{-| -}
join : IO msg (IO msg a) -> IO msg a
join ( ( model, cmdA ), cmdB ) =
    ( model
    , Cmd.batch [ cmdA, cmdB ]
    )
