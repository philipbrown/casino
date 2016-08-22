defmodule Casino.Games.Blackjack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      supervisor(Casino.Games.Blackjack.TableSupervisor, []),
      worker(Casino.Games.Blackjack.Server, [4])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
