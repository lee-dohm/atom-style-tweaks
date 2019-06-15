defmodule AtomTweaksWeb.Api.ReleaseNotesController do
  @moduledoc """
  Handles all release notes API routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases

  @doc """
  Handles a request to create a release note.

  On success, returns a `201 Created` status with an empty body.

  On failure, returns a `401 Bad Request` status with an empty body.
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
