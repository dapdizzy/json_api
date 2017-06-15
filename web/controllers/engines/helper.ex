defmodule JsonApi.Helper do
  def to_json(conn_options) do
    conn_options |> Map.keys |> Stream.map(& &1 |> String.replace(~s|'|, "") |> Poison.decode!) |> Enum.reduce(%{}, & Map.merge(&1, &2))
  end
end
