defmodule Days.Day15 do
  defstruct []

  defimpl DaySolver do
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: String.t() # "<" | "v" | ">" | "^" is not possible unfortunately
    @typep move_sequence() :: list(direction())
    @typep robot() :: position()
    @typep wall_tile() :: position()
    @typep walls() :: MapSet.t(wall_tile())
    @typep box() :: position()
    @typep boxes() :: MapSet.t(box())
    @typep warehouse() :: {robot(), boxes(), walls()}
    @typep day_input() :: {warehouse(), move_sequence()}
    @typep box_size() :: 1 | 2

    @spec parse_input(%Days.Day15{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      [warehouse_text, moves_text | _] = String.split(input_text, ~r"\r?\n\r?\n")
      warehouse = parse_warehouse(warehouse_text)
      moves = parse_moves(moves_text)
      {warehouse, moves}
    end

    @spec parse_warehouse(String.t()) :: warehouse()
    defp parse_warehouse(text) do
      text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Stream.with_index() |>
        Enum.reduce({nil, MapSet.new(), MapSet.new()}, fn {row, y}, row_warehouse ->
          row |>
            String.graphemes() |>
            Stream.with_index() |>
            Enum.reduce(row_warehouse, fn {tile, x}, {robot, boxes, walls} ->
              case tile do
                "@" -> {{y, x}, boxes, walls}
                "O" -> {robot, MapSet.put(boxes, {y, x}), walls}
                "#" -> {robot, boxes, MapSet.put(walls, {y, x})}
                _ -> {robot, boxes, walls}
              end
            end)
        end)
    end

    @spec parse_moves(String.t()) :: move_sequence()
    defp parse_moves(text) do
      directions = MapSet.new(["<", "v", ">", "^"])
      text |>
        String.graphemes() |>
        Enum.filter(fn c -> MapSet.member?(directions, c) end)
    end


    @spec solve_part1(%Days.Day15{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {warehouse, move_sequence} = input
      {_, boxes, _} = move(warehouse, move_sequence, 1)
      boxes |>
        Enum.map(&gps_coordinates/1) |>
        Enum.sum() |>
        to_string()
    end


    @spec move(warehouse(), move_sequence(), box_size()) :: warehouse()
    defp move(warehouse, move_sequence, box_size) do
      {initial_robot, initial_boxes, walls} = warehouse
      {new_robot, new_boxes} = move_sequence |>
        Enum.reduce({initial_robot, initial_boxes}, fn direction, {robot, boxes} ->
          move_once(direction, robot, boxes, walls, box_size)
        end)
      {new_robot, new_boxes, walls}
    end

    @spec move_once(direction(), robot(), boxes(), walls(), box_size()) :: {robot(), boxes()}
    defp move_once(direction, robot, boxes, walls, box_size) do
      move_target = neighbour(robot, direction)
      cond do
        MapSet.member?(walls, move_target) -> {robot, boxes}
        has_box?(move_target, boxes, box_size) ->
          boxes_after_move_attempt = try_to_move_box_at(direction, move_target, boxes, walls, box_size)
          if has_box?(move_target, boxes_after_move_attempt, box_size) do
            # Could not move the box.
            {robot, boxes}
          else
            {move_target, boxes_after_move_attempt}
          end
        true -> {move_target, boxes}
      end
    end

    @spec has_box?(position(), boxes(), box_size()) :: boolean()
    defp has_box?(position, boxes, box_size) do
      if box_size == 1 do
        MapSet.member?(boxes, position)
      else
        MapSet.member?(boxes, position) or MapSet.member?(boxes, neighbour(position, "<"))
      end
    end

    @spec neighbour(position(), direction()) :: position()
    defp neighbour(position, direction) do
      {y, x} = position
      case direction do
        "<" -> {y, x - 1}
        ">" -> {y, x + 1}
        "^" -> {y - 1, x}
        "v" -> {y + 1, x}
      end
    end

    @spec try_to_move_box_at(direction(), position(), boxes(), walls(), box_size()) :: boxes()
    defp try_to_move_box_at(direction, position, boxes, walls, box_size) do
      if box_size == 1 do
        try_to_move_thin_box(direction, position, boxes, walls)
      else
        try_to_move_wide_box_at(direction, position, boxes, walls)
      end
    end

    @spec try_to_move_thin_box(direction(), box(), boxes(), walls()) :: boxes()
    defp try_to_move_thin_box(direction, box, boxes, walls) do
      move_target = neighbour(box, direction)
      cond do
        MapSet.member?(walls, move_target) -> boxes
        MapSet.member?(boxes, move_target) ->
          boxes_after_move_attempt = try_to_move_thin_box(direction, move_target, boxes, walls)
          if has_box?(move_target, boxes_after_move_attempt, 1) do
            # Could not move the box.
            boxes
          else
            boxes_after_move_attempt|>
              MapSet.delete(box)|>
              MapSet.put(move_target)
          end
        true -> boxes |>
                  MapSet.delete(box)|>
                  MapSet.put(move_target)
      end
    end

    @spec gps_coordinates(position()) :: non_neg_integer()
    defp gps_coordinates(position) do
      {y, x} = position
      100 * y + x
    end


    @spec solve_part2(%Days.Day15{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {original_warehouse, move_sequence} = input
      warehouse = stretch_warehouse(original_warehouse)
      {_, boxes, _} = move(warehouse, move_sequence, 2)
      boxes |>
        Enum.map(&gps_coordinates/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec stretch_warehouse(warehouse()) :: warehouse()
    defp stretch_warehouse(warehouse) do
      {robot, boxes, walls} = warehouse
      new_robot = double_x_coordinate(robot)
      new_boxes = boxes |>
        Stream.map(&double_x_coordinate/1) |>
        Enum.into(MapSet.new())
      new_walls = walls |>
        Stream.map(&double_x_coordinate/1) |>
        Stream.flat_map(fn wall -> [wall, neighbour(wall, ">")] end) |>
        Enum.into(MapSet.new())
      {new_robot, new_boxes, new_walls}
    end

    @spec double_x_coordinate(position()) :: position()
    defp double_x_coordinate(point) do
      {y, x} = point
      {y, 2 * x}
    end

    @spec try_to_move_wide_box_at(direction(), position(), boxes(), walls()) :: boxes()
    defp try_to_move_wide_box_at(direction, position, boxes, walls) do
      box = if MapSet.member?(boxes, position) do
        position
      else
        neighbour(position, "<")
      end
      move_target = neighbour(box, direction)
      possible_collision_points = freshly_covered_points(direction, box)
      {can_move_box, potential_new_boxes} = possible_collision_points |>
        Enum.reduce_while({true, boxes}, fn point, {_can_move, current_boxes} ->
          cond do
            MapSet.member?(walls, point) -> {:halt, {false, boxes}}
            has_box?(point, current_boxes, 2) ->
              boxes_after_move_attempt = try_to_move_wide_box_at(direction, point, current_boxes, walls)
              if has_box?(point, boxes_after_move_attempt, 2) do
                # Could not move the box.
                {:halt, {false, boxes}}
              else
                {:cont, {true, boxes_after_move_attempt}}
              end
            true -> {:cont, {true, current_boxes}}
          end
        end)
        if can_move_box do
          potential_new_boxes |>
            MapSet.delete(box) |>
            MapSet.put(move_target)
        else
          boxes
        end
    end


    @spec freshly_covered_points(direction(), box()) :: list(position())
    defp freshly_covered_points(direction, wide_box) do
      case direction do
        "<" -> [wide_box |> neighbour(direction)]
        ">" -> [wide_box |> neighbour(">") |> neighbour(direction)]
        "v" -> [wide_box |> neighbour(direction), wide_box |> neighbour(">") |> neighbour(direction)]
        "^" -> [wide_box |> neighbour(direction), wide_box |> neighbour(">") |> neighbour(direction)]
      end
    end

  end
end
