module Ren.Examples exposing (..)


helloworld : String
helloworld =
    String.trim """
pub fun main = _ =>
  console.log 'Hello world!'
"""



--------------------------------------------------------------------------------


letExample : String
letExample =
    String.trim """
pub let n = 10

pub let { x, y } = { x: 10.5, y: 7 }

pub let [ a, b ] = [ 'foo', 'bar' ]

pub let complexValue = {
  let m = 2.25
  ret n ^ m
}
"""


funExample : String
funExample =
    String.trim """
pub fun mul = x y => x * y

pub fun double = x => {
  let n = 2
  ret mul x n
}
"""


primitivesExample : String
primitivesExample =
    String.trim """
pub let numbers = {
  let ints = 1234
  let floats = 0.56789
  let hex = 0xEEE
  let oct = 0o567
  let bin = 0b110011

  ret ints + floats + hex + oct + bin
}

pub let strings = {
  let singleQuotes = 'superior character'
  let doubleQuotes = "rubbish character"

  ret singleQuotes + doubleQuotes
}

pub let booleans = {
    let t = true
    let f = false

    ret t || f
}

pub let objects = {
  foo: 'foo',
  bar: 1337,
  numbers,
  strings
}

pub let arrays = [
    numbers, strings, objects
]

pub let lambdas = 
  fun x y => x * y
"""
