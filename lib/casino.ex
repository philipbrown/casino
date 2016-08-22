defmodule Casino do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Casino.PlayersSupervisor, []),
      supervisor(Casino.GamesSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Casino.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def add_player(name, balance) do
    Casino.Players.Server.add(name, balance)
  end

  def remove_player(id) do
    Casino.Players.Server.remove(id)
  end

  def list_players do
    Casino.Players.Server.list
  end

  def add_blackjack_table(count \\ 1) do
    Casino.Games.Blackjack.Server.add_table(count)
  end

  def remove_blackjack_table do
    Casino.Games.Blackjack.Server.remove_table
  end

  def count_blackjack_tables do
    Casino.Games.Blackjack.Server.count_tables
  end
end
