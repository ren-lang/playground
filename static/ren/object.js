// get : Object -> String -> Maybe a
export function get(key) {
    return (obj) => {
        return obj[key] || null
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