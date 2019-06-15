defmodule AtomTweaksWeb.Api.ReleaseNotesController do
  @moduledoc """
  Handles all release notes API routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases

  @doc """
  Handles a request to create a release note.
  """
  @spec create(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, params) do
    case Releases.create_note(params) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> render("empty.json")

      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> render("empty.json")
    end
  end
end
