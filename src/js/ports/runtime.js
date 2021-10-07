export function init({ ports }) {
    ports.toJavascript?.subscribe((source = '') => {
        const href = location.href.replace(location.search, '')
        const src = source.replaceAll(/from\s+'(.+)'/g, `from '${href}$1.js\'`)
        const esm = 'data:text/javascript;base64,' + btoa(src)
        console.log(src)
        src && import(esm)
            .then(({ main }) => main && main())
            .then(result => {

                // This super naive RegEx attempts to determine if the provided string
                // might be HTML/XML or not. It's *very* naive and will definitely
                // throw up false positives, but it's fine for now.
                //
                // If it is an HTML string, we ship it off to the playground display
                // for rendering.
                if (result && typeof result === 'string' && /(<([^>]+)>)/i.test(result)) {
                    document.querySelector('#playground-display').innerHTML = result
                } else if (result) {
                    console.log(result)
                }
            })
            .catch(err => {
                window.alert(
                    'Oops, it looks like I ran in to some troubles running your ren '
                    + 'code. Make sure you\'ve defined a public `main` function '
                    + 'for me to run.\n\n'
                    + 'If the problem persists, please open an issue with the code '
                    + 'you tried to run quoting the error below:\n\n'
                    + err.toString() + '\n\n'
                    + 'https://github.com/ren-lang/playground/issues'
                )
            })
    })
}