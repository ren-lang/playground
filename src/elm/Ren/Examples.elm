module Ren.Examples exposing (..)


bottlesOfBeer : String
bottlesOfBeer =
    """import 'ren/array' as Array exposing { forEach }

pub fun main = _ =>  {
    fun makeVerses = n => if n >= 0 then verse n :: makeVerses (n - 1) else []
    let verses = makeVerses 20

    ret verses 
        |> forEach console.log 
}

fun verse = n => when n
    is 0 =>
        'No more bottles of beer on the wall, no more bottles of beer. ' +
        'Go to the store and buy some more, 99 bottles of beer on the wall.'
    is _ if n > 0 =>
        `${bottles n} of beer on the wall, ${bottles n} of beer. ` +
        `Take one down and pass it around, ${bottles (n - 1)} of beer on the wall.`

fun bottles = n => when n
    is 0 => 'no more bottles'
    is 1 => '1 bottle'
    else => `${n} bottles`
"""
