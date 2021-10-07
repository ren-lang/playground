// eq : a -> a -> Boolean
export function eq(x) {
    // Thanks (for nothing) Louis ❤️
    return (y) => {
        let values = [x, y]

        while (values.length !== 0) {
            const a = values.pop()
            const b = values.pop()

            // Short circuit reference check to save us the effort when things 
            // are identical
            if (a === b) continue
            // Null is a bitch and pretends to be an object when you typeof
            // check it, but then functions like Object.getOwnPropertyNames
            // will fail because null isn't actually an object. 
            if (a === null || a === undefined || b === null || b === undefined) return false

            // Onward with the structural check
            if (typeof a === 'object' || typeof b === 'object') {
                // Handles mental scenarios like using `new` to create numbers.
                // Maybe this incurs a horrendous performance cost on non-primative
                // objects, no idea.
                if (a.valueOf() === b.valueOf()) continue

                // Catches things like comparing an Array to an Object or comparing
                // instances of two different classes.
                if (a.constructor !== b.constructor) return false

                // We know the constructors are equal at this point, if they're
                // dates we can do this nifty date equality check. 
                if (a.constructor === Date) {
                    if (!(a > b || a < b)) {
                        continue
                    } else {
                        return false
                    }
                }

                // The `TypedArray` prototype is hidden from us mere mortals but
                // hooray for ducktyping, we can still work out whether what we
                // have is a Uint8Array or Float32Array or whatever.
                if (a.buffer instanceof ArrayBuffer && a.BYTES_PER_ELEMENT) {
                    if (a.length === b.length && a.every((n, i) => n === b[i])) {
                        continue
                    } else {
                        return false
                    }
                }

                for (const k of Object.getOwnPropertyNames(a)) {
                    values.push(a[k], b[k])
                }

                continue
            }

            // Either `a` or `b` weren't objects which at this point means the
            // only things left are primitives, bigint, and function.
            //
            // They didn't satisfy the initial strict equality check so they
            // can't be equal.
            return false
        }

        return true
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
