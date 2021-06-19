// andThen : (a -> b) -> Promise e a -> Promise e b
export function andThen(f) {
    return (promise) => {
        return promise.then(f)
    }
}


// andCatch (e -> x) -> Promise e a -> Promise x a
export function andCatch(f) {
    return promise => {
        return promise.catch(f)
    }
}