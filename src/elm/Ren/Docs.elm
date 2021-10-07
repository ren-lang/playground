module Ren.Docs exposing (..)

-- IMPORTS ---------------------------------------------------------------------

import Html exposing (Html)
import Html.Attributes
import Markdown



--


makeDoc : String -> Html msg
makeDoc =
    Markdown.toHtmlWith
        { githubFlavored = Just { tables = False, breaks = False }
        , defaultHighlighting = Nothing
        , sanitize = False
        , smartypants = True
        }
        [ Html.Attributes.class "m-auto prose" ]



-- DOCS ------------------------------------------------------------------------


all : List (Html msg)
all =
    [ preamble
    , array
    , compare
    , function
    , logic
    , math
    , maybe
    , object
    , promise
    ]


preamble : Html msg
preamble =
    makeDoc """
# Module Documentation

🚨 **How to read these docs**: We present each function here using ML-style type
signatures that can be a little weird to read the first time you come across them.

- `a → b` is shorthand for `Function a b`. That is, a function that takes an `a`
and turns it into a `b`.
- By extension, `a → b → c` would be shorthand for `Function a (Function b c)`:
a function that returns another function! All functions in Ren are _curried_ which
means their arguments can be partially applied.
- Lowercase types are *type variables*, they could be anything. An example is
`Array a`: An array filled with a's! It's important to note that the same
lowercase type variable refers to the same type through a type signature. If you
have a type `Array a → Array a` then the type of the elements doesn't change.
- Uppercase types are *concrete types*. We've seen one already, `Array`. These
generally correspond to basic JavaScript types but there are some others to note
like `Maybe`.
- Concrete types can be parameterised by other types. `Array` on its own isn't
a proper type, but `Array Number` is.

## Available modules

- **ren/array**
- **ren/compare**
- **ren/function**
- **ren/logic**
- **ren/math**
- **ren/maybe**
- **ren/object**
- **ren/promise**
- **ren/string**


The above list of modules is available for you to import in the playground.
You should import their module name exactly (with no leading `/` or `./`). For 
example:

```ren
import 'ren/array' as Array
import 'ren/maybe' as Maybe exposing { just, nothing }
```
"""


array : Html msg
array =
    makeDoc """
## ren/array

**Creating Arrays**

- `singleton : a → Array a`

    Create a single-element array from an initial value.

- `repeat : Number → a → Array a`

    Create an array by repeating an initial value a certain number of times.

- `range : Number → Number → Array Number`

    Create an array of numbers incrementing by one. You supply a starting value 
    and length of the array:

    ```ren
    range 0 5 == [0, 1, 2, 3, 4]
    range 5 5 == [5, 6, 7, 8, 9]
    ```

- `cons : a → Array a → Array a`

    Add an item to the front of an array.

- `join : Array a → Array a → Array a`

    Concatenate two arrays together.

**Transforming Arrays**

- `map : (a → b) → Array a → Array b`

    Apply a function to every element of an array.

- `indexedMap : (Number → a → b) → Array a → Array b`

    Apply a function to every element of the array with the index of the current
    iteration.

- `foldl : (b → a → b) → b → Array a → b`

    Reduce an array from the left.

- `foldr : (b → a → b) → b → Array a → b`

    Reduce an array from the right.

- `filter : (a → Boolean) → Array a → Array a`

    Filter an array, keeping only those elements that satisfy some predicate.

- `filterMap : (a → Maybe b) → Array a → Array b`

    Filter and map combined. `undefined` values are filtered out.

- `forEach : (a → ()) → Array a → ()`

    Iterate over an array and apply some function purely for its side effects.

**Querying Arrays**

- `length : Array a → Number`

- `reverse : Array a → Array a`

- `member : a → Array a`

- `any : (a → Boolean) → Array a → Boolean`

    Checks if at least one element in the array satisfies the supplied predicate.

- `all : (a → Boolean) → Array a → Boolean`

    Checks if **all** elements in the array satisfy the supplied predicate.

"""


compare : Html msg
compare =
    makeDoc """
## ren/compare

- `eq : a → a → Boolean`

- `notEq : a → a → Boolean`

- `lt : a → a -> Boolean`

- `lte : a → a -> Boolean`

- `gt : a → a -> Boolean`

- `gte : a → a -> Boolean`

"""


function : Html msg
function =
    makeDoc """
## ren/function

- `always : a → b → a`

- `discard : a → b → b`

- `pipe : a → (a → b) → b`

- `compose : (a → b) -> (b → c) → a → c`

"""


logic : Html msg
logic =
    makeDoc """
## ren/logic

- `and : Boolean → Boolean → Boolean`

- `or : Boolean → Boolean → Boolean`

- `xor : Boolean → Boolean → Boolean`

"""


math : Html msg
math =
    makeDoc """
## ren/math

- `add : Number → Number → Number`
- `add : Number → String → String`
- `add : String → Number → String`
- `add : String → String → String`

- `sub : Number → Number → Number`

- `mul : Number → Number → Number`

- `div : Number → Number → Number`

- `pow : Number → Number → Number`

- `mod : Number → Number → Number`

"""


maybe : Html msg
maybe =
    makeDoc """
## ren/maybe

- `just : a → Maybe a`

- `nothing : Maybe a`

- `map : (a → b) → Maybe a → Maybe b`

- `andThen : (a → Maybe b) → Maybe a → Maybe b`

- `withDefault : a → Maybe a → a`
"""


object : Html msg
object =
    makeDoc """
## ren/object

- `get : String → Object → Maybe a`

- `set : String → a → Object → Object`

- `has : String → Object → Boolean`
"""


promise : Html msg
promise =
    makeDoc """
## ren/promise

- `from : a → Promise e a`

- `fromError : e → Promise e a`

- `andThen : (a → b | Promise e b) → Promise e a → Promise e b`

- `andCatch : (e → x | Promise x a) → Promise e a → Promise x a`
"""
