import_file_if_available "~/.iex.exs"

use Phoenix.HTML

import Ecto.Query
import Phoenix.HTML.Safe, only: [to_iodata: 1]

alias AtomTweaks.Accounts
alias AtomTweaks.Accounts.User
alias AtomTweaks.Repo
alias AtomTweaks.Tweaks
alias AtomTweaks.Tweaks.Star
alias AtomTweaks.Tweaks.Tweak
