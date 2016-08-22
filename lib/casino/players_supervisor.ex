defmodule Casino.PlayersSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Casino.Players.Server, []),
      supervisor(Casino.Players.PlayerSupervisor, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
