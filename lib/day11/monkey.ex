 defmodule Day11.Monkey do
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

    @spec iteration(t, integer()) :: {t, [{monkey_id, worry_level}]}
    def iteration(monkey, divisor) do
      inspections = length(monkey.items) + monkey.inspections

      throws =
        monkey.items
        |> Stream.map(&eval_op(monkey.operation, &1))
        |> Enum.map(fn level ->
          monkey_id =
            if rem(level, monkey.test) == 0,
              do: monkey.test_true,
              else: monkey.test_false

          {monkey_id, rem(level, divisor)}
        end)

      {%{monkey | items: [], inspections: inspections}, throws}
    end

    def div_if_great(num, divisor) do
      if rem(num, divisor) == 0 or num > divisor * 1000000 do
        div(num, divisor)
      else
        num
      end
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
