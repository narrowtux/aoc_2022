defmodule Day11.Parser do
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
