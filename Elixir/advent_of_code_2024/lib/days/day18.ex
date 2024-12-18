defmodule Days.Day18 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {width(), height()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {1, 0} | {0, 1} | {-1, 0} | {0, -1}
    @typep block() :: position()
    @typep corruptions() :: MapSet.t(position())
    @typep start_point() :: position()
    @typep end_point() :: position()
    @typep day_input() :: {start_point(), end_point(), map_dimensions(), list(block()), non_neg_integer()}

    @spec parse_input(%Days.Day18{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      blocks = input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(fn line ->
          line |>
            String.split(~r",") |>
            Enum.map(&String.to_integer/1) |>
            List.to_tuple()
        end)
        {{0, 0}, {70, 70}, {71, 71}, blocks, 1024}
    end


    @spec solve_part1(%Days.Day18{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {start_point, end_point, dimensions, blocks, blocks_fallen} = input
      corruptions = blocks |>
        Enum.take(blocks_fallen) |>
        Enum.into(MapSet.new())
      shortest_distance(start_point, end_point, dimensions, corruptions) |>
        to_string()
    end

    @spec shortest_distance(start_point(), end_point(), map_dimensions(), corruptions()) :: integer()
    defp shortest_distance(start_point, end_point, dimensions, corruptions) do
      distances_to_start(
        end_point,
        dimensions,
        corruptions,
        %{},
        Heap.new(fn {distance_1, _}, {distance_2, _} -> distance_1 <= distance_2 end) |>
          Heap.push({0, start_point})
      )
    end


    @spec distances_to_start(end_point(), map_dimensions(), corruptions(), %{position() => non_neg_integer()}, Heap.t()) :: integer()
    defp distances_to_start(end_point, dimensions, corruptions, known_distances, interesting_points) do
      if Heap.empty?(interesting_points) do
        # The end point is not reachable.
        -1
      else
        {distance, point} = Heap.root(interesting_points)
        if point == end_point do
          distance
        else
          remaining_heap = Heap.pop(interesting_points)
          if Map.has_key?(known_distances, point) do
            # We have found this point and direction already with lower distance.
            # We need to check this because we do not delete old versions on update of distance.
            distances_to_start(end_point, dimensions, corruptions, known_distances, remaining_heap)
          else
            new_known = Map.put(known_distances, point, distance)
            accessible_neighbours = neighbours(point) |>
              Enum.filter(fn neighbour ->
                on_map?(neighbour, dimensions)
                  and not MapSet.member?(corruptions, neighbour)
                  and not Map.has_key?(known_distances, neighbour)
              end)
            new_heap = accessible_neighbours |>
              Enum.reduce(remaining_heap, fn neighbour, heap ->
                Heap.push(heap, {distance + 1, neighbour})
              end)
            distances_to_start(end_point, dimensions, corruptions, new_known, new_heap)
          end
        end
      end
    end

    @spec neighbours(position()) :: list(position())
    defp neighbours(point) do
      [{1, 0}, {0, 1}, {-1, 0}, {0, -1}] |>
        Enum.map(fn direction -> neighbour_in_direction(point, direction) end)
    end

    @spec neighbour_in_direction(position(), direction()) :: position()
    defp neighbour_in_direction(point, direction) do
      {y, x} = point
      {y_d, x_d} = direction
      {y + y_d, x + x_d}
    end

    @spec on_map?(position(), map_dimensions()) :: boolean()
    defp on_map?(point, dimensions) do
      {y, x} = point
      {height, width} = dimensions
      0 <= y and 0 <= x and y < height and x < width
    end

    @spec shortest_distance_A(start_point(), end_point(), map_dimensions(), corruptions()) :: integer()
    defp shortest_distance_A(start_point, end_point, dimensions, corruptions) do
      distances_to_start_A(
        end_point,
        dimensions,
        corruptions,
        %{},
        Heap.new(fn {loss_1, _, _}, {loss_2, _, _} -> loss_1 <= loss_2 end) |>
          Heap.push({a_heuristic(start_point, end_point), 0, start_point})
      )
    end

    @spec a_heuristic(position(), end_point()) :: non_neg_integer()
    defp a_heuristic(point, end_point) do
      manhatten_distance(point, end_point) |>
        Bitwise.bsr(1)
    end

    @spec manhatten_distance(position(), position()) :: non_neg_integer()
    defp manhatten_distance(point, other_point) do
      {x_1, y_1} = point
      {x_2, y_2} = other_point
      abs(x_1 - x_2) + abs(y_1 - y_2)
    end


    @spec distances_to_start_A(end_point(), map_dimensions(), corruptions(), %{position() => non_neg_integer()}, Heap.t()) :: integer()
    defp distances_to_start_A(end_point, dimensions, corruptions, known_distances, interesting_points) do
      if Heap.empty?(interesting_points) do
        # The end point is not reachable.
        -1
      else
        {_loss, distance, point} = Heap.root(interesting_points)
        if point == end_point do
          distance
        else
          remaining_heap = Heap.pop(interesting_points)
          if Map.has_key?(known_distances, point) do
            # We have found this point and direction already with lower distance.
            # We need to check this because we do not delete old versions on update of distance.
            distances_to_start_A(end_point, dimensions, corruptions, known_distances, remaining_heap)
          else
            new_known = Map.put(known_distances, point, distance)
            accessible_neighbours = neighbours(point) |>
              Enum.filter(fn neighbour ->
                on_map?(neighbour, dimensions)
                  and not MapSet.member?(corruptions, neighbour)
                  and not Map.has_key?(known_distances, neighbour)
              end)
            new_heap = accessible_neighbours |>
              Enum.reduce(remaining_heap, fn neighbour, heap ->
                Heap.push(heap, {a_heuristic(neighbour, end_point) + distance + 1, distance + 1, neighbour})
              end)
            distances_to_start_A(end_point, dimensions, corruptions, new_known, new_heap)
          end
        end
      end
    end



    @spec solve_part2(%Days.Day18{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {start_point, end_point, dimensions, blocks, known_non_blocking_block_count} = input
      first_blocking_block(start_point, end_point, dimensions, blocks, known_non_blocking_block_count) |>
        Tuple.to_list() |>
        Enum.join(",")
    end

    @spec first_blocking_block(start_point(), end_point(), map_dimensions(), list(block()), non_neg_integer()) :: block() | nil
    defp first_blocking_block(start_point, end_point, dimensions, blocks, known_safe_block_count) do
      if end_point_reachable?(start_point, end_point, dimensions, blocks |> Enum.into(MapSet.new())) do
        # The path will never be blocked.
        nil
      else
        start_corruptions = blocks |>
          Enum.take(known_safe_block_count) |>
          Enum.into(MapSet.new())
        remaining_blocks = blocks |>
          Enum.drop(known_safe_block_count)
        first_blocking_block_impl(start_point, end_point, dimensions, remaining_blocks, start_corruptions)
      end
    end

    @spec first_blocking_block_impl(start_point(), end_point(), map_dimensions(), list(block()), corruptions()) :: block() | nil
    defp first_blocking_block_impl(start_point, end_point, dimensions, remaining_blocks, known_corruptions) do
      block_count = length(remaining_blocks)
      case block_count do
        1 -> hd(remaining_blocks)
        0 -> nil
        _ ->
          middle = floor(block_count / 2)
          corruptions = remaining_blocks |>
            Enum.take(middle) |>
            Enum.into(known_corruptions)
          if end_point_reachable?(start_point, end_point, dimensions, corruptions) do
            first_blocking_block_impl(
              start_point,
              end_point,
              dimensions,
              remaining_blocks |> Enum.drop(middle),
              corruptions
            )
          else
            first_blocking_block_impl(
              start_point,
              end_point,
              dimensions,
              remaining_blocks |> Enum.take(middle),
              known_corruptions
            )
          end
      end
    end

    @spec end_point_reachable?(position(), position(), map_dimensions(), corruptions()) :: boolean()
    defp end_point_reachable?(start_point, end_point, dimensions, corruptions) do
      0 <= shortest_distance_A(start_point, end_point, dimensions, corruptions)
    end

    # Returns the first blocking block, if there is any, and all corruptions, otherwise.
    # Sufficiently fast, but faster is easily possible
    @spec first_blocking_block_naive(start_point(), end_point(), map_dimensions(), list(block()), non_neg_integer()) :: block() | corruptions()
    defp first_blocking_block_naive(start_point, end_point, dimensions, blocks, known_safe_block_count) do
      start_corruptions = blocks |>
        Enum.take(known_safe_block_count) |>
        Enum.into(MapSet.new())
      remaining_blocks = blocks |>
        Enum.drop(known_safe_block_count)
      remaining_blocks |>
        Enum.reduce_while(start_corruptions, fn block, corruptions ->
          new_corruptions = MapSet.put(corruptions, block)
          if end_point_reachable?(start_point, end_point, dimensions, new_corruptions) do
            {:cont, new_corruptions}
          else
            {:halt, block}
          end
        end)
    end

  end
end
