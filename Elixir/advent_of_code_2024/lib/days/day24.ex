defmodule Days.Day24 do
  defstruct []

  defimpl DaySolver do
    @typep operator() :: :AND | :OR | :XOR
    @typep wire() :: String.t()
    @typep in_wire() :: wire()
    @typep out_wire() :: wire()
    @typep gate() :: {in_wire(), in_wire(), operator(), out_wire()}
    @typep wire_state() :: 0..1
    @typep day_input() :: {%{wire() => wire_state()}, list(gate())}
    @typep equation() :: {String.t(), non_neg_integer(), non_neg_integer(), non_neg_integer()}
    @typep swap() :: {out_wire(), out_wire()}

    @spec parse_input(%Days.Day24{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      [wire_state_text, gates_text] = String.split(input_text, ~r"\r?\n\r?\n")
      {
        parse_wire_state(wire_state_text),
        parse_gates(gates_text)
      }
    end

    @spec parse_wire_state(String.t()) :: %{wire() => boolean()}
    defp parse_wire_state(text) do
      text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.reduce(%{}, fn line, state ->
          [wire, value_text] = String.split(line, ~r":\s*")
          Map.put(state, wire, String.to_integer(value_text))
        end)

    end

    @spec parse_gates(String.t()) :: list(gate())
    defp parse_gates(text) do
      text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&parse_gate/1)
    end

    @spec parse_gate(String.t()) :: gate()
    defp parse_gate(text) do
      [in_1, op_text, in_2, _, out] = String.split(text, ~r"\s+")
      op = case op_text do
        "AND" -> :AND
        "XOR" -> :XOR
        "OR" -> :OR
      end
      {in_1, in_2, op, out}
    end


    @spec solve_part1(%Days.Day24{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {initial_values, gates} = input
      interesting_wires = gates |>
        Enum.map(fn {_, _, _, out} -> out end) |>
        Enum.filter(fn wire -> String.starts_with?(wire, "z") end) |>
        Enum.into(MapSet.new())
      wire_values = run_till_interesting_known(gates, initial_values, interesting_wires)
      ordered_interesting = interesting_wires |>
        Enum.sort(fn val1, val2 -> val1 >= val2 end)
      ordered_interesting |>
        Enum.map(fn wire -> wire_values[wire] end) |>
        Enum.join() |>
        String.to_integer(2) |>
        to_string()
    end

    @spec run_till_interesting_known(list(gate()), %{wire() => boolean()}, MapSet.t(wire())) :: %{wire() => boolean()}
    defp run_till_interesting_known(gates, known_values, interesting) do
      if Enum.empty?(interesting) do
        known_values
      else
        opening_gates = gates |>
          Stream.reject(fn {_, _, _, out} -> Map.has_key?(known_values, out) end) |>
          Enum.filter(fn {in1, in2, _, _} -> Map.has_key?(known_values, in1) and Map.has_key?(known_values, in2) end)
        if Enum.empty?(opening_gates) do
          # The interesting wires will never be set.
          known_values
        else
          new_known = opening_gates |>
            Enum.reduce(known_values, fn {in1, in2, op, out}, known ->
              val1 = known[in1]
              val2 = known[in2]
              result =  case op do
                :AND -> Bitwise.band(val1, val2)
                :OR -> Bitwise.bor(val1, val2)
                :XOR -> Bitwise.bxor(val1, val2)
              end
              Map.put(known, out, result)
            end)
          still_interesting = opening_gates |>
            Stream.map(fn {_, _, _, out} -> out end) |>
            Stream.filter(fn wire -> MapSet.member?(interesting, wire) end) |>
            Enum.reduce(interesting, fn wire, interesting_now ->
              MapSet.delete(interesting_now, wire)
            end)
          run_till_interesting_known(gates, new_known, still_interesting)
        end
      end
    end


    @spec solve_part2(%Days.Day24{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      exchanges = [{"mwk", "z10"}, {"qgd", "z18"}, {"hsw", "jmh"}, {"gqp", "z33"}]

      {initial_values, gates} = input
      output_wires = gates |>
        Enum.map(fn {_, _, _, out} -> out end) |>
        Enum.filter(fn wire -> String.starts_with?(wire, "z") end) |>
        Enum.into(MapSet.new())
      gates_to_use = exchanged_gates(gates, exchanges)
      {x, y} = input_values(initial_values)
      interesting_test_equations = [
        {"input", x, y, x + y}
      ]  ++
      (0..44 |>
        Enum.map(fn index -> {"y_zero_" <> to_string(index), Bitwise.bsl(1,index), 0, Bitwise.bsl(1,index)} end)) ++
      (0..44 |>
        Enum.map(fn index -> {"x_zero_" <> to_string(index), 0, Bitwise.bsl(1,index), Bitwise.bsl(1,index)} end)) ++
      (0..44 |>
        Enum.map(fn index -> {"next_bit_" <> to_string(index), Bitwise.bsl(1,index), Bitwise.bsl(1,index), Bitwise.bsl(1,index + 1)} end)) ++
      (0..44 |>
        Enum.map(fn index -> {"shifting_bits_x_" <> to_string(index), 1, Bitwise.bsl(1,index + 1) - 1, Bitwise.bsl(1,index + 1)} end))  ++
      (0..44 |>
        Enum.map(fn index -> {"shifting_bits_y_" <> to_string(index), Bitwise.bsl(1,index + 1) - 1, 1, Bitwise.bsl(1,index + 1)} end))
      failed_tests = interesting_test_equations |>
        Stream.map(fn eq -> validate_equation(eq, gates_to_use, output_wires) end) |>
        Stream.reject(fn {_eq, diff} -> diff == 0 end) |>
        Enum.map(fn {{id, x,y,z}, diff} ->
          {
            {
              id,
              Integer.to_string(x, 2),
              Integer.to_string(y, 2),
              Integer.to_string(z, 2)
            },
            Integer.to_string(diff, 2)
          } |> IO.inspect()
        end)
      if Enum.empty?(failed_tests) do
        exchanges |>
          Enum.flat_map(&Tuple.to_list/1) |>
          Enum.sort() |>
          Enum.join(",")
      else
        nil
      end
    end

    @spec exchanged_gates(list(gate()), list(swap())) :: list(gate())
    defp exchanged_gates(original_gates, wire_changes) do
      wire_changes |>
        Enum.reduce(original_gates, fn {out1, out2}, gates ->
          gate1 = gates |> Enum.filter(fn {_, _, _, out} -> out == out1 end) |> hd()
          gate2 = gates |> Enum.filter(fn {_, _, _, out} -> out == out2 end) |> hd()
          new_gate1 = gate1 |> Tuple.delete_at(3) |> Tuple.append(out2)
          new_gate2 = gate2 |> Tuple.delete_at(3) |> Tuple.append(out1)
          gates |>
            List.delete(gate1) |>
            List.delete(gate2) |>
            List.insert_at(0, new_gate1) |>
            List.insert_at(0, new_gate2)
        end)
    end

    @spec validate_equation(equation(), list(gate()), MapSet.t(wire)) :: {equation(), non_neg_integer()}
    defp validate_equation(equation, gates, output_wires) do
      {_id, x, y, z} = equation
      initial_values = input_for_values(x, y, 45)
      wire_values = run_till_interesting_known(gates, initial_values, output_wires)
      result = value_for_start(wire_values, "z")
      {equation, Bitwise.bxor(result, z)}
    end

    @spec input_values(%{wire() => wire_state()}) :: {non_neg_integer(), non_neg_integer()}
    defp input_values(known_values) do
      {
        value_for_start(known_values, "x"),
        value_for_start(known_values, "y")
      }
    end

    @spec value_for_start(%{wire() => wire_state()}, String.t()) :: non_neg_integer()
    defp value_for_start(known_values, start) do
      known_values |>
        Map.keys() |>
        Enum.filter(fn wire -> String.starts_with?(wire, start) end) |>
        Enum.sort(fn val1, val2 -> val1 >= val2 end) |>
        Enum.map(fn wire -> known_values[wire] end) |>
        Enum.join() |>
        String.to_integer(2)
    end

    @spec input_for_values(non_neg_integer(), non_neg_integer(), pos_integer()) :: %{wire() => wire_state()}
    defp input_for_values(x, y, digits) do
      Map.merge(
        input_for_value(x, digits, "x"),
        input_for_value(y, digits, "y")
      )
    end

    @spec input_for_value(non_neg_integer(), pos_integer(), String.t()) :: %{wire() => wire_state()}
    defp input_for_value(value, digits, prefix) do
      value |>
        Integer.to_string(2) |>
        String.pad_leading(digits, "0") |>
        String.reverse() |>
        String.graphemes() |>
        Stream.map(&String.to_integer/1) |>
        Stream.with_index() |>
        Enum.reduce(%{}, fn {digit, index}, known ->
          Map.put(
            known,
            prefix <> (index |> Integer.to_string() |> String.pad_leading(2, "0")),
            digit
          )
        end)
    end



  end
end
