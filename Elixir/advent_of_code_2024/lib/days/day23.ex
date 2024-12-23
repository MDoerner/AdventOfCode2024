defmodule Days.Day23 do
  defstruct []

  defimpl DaySolver do
    @typep computer() :: String.t()
    @typep connection() :: {computer(), computer()}
    @typep network() :: %{computer() => MapSet.t(computer())}
    @typep cluster() :: MapSet.t(computer())
    @typep day_input() :: list(connection())

    @spec parse_input(%Days.Day23{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n") |>
        Stream.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&parse_connection/1)
    end

    @spec parse_connection(String.t()) :: connection()
    defp parse_connection(text) do
      text |>
        String.split(~r"-") |>
        List.to_tuple()
    end


    @spec solve_part1(%Days.Day23{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      network = adjacency_map(input)
      t_computers = network |>
        Map.keys() |>
        Enum.filter(fn computer -> String.starts_with?(computer, "t") end)
      t_computers |>
        Enum.reduce(MapSet.new(), fn computer, triplets ->
          MapSet.union(triplets, triplets(computer, network))
        end) |>
        MapSet.size() |>
        to_string()
    end

    @spec adjacency_map(Enumerable.t(connection())) :: network()
    defp adjacency_map(connections) do
      connections |>
        Enum.reduce(%{}, fn connection, network ->
          {a, b} = connection
          network |>
            Map.update(a, MapSet.new([b]), fn connected -> MapSet.put(connected, b) end) |>
            Map.update(b, MapSet.new([a]), fn connected -> MapSet.put(connected, a) end)
        end)
    end

    @spec triplets(computer(), network()) :: MapSet.t(cluster())
    defp triplets(computer, network) do
      neighbours = Map.get(network, computer, MapSet.new())
      neighbours |>
        Enum.reduce(MapSet.new(), fn neighbour_1, outer_triplets ->
          neighbours_of_neighbour = network[neighbour_1]
          neighbours |>
            Enum.reduce(outer_triplets, fn neighbour_2, inner_triplets ->
              if MapSet.member?(neighbours_of_neighbour, neighbour_2) do
                MapSet.put(inner_triplets, MapSet.new([computer, neighbour_1, neighbour_2]))
              else
                inner_triplets
              end
            end)
        end)
    end

    @spec solve_part2(%Days.Day23{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      network = adjacency_map(input)
      largest = largest_cluster(network, 3)
      largest |>
        Enum.sort() |>
        Enum.join(",")
    end

    @spec largest_cluster(network, non_neg_integer()) :: cluster()
    defp largest_cluster(network, min_size) do
        {_, best_known} = network |>
          Enum.sort(fn {_computer, neighbours}, {_computer2, neighbours2} ->
            MapSet.size(neighbours) >= MapSet.size(neighbours2)
          end) |>
          Enum.reduce_while({min_size, MapSet.new()}, fn {computer, neighbours}, {current_min_size, best_cluster} ->
            if MapSet.size(neighbours) < current_min_size do
              {:halt, {current_min_size - 1, best_cluster}}
            else
              subnet = subnetwork(neighbours, network)
              best_sub_cluster = largest_cluster(subnet, min_size - 1)
              if MapSet.size(best_sub_cluster) >= min_size - 1 do
                new_best = MapSet.put(best_sub_cluster, computer)
                new_target_size = MapSet.size(new_best) + 1
                {:cont, {new_target_size, new_best}}
              else
                {:cont, {current_min_size, best_cluster}}
              end
            end
          end)
          best_known
    end

    @spec subnetwork(MapSet.t(computer()), network()) :: network()
    defp subnetwork(computers, network) do
      computers |>
        Enum.reduce(%{}, fn computer, subnet ->
          neighbours = Map.get(network, computer, MapSet.new())
          Map.put(subnet, computer, MapSet.intersection(neighbours, computers))
        end)
    end

  end
end
