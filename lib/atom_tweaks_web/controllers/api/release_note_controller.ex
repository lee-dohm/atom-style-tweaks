defmodule AtomTweaksWeb.Api.ReleaseNoteController do
  @moduledoc """
  Handles all release notes API routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases

  plug(:authorize, [required_scope: "release_notes/write"] when action in [:create])

  @doc """
  Handles a request to create a release note.

  ## Responses

  * `201 Created` on success
  * `400 Bad Request` on failure
  * `403 Forbidden` if the API token does not contain the `release_notes/write` scope
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
