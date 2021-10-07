import * as CodeFlask from './web-components/codeflask.js'
import * as Console from './ports/console.js'
import * as Clipboard from './ports/clipboard.js'
import * as Runtime from './ports/runtime.js'
import { Elm } from '../elm/Main.elm'

CodeFlask.register('code-editor')

const params = new URLSearchParams(window.location.search)
const code = params.has('code') ? decodeURI(params.get('code')) : null

const app = Elm.Main.init({
    node: document.querySelector('[data-elm-container]'),
    flags: {
        code
    }
})

Console.init(app)
Clipboard.init(app)
Runtime.init(app)