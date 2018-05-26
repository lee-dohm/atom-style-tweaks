defmodule AtomStyleTweaksWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use AtomStyleTweaks.Web, :controller
      use AtomStyleTweaks.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      alias AtomStyleTweaks.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: AtomStyleTweaksWeb

      alias AtomStyleTweaks.Repo
      import Ecto
      import Ecto.Query

      import AtomStyleTweaksWeb.Router.Helpers
      import AtomStyleTweaksWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/atom_style_tweaks_web/templates",
        namespace: AtomStyleTweaksWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Built-in view helpers
      import AtomStyleTweaksWeb.Router.Helpers
      import AtomStyleTweaksWeb.ErrorHelpers
      import AtomStyleTweaksWeb.Gettext

      # Project-specific view helpers
      import PhoenixOcticons

      import AtomStyleTweaksWeb.AvatarHelpers
      import AtomStyleTweaksWeb.FormHelpers
      import AtomStyleTweaksWeb.MenuHelpers
      import AtomStyleTweaksWeb.OcticonHelpers
      import AtomStyleTweaksWeb.RenderHelpers
      import AtomStyleTweaksWeb.TimeHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias AtomStyleTweaks.Repo
      import Ecto
      import Ecto.Query
      import AtomStyleTweaksWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
