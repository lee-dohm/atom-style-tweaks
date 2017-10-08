defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias AtomStyleTweaks.Repo

      import AtomStyleTweaks.Factory
      import AtomStyleTweaksWeb.Model.Helpers
      import ESpec.Phoenix.Assertions.Changeset.Helpers
    end
  end

  def controller do
    quote do
      alias AtomStyleTweaksWeb

      import AtomStyleTweaks.Factory
      import AtomStyleTweaksWeb.Router.Helpers
      import AtomStyleTweaksWeb.Conn.Helpers
      import ESpec.Phoenix.Assertions.Conn.Helpers
      import ESpec.Phoenix.Assertions.Content.Helpers

      @endpoint AtomStyleTweaksWeb.Endpoint
    end
  end

  def view do
    quote do
      import AtomStyleTweaksWeb.Router.Helpers
    end
  end

  def channel do
    quote do
      alias AtomStyleTweaks.Repo

      @endpoint AtomStyleTweaksWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
