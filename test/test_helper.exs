{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AtomTweaks.Repo, :manual)
