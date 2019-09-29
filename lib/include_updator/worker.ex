defmodule IncludeUpdator.Worker do

  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link __MODULE__, :no_args
  end

  def init(:no_args) do
    Process.send_after(self(), :process_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:process_one_file, _) do
    IncludeUpdator.DirIterator.next_filename()
    |> process_filename()
  end

  defp process_filename(nil) do
    IncludeUpdator.Gatherer.worker_done()
    {:stop, :normal, nil}
  end
  defp process_filename(filename) do
    update_include_directives(filename)
    IncludeUpdator.Gatherer.add_filename(filename)
    send(self(), :process_one_file)
    {:noreply, nil}
  end

  defp update_include_directives(filename) do
    alias IncludeUpdator.TempFiles
    temp_file_name = TempFiles.create_file()
    write_updated(filename, temp_file_name)
    File.copy(temp_file_name, filename)
    TempFiles.remove_file(temp_file_name)
  end

  defp write_updated(from, to) do
    dest = File.open!(to, [:write])
    File.stream!(from)
    |> Stream.map(&update_line/1)
    |> Enum.each(&IO.write(dest, &1))
    File.close(dest)
  end

  defp update_line(line) do
    if is_outdated_include_directive(line) do
      line
      |> String.trim
      |> String.trim_trailing("\"")
      |> String.trim_trailing
      |> Kernel.<>("pp\"\n")
    else
      line
    end
  end

  defp is_outdated_include_directive(line) do
    Regex.match?(~r{^\h*#include\h+\".*\.h\h*\"\h*$}, line)
  end
end
