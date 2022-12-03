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
    |> Stream.map(&rucksack_priority/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_2(input \\ input_list()) do
    input
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&Enum.uniq/1)
    |> Stream.chunk_every(3)
    |> Stream.map(&group_priority/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def group_priority(group) do
    badge_item = Enum.reduce_while(?A..?z, nil, fn item, _acc ->
      if Enum.all?(group, & item in &1),
      do: {:halt, item},
      else: {:cont, nil}
    end)
    item_priority(badge_item)
  end

  def split_evenly(string) do
    string
    |> String.split_at(div(String.length(string), 2))
    |> Tuple.to_list()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.uniq/1)
    |> List.to_tuple()
  end

  defcase item_priority() do
    l when l >= ?a and l <= ?z -> l - ?a + 1
    u when u >= ?A and u <= ?Z -> u - ?A + 27
  end

  def rucksack_priority({lhs, rhs}) do
    for item <- lhs, reduce: 0 do
      sum ->
        if item in rhs do
          prio = item_priority(item)
          # IO.puts "#{[item]} is duplicate with priority #{prio}"
          sum + prio
        else
          sum
        end
    end
  end
end
