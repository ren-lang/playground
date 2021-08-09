// from : a -> Promise e a
export function from(a) {
    return Promise.resolve(a)
}

// fromError : e -> Promise e a
export function fromError(e) {
    return Promise.reject(e)
}

// andThen : (a -> Promise e b) -> Promise e a -> Promise e b
export function andThen(f) {
    return (promise) => {
        return promise.then(f)
    }
}


// andCatch : (e -> x) -> Promise e a -> Promise x a
export function andCatch(f) {
    return promise => {
        return promise.catch(f)
    }
}
