defmodule WalkDirectory do
  def recursive(dir, func) do
    Enum.each(File.ls!(dir), fn file ->
      path = Path.join(dir, file)

      if File.dir?(path), do: recursive(path, func), else: func.(path)
    end)
  end
end

Code.require_file("spec/espec_phoenix_extend.ex")
WalkDirectory.recursive("spec/support", fn(path) -> Code.require_file(path) end)

Ecto.Adapters.SQL.Sandbox.mode(AtomStyleTweaks.Repo, :manual)
