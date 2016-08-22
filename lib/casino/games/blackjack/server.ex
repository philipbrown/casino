defmodule Casino.Games.Blackjack.Server do
  use GenServer

  # Client

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Add a new table
  """
  def add_table(count \\ 1) do
    GenServer.cast(__MODULE__, {:add, count})
  end

  @doc """
  Remove an existing table
  """
  def remove_table do
    GenServer.cast(__MODULE__, {:remove})
  end

  @doc """
  Return the count of active tables
  """
  def count_tables do
    GenServer.call(__MODULE__, {:count})
  end

  # Server

  def init(state) do
    send(self, {:start})

    {:ok, state}
  end

  def handle_cast({:add, count}, state) do
    open_table(count)

    {:noreply, state + count}
  end

  def handle_cast({:remove}, state) do
    close_table(state)

    {:noreply, state}
  end

  def handle_call({:count}, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:start}, state) do
    open_table(state)

    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state - 1}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # Helpers

  defp open_table(n) when is_number(n) and n <= 1 do
    start_table
  end
  defp open_table(n) when is_number(n) do
    start_table
    open_table(n - 1)
  end

  defp start_table do
    {:ok, pid} = Casino.Games.Blackjack.TableSupervisor.start_table

    Process.monitor(pid)
  end

  defp close_table(state) when state == 0, do: 0
  defp close_table(state) when is_number(state) do
    Supervisor.which_children(Casino.Games.Blackjack.TableSupervisor)
      |> List.last
      |> close_table

      state
  end
  defp close_table({_, pid, _, _}) when is_pid(pid) do
    Supervisor.terminate_child(Casino.Games.Blackjack.TableSupervisor, pid)
  end
end
