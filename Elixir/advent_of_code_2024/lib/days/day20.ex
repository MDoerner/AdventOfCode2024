defmodule Days.Day20 do
  defstruct []

  defimpl DaySolver do
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {1, 0} | {0, 1} | {-1, 0} | {0, -1}
    @typep corridor() :: position()
    @typep track() :: MapSet.t(corridor())
    @typep start_point() :: position()
    @typep end_point() :: position()
    @typep shortcut_goal() :: integer()
    @typep day_input() :: {start_point(), end_point(), track(), shortcut_goal()}
    @typep shortcut() :: {position(), position()}

    @spec parse_input(%Days.Day20{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      {start_point, end_point, corridors} = input_text |>
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
      {start_point, end_point, corridors, 100}
    end


    @spec solve_part1(%Days.Day20{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {start_point, end_point, track, shortcut_goal} = input
      short_shortcuts_above_threshold(start_point, end_point, track, shortcut_goal) |>
        Enum.count() |>
        to_string()
    end

    @spec short_shortcuts_above_threshold(start_point(), end_point(), track(), non_neg_integer()) :: MapSet.t(shortcut())
    defp short_shortcuts_above_threshold(start_point, end_point, track, threshold) do
      distances_to_goal = track_goal_distances(start_point, end_point, track)
      track |>
        Enum.reduce(MapSet.new(), fn start, known_shortcuts ->
          neighbours(start) |>
            Enum.reject(fn neighbour -> MapSet.member?(track, neighbour) end) |>
            Enum.reduce(known_shortcuts, fn first, known_shorts_first ->
              immediate_exists = neighbours(first) |>
                Enum.filter(fn next_neighbour ->
                  MapSet.member?(track, next_neighbour)
                    and next_neighbour != start
                end)
              immediate_exists |>
                Enum.reduce(known_shorts_first, fn immediate_exit, known ->
                  safe = shortcut_safe(start, immediate_exit, distances_to_goal)
                  if safe >= threshold do
                    MapSet.put(known, {start, immediate_exit})
                  else
                    known
                  end
                end)
            end)
        end)
    end


    @spec track_goal_distances(start_point(), end_point(), track()) :: %{corridor() => non_neg_integer()}
    defp track_goal_distances(start_point, end_point, track) do
      track_goal_distances_impl(end_point, 0, start_point, track, %{})
    end

    @spec track_goal_distances_impl(position(), non_neg_integer(), start_point(), track(), %{corridor() => non_neg_integer()}) :: %{corridor() => non_neg_integer()}
    defp track_goal_distances_impl(point, distance, start_point, track, known_distances) do
      new_known = Map.put(known_distances, point, distance)
      if point == start_point do
        new_known
      else
        next_point = neighbours(point) |>
          Enum.filter(fn neighbour ->
            MapSet.member?(track, neighbour)
              and not Map.has_key?(known_distances, neighbour)
          end) |>
          List.first()
        track_goal_distances_impl(next_point, distance + 1, start_point, track, new_known)
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

    @spec shortcut_safe(position(), position(), %{position() => non_neg_integer()}) :: integer()
    defp shortcut_safe(from_point, to_point, distances_to_goal) do
      track_distance(from_point, to_point, distances_to_goal) - manhatten_distance(from_point, to_point)
    end

    @spec track_distance(position(), position(), %{position() => non_neg_integer()}) :: integer()
    defp track_distance(from_point, to_point, distances_to_goal) do
      distances_to_goal[to_point] - distances_to_goal[from_point]
    end

    @spec manhatten_distance(position(), position()) :: non_neg_integer()
    defp manhatten_distance(point, other_point) do
      {x_1, y_1} = point
      {x_2, y_2} = other_point
      abs(x_1 - x_2) + abs(y_1 - y_2)
    end


    @spec solve_part2(%Days.Day20{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      (42 + String.length(to_string(input)) - String.length(to_string(input))) |>
        to_string()
    end



  end
end
