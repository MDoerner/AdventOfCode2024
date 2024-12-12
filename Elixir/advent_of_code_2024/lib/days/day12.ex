defmodule Days.Day12 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {height(), width()}
    @typep field_map() :: tuple()
    @typep day_input() :: {map_dimensions(), field_map()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep direction() :: {0, 1} | {1, 0} | {0, -1} | {-1, 0}
    @typep crop_type() :: String.t()
    @typep region() :: {non_neg_integer(), crop_type}

    @spec parse_input(%Days.Day12{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      fields = input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(fn line ->
          line |>
            String.graphemes() |>
            List.to_tuple()
        end) |>
        List.to_tuple()
      dimensions = {tuple_size(fields), tuple_size(elem(fields, 0))}
      {dimensions, fields}
    end


    @spec solve_part1(%Days.Day12{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {dimensions, fields} = input
      region_fences = fences(dimensions, fields)
      {_, region_contents} = regions(fields, dimensions)
      region_contents |>
        Map.values() |>
        Enum.map(fn region_points -> price(region_points, region_fences) end) |>
        Enum.sum() |>
        to_string()
    end

    @spec fences(map_dimensions(), field_map()) :: %{position() => MapSet.t(direction())}
    defp fences(dimensions, fields) do
      {height, width} = dimensions
      Range.new(0, height - 1) |>
        Enum.reduce(%{}, fn y, known_row_fences ->
          Range.new(0, width - 1) |>
            Enum.reduce(known_row_fences, fn x, known_fences ->
              Map.put(known_fences, {y, x}, fences_for_point({y, x}, fields, dimensions))
            end)
        end)
    end

    @spec fences_for_point(position(), field_map(), map_dimensions()) :: MapSet.t(direction())
    defp fences_for_point(point, fields, dimensions) do
      {y, x} = point
      directions = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
      directions |>
        Enum.reduce(MapSet.new(), fn direction, known_fences ->
          {y_d, x_d} = direction
          neighbour = {y + y_d, x + x_d}
          if not on_map?(neighbour, dimensions) do
            MapSet.put(known_fences, direction)
          else
            if crop(neighbour, fields) != crop(point, fields) do
              MapSet.put(known_fences, direction)
            else
              known_fences
            end
          end
        end)
    end

    @spec price(MapSet.t(position()), %{position() => MapSet.t(direction())}) :: non_neg_integer()
    defp price(region_contents, fences) do
      perimeter(region_contents, fences) * area(region_contents)
    end

    @spec perimeter(MapSet.t(position()), %{position() => MapSet.t(direction())}) :: non_neg_integer()
    defp perimeter(region_contents, fences) do
      region_contents |>
        Enum.map(fn point -> fences[point] |> MapSet.size() end) |>
        Enum.sum()
    end

    @spec area(MapSet.t(position())) :: non_neg_integer()
    defp area(region_contents) do
      MapSet.size(region_contents)
    end

    @spec crop(position(), field_map()) :: non_neg_integer()
    defp crop(point, fields) do
      {y, x} = point
      elem(elem(fields, y), x)
    end

    @spec on_map?(position(), map_dimensions()) :: boolean()
    defp on_map?(point, dimensions) do
      {y, x} = point
      {height, width} = dimensions
      0 <= y and 0 <= x and y < height and x < width
    end

    @spec regions(field_map(), map_dimensions()) :: {%{position() => region()}, %{region() => MapSet.t(position())}}
    defp regions(fields, dimensions) do
      {height, width} = dimensions
      {final_region_assignments, final_region_contents, _} =  Range.new(0, height - 1) |>
        Enum.reduce({%{}, %{}, 0}, fn y, known_row_regions ->
          Range.new(0, width - 1) |>
            Enum.reduce(known_row_regions, fn x, {region_assignments, region_contents, id} ->
              if Map.has_key?(region_assignments, {y, x}) do
                {region_assignments, region_contents, id}
              else
                {crop_type, new_region_contents} = fill_region({y, x}, fields, dimensions)
                new_region_assignments = new_region_contents |>
                  Enum.reduce(region_assignments, fn point, assignments ->
                    Map.put(assignments, point, {id, crop_type})
                  end)
                new_regions = Map.put(region_contents, {id, crop_type}, new_region_contents)
                {new_region_assignments, new_regions, id + 1}
              end
            end)
        end)
      {final_region_assignments, final_region_contents}
    end

    @spec fill_region(position(), field_map(), map_dimensions()) :: {crop_type(), MapSet.t(position())}
    defp fill_region(point, fields, dimensions) do
      crop_type = crop(point, fields)
      fill_region_impl(MapSet.new([point]), MapSet.new([point]), crop_type, fields, dimensions)
    end

    @spec fill_region_impl(MapSet.t(position()), MapSet.t(position()), crop_type(), field_map(), map_dimensions()) :: {crop_type(), MapSet.t(position())}
    defp fill_region_impl(know_points, points_to_consider, crop_type, fields, dimensions) do
      if Enum.empty?(points_to_consider) do
        {crop_type, know_points}
      else
        point = Enum.take(points_to_consider, 1) |> List.first()
        new_points = neighbours(point) |>
          Enum.filter(fn neighbour ->
            not MapSet.member?(know_points, neighbour)
              and on_map?(neighbour, dimensions)
              and crop(neighbour, fields) == crop_type
          end)
        new_known = new_points |>
          Enum.reduce(know_points, fn point, known -> MapSet.put(known, point) end)
        new_to_consider = new_points |>
          Enum.reduce(points_to_consider, fn point, to_consider -> MapSet.put(to_consider, point) end) |>
          MapSet.delete(point)
        fill_region_impl(new_known, new_to_consider, crop_type, fields, dimensions)
      end
    end

    @spec neighbours(position()) :: list(position())
    defp neighbours(point) do
      {y, x} = point
      directions = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
      directions |>
        Enum.map(fn {y_d, x_d} -> {y + y_d, x + x_d} end)
    end


    @spec solve_part2(%Days.Day12{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {dimensions, fields} = input
      region_fences = fences(dimensions, fields)
      {_, region_contents} = regions(fields, dimensions)
      region_contents |>
        Map.values() |>
        Enum.map(fn region_points -> discounted_price(region_points, region_fences) end) |>
        Enum.sum() |>
        to_string()
    end

    @spec discounted_price(MapSet.t(position()), %{position() => MapSet.t(direction())}) :: non_neg_integer()
    defp discounted_price(region_contents, fences) do
      side_count(region_contents, fences) * area(region_contents)
    end

    @spec side_count(MapSet.t(position()), %{position() => MapSet.t(direction())}) :: non_neg_integer()
    defp side_count(region_contents, fences) do
      {_, side_contents} = sides(region_contents, fences)
      side_contents |>
        Map.keys() |>
        Enum.count()
    end

    @spec sides(MapSet.t(position()), %{position() => MapSet.t(direction())}) :: {%{{position(), direction()} => non_neg_integer()}, %{non_neg_integer() => MapSet.t({position(), direction()})}}
    defp sides(region_contents, fences) do
      {final_side_assignments, final_side_contents, _} = region_contents |>
        Enum.reduce({%{}, %{}, 0}, fn point, {side_assignments, side_contents, id} ->
          fences_here = fences[point]
          if MapSet.size(fences_here) == 0 do
            {side_assignments, side_contents, id}
          else
            fences_here |>
              Enum.reduce({side_assignments, side_contents, id}, fn direction, {side_assignments_before, side_contents_before, id}  ->
                if Map.has_key?(side_assignments_before, {point, direction}) do
                  {side_assignments_before, side_contents_before, id}
                else
                  new_side_contents = fill_side(point, direction, region_contents, fences)
                  new_side_assignments = new_side_contents |>
                    Enum.reduce(side_assignments_before, fn fence, assignments ->
                      Map.put(assignments, fence, id)
                    end)
                  new_sides = Map.put(side_contents_before, id, new_side_contents)
                  {new_side_assignments, new_sides, id + 1}
                end
              end)
          end
        end)
      {final_side_assignments, final_side_contents}
    end

    @spec fill_side(position(), direction(), MapSet.t(position()), %{position() => MapSet.t(direction())}) :: {crop_type(), MapSet.t(position())}
    defp fill_side(point, direction, region_contents, fences) do
      fill_side_impl(MapSet.new([{point, direction}]), MapSet.new([{point, direction}]), region_contents, fences)
    end

    @spec fill_side_impl(MapSet.t({position(), direction()}), MapSet.t({position(), direction()}), MapSet.t(position()), %{position() => MapSet.t(direction())}) :: {crop_type(), MapSet.t(position())}
    defp fill_side_impl(known_fences, fences_to_consider, region_contents, fences) do
      if Enum.empty?(fences_to_consider) do
        known_fences
      else
        {point, direction} = Enum.take(fences_to_consider, 1) |> List.first()
        new_fences = neighbours(point) |>
          Enum.filter(fn neighbour ->
            not MapSet.member?(known_fences, {neighbour, direction})
              and MapSet.member?(region_contents, neighbour)
              and MapSet.member?(fences[neighbour], direction)
          end) |>
          Enum.map(fn point -> {point, direction} end)
        new_known = new_fences |>
          Enum.reduce(known_fences, fn fence, known -> MapSet.put(known, fence) end)
        new_to_consider = new_fences |>
          Enum.reduce(fences_to_consider, fn fence, to_consider -> MapSet.put(to_consider, fence) end) |>
          MapSet.delete({point, direction})
        fill_side_impl(new_known, new_to_consider, region_contents, fences)
      end
    end


  end
end
