defmodule Days.Day17 do
  defstruct []

  defimpl DaySolver do
    @typep register_value() :: non_neg_integer()
    @typep registers() :: {register_value(), register_value(), register_value()}
    @typep instruction() :: non_neg_integer()
    @typep code() :: tuple()
    @typep day_input() :: {registers(), code()}
    @typep pointer() :: non_neg_integer()
    @typep program_state() :: {pointer(), registers()}
    @typep output() :: list(non_neg_integer())

    @spec parse_input(%Days.Day17{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      [register_A_line, register_B_line, register_C_line, code_line] = input_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end)
      {
        {
          parse_register(register_A_line),
          parse_register(register_B_line),
          parse_register(register_C_line)
        },
        parse_instructions(code_line)
      }
    end

    @spec parse_register(String.t()) :: register_value()
    defp parse_register(register_line) do
      [value] = Regex.run(~r"\d+", register_line)
      String.to_integer(value)
    end

    @spec parse_instructions(String.t()) :: code()
    defp parse_instructions(code_line) do
      [code] = Regex.run(~r"(\d|,)+", code_line, capture: :first)
      code |>
        String.split(~r",") |>
        Enum.map(&String.to_integer/1) |>
        List.to_tuple()
    end


    @spec solve_part1(%Days.Day17{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {registers, code} = input
      execute_code(0, registers, code) |>
        Enum.join(",")
    end

    @spec execute_code(pointer(), registers(), code()) :: output()
    defp execute_code(pointer, registers, code) do
      execute_code_impl({pointer, registers}, code, [])
    end

    @spec execute_code_impl(program_state(), code(), output()) :: output()
    defp execute_code_impl({instruction_pointer, registers}, code, existing_reverse_output) do
      if instruction_pointer >= tuple_size(code) do
        Enum.reverse(existing_reverse_output)
      else
        instruction = elem(code, instruction_pointer)
        operand = elem(code, instruction_pointer + 1)
        {new_state, additional_output} = execute_instruction(instruction, operand, {instruction_pointer, registers})
        new_output = additional_output ++ existing_reverse_output
        execute_code_impl(new_state, code, new_output)
      end
    end

    @spec execute_instruction(instruction(), non_neg_integer(), program_state()) :: {program_state(), output()}
    defp execute_instruction(instruction, operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      case instruction do
        0 -> adv(operand, {instruction_pointer, {register_A, register_B, register_C}})
        1 -> bxl(operand, {instruction_pointer, {register_A, register_B, register_C}})
        2 -> bst(operand, {instruction_pointer, {register_A, register_B, register_C}})
        3 -> jnz(operand, {instruction_pointer, {register_A, register_B, register_C}})
        4 -> bxc(operand, {instruction_pointer, {register_A, register_B, register_C}})
        5 -> out(operand, {instruction_pointer, {register_A, register_B, register_C}})
        6 -> bdv(operand, {instruction_pointer, {register_A, register_B, register_C}})
        7 -> cdv(operand, {instruction_pointer, {register_A, register_B, register_C}})
      end
    end

    @spec adv(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp adv(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
        {
          Bitwise.bsr(register_A, combo_operand(operand, {register_A, register_B, register_C})),
          register_B,
          register_C
        }
      }
      {new_state, []}
    end

    @spec combo_operand(non_neg_integer(), registers()) :: non_neg_integer()
    defp combo_operand(operand, {reg_A, reg_B, reg_C}) do
      case operand do
         0 -> 0
         1 -> 1
         2 -> 2
         3 -> 3
         4 -> reg_A
         5 -> reg_B
         6 -> reg_C
      end
    end

    @spec bxl(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp bxl(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
        {
          register_A,
          Bitwise.bxor(register_B, operand),
          register_C
        }
      }
      {new_state, []}
    end

    @spec bst(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp bst(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
        {
          register_A,
          combo_operand(operand, {register_A, register_B, register_C}) |> rem(8),
          register_C
        }
      }
      {new_state, []}
    end

    @spec jnz(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp jnz(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = if register_A == 0 do
        {instruction_pointer + 2, {register_A, register_B, register_C}}
      else
        {operand, {register_A, register_B, register_C}}
      end
      {new_state, []}
    end

    @spec bxc(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp bxc(_operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
        {
          register_A,
          Bitwise.bxor(register_B, register_C),
          register_C
        }
      }
      {new_state, []}
    end

    @spec out(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp out(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {instruction_pointer + 2, {register_A, register_B, register_C}}
      output_value = combo_operand(operand, {register_A, register_B, register_C}) |> rem(8)
      {new_state, [output_value]}
    end

    @spec bdv(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp bdv(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
        {
          register_A,
          Bitwise.bsr(register_A, combo_operand(operand, {register_A, register_B, register_C})),
          register_C
        }
      }
      {new_state, []}
    end

    @spec cdv(non_neg_integer(), program_state()) :: {program_state(), output()}
    defp cdv(operand, {instruction_pointer, {register_A, register_B, register_C}}) do
      new_state = {
        instruction_pointer + 2,
          {
            register_A,
            register_B,
            Bitwise.bsr(register_A, combo_operand(operand, {register_A, register_B, register_C}))
          }
        }
      {new_state, []}
    end



    @spec solve_part2(%Days.Day17{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {{_register_A, register_B, register_C}, code} = input
      start_register_A = if code == {2,4,1,5,7,5,4,5,0,3,1,6,5,5,3,0} do
        revert_special_code(code, code |> Tuple.to_list()) |>
          Enum.min()
      else
        0
      end
      brute_force_matching_output(start_register_A, register_B, register_C, code) |>
        to_string()
    end

    # Only works with jump to start at the end,
    # one output per loop,
    # irrelevant initial registers B and C and
    # register A changing from loop to loop as A -> A >>> 3
    @spec revert_special_code(code(), output()) :: MapSet.t(register_value())
    defp revert_special_code(code, target_output) do
      loop_code = code |>
        Tuple.to_list() |>
        Enum.take(tuple_size(code) - 2) |>
        List.to_tuple()
      target_output |>
        Enum.reverse() |>
        Enum.reduce(MapSet.new([0]), fn target, possible_base_reg_As ->
          possible_base_reg_As |>
            Enum.reduce(MapSet.new(), fn base_reg_A, possible_reg_As ->
              possible_for_base = revert_special_output(base_reg_A, loop_code, [target])
              MapSet.union(possible_reg_As, possible_for_base)
            end)
        end)
    end


    @spec revert_special_output(register_value(), code(), output()) :: MapSet.t(register_value())
    defp revert_special_output(base_register_A, code, target_output) do
      new_base = Bitwise.bsl(base_register_A, 3)
      0..7 |>
        Enum.map(fn octal -> new_base + octal end) |>
        Enum.filter(fn reg_A -> target_output == execute_code(0, {reg_A, 0, 0}, code) end) |>
        Enum.into(MapSet.new())
    end


    @spec brute_force_matching_output(register_value(), register_value(), register_value(), code()) :: register_value()
    defp brute_force_matching_output(register_A_candidate, register_B, register_A, code) do
      output = execute_code(0, {register_A_candidate, register_B, register_A}, code) |> List.to_tuple()
      if code == output do
        register_A_candidate
      else
        brute_force_matching_output(register_A_candidate + 1, register_B, register_A, code)
      end
    end


  end
end
