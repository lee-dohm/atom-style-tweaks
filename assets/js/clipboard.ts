import * as Clipboard from 'clipboard'

let clipboard = new Clipboard('#copy-button')

clipboard.on('success', (e: Clipboard.Event) => e.clearSelection())
