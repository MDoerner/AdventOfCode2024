defmodule Days.Day10 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {height(), width()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep topographic_map() :: tuple()
    @typep day_input() :: {map_dimensions(), topographic_map()}

    @spec parse_input(%Days.Day10{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      topo_map = input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(fn line ->
          line |>
            String.graphemes() |>
            Enum.map(&String.to_integer/1) |>
            List.to_tuple()
        end) |>
        List.to_tuple()
      dimensions = {tuple_size(topo_map), tuple_size(elem(topo_map, 0))}
      {dimensions, topo_map}
    end


    @spec solve_part1(%Days.Day10{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {dimensions, topo_map} = input
      start_points(topo_map) |>
        reachable_peaks(topo_map, dimensions) |>
        Enum.map(&Map.keys/1) |>
        Enum.map(&Enum.count/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec start_points(topographic_map()) :: MapSet.t(position())
    defp start_points(topo_map) do
      topo_map |>
        Tuple.to_list() |>
        Stream.with_index() |>
        Enum.reduce(MapSet.new(), fn {row, y}, known_starts ->
          row |>
            Tuple.to_list() |>
            Enum.with_index() |>
            Enum.reduce(known_starts, fn {height, x}, starts ->
              if height == 0 do
                MapSet.put(starts, {y, x})
              else
                starts
              end
            end)
        end)
    end

    @spec reachable_peaks(MapSet.t(position()), topographic_map(), map_dimensions()) :: list(%{position() => pos_integer()})
    defp reachable_peaks(starts, topo_map, dimensions) do
      reachable_by_position = starts |>
        Enum.reduce(%{}, fn point, reachable ->
          reachable_peaks_on_trail(point, reachable, topo_map, dimensions)
        end)
      starts |>
        Enum.map(fn point ->
          reachable_by_position[point]
        end)
    end

    @spec reachable_peaks_on_trail(position(), %{position() => %{position() => pos_integer()}}, topographic_map(), map_dimensions()) :: MapSet.t(position())
    defp reachable_peaks_on_trail(point, known_reachable_peaks, topo_map, dimensions) do
      if Map.has_key?(known_reachable_peaks, point) do
        known_reachable_peaks
      else
        if height(point, topo_map) == 9 do
          Map.put(known_reachable_peaks, point, %{point => 1})
        else
          relevant_neighbours = reachable_neighbours(point, topo_map, dimensions)
          reachable_incl_neighbours = relevant_neighbours |>
            Enum.reduce(known_reachable_peaks, fn neighbour, reachable ->
              reachable_peaks_on_trail(neighbour, reachable, topo_map, dimensions)
            end)
          reachable_from_here = relevant_neighbours |>
            Stream.map(fn neighbour ->
              reachable_incl_neighbours[neighbour]
            end) |>
            Enum.reduce(%{}, fn known_so_far, known_neighbour ->
              Map.merge(
                known_so_far,
                known_neighbour,
                fn _, count_1, count_2 -> count_1 + count_2
              end)
            end)
          Map.put(reachable_incl_neighbours, point, reachable_from_here)
        end
      end
    end

    @spec height(position(), topographic_map()) :: non_neg_integer()
    defp height(point, topo_map) do
      {y, x} = point
      elem(elem(topo_map, y), x)
    end

    @spec reachable_neighbours(position(), topographic_map(), map_dimensions()) :: list(position())
    defp reachable_neighbours(point, topo_map, dimensions) do
      point |>
        neighbours(dimensions) |>
        Enum.filter(fn neighbour -> reachable?(neighbour, point, topo_map) end)
    end

    @spec neighbours(position(), map_dimensions()) :: list(position())
    defp neighbours(point, dimensions) do
      {y, x} = point
      [{1, 0}, {0, 1}, {-1, 0}, {0, -1}] |>
        Enum.map(fn {y_d, x_d} -> {y + y_d, x + x_d} end) |>
        Enum.filter(fn p -> on_map?(p, dimensions) end)
    end

    @spec on_map?(position(), map_dimensions()) :: boolean()
    defp on_map?(point, dimensions) do
      {y, x} = point
      {height, width} = dimensions
      0 <= y and 0 <= x and y < height and x < width
    end

    @spec reachable?(position(), position(), topographic_map()) :: boolean()
    defp reachable?(neighbour, point, topo_map) do
      height(neighbour, topo_map) == height(point, topo_map) + 1
    end

    @spec solve_part2(%Days.Day10{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {dimensions, topo_map} = input
      start_points(topo_map) |>
        reachable_peaks(topo_map, dimensions) |>
        Enum.flat_map(&Map.values/1) |>
        Enum.sum() |>
        to_string()
    end


  end
end
