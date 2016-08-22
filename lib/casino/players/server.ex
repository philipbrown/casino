defmodule Casino.Players.Server do
  use GenServer

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Add a new player and their starting balance
  """
  def add(name, balance) when is_binary(name) and is_number(balance) do
    GenServer.cast(__MODULE__, {:add, name, balance})
  end

  @doc """
  Remove a player by their id
  """
  def remove(id) do
    GenServer.cast(__MODULE__, {:remove, id})
  end

  @doc """
  Return all the players as a list
  """
  def list do
    GenServer.call(__MODULE__, {:list})
  end

  # Server

  def init(:ok) do
    players = %{}
    refs    = %{}
    {:ok, {players, refs}}
  end

  def handle_cast({:add, name, balance}, {players, refs}) do
    {:ok, pid} = Casino.Players.PlayerSupervisor.new_player(balance)
    ref = Process.monitor(pid)
    id = auto_increment(players)
    refs = Map.put(refs, ref, id)
    players = Map.put(players, id, {name, pid, ref})
    {:noreply, {players, refs}}
  end

  def handle_cast({:remove, id}, {players, refs}) do
    {{_name, pid, _ref}, players} = Map.pop(players, id)

    Process.exit(pid, :kill)

    {:noreply, {players, refs}}
  end

  def handle_call({:list}, _from, {players, _refs} = state) do
    list = Enum.map(players, fn {id, {name, pid, _ref}} ->
      %{id: id, name: name, balance: Casino.Players.Player.balance(pid)}
    end)

    {:reply, list, state}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {players, refs}) do
    {id, refs} = Map.pop(refs, ref)
    players = Map.delete(players, id)
    {:noreply, {players, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # Helpers

  defp auto_increment(map) when map == %{}, do: 1
  defp auto_increment(players) do
    Map.keys(players)
      |> List.last
      |> Kernel.+(1)
  end
end
