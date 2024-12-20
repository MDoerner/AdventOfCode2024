defmodule Days.Day20 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {width(), height()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {1, 0} | {0, 1} | {-1, 0} | {0, -1}
    @typep corridor() :: position()
    @typep track() :: MapSet.t(corridor())
    @typep start_point() :: position()
    @typep end_point() :: position()
    @typep shortcut_goal() :: integer()
    @typep day_input() :: {start_point(), end_point(), track(), map_dimensions(), shortcut_goal()}
    @typep shortcut() :: {position(), position()}

    @spec parse_input(%Days.Day20{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      lines = input_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end)
      height = Enum.count(lines)
      width = List.first(lines) |> String.length()
      {start_point, end_point, corridors} = lines |>
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
      {start_point, end_point, corridors, {height, width}, 100}
    end


    @spec solve_part1(%Days.Day20{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {start_point, end_point, track, _dimensions, shortcut_goal} = input
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
                  safe = short_shortcut_save(start, immediate_exit, distances_to_goal)
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

    @spec short_shortcut_save(position(), position(), %{position() => non_neg_integer()}) :: integer()
    defp short_shortcut_save(from_point, to_point, distances_to_goal) do
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
      {start_point, end_point, track, _dimensions, shortcut_goal} = input
      shortcuts_above_threshold(start_point, end_point, track, shortcut_goal, 20) |>
        Enum.count() |>
        to_string()
    end

    @spec shortcuts_above_threshold(start_point(), end_point(), track(), non_neg_integer(), pos_integer()) :: MapSet.t(shortcut())
    defp shortcuts_above_threshold(start_point, end_point, track, threshold, max_shortcut_length) do
      track_distances = track_goal_distances(start_point, end_point, track)
      track |>
        Enum.reduce(MapSet.new(), fn shortcut_start, shortcuts ->
          track |>
            Enum.filter(fn shortcut_end ->
              manhatten_distance(shortcut_start, shortcut_end) <= max_shortcut_length
                and short_shortcut_save(shortcut_start, shortcut_end, track_distances) >= threshold
            end) |>
            Enum.map(fn shortcut_end -> {shortcut_start, shortcut_end} end) |>
            Enum.into(shortcuts)
        end)
    end

    # The below was based on the wrong assumption that a cheat needs to stay off-road, which makes the problem actually quite a bit harder.

    # @spec shortcuts_above_threshold(start_point(), end_point(), track(), map_dimensions(), non_neg_integer(), pos_integer()) :: MapSet.t(shortcut())
    # defp shortcuts_above_threshold(start_point, end_point, track, dimensions, threshold, max_shortcut_length) do
    #   track_distances = track_goal_distances(start_point, end_point, track)
    #   track |>
    #     Enum.reduce(MapSet.new(), fn start, shortcuts ->
    #       points_within_off_road_distance(start, max_shortcut_length, track, dimensions) |>
    #         Enum.filter(fn {shortcut_end, shortcut_length} ->
    #           shortcut_saved_distance(start, shortcut_end, shortcut_length, track_distances) >= threshold
    #         end) |>
    #         Enum.map(fn {shortcut_end, _shortcut_length} -> {start, shortcut_end} end) |>
    #         Enum.into(shortcuts)
    #     end)
    # end

    # @spec points_within_off_road_distance(position(), non_neg_integer(), track(), map_dimensions()) :: %{corridor() => non_neg_integer()}
    # defp points_within_off_road_distance(start_point, max_distance, track, dimensions) do
    #   first_off_road_neighbours = neighbours(start_point) |>
    #     Enum.reject(fn neighbour -> MapSet.member?(track, neighbour) end)
    #   initial_interesting = first_off_road_neighbours |>
    #     Enum.reduce(Heap.new(fn {distance_1, _}, {distance_2, _} -> distance_1 <= distance_2 end), fn neighbour, interesting ->
    #       Heap.push(interesting, {1, neighbour})
    #     end)
    #   off_road_distance_points(
    #     max_distance,
    #     track,
    #     dimensions,
    #     MapSet.new(),
    #     initial_interesting,
    #     %{}
    #   )
    # end

    # @spec off_road_distance_points(non_neg_integer(), track(), map_dimensions(), MapSet.t(position()), Heap.t(), %{corridor() => non_neg_integer()}) :: %{corridor() => non_neg_integer()}
    # defp off_road_distance_points(max_distance, track, dimensions, visited_off_road_points, interesting_points, known_shortcut_ends) do
    #   if Heap.empty?(interesting_points) do
    #     known_shortcut_ends
    #   else
    #     {distance, point} = Heap.root(interesting_points)
    #     if distance >= max_distance do
    #       known_shortcut_ends
    #     else
    #       remaining_heap = Heap.pop(interesting_points)
    #       if Map.has_key?(visited_off_road_points, point) do
    #         # We have found this point and direction already with lower distance.
    #         # We need to check this because we do not delete old versions on update of distance.
    #         off_road_distance_points(max_distance, track, dimensions, visited_off_road_points, remaining_heap, known_shortcut_ends)
    #       else
    #         new_visited = MapSet.put(visited_off_road_points, point)
    #         new_on_road_neighbours = neighbours(point) |>
    #           Enum.filter(fn neighbour ->
    #             MapSet.member?(track, neighbour)
    #               and not Map.has_key?(known_shortcut_ends, neighbour)
    #           end)
    #         new_known = new_on_road_neighbours |>
    #           Enum.reduce(known_shortcut_ends, fn neighbour, known ->
    #             Map.put(known, neighbour, distance + 1)
    #           end)
    #         new_off_road_neighbours = neighbours(point) |>
    #           Enum.filter(fn neighbour ->
    #             not MapSet.member?(track, neighbour)
    #               and not MapSet.member?(visited_off_road_points, neighbour)
    #               and on_map?(neighbour, dimensions)
    #           end)
    #         new_heap = new_off_road_neighbours |>
    #           Enum.reduce(remaining_heap, fn neighbour, heap ->
    #             Heap.push(heap, {distance + 1, neighbour})
    #           end)
    #         off_road_distance_points(max_distance, track, dimensions, new_visited, new_heap, new_known)
    #       end
    #     end
    #   end
    # end

    # @spec on_map?(position(), map_dimensions()) :: boolean()
    # defp on_map?(point, dimensions) do
    #   {y, x} = point
    #   {height, width} = dimensions
    #   0 <= y and 0 <= x and y < height and x < width
    # end


    # @spec shortcut_saved_distance(position(), position(), pos_integer(), %{position() => non_neg_integer()}) :: integer()
    # defp shortcut_saved_distance(from_point, to_point, shortcut_length, distances_to_goal) do
    #   track_distance(from_point, to_point, distances_to_goal) - shortcut_length
    # end



  end
end
