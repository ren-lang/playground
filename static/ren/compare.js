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

// lt : a -> b -> Boolean
export function lt(a) {
    return (b) => {
        return a < b
    }
}

// lte : a -> b -> Boolean
export function lte(a) {
    return (b) => {
        return a <= b
    }
}

// gt : a -> b -> Boolean
export function gt(a) {
    return (b) => {
        return a > b
    }
}

// gte : a -> b -> Boolean
export function gte(a) {
    return (b) => {
        return a >= b
    }
}