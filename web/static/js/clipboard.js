import Clipboard from 'clipboard'

let clipboard = new Clipboard('#copy-button')

clipboard.on('success', e => e.clearSelection())
