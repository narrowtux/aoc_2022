defmodule Day4 do
  def solve(input, fun) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Stream.flat_map(&String.split(&1, ~r/[,-]/))
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Stream.map(&apply(Range, :new, &1))
    |> Stream.chunk_every(2)
    |> Enum.count(&apply(fun, &1))
  end

  def part_1(input \\ File.stream!("./day4.txt")) do
    solve(input, &(subset?(&1, &2) or subset?(&2, &1)))
  end

  def part_2(input \\ File.stream!("./day4.txt")) do
    solve(input, &(not Range.disjoint?(&1, &2)))
  end

  def subset?(f1..t1, f2..t2) do
    f2 >= f1 and f2 <= t1 and t2 >= f1 and t2 <= t1
  end

  def example do
    """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
    |> String.split("\n")
  end
end
