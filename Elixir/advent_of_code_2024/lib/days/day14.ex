defmodule Days.Day14 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {width(), height()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep velocity() :: {non_neg_integer(), non_neg_integer()}
    @typep robot() :: {position(), velocity()}
    @typep day_input() :: {map_dimensions(), list(robot())}

    @spec parse_input(%Days.Day14{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      robots = input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&parse_robot/1)
      {{101, 103}, robots}
    end

    @spec parse_robot(String.t()) :: robot()
    defp parse_robot(text) do
      [p_x, p_y, v_x, v_y] = Regex.run(
        ~r"p=(-?\d+),(-?\d+)\s* v=(-?\d+),(-?\d+)",
        text,
        capture: :all_but_first
      ) |>
        Enum.map(&String.to_integer/1)
      {{p_x, p_y}, {v_x, v_y}}
    end


    @spec solve_part1(%Days.Day14{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {dimensions, robots} = input
      robots |>
        Enum.map(fn robot -> robot_position(robot, 100, dimensions) end) |>
        safety_factor(dimensions) |>
        to_string()
    end

    @spec robot_position(robot(), integer(), map_dimensions()) :: position()
    defp robot_position(robot, time, dimensions) do
      {width, height} = dimensions
      {{p_x, p_y}, {v_x, v_y}} = robot
      {mod(p_x + time * v_x, width), mod(p_y + time * v_y, height)}
    end

    defp mod(a,b) do
      candiate = rem(a, b)
      if candiate >= 0 do
        candiate
      else
        candiate + b
      end
    end

    @spec safety_factor(list(position()), map_dimensions()) :: non_neg_integer()
    defp safety_factor(robots, dimensions) do
      quadrant_counts(robots, dimensions) |>
        IO.inspect() |>
        Tuple.to_list() |>
        Enum.product()
    end

    @spec quadrant_counts(list(position()), map_dimensions()) :: {non_neg_integer(), non_neg_integer(), non_neg_integer(), non_neg_integer()}
    defp quadrant_counts(points, dimensions) do
      {width, height} = dimensions
      points |>
        Enum.reduce({0, 0, 0, 0}, fn {x, y}, {c_ul, c_ur, c_ll, c_lr} ->
          cond do
            x < floor(width/2) and y < floor(height/2) -> {c_ul + 1, c_ur, c_ll, c_lr}
            x > floor(width/2) and y < floor(height/2) -> {c_ul, c_ur + 1, c_ll, c_lr}
            x < floor(width/2) and y > floor(height/2) -> {c_ul, c_ur, c_ll + 1, c_lr}
            x > floor(width/2) and y > floor(height/2) -> {c_ul, c_ur, c_ll, c_lr + 1}
            true -> {c_ul, c_ur, c_ll, c_lr}
          end
        end)

    end


    @spec solve_part2(%Days.Day14{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {dimensions, robots} = input
      robots |>
        Enum.map(fn robot -> robot_position(robot, 10, dimensions) end) |>
        print_positions(dimensions)
    end

    @spec print_positions(list(position()), map_dimensions()) :: String.t()
    defp print_positions(points, dimensions) do
      {width, height} = dimensions
      point_map = Enum.frequencies(points)
      x_range = Range.new(0, width - 1)
      y_range = Range.new(0, height - 1)
      y_range |>
        Enum.map(fn y ->
          x_range |>
            Enum.map(fn x ->
              if Map.has_key?(point_map, {x, y}) do
                Map.get(point_map, {x, y}, 0) |> to_string()
              else
                " "
              end
            end) |>
            Enum.join() |>
            IO.inspect()
        end) |>
        Enum.join("\r\n")
    end


  end
end
