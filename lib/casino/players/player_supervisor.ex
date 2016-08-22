defmodule Casino.Players.PlayerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Casino.Players.Player, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def new_player(balance) do
    Supervisor.start_child(Casino.Players.PlayerSupervisor, [balance])
  end
end
