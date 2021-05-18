export function toDataURI(templateStrings, ...substitutions) {
    let js = templateStrings.raw[0];
    for (let i = 0; i < substitutions.length; i++) {
        js += substitutions[i] + templateStrings.raw[i + 1];
    }
    return 'data:text/javascript;base64,' + btoa(js);
}