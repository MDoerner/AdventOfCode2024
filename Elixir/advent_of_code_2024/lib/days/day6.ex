defmodule Days.Day6 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {height(), width()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {1, 0} | {0, 1} | {-1, 0} | {0, -1}
    @typep obstacles() :: MapSet.t(position())
    @typep day_input() :: {map_dimensions(), obstacles(), position()}

    @spec parse_input(%Days.Day6{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      lines = input_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end)
      height = Enum.count(lines)
      width = String.length(hd(lines))
      {obstacles, start_position} = lines |>
        Enum.with_index() |>
        Enum.reduce({MapSet.new(), nil}, fn {line, y}, state ->
          line |>
            String.graphemes() |>
            Enum.with_index() |>
            Enum.reduce(state, fn {letter, x}, {discovered_obstacles, maybe_start_position} ->
              case letter do
                "#" -> {MapSet.put(discovered_obstacles, {y, x}), maybe_start_position}
                "^" -> {discovered_obstacles, {y, x}}
                _ -> {discovered_obstacles, maybe_start_position}
              end
            end)
        end)
        {{height, width}, obstacles, start_position}
    end


    @spec solve_part1(%Days.Day6{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {map_dimensions, obstacles, start_position} = input
      start_direction = {-1, 0}
      visited = visited_till_leaving(start_position, start_direction, MapSet.new(), obstacles, map_dimensions)
      Enum.count(visited) |>
      to_string()
    end

    @spec visited_till_leaving(position(), direction(), MapSet.t(position()), obstacles(), map_dimensions()) :: MapSet.t(position())
    defp visited_till_leaving(position, direction, visited, obstacles, map_dimensions) do
      {y, x} = position
      {height, width} = map_dimensions
      if y < 0 or y >= height or x < 0 or x >= width do
        visited
      else
        new_visited = MapSet.put(visited, position)
        {new_position, new_direction} = next_state(position, direction, obstacles)
        visited_till_leaving(new_position, new_direction, new_visited, obstacles, map_dimensions)
      end
    end

    @spec next_state(position(), direction(), obstacles()) :: {position(), direction()}
    defp next_state(position, direction, obstacles) do
      {y, x} = position
      {y_dir, x_dir} = direction
      potential_next_position = {y + y_dir, x + x_dir}
      if MapSet.member?(obstacles, potential_next_position) do
        {position, next_direction(direction)}
      else
        {potential_next_position, direction}
      end
    end

    @spec next_direction(direction()) :: direction()
    defp next_direction(direction) do
      case direction do
        {1, 0} -> {0, -1}
        {0, -1} -> {-1, 0}
        {-1, 0} -> {0, 1}
        {0, 1} -> {1, 0}
      end
    end



    @spec solve_part2(%Days.Day5{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {map_dimensions, obstacles, start_position} = input
      start_direction = {-1, 0}
      #Adding an obstacle not on the path does not change anything.
      relevant_points = MapSet.delete(
        visited_till_leaving(
          start_position,
          start_direction,
          MapSet.new(),
          obstacles,
          map_dimensions
        ),
        start_position
      )
      loop_points = relevant_points |>
        Enum.filter(fn point ->
          loops?(
              start_position,
              start_direction,
              MapSet.new(),
              MapSet.put(obstacles, point),
              map_dimensions
            )
        end)
      Enum.count(loop_points) |>
      to_string()
    end

    @spec loops?(position(), direction(), MapSet.t({position(), direction()}), obstacles(), map_dimensions()) :: boolean()
    defp loops?(position, direction, visited, obstacles, map_dimensions) do
      {y, x} = position
      {height, width} = map_dimensions
      if y < 0 or y >= height or x < 0 or x >= width do
        false
      else
        if MapSet.member?(visited, {position, direction}) do
          true
        else
          new_visited = MapSet.put(visited, {position, direction})
          {new_position, new_direction} = next_state(position, direction, obstacles)
          loops?(new_position, new_direction, new_visited, obstacles, map_dimensions)
        end
      end
    end

  end
end
