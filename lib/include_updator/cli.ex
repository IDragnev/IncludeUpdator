defmodule IncludeUpdator.CLI do

    @processes_count 4

    def main(argv) do
        argv
        |> parse_args()
        |> process_args()
    end

    def parse_args(argv) do
        argv
        |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
        |> args_to_internal_representation
    end

    defp args_to_internal_representation({[h: true], _args, _invalid}) do
        :help
    end
    defp args_to_internal_representation({[help: true], _args, _invalid}) do
        :help
    end
    defp args_to_internal_representation({[], [root_dir], _invalid}) do
        {root_dir, @processes_count}
    end
    defp args_to_internal_representation({[], [root_dir, processes_count], _invalid}) do
        {root_dir, String.to_integer(processes_count)}
    end
    defp args_to_internal_representation(_) do
        :help
    end

    defp process_args(:help) do
        IO.puts """
        usage: include_updator <root_dir> [processes_count | #{@processes_count}]
        """
        System.halt(0)
    end
    defp process_args({root_dir, workers_count}) do
        IncludeUpdator.Application.start(root_dir, workers_count)
    end

end
