elves =
  "day1.txt"
  |> File.stream!()
  |> Stream.map(&String.trim/1)
  |> Enum.reduce([[]], fn
    "", acc ->
      [[] | acc]

    calories, [current_elf | acc] ->
      calories = String.to_integer(calories)
      [[calories | current_elf] | acc]
  end)
  |> Enum.map(&Enum.sum/1)
  |> Enum.sort(:desc)
  |> Enum.take(3)

[first | _] = elves

IO.puts ["The elf with the most calories has ", to_string(first), "."]
IO.puts ["The top 3 elves have ", to_string(Enum.sum(elves)), " calories."]
