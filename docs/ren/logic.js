// and : Boolean -> Boolean -> Boolean
export function and(a) {
    return (b) => {
        return a && b
    }
}

// or : Boolean -> Boolean -> Boolean
export function or(a) {
    return (b) => {
        return a || b
    }
}

// xor : Boolean -> Boolean -> Boolean
export function xor(a) {
    return (b) => {
        return a ? !b : b
    }
}