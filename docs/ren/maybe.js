// just : a -> Maybe a
export function just(a) {
    return { $: 'just', 0: a }
}

// nothing : Maybe a
export const nothing = { $: 'nothing' }

// map : (a -> b) -> Maybe a -> Maybe b
export function map(f) {
    return (maybe) => {
        switch (maybe.$) {
            case 'just': return just(f(maybe[0]))
            case 'nothing': return nothing
        }
    }
}

// andThen : (a -> Maybe b) -> Maybe a -> Maybe b
export function andThen(f) {
    return (maybe) => {
        switch (maybe.$) {
            case 'just': return f(maybe[0])
            case 'nothing': return nothing
        }
    }
}

// withDefault : a -> Maybe a -> a
export function withDefault(a) {
    return (maybe) => {
        switch (maybe.$) {
            case 'just': return maybe[0]
            case 'nothing': return a
        }
    }
}