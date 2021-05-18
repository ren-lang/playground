// add : Number -> Number -> Number
// add : Number -> String -> String
// add : String -> Number -> String
// add : String -> String -> String
export function add(x) {
    return (y) => {
        return x + y
    }
}

// sub : Number -> Number -> Number
export function sub(x) {
    return (y) => {
        return x - y
    }
}

// mul : Number -> Number -> Number
export function mul(x) {
    return (y) => {
        return x * y
    }
}

// div : Number -> Number -> Number
export function div(x) {
    return (y) => {
        return x / y
    }
}

// pow : Number -> Number -> Number
export function pow(x) {
    return (y) => {
        return x ** y
    }
}

// mod : Number -> Number -> Number
export function mod(x) {
    return (y) => {
        return x % y
    }
}