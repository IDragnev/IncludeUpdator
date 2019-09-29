defmodule IncludeUpdator.ChangedFiles do

  use GenServer

  @cf __MODULE__

  #API

  def start_link(_) do
    GenServer.start_link __MODULE__, :no_args, name: @cf
  end

  def add_filename(filename) do
    GenServer.cast @cf, {:add_filename, filename}
  end

  def filenames do
    GenServer.call @cf, :get_filenames
  end

  #server implementation
  def init(:no_args) do
    {:ok, _filenames = []}
  end

  def handle_cast({:add_filename, filename}, filenames) do
    {:noreply, [filename | filenames]}
  end

  def handle_call(:get_filenames, _from, filenames) do
    {:reply, filenames, filenames}
  end

end
