defmodule Day11 do
  alias __MODULE__.{Parser, Monkey}
  def iteration(remaining_monkeys, iterated_monkeys \\ [], divisor \\ nil)

  def iteration(monkeys, [], nil) do
    divisor = Enum.map(monkeys, & &1.test) |> Enum.product()
    iteration(monkeys, [], divisor)
  end

  def iteration([], iterated_monkeys, _) do
    Enum.reverse(iterated_monkeys)
  end

  def iteration([monkey | rest], iterated_monkeys, divisor) do

    {monkey, throws} = Monkey.iteration(monkey, divisor)

    rest = Enum.map(rest, &apply_throws(&1, throws))
    iterated_monkeys = Enum.map(iterated_monkeys, &apply_throws(&1, throws))

    iteration(rest, [monkey | iterated_monkeys], divisor)
  end

  def apply_throws(monkey, throws) do
    Enum.reduce(throws, monkey, fn {throw_to, worry_level}, monkey ->
      if monkey.monkey_id == throw_to do
        Map.update!(monkey, :items, &[worry_level | &1])
      else
        monkey
      end
    end)
  end

  def example do
    """
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    """
    |> String.split("\n")
    |> Parser.parse()
  end

  def input() do
    "day11.txt"
    |> File.stream!()
    |> Parser.parse()
  end

  def iterate_times(monkeys, n, iteration \\ 1)

  def iterate_times(monkeys, 0, _) do
    monkeys
  end

  def iterate_times(monkeys, n, iter) do
    # IO.puts("Iteration #{iter}")
    new_monkeys = iteration(monkeys)
    # [top_1, top_2] = new_monkeys |> Enum.map(& &1.inspections) |> Enum.sort(:desc) |> Enum.take(2)
    # IO.puts("  #{top_1}, #{top_2}")

    iterate_times(new_monkeys, n - 1, iter + 1)
  end
end
