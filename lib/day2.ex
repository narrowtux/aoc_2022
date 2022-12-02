defmodule Day2 do
  import Macros
  @type hand :: :rock | :paper | :scissors
  @type outcome :: :win | :draw | :loss

  def playbook(input \\ File.stream!("./day2.txt")) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
  end

  @spec code_to_hand(String.t()) :: hand()
  defcase code_to_hand() do
    "A" -> :rock
    "B" -> :paper
    "C" -> :scissors
    "X" -> :rock
    "Y" -> :paper
    "Z" -> :scissors
  end

  @spec code_to_outcome(String.t()) :: outcome()
  defcase code_to_outcome() do
    "X" -> :loss
    "Y" -> :draw
    "Z" -> :win
  end

  @spec hand_score(hand()) :: non_neg_integer()
  defcase hand_score() do
    :rock -> 1
    :paper -> 2
    :scissors -> 3
  end

  @spec round_outcome({hand(), hand()}) :: outcome()
  defcase round_outcome() do
    {same, same} -> :draw
    {:rock, :paper} -> :win
    {:paper, :scissors} -> :win
    {:scissors, :rock} -> :win
    _ -> :loss
  end

  @spec outcome_score(outcome()) :: non_neg_integer()
  defcase outcome_score() do
    :draw -> 3
    :win -> 6
    :loss -> 0
  end

  @spec choose_hand({hand(), outcome()}) :: hand()
  defcase choose_hand() do
    {hand, :draw} -> hand
    {:rock, :win} -> :paper
    {:paper, :win} -> :scissors
    {:scissors, :win} -> :rock
    {:rock, :loss} -> :scissors
    {:paper, :loss} -> :rock
    {:scissors, :loss} -> :paper
  end

  @spec round_score({hand, hand}) :: non_neg_integer()
  def round_score({_, b} = play) do
    hand_part = hand_score(b)
    outcome_part = play |> round_outcome() |> outcome_score()
    hand_part + outcome_part
  end

  def part_1(input \\ playbook()) do
    part_1 =
      input
      |> Stream.map(fn hands -> Enum.map(hands, &code_to_hand/1) end)
      |> Stream.map(&List.to_tuple/1)
      |> Stream.map(&round_score/1)
      |> Enum.sum()

    IO.puts("The total score according to the guessed instructions is #{part_1}.")
  end

  def part_2(input \\ playbook()) do
    part_2 =
      input
      |> Stream.map(fn [play, outcome] ->
        play = code_to_hand(play)
        outcome = code_to_outcome(outcome)
        response = choose_hand({play, outcome})
        {play, response}
      end)
      |> Stream.map(&round_score/1)
      |> Enum.sum()

    IO.puts("The total score according to the actual instructions is #{part_2}.")
  end
end
