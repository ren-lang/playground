import './components/codeflask-editor.js'
import { Elm } from '../elm/Main.elm'
import * as ESM from './esm.js'

const params = new URLSearchParams(window.location.search)
const code = params.has('code') ? decodeURI(params.get('code')) : null

const app = Elm.Main.init({
    node: document.querySelector('[data-elm-container]'),
    flags: {
        code
    }
})

const log = window.console.log
window.console.log = function (...messages) {
    log(...messages)
    const time = new Date(Date.now()).toTimeString().substring(0, 8)

    messages.forEach(message => {
        app.ports.toConsole?.send(
            [`[${time}]`, JSON.stringify(message, null, 2)
                || message.toString?.()
                || ""
            ]
        )
    })
}

app.ports.toClipboard?.subscribe(source => {
    const code = encodeURI(source)
    const uri = location.href.replace(location.search, '') + `?code=${code}`

    navigator.clipboard.writeText(uri)
        .then()
        .catch(console.err)
})

app.ports.toJavascript?.subscribe(source => {
    const href = location.href.replace(location.search, '')
    // This fixes some weird quirk to do with relative imports. I'm not sure it's
    // entirely necessary but I was deep in the weeds trying to work out why imports
    // weren't working and this was one of a few things I tried that seemed to 
    // work.
    const modifiedSource = source.replaceAll(/ren\/(.+)'/g, href + 'ren/$1.js\'')

    source && import(ESM.toDataURI`${modifiedSource}`)
        .then(({ main }) => {
            const result = main && main() || undefined

            if (result) {
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

