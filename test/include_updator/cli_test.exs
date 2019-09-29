defmodule IncludeUpdator.CliTest do
  use ExUnit.Case

  import IncludeUpdator.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "two values returned if two were given" do
    assert parse_args(["root_dir", "5"]) == {"root_dir", 5}
  end

  test "processes count is defaulted if one value was given" do
    assert parse_args(["root_dir"]) == {"root_dir", 4}
  end

end
