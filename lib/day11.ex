defmodule Day11 do
  defmodule Monkey do
    defstruct [:monkey_id, :items, :operation, :test, :test_true, :test_false, inspections: 0]
    @type worry_level :: integer
    @type operator :: :* | :+
    @type operand :: integer | :old
    @type monkey_id :: integer
    @type t :: %__MODULE__{
            monkey_id: monkey_id,
            items: [worry_level],
            operation: {operator, operand, operand},
            test: integer,
            test_true: monkey_id,
            test_false: monkey_id,
            inspections: integer
          }

    def example do
      %__MODULE__{
        monkey_id: 3,
        items: [79, 98],
        operation: {:*, :old, 19},
        test: 23,
        test_true: 2,
        test_false: 3,
        inspections: 0
      }
    end

    @spec iteration(t) :: {t, [{monkey_id, worry_level}]}
    def iteration(monkey) do
      inspections = length(monkey.items) + monkey.inspections

      throws =
        monkey.items
        |> Stream.map(&eval_op(monkey.operation, &1))
        # |> Stream.map(&div(&1, 3))
        |> Enum.map(fn level ->
          monkey_id =
            if rem(level, monkey.test) == 0,
              do: monkey.test_true,
              else: monkey.test_false

          {monkey_id, level}
        end)

      {%{monkey | items: [], inspections: inspections}, throws}
    end

    def eval_op({:+, lhs, rhs}, worry_level) do
      eval_lit(lhs, worry_level) + eval_lit(rhs, worry_level)
    end

    def eval_op({:*, lhs, rhs}, worry_level) do
      eval_lit(lhs, worry_level) * eval_lit(rhs, worry_level)
    end

    def eval_lit(:old, worry_level), do: worry_level
    def eval_lit(int, _worry_level) when is_integer(int), do: int
  end

  defmodule Parser do
    alias Day11.Monkey

    def token("Monkey " <> rest) do
      int_token(:monkey_id, rest)
    end

    def token("  Starting items: " <> rest) do
      items =
        rest
        |> String.trim()
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)

      {:items, items}
    end

    def token("  Operation: new = " <> rest) do
      [lhs, op, rhs] =
        rest
        |> String.trim()
        |> String.split(" ")
        |> Enum.map(fn
          "old" -> :old
          "+" -> :+
          "*" -> :*
          int -> String.to_integer(int)
        end)

      {:operation, {op, lhs, rhs}}
    end

    def token("  Test: divisible by " <> rest) do
      int_token(:test, rest)
    end

    def token("    If true: throw to monkey " <> rest) do
      int_token(:test_true, rest)
    end

    def token("    If false: throw to monkey " <> rest) do
      int_token(:test_false, rest)
    end

    def token("\n"), do: :skip

    def token(""), do: :skip

    def parse(stream) do
      stream
      |> Stream.map(&token/1)
      |> Enum.reduce([], fn
        {:monkey_id, id}, monkeys ->
          [%Monkey{monkey_id: id} | monkeys]

        {k, v}, [monkey | monkeys] ->
          [Map.put(monkey, k, v) | monkeys]

        :skip, monkeys ->
          monkeys
      end)
      |> Enum.reverse()
    end

    def int_token(label, input) do
      {input, _} = Integer.parse(input)
      {label, input}
    end
  end

  def iteration(remaining_monkeys, iterated_monkeys \\ [])

  def iteration([], iterated_monkeys) do
    Enum.reverse(iterated_monkeys)
  end

  def iteration([monkey | rest], iterated_monkeys) do
    {monkey, throws} = Monkey.iteration(monkey)

    rest = Enum.map(rest, &apply_throws(&1, throws))
    iterated_monkeys = Enum.map(iterated_monkeys, &apply_throws(&1, throws))

    iteration(rest, [monkey | iterated_monkeys])
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
    IO.puts("Iteration #{iter}")
    new_monkeys = iteration(monkeys)
    [top_1, top_2] = new_monkeys |> Enum.map(& &1.inspections) |> Enum.sort(:desc) |> Enum.take(2)
    IO.puts("  #{top_1}, #{top_2}")

    iterate_times(new_monkeys, n - 1, iter + 1)
  end
end
