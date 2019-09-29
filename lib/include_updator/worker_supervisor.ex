defmodule IncludeUpdator.WorkerSupervisor do

  use DynamicSupervisor

  @ws __MODULE__

  #API
  def start_link(_) do
    DynamicSupervisor.start_link __MODULE__, :no_args, name: @ws
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker do
    {:ok, _pid} = DynamicSupervisor.start_child @ws, IncludeUpdator.Worker
  end

end
