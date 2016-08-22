defmodule Casino.Games.Blackjack.TableSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Casino.Games.Blackjack.Table, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_table do
    Supervisor.start_child(Casino.Games.Blackjack.TableSupervisor, [])
  end
end
