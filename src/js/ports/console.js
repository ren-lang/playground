const log = window.console.log
const info = window.console.info
const warn = window.console.warn
const error = window.console.error

const now = () => new Date(Date.now()).toTimeString().substring(0, 8)

export function init({ ports }) {
    window.console.log = (...messages) => {
        log(...messages)

        messages.forEach(message => {
            ports.fromConsole?.send({
                $: 'Log',
                timestamp: now(),
                message: message.toString?.$() || JSON.stringify(message, null, 2)
            })
        })
    }

    window.console.info = (...messages) => {
        info(...messages)

        messages.forEach(message => {
            ports.fromConsole?.send({
                $: 'Info',
                timestamp: now(),
                message: message.toString?.$() || JSON.stringify(message, null, 2)
            })
        })
    }

    window.console.warn = (...messages) => {
        // Very hacky workaround to stop twind-specific error messages from showing
        // up in the on-screen console.
        if (messages[0]?.startsWith("[UNKNOWN_DIRECTIVE]")) return

        warn(...messages)

        messages.forEach(message => {
            ports.fromConsole?.send({
                $: 'Warn',
                timestamp: now(),
                message: message.toString?.$() || JSON.stringify(message, null, 2)
            })
        })
    }

    window.console.error = (...messages) => {
        error(...messages)

        messages.forEach(message => {
            ports.fromConsole?.send({
                $: 'Error',
                timestamp: now(),
                message: message.toString?.$() || JSON.stringify(message, null, 2)
            })
        })
    }

    ports.toConsole?.subscribe(({ $, message }) => {
        window.console[$.toLowerCase()]?.(message)
    })
}