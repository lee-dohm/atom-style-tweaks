import * as Clipboard from 'clipboard'

const clipboard = new Clipboard('#copy-button')

clipboard.on('success', (e: Clipboard.Event) => e.clearSelection())
