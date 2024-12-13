defmodule Days.Day13 do
  defstruct []

  defimpl DaySolver do
    @typep position() :: {integer(), integer()}
    @typep button() :: position()
    @typep prize() :: position()
    @typep arcade() :: {button(), button(), prize()}
    @typep day_input() :: list(arcade())

    @spec parse_input(%Days.Day13{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n\r?\n") |>
        Enum.map(&parse_arcade/1)
    end

    @spec parse_arcade(String.t()) :: arcade()
    defp parse_arcade(text) do
      [button_a, button_b, prize | _] = text |>
        String.split(~r"\r?\n")
      {parse_button(button_a), parse_button(button_b), parse_prize(prize)}
    end

    @spec parse_button(String.t()) :: button()
    defp parse_button(text) do
      Regex.run(
        ~r"X\+(\d+), Y\+(\d+)",
        text,
        capture: :all_but_first
      ) |>
      Enum.map(&String.to_integer/1) |>
      List.to_tuple()
    end

    @spec parse_prize(String.t()) :: prize()
    defp parse_prize(text) do
      Regex.run(
        ~r"X=(\d+), Y=(\d+)",
        text,
        capture: :all_but_first
      ) |>
      Enum.map(&String.to_integer/1) |>
      List.to_tuple()
    end


    @spec solve_part1(%Days.Day13{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      input |>
        Enum.map(fn arcade ->
          arcade |>
            solve_arcade() |>
            Enum.reject(fn {a, b} -> a > 100 or b > 100 end) |>
            Enum.map(&tokens_spent/1) |>
            Enum.min(fn -> 0 end)
        end) |>
        Enum.sum() |>
        to_string()
    end

    @spec solve_arcade(arcade()) :: list({non_neg_integer(), non_neg_integer()})
    defp solve_arcade({button_a, button_b, prize}) do
      {x, y} = prize
      {{a, c}, {b, d}, determinant} = base_change_matrix(button_a, button_b)
      if determinant != 0 do
        # The button movements form a basis.
        a_numerator = a*x + b*y
        b_numerator = c*x + d*y
        if rem(a_numerator, determinant) == 0 and rem(b_numerator, determinant) == 0 do
          a_presses = floor(a_numerator/determinant)
          b_presses = floor(b_numerator/determinant)
          if a_presses >= 0 and b_presses >= 0 do
            [{a_presses, b_presses}]
          else
            []
          end
        else
          []
        end
      else
        # The button movements are colinear.
        if a*y - c*x != 0 or b*y - d*x != 0 do
          # The prize is at an offset not colinear to any button movements and, thus, cannot be reached.
          # We checked both movements since one button might not do anything.
          []
        else
          {x_a, y_a} = button_a
          {x_b, y_b} = button_b
          if x_a == 0 and y_a == 0 do
            if x_b == 0 do
              if y_b == 0 do
                []
              else
                if rem(y, y_b) != 0 do
                  []
                else
                  [{0, floor(y/y_b)}]
                end
              end
            else
              if rem(x, x_b) != 0 do
                []
              else
                b_presses = floor(x/x_b)
                if b_presses * y_b == y do
                  [{0, b_presses}]
                else
                  []
                end
              end
            end
            max_a_tries = cond do
              x_a == 0 -> floor(y/y_a)
              y_a == 0 -> floor(x/x_a)
              true -> min(floor(x/x_a), y/y_a)
            end
            a_tries = Range.new(0, max_a_tries)
            a_tries |>
              Enum.map(fn a_presses ->
                remaining_x = x - a_presses * x_a
                remaining_y = y - a_presses * y_a
                if x_b == 0 do
                  if remaining_x != 0 do
                    nil
                  else
                    if y_b == 0 do
                      if remaining_y != 0 do
                        nil
                      else
                        {a_presses, 0}
                      end
                    else
                      if rem(remaining_y, y_b) != 0 do
                        nil
                      else
                        {a_presses, floor(remaining_y/y_b)}
                      end
                    end
                  end
                end
                if rem(remaining_x, x_b) != 0 do
                  nil
                else
                  b_presses = floor(remaining_x/x_b)
                  if remaining_y == b_presses * y_b do
                    {a_presses, b_presses}
                  else
                    nil
                  end
                end
              end)
          end
        end
      end
    end

    @spec base_change_matrix(position(), position()) :: {position(), position(), integer()}
    defp base_change_matrix(button_a, button_b) do
      {a, c} = button_a
      {b, d} = button_b
      {{d, -c}, {-b, a}, a*d - b*c}
    end

    @spec tokens_spent({non_neg_integer(), non_neg_integer()}) :: non_neg_integer()
    defp tokens_spent({a_presses, b_presses}) do
      a_presses * 3 + b_presses
    end


    @spec solve_part2(%Days.Day13{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      input |>
        Enum.map(fn {button_a, button_b, {x, y}} ->
          arcade = {button_a, button_b, {x + 10000000000000, y + 10000000000000}}
          arcade |>
            solve_arcade() |>
            Enum.map(&tokens_spent/1) |>
            Enum.min(fn -> 0 end)
        end) |>
        Enum.sum() |>
        to_string()
    end


  end
end
