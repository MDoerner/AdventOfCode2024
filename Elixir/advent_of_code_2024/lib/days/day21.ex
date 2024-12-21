defmodule Days.Day21 do
  defstruct []

  defimpl DaySolver do
    @typep digi_button() :: 0..9 | :a
    @typep direction_button() :: :< | :> | :^ | :v | :a
    @typep code() :: list(digi_button())
    @typep move_sequence() :: list(direction_button())
    @typep day_input() :: list(code())

    @spec parse_input(%Days.Day21{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&parse_code/1)
    end

    @spec parse_code(String.t()) :: code()
    defp parse_code(text) do
      text |>
        String.graphemes() |>
        Enum.map(&parse_digi_button/1)
    end

    @spec parse_digi_button(String.t()) :: digi_button()
    defp parse_digi_button(text) do
      if text == "A" do
        :a
      else
        String.to_integer(text)
      end
    end


    @spec solve_part1(%Days.Day21{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      input |>
        Enum.map(&complexity/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec complexity(code()) :: non_neg_integer()
    defp complexity(code) do
      number = number_part(code)
      shortest_length = shortest_sequence_length(code)
    end

    @spec number_part(code()) :: non_neg_integer()
    defp number_part(code) do
      code |>
        Enum.reject(fn button -> button == :a end) |>
        Enum.join() |>
        String.to_integer()
    end

    @spec shortest_sequence_length(code()) :: non_neg_integer()
    defp shortest_sequence_length(code) do

    end

    @spec shortest_direct_keypad_transitions() :: %{{direction_button(), direction_button()} => MapSet.t(move_sequence())}
    defp shortest_direct_keypad_transition() do
      %{
        {:a, :a} => MapSet.new([[]]),
        {:a, :^} => MapSet.new([[:<]]),
        {:a, :>} => MapSet.new([[:v]]),
        {:a, :v} => MapSet.new([[:v, :<], [:<, :v]]),
        {:a, :<} => MapSet.new([[:v, :<, :<], [:<, :v, :<]]),

        {:^, :a} => MapSet.new([[:>]]),
        {:^, :^} => MapSet.new([[]]),
        {:^, :>} => MapSet.new([[:v, :>], [:>, :v]]),
        {:^, :v} => MapSet.new([[:v]]),
        {:^, :<} => MapSet.new([[:V, :<]]),

        {:>, :a} => MapSet.new([[:^]]),
        {:>, :^} => MapSet.new([[:<, :^], [:^, :<]]),
        {:>, :>} => MapSet.new([[]]),
        {:>, :v} => MapSet.new([[:<]]),
        {:>, :<} => MapSet.new([[:<, :<]]),

        {:v, :a} => MapSet.new([[:>, :^], [:^, :>]]),
        {:v, :^} => MapSet.new([[:^]]),
        {:v, :>} => MapSet.new([[:>]]),
        {:v, :v} => MapSet.new([[]]),
        {:v, :<} => MapSet.new([[:<]]),

        {:<, :a} => MapSet.new([[:>, :>, :^], [:>, :^, :>]]),
        {:<, :^} => MapSet.new([[:>, :^]]),
        {:<, :>} => MapSet.new([[:>, :>]]),
        {:<, :v} => MapSet.new([[:>]]),
        {:<, :<} => MapSet.new([[]]),
      }
    end

    # A sequence is sensible if it has the least possible number of direction changes for its length.
    @spec shortest_sensible_direct_digi_pad_transitions() :: %{{digi_button(), digi_button()} => MapSet.t(move_sequence())}
    defp shortest_sensible_direct_digi_pad_transitions() do
      %{
        {:a, :a} => MapSet.new([[]]),
        {:a, 0} => MapSet.new([[:<]]),
        {:a, 1} => MapSet.new([[:^, :<, :<]]),
        {:a, 2} => MapSet.new([[:<, :^], [:^, :<]]),
        {:a, 3} => MapSet.new([[:^]]),
        {:a, 4} => MapSet.new([[:^, :^, :<, :<]]),
        {:a, 5} => MapSet.new([[:^, :^, :<], [:<, :^, :^]]),
        {:a, 6} => MapSet.new([[:^, :^]]),
        {:a, 7} => MapSet.new([[:^, :^, :^, :<, :<]]),
        {:a, 8} => MapSet.new([[:^, :^, :^, :<], [:<, :^, :^, :^]]),
        {:a, 9} => MapSet.new([[:^, :^, :^]]),

        {0, :a} => MapSet.new([[:>]]),
        {0, 0} => MapSet.new([[]]),
        {0, 1} => MapSet.new([[:^, :<]]),
        {0, 2} => MapSet.new([[:^]]),
        {0, 3} => MapSet.new([[:^, :>], [:>, :^]]),
        {0, 4} => MapSet.new([[:^, :^, :<]]),
        {0, 5} => MapSet.new([[:^, :^]]),
        {0, 6} => MapSet.new([[:^, :^, :>], [:>, :^, :^]]),
        {0, 7} => MapSet.new([[:^, :^, :^, :<]]),
        {0, 8} => MapSet.new([[:^, :^, :^]]),
        {0, 9} => MapSet.new([[:^, :^, :^, :>], [:>, :^, :^, :^]]),

        {1, :a} => MapSet.new([[:>, :>, :v]]),
        {1, 0} => MapSet.new([[:>, :v]]),
        {1, 1} => MapSet.new([[]]),
        {1, 2} => MapSet.new([[:>]]),
        {1, 3} => MapSet.new([[:>, :>]]),
        {1, 4} => MapSet.new([[:^]]),
        {1, 5} => MapSet.new([[:^, :>], [:>, :^]]),
        {1, 6} => MapSet.new([[:^, :>, :>], [:>, :>, :^]]),
        {1, 7} => MapSet.new([[:^, :^]]),
        {1, 8} => MapSet.new([[:^, :^, :>], [:>, :^, :^]]),
        {1, 9} => MapSet.new([[:^, :^, :>, :>], [:>, :>, :^, :^]]),

        {2, :a} => MapSet.new([[:>, :v], [:v, :>]]),
        {2, 0} => MapSet.new([[:v]]),
        {2, 1} => MapSet.new([[:<]]),
        {2, 2} => MapSet.new([[]]),
        {2, 3} => MapSet.new([[:>]]),
        {2, 4} => MapSet.new([[:^, :<], [:<, :^]]),
        {2, 5} => MapSet.new([[:^]]),
        {2, 6} => MapSet.new([[:^, :>], [:>, :^]]),
        {2, 7} => MapSet.new([[:^, :^, :<], [:<, :^, :^]]),
        {2, 8} => MapSet.new([[:^, :^]]),
        {2, 9} => MapSet.new([[:^, :^, :>], [:>, :^, :^]]),

        {3, :a} => MapSet.new([[:v]]),
        {3, 0} => MapSet.new([[:v, :<], [:<, :v]]),
        {3, 1} => MapSet.new([[:<, :<]]),
        {3, 2} => MapSet.new([[:<]]),
        {3, 3} => MapSet.new([[]]),
        {3, 4} => MapSet.new([[:^, :<, :<], [:<, :<, :^]]),
        {3, 5} => MapSet.new([[:^, :<], [:<, :^]]),
        {3, 6} => MapSet.new([[:^]]),
        {3, 7} => MapSet.new([[:^, :^, :<, :<], [:<, :<, :^, :^]]),
        {3, 8} => MapSet.new([[:^, :^, :<], [:<, :^, :^]]),
        {3, 9} => MapSet.new([[:^, :^]]),

        {4, :a} => MapSet.new([[:>, :>, :v, :v]]),
        {4, 0} => MapSet.new([[:>, :v, :v]]),
        {4, 1} => MapSet.new([[:v]]),
        {4, 2} => MapSet.new([[:v], [:v]]),
        {4, 3} => MapSet.new([[:v], [:v]]),
        {4, 4} => MapSet.new([[]]),
        {4, 5} => MapSet.new([[:>]]),
        {4, 6} => MapSet.new([[:>, :>]]),
        {4, 7} => MapSet.new([[:^]]),
        {4, 8} => MapSet.new([[:^, :>], :>, [:^]]),
        {4, 9} => MapSet.new([[:^, :>, :>], [:>, :>, :^]]),

        {5, :a} => MapSet.new([[:v, :v, :>], [:>, :v, :v]]),
        {5, 0} => MapSet.new([[:v, :v]]),
        {5, 1} => MapSet.new([[:v, :<], [:<, :v]]),
        {5, 2} => MapSet.new([[:v]]),
        {5, 3} => MapSet.new([[:v, :>], [:>, :v]]),
        {5, 4} => MapSet.new([[:<]]),
        {5, 5} => MapSet.new([[]]),
        {5, 6} => MapSet.new([[:>]]),
        {5, 7} => MapSet.new([[:^, :<], [:<, :^]]),
        {5, 8} => MapSet.new([[:^]]),
        {5, 9} => MapSet.new([[:^, :>], [:>, :^]]),

        {6, :a} => MapSet.new([[:v, :v]]),
        {6, 0} => MapSet.new([[:v, :v, :<], [:<, :v, :v]]),
        {6, 1} => MapSet.new([[:v, :<, :<], [:<, :<, :v]]),
        {6, 2} => MapSet.new([[:v, :<], [:<, :v]]),
        {6, 3} => MapSet.new([[:v]]),
        {6, 4} => MapSet.new([[:<, :<]]),
        {6, 5} => MapSet.new([[:<]]),
        {6, 6} => MapSet.new([[]]),
        {6, 7} => MapSet.new([[:^, :<, :<], [:<, :<, :^]]),
        {6, 8} => MapSet.new([[:^, :<], [:<, :^]]),
        {6, 9} => MapSet.new([[:^]]),

        {7, :a} => MapSet.new([[:>, :>, :v, :v, :v]]),
        {7, 0} => MapSet.new([[:>, :v, :v, :v]]),
        {7, 1} => MapSet.new([[:v, :v]]),
        {7, 2} => MapSet.new([[:v, :v, :>], [:>, :v, :v]]),
        {7, 3} => MapSet.new([[:v, :v, :>, :>], [:>, :>, :v, :v]]),
        {7, 4} => MapSet.new([[:v]]),
        {7, 5} => MapSet.new([[:v, :>], [:>, :v]]),
        {7, 6} => MapSet.new([[:v, :>, :>], [:>, :>, :v]]),
        {7, 7} => MapSet.new([[]]),
        {7, 8} => MapSet.new([[:>]]),
        {7, 9} => MapSet.new([[:>, :>]]),

        {8, :a} => MapSet.new([[:v, :v, :v, :>], [:>, :v, :v, :v]]),
        {8, 0} => MapSet.new([[:v, :v, :v]]),
        {8, 1} => MapSet.new([[:v, :v, :<], [:<, :v, :v]]),
        {8, 2} => MapSet.new([[:v, :v]]),
        {8, 3} => MapSet.new([[:v, :v, :>], [:>, :v, :v]]),
        {8, 4} => MapSet.new([[:v, :<], [:<, :v]]),
        {8, 5} => MapSet.new([[:v]]),
        {8, 6} => MapSet.new([[:v, :>], [:>, :v]]),
        {8, 7} => MapSet.new([[:<]]),
        {8, 8} => MapSet.new([[]]),
        {8, 9} => MapSet.new([[:>]]),

        {9, :a} => MapSet.new([[:v, :v, :v]]),
        {9, 0} => MapSet.new([[:v, :v, :v, :<], [:<, :v, :v, :v]]),
        {9, 1} => MapSet.new([[:v, :v, :<, :<], [:<, :<, :v, :v]]),
        {9, 2} => MapSet.new([[:v, :v, :<], [:<, :v, :v]]),
        {9, 3} => MapSet.new([[:v, :v]]),
        {9, 4} => MapSet.new([[:v, :<, :<], [:<, :<, :v]]),
        {9, 5} => MapSet.new([[:v, :<], [:<, :v]]),
        {9, 6} => MapSet.new([[:v]]),
        {9, 7} => MapSet.new([[:<, :<]]),
        {9, 8} => MapSet.new([[:<]]),
        {9, 9} => MapSet.new([[]]),
      }
    end


    @spec solve_part2(%Days.Day21{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      (42 + String.length(to_string(input)) - String.length(to_string(input))) |>
        to_string()
    end


  end
end
