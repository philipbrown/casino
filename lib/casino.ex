defmodule Casino do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
       supervisor(Casino.PlayersSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Casino.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
