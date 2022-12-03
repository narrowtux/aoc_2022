defmodule Day3 do
  import Macros

  def example do
    """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
  end

  def input_list() do
    "./day3.txt"
    |> File.stream!()
  end

  def part_1(input \\ input_list()) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&split_evenly/1)
    |> Stream.flat_map(&apply(MapSet, :intersection, &1))
    |> Stream.map(&item_priority/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_2(input \\ input_list()) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&MapSet.new/1)
    |> Stream.chunk_every(3)
    |> Stream.flat_map(fn sets -> Enum.reduce(sets, &MapSet.intersection/2) end)
    |> Stream.map(&item_priority/1)
    |> Enum.sum()
  end

  def split_evenly(string) do
    string
    |> String.split_at(div(String.length(string), 2))
    |> Tuple.to_list()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
  end

  defcase item_priority() do
    l when l >= ?a and l <= ?z -> l - ?a + 1
    u when u >= ?A and u <= ?Z -> u - ?A + 27
  end
end
