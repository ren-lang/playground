// join : String -> Array String -> String
export function join(separator) {
    return (strings) => {
        return strings.join(separator)
    }
}