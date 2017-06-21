defmodule JsonApi.Helper do
  def to_json(conn_options) do
    conn_options |> Map.keys |> Stream.map(& &1 |> String.replace(~s|'|, "") |> Poison.decode!) |> Enum.reduce(%{}, & Map.merge(&1, &2))
  end

  def parse_time(time) do
    case ~r/(?<value>\d+)(?<ext>\w+)/i
      |> Regex.named_captures(time) do
        %{"value" => value, "ext" => ext} = map ->
          factor =
            case ext |> String.downcase do
              "s" -> 1_000
              "ms" -> 1
            end
          value |> String.to_integer |> Kernel.*(factor)
        nil ->
          1_000 # default value
      end
  end
end
