Code.require_file("spec/phoenix_helper.exs")

ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AtomStyleTweaks.Repo)
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(AtomStyleTweaks.Repo, [])
  end
end

{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)
{:ok, _} = Application.ensure_all_started(:ex_machina)
