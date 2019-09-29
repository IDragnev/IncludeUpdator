defmodule IncludeUpdator.DirIterator do

  use GenServer

  @di __MODULE__

  #API
  def start_link(root_dir) do
    GenServer.start_link __MODULE__, root_dir, name: @di
  end

  def next_filename do
    GenServer.call @di, :next_filename
  end

  #server implementation
  def init(root_dir) do
    DirWalker.start_link root_dir, matching: ~r{^.*\.(cpp|hpp)$}
  end

  def handle_call(:next_filename, _from, dir_iterator) do
    result = case DirWalker.next(dir_iterator) do
      [filename] -> filename
      other      -> other
    end
    {:reply, result, dir_iterator}
  end

end
