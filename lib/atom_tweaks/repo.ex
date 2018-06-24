defmodule AtomTweaks.Repo do
  @moduledoc """
  Defines the Atom Tweaks database repository.

  ## Shared options

  Almost all of the repository operations below accept the following options:

  * `:timeout` - The time in milliseconds to wait for the query call to finish, `:infinity` will
    wait indefinitely (default: 15000);
  * `:pool_timeout` - The time in milliseconds to wait for calls to the pool to finish, `:infinity`
    will wait indefinitely (default: 5000);
  * `:log` - When false, does not log the query

  Such cases will be explicitly documented as well as any extra options.
  """
  use Ecto.Repo, otp_app: :atom_tweaks
end
