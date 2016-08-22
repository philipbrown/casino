defmodule Casino.Players.Player do
  def start_link(balance) do
    Agent.start_link(fn -> balance end, [])
  end

  @doc """
  Check the balance
  """
  def balance(pid) do
    Agent.get(pid, &(&1))
  end

  @doc """
  Deposit more money
  """
  def deposit(pid, amount) do
    Agent.update(pid, &(&1 + amount))
  end

  @doc """
  Place a bet
  """
  def bet(pid, amount) do
    Agent.update(pid, &(&1 - amount))
  end
end
