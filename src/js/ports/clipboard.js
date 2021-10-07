export function init({ ports }) {
    ports.toClipboard?.subscribe(source => {
        const code = encodeURI(source)
        const uri = location.href.replace(location.search, '') + `?code=${code}`

        navigator.clipboard.writeText(uri)
            .catch(() => {
                const editor = document.querySelector('#ren')

                editor.select()
                document.execCommand('copy')
            })
    })
}