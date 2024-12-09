defmodule Days.Day9 do
  defstruct []

  defimpl DaySolver do
    @typep disk_index() :: non_neg_integer()
    @typep run_length() :: non_neg_integer()
    @typep disk_block() :: {disk_index(), run_length()}
    @typep data_block() :: {non_neg_integer(), disk_block()}
    @typep day_input() :: {list(data_block()), list(disk_block())}

    @spec parse_input(%Days.Day9{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_line = hd(String.split(input_text, ~r"\r?\n"))
      parse_disk_map(input_line)
    end

    @spec parse_disk_map(String.t()) :: day_input()
    defp parse_disk_map(line) do
      run_lengths = line |>
        String.graphemes() |>
        Enum.map(&String.to_integer/1)
      {_, reverse_data, reverse_spaces} = run_lengths |>
        Stream.with_index() |>
        Enum.reduce({0, [], []}, fn {block_length, index}, {block_start, data_blocks, empty_blocks} ->
          next_block_start = block_start + block_length
          if rem(index, 2) == 0 do
            {
              next_block_start,
              [{floor(index / 2), {block_start, block_length}}] ++ data_blocks,
              empty_blocks
            }
          else
            {
              next_block_start,
              data_blocks,
              [{block_start, block_length}] ++ empty_blocks
            }
          end
        end)
      {reverse_data, Enum.reverse(reverse_spaces)}
    end



    @spec solve_part1(%Days.Day9{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {reverse_data_blocks, empty_blocks} = input
      compact(reverse_data_blocks, empty_blocks) |>
        Enum.map(&checksum/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec compact(list(data_block()), list(disk_block())) :: list(data_block())
    defp compact(reverse_data_blocks, empty_blocks) do
      compact_impl([], reverse_data_blocks, empty_blocks)
    end

    @spec compact_impl(list(data_block()), list(data_block()), list(disk_block())) :: list(data_block())
    defp compact_impl(compacted_blocks, reverse_data_blocks, empty_blocks) do
      if Enum.empty?(reverse_data_blocks) or Enum.empty?(empty_blocks) do
        reverse_data_blocks ++ compacted_blocks
      else
        [{id, {data_index, data_length}} | remaining_data] = reverse_data_blocks
        [{empty_index, empty_length} | remaining_empty] = empty_blocks
        cond do
          empty_length == 0 ->
            compact_impl(compacted_blocks, reverse_data_blocks, remaining_empty)
          empty_index > data_index ->
            compacted_blocks ++ reverse_data_blocks
          data_length == empty_length ->
            compact_impl(
              [{id, {empty_index, empty_length}}] ++ compacted_blocks,
              remaining_data,
              remaining_empty
            )
          data_length < empty_length ->
            compact_impl(
              [{id, {empty_index, data_length}}] ++ compacted_blocks,
              remaining_data,
              [{empty_index + data_length, empty_length - data_length}] ++ remaining_empty
            )
          data_length > empty_length ->
            compact_impl(
              [{id, {empty_index, empty_length}}] ++ compacted_blocks,
              [{id, {data_index, data_length - empty_length}}] ++ remaining_data,
              remaining_empty
            )
       end
      end
    end


    @spec checksum(data_block()) :: non_neg_integer()
    defp checksum(data_block) do
      {id, {start_index, block_length}} = data_block
      end_index = start_index + block_length - 1
      id * floor(end_index*(end_index + 1)/2 - (start_index - 1)*start_index/2)
    end




    @spec solve_part2(%Days.Day9{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {reverse_data_blocks, empty_blocks} = input
      compact_whole(reverse_data_blocks, empty_blocks) |>
        Enum.map(&checksum/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec compact_whole(list(data_block()), list(disk_block())) :: list(data_block())
    defp compact_whole(reverse_data_blocks, empty_blocks) do
      empty_spaces = Enum.filter(empty_blocks, fn {_, block_length} -> block_length > 0 end)
      {compacted, _} = reverse_data_blocks |>
        Enum.reduce({[], empty_spaces}, fn {id, {data_index, data_length}}, {compacted_blocks, current_empty_blocks} ->
          {{empty_index, empty_length}, list_index} = current_empty_blocks |>
            Stream.with_index() |>
            Enum.find({{0, 0}, -1}, fn {{disk_index, block_length}, _} ->
              block_length >= data_length or data_index < disk_index
            end)
          if empty_index > data_index or list_index == -1 do
            {
              [{id, {data_index, data_length}}] ++ compacted_blocks,
              current_empty_blocks
            }
          else
            if empty_length == data_length do
              {
                [{id, {empty_index, data_length}}] ++ compacted_blocks,
                List.delete_at(current_empty_blocks, list_index)
              }
            else
              {
                [{id, {empty_index, data_length}}] ++ compacted_blocks,
                List.replace_at(current_empty_blocks, list_index, {empty_index + data_length, empty_length - data_length})
              }
            end
          end
      end)
      compacted
    end


  end
end
