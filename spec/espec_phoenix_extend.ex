defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias AtomStyleTweaks.Repo
    end
  end

  def controller do
    quote do
      alias AtomStyleTweaksWeb
      import AtomStyleTweaksWeb.Router.Helpers

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
