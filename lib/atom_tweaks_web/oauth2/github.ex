defmodule AtomTweaksWeb.GitHub do
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy

  alias AtomTweaksWeb.GitHub

  # Public API

  def client do
    config()
    |> OAuth2.Client.new()
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), Keyword.merge(params, scope: config(:scope) || ""))
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp config do
    Keyword.merge(default_config(), Application.get_env(:atom_tweaks, GitHub) || [])
  end

  defp config(key), do: Keyword.get(config(), key)

  defp default_config do
    [
      strategy: __MODULE__,
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token",
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      redirect_uri: System.get_env("GITHUB_REDIRECT_URI")
    ]
  end
end
