defmodule IncludeUpdator.Application do

  def start(root_dir, processes_count) do
    children = [
      IncludeUpdator.ChangedFiles,
      IncludeUpdator.TempFiles,
      {IncludeUpdator.DirIterator, root_dir},
      IncludeUpdator.WorkerSupervisor,
      {IncludeUpdator.Gatherer, processes_count}
    ]
    opts = [
      strategy: :one_for_all,
      name: IncludeUpdator.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end

end
