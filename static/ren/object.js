import * as Maybe from './maybe.js'

// get : String -> Object -> Maybe a
export function get(key) {
    return (obj) => {
        return key in obj
            ? Maybe.just(obj[key])
            : Maybe.nothing
    }
}

// set : String -> a -> Object -> Object
export function set(key) {
    return (a) => (obj) => {
        return { ...obj, [key]: a }
    }
}

// has : String -> Object -> Boolean
export function has(key) {
    return (obj) => {
        return key in obj
    }
}

// construct : (Array a -> Object) -> Array a -> Object
export function construct(obj) {
    return (params) => {
        return new obj(...params)
    }
}