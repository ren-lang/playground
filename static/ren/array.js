// CREATING ARRAYS -------------------------------------------------------------
// singleton : a -> Array a
export function singleton(a) {
    return [a]
}

// repeat : Number -> a -> Array a
export function repeat(length) {
    return (a) => {
        return Array.from({ length }, _ => a)
    }
}

// range : Number -> Number -> Array Number
export function range(start) {
    return (length) => {
        return Array.from({ length }, (_, i) => i + start)
    }
}

// cons : a -> Array a -> Array a
export function cons(head) {
    return (tail) => {
        return [head, ...tail]
    }
}

// join : Array a -> Array a -> Array a
export function join(xs) {
    return (ys) => {
        return [...xs, ...ys]
    }
}

// TRANSFORMING ARRAYS ---------------------------------------------------------
// map : (a -> b) -> Array a -> Array b
export function map(f) {
    return (arr) => {
        return arr.map(f)
    }
}

// indexedMap : (Number -> a -> b) -> Array a -> Array b
export function indexedMap(f) {
    return (arr) => {
        return arr.map((x, i) => f(i)(x))
    }
}

// foldl : (b -> a -> b) -> b -> Array a -> b
export function foldl(f) {
    return (a) => (arr) => {
        arr.reduce(f, a)
    }
}

// foldr : (b -> a -> b) -> b -> Array a -> b
export function foldr(f) {
    return (a) => (arr) => {
        return arr.reduceRight(f, a)
    }
}

// filter : (a -> Boolean) -> Array a -> Array a
export function filter(f) {
    return (arr) => {
        arr.filter(f)
    }
}

// filterMap : (a -> Maybe b) -> Array a -> Array b
export function filterMap(f) {
    return (arr) => {
        arr.reduceRight((xs, x) => {
            const y = f(x)
            return y ? [y, ...xs] : xs
        }, [])
    }
}

// forEach : (a -> ()) -> Array a -> ()
export function forEach(f) {
    return (arr) => {
        arr.forEach(a => f(a))
    }
}

// UTILS -----------------------------------------------------------------------
// length : Array a -> Number
export function length(arr) {
    return arr.length
}

// reverse : Array a -> Array a
export function reverse(arr) {
    return [...arr].reverse()
}

// member : a -> Array a
export function member(a) {
    return (arr) => {
        return arr.includes(a)
    }
}

// any : (a -> Boolean) -> Array a -> Boolean
export function any(f) {
    return (arr) => {
        return arr.some(f)
    }
}

// all : (a -> Boolean) -> Array a -> Boolean
export function all(f) {
    return (arr) => {
        return arr.every(f)
    }
}
