// andThen : (a -> b) -> Promise e a -> Promise e b
export function andThen(f) {
    return (promise) => {
        return promise.then(f)
    }
}
