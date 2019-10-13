defmodule IncludeUpdator.Gatherer do

  use GenServer

  @gatherer __MODULE__

  #API
  def start_link(workers_count) do
    GenServer.start_link __MODULE__, workers_count, name: @gatherer
  end
  def worker_done do
    GenServer.cast @gatherer, :worker_done
  end
  def add_filename(filename) do
    GenServer.cast @gatherer, {:add_filename, filename}
  end

  #server implementation
  def init(workers_count) do
    {:ok, workers_count, {:continue, :kickoff}}
  end

  def handle_continue(:kickoff, workers_count) do
    alias IncludeUpdator.WorkerSupervisor
    1..workers_count
    |> Enum.each(fn _ -> WorkerSupervisor.add_worker() end)
    {:noreply, workers_count}
  end

  def handle_cast(:worker_done, _workers_count = 1) do
    list_changed_files()
    System.halt(0)
  end
  def handle_cast(:worker_done, workers_count) do
    {:noreply, workers_count - 1}
  end
  def handle_cast({:add_filename, filename}, workers_count) do
    IncludeUpdator.ChangedFiles.add_filename filename
    {:noreply, workers_count}
  end

  defp list_changed_files do
    IO.puts "\nChanged files:"
    IncludeUpdator.ChangedFiles.filenames()
    |> Enum.each(&IO.puts/1)
  end

end
