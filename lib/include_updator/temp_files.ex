defmodule IncludeUpdator.TempFiles do

  use GenServer

  @tf __MODULE__
  @tmp_dir "/tmp"

  defmodule Files do
    defstruct names: [], count: 0
  end

  #API
  def start_link(_) do
    GenServer.start_link __MODULE__, :no_args, name: @tf
  end

  def create_file do
    GenServer.call @tf, :create_file
  end

  def remove_file(name) do
    GenServer.cast @tf, {:remove_file, name}
  end

  #server implementation
  def init(:no_args) do
    {:ok, %Files{}}
  end

  def handle_call(:create_file, _from, %Files{names: names, count: count}) do
    new_count = count + 1
    name = "#{@tmp_dir}/incupdt_tmp_#{new_count}.txt"
    :ok = File.touch!(name)
    {:reply, name, %Files{names: [name | names], count: new_count}}
  end

  def handle_cast({:remove_file, _name}, files = %Files{names: [], count: 0}) do
    {:noreply, files}
  end
  def handle_cast({:remove_file, name}, %Files{names: names, count: count}) do
    File.rm(name)
    {:noreply, %Files{names: List.delete(names, name), count: count - 1}}
  end

  def terminate(_reason, files) do
    files.names
    |> Enum.each(&remove_file/1)
  end

end
