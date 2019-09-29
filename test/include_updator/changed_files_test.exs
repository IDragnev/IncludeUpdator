defmodule IncludeUpdator.ChandgedFilesTest do
  use ExUnit.Case

  alias IncludeUpdator.ChangedFiles, as: ICF

  test "adding a file" do
    filenames = sample_filenames()
    filenames |> Enum.each(&ICF.add_filename/1)
    assert filenames |> Enum.all?(& &1 in ICF.filenames())
  end

  defp sample_filenames do
    1..10 |> Enum.map(&to_string(&1))
  end

end
