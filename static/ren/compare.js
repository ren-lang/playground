// eq : a -> a -> Boolean
export function eq(a) {
    return (b) => {
        return a == b
    }
}

// notEq : a -> a -> Boolean
export function notEq(a) {
    return (b) => {
        return a != b
    }
}

// lt : a -> a -> Boolean
export function lt(a) {
    return (b) => {
        return a < b
    }
}

// lte : a -> a -> Boolean
export function lte(a) {
    return (b) => {
        return a <= b
    }
}

// gt : a -> a -> Boolean
export function gt(a) {
    return (b) => {
        return a > b
    }
}

// gte : a -> a -> Boolean
export function gte(a) {
    return (b) => {
        return a >= b
    }
}