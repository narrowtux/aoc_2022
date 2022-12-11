defmodule Day10 do
  def example do
    File.stream!("day10.example")
  end

  def input do
    File.stream!("day10.txt")
  end

  def eval(input) do
    check_at = [20, 60, 100, 140, 180, 220]

    input
    |> Enum.map(&String.trim/1)
    |> execute(check_at)
  end

  def execute(operations, check_at, cycle \\ 1, x \\ 1, acc \\ 0)

  def execute([], _, _, _, acc) do
    acc
  end

  def execute([op | rest], check_at, cycle, x, acc) do
    if rem(cycle - 1, 40) in (x - 1)..(x + 1) do
      IO.write("#")
    else
      IO.write(" ")
    end

    if rem(cycle, 40) == 0 do
      IO.write("\n")
    end

    acc = if cycle in check_at do
      acc + cycle * x
    else
      acc
    end

    case op do
      "noop" ->
        execute(rest, check_at, cycle + 1, x, acc)

      "addx " <> int ->
        execute(["ADDX " <> int | rest], check_at, cycle + 1, x, acc)

      "ADDX " <> int ->
        int = String.to_integer(int)
        execute(rest, check_at, cycle + 1, x + int, acc)
    end
  end
end
