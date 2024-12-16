defmodule Days.Day16 do
  defstruct []

  defimpl DaySolver do
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {1, 0} | {0, 1} | {-1, 0} | {0, -1}
    @typep corridor() :: position()
    @typep maze() :: MapSet.t(corridor())
    @typep start_point() :: position()
    @typep end_point() :: position()
    @typep day_input() :: {start_point(), end_point(), maze()}

    @spec parse_input(%Days.Day16{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Stream.with_index() |>
        Enum.reduce({nil, nil, MapSet.new()}, fn {row, y}, row_maze ->
          row |>
            String.graphemes() |>
            Stream.with_index() |>
            Enum.reduce(row_maze, fn {tile, x}, {start_point, end_point, corridors} ->
              case tile do
                "S" -> {{y, x}, end_point, MapSet.put(corridors, {y, x})}
                "E" -> {start_point, {y, x}, MapSet.put(corridors, {y, x})}
                "." -> {start_point, end_point, MapSet.put(corridors, {y, x})}
                _ -> {start_point, end_point, corridors}
              end
            end)
        end)
    end


    @spec solve_part1(%Days.Day16{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {start_point, end_point, maze} = input
      shortest_distance(start_point, {0, 1}, end_point, maze, 1, 1000) |>
        to_string()
    end

    @spec shortest_distance(start_point(), direction(), end_point(), maze(), non_neg_integer(), non_neg_integer()) :: integer()
    defp shortest_distance(start_point, start_direction, end_point, maze, move_cost, turn_cost) do
      distances_to_start(
        end_point,
        maze,
        %{},
        Heap.new(fn {distance_1, _}, {distance_2, _} -> distance_1 <= distance_2 end) |>
          Heap.push({0, {start_point, start_direction}}),
        move_cost,
        turn_cost
      )
    end


    @spec distances_to_start(end_point(), maze(), %{position() => non_neg_integer()}, Heap.t(), non_neg_integer(), non_neg_integer()) :: integer()
    defp distances_to_start(end_point, maze, known_distances, interesting_points, move_cost, turn_cost) do
      if Heap.empty?(interesting_points) do
        # The end point is not reachable.
        -1
      else
        {distance, {point, direction}} = Heap.root(interesting_points)
        if point == end_point do
          distance
        else
          remaining_heap = Heap.pop(interesting_points)
          if Map.has_key?(known_distances, {point, direction}) do
            # We have found this point and direction already with lower distance.
            # We need to check this because we do not delete old versions on update of distance.
            distances_to_start(end_point, maze, known_distances, remaining_heap, move_cost, turn_cost)
          else
            new_known = Map.put(known_distances, {point, direction}, distance)
            in_front = neighbour_in_direction(point, direction)
            intermediate_heap = if MapSet.member?(maze, in_front) do
              Heap.push(remaining_heap, {distance + move_cost, {in_front, direction}})
            else
              remaining_heap
            end
            new_heap = intermediate_heap |>
              Heap.push({distance + turn_cost, {point, turn_clockwise(direction)}})|>
              Heap.push({distance + turn_cost, {point, turn_counterclockwise(direction)}})
            distances_to_start(end_point, maze, new_known, new_heap, move_cost, turn_cost)
          end
        end
      end
    end


    @spec turn_clockwise(direction()) :: direction()
    defp turn_clockwise(direction) do
      case direction do
        {1, 0} -> {0, -1}
        {0, -1} -> {-1, 0}
        {-1, 0} -> {0, 1}
        {0, 1} -> {1, 0}
      end
    end

    @spec turn_counterclockwise(direction()) :: direction()
    defp turn_counterclockwise(direction) do
      case direction do
        {1, 0} -> {0, 1}
        {0, -1} -> {1, 0}
        {-1, 0} -> {0, -1}
        {0, 1} -> {-1, 0}
      end
    end

    @spec neighbour_in_direction(position(), direction()) :: position()
    defp neighbour_in_direction(point, direction) do
      {y, x} = point
      {y_d, x_d} = direction
      {y + y_d, x + x_d}
    end


    @spec solve_part2(%Days.Day16{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
     {start_point, end_point, maze} = input
     shortest_path_points(start_point, {0, 1}, end_point, maze, 1, 1000) |>
     MapSet.size() |>
       to_string()
    end

    @spec shortest_path_points(start_point(), direction(), end_point(), maze(), non_neg_integer(), non_neg_integer()) :: MapSet.t(corridor())
    defp shortest_path_points(start_point, start_direction, end_point, maze, move_cost, turn_cost) do
      shortest_path_points_from_start(
        end_point,
        maze,
        %{},
        Heap.new(fn {distance_1, _, points_1}, {distance_2, _, points_2} ->
          distance_1 < distance_2
            or (distance_1 == distance_2
              and MapSet.size(points_1) >= MapSet.size(points_2))
        end) |>
          Heap.push({0, {start_point, start_direction}, MapSet.new([{start_point, start_direction}])}),
        {-1, MapSet.new()},
        move_cost,
        turn_cost
      )
    end


    @spec shortest_path_points_from_start(end_point(), maze(), %{position() => {non_neg_integer(), MapSet.t(corridor())}}, Heap.t(), {integer(), MapSet.t(corridor())}, non_neg_integer(), non_neg_integer()) :: MapSet.t(corridor())
    defp shortest_path_points_from_start(end_point, maze, known_distances, interesting_points, known_end_point_paths, move_cost, turn_cost) do
      if Heap.empty?(interesting_points) do
        {_best_distance, known_best_path_points} = known_end_point_paths
        known_best_path_points |>
          Enum.map(fn {point, _} -> point end) |>
          Enum.into(MapSet.new())
      else
        {distance, {point, direction}, shortest_path_points} = Heap.root(interesting_points)
        remaining_heap = Heap.pop(interesting_points)
        if point == end_point do
          {best_distance, known_best_path_points} = known_end_point_paths
          real_shortest_path_points = shortest_path_points |>
            Enum.reduce(MapSet.new(), fn {pos, dir}, path_points ->
              if pos == end_point do
                MapSet.put(path_points, {pos, dir})
              else
                {_, shortest} = Map.get(known_distances, {pos, dir})
                MapSet.union(path_points, shortest)
              end
            end)
          if best_distance == -1 do
            shortest_path_points_from_start(end_point, maze, known_distances, remaining_heap, {distance, real_shortest_path_points}, move_cost, turn_cost)
          else
            if distance == best_distance do
              shortest_path_points_from_start(end_point, maze, known_distances, remaining_heap, {distance, MapSet.union(real_shortest_path_points, known_best_path_points)}, move_cost, turn_cost)
            else
              # There is no more path to the end point with at most the optimal length.
              known_best_path_points |>
                Enum.map(fn {point, _} -> point end) |>
                Enum.into(MapSet.new())
            end
          end
        else
          if Map.has_key?(known_distances, {point, direction}) do
            {best_distance, path_points} = Elixir.Map.get(known_distances, {point, direction})
            if best_distance == distance do
              new_known = Map.update(known_distances, {point, direction}, nil, fn _ -> {best_distance, MapSet.union(path_points, shortest_path_points)} end)
              shortest_path_points_from_start(end_point, maze, new_known, remaining_heap, known_end_point_paths, move_cost, turn_cost)
            else
              # We have found this point and direction already with lower distance.
              # We need to check this because we do not delete old versions on update of distance.
              shortest_path_points_from_start(end_point, maze, known_distances, remaining_heap, known_end_point_paths, move_cost, turn_cost)
            end
          else
            new_known = Map.put(known_distances, {point, direction}, {distance, shortest_path_points})
            in_front = neighbour_in_direction(point, direction)
            intermediate_heap = if MapSet.member?(maze, in_front) do
              Heap.push(remaining_heap, {distance + move_cost, {in_front, direction}, MapSet.put(shortest_path_points, {in_front, direction})})
            else
              remaining_heap
            end
            new_heap = intermediate_heap |>
              Heap.push({distance + turn_cost, {point, turn_clockwise(direction)}, MapSet.put(shortest_path_points, {point, turn_clockwise(direction)})})|>
              Heap.push({distance + turn_cost, {point, turn_counterclockwise(direction)}, MapSet.put(shortest_path_points, {point, turn_counterclockwise(direction)})})
            shortest_path_points_from_start(end_point, maze, new_known, new_heap, known_end_point_paths, move_cost, turn_cost)
          end
        end
      end
    end


  end
end
