defmodule Days.Day22 do
  defstruct []

  defimpl DaySolver do
    @typep secret() :: non_neg_integer()
    @typep bananas() :: non_neg_integer()
    @typep price_difference() :: -9..9
    @typep difference_sequence() :: {price_difference(), price_difference(), price_difference(), price_difference()}
    @typep day_input() :: list(secret())

    @spec parse_input(%Days.Day22{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&String.to_integer/1)
    end


    @spec solve_part1(%Days.Day22{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      input |>
        Enum.map(fn initial_secret -> derive_secret(initial_secret, 2000) end) |>
        Enum.sum() |>
        to_string()
    end

    @spec derive_secret(secret(), pos_integer()) :: secret()
    defp derive_secret(initial_secret, times) do
      Range.new(1, times) |>
        Enum.reduce(initial_secret, fn _, secret ->
          derive_next_secret(secret)
        end)
    end

    @spec derive_next_secret(secret()) :: secret()
    defp derive_next_secret(secret) do
      first = mix(secret, Bitwise.bsl(secret, 6)) |> prune()
      second = mix(first, Bitwise.bsr(first, 5)) |> prune()
      mix(second, Bitwise.bsl(second, 11)) |> prune()
    end

    @spec mix(secret(), non_neg_integer()) :: non_neg_integer()
    defp mix(secret, other) do
      Bitwise.bxor(secret, other)
    end

    @spec prune(non_neg_integer()) :: secret()
    defp prune(secret) do
      rem(secret, 16777216)
    end



    @spec solve_part2(%Days.Day22{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      input |>
        most_bananas() |>
        to_string()
    end

    @spec most_bananas(Enumerable.t(secret())) :: bananas()
    defp most_bananas(secrets) do
      secrets |>
        bananas_by_sequence() |>
        Map.values() |>
        Enum.max()
    end

    @spec bananas_by_sequence(Enumerable.t(secret())) :: %{difference_sequence() => bananas()}
    defp bananas_by_sequence(secrets) do
      secrets |>
        Enum.reduce(%{}, fn secret, bananas ->
          bananas_by_sequence(secret, bananas)
        end)
    end

    @spec bananas_by_sequence(secret(), %{difference_sequence() => bananas()}) :: %{difference_sequence() => bananas()}
    defp bananas_by_sequence(secret, bananas_so_far) do
      first = derive_next_secret(secret)
      second = derive_next_secret(first)
      third = derive_next_secret(second)
      initial_price_diffs = {
        price(first) - price(secret),
        price(second) - price(first),
        price(third) - price(second)
      }
      remaining_secret_seq = Stream.unfold(third, fn current_secret -> {derive_next_secret(current_secret), derive_next_secret(current_secret)} end)
      {_, _, _, final_bananas} = remaining_secret_seq |>
        Stream.take(1997) |>
        Enum.reduce({price(third), initial_price_diffs, MapSet.new(), bananas_so_far}, fn new_secret, {last_price, {diff_3, diff_2, diff_1}, visited, bananas} ->
          new_price = price(new_secret)
          new_price_diff = new_price - last_price
          new_price_diffs = {diff_3, diff_2, diff_1, new_price_diff}
          if MapSet.member?(visited, new_price_diffs) do
            {new_price, {diff_2, diff_1, new_price_diff}, visited, bananas}
          else
            new_visited = MapSet.put(visited, new_price_diffs)
            new_bananas = Map.update(bananas, new_price_diffs, new_price, fn old_bananas -> old_bananas + new_price end)
            {new_price, {diff_2, diff_1, new_price_diff}, new_visited, new_bananas}
          end
        end)
      final_bananas
    end

    @spec price(secret()) :: bananas()
    defp price(secret) do
      rem(secret, 10)
    end




  end
end
