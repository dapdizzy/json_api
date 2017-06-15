defmodule JsonApi.ShopperController do
  use JsonApi.Web, :controller

  def choose(conn, options) do
    IO.puts "Options received: #{inspect options}"
    json = options |> Map.keys |> Stream.map(& &1 |> String.replace(~s|'|, "") |> Poison.decode!) |> Enum.reduce(%{}, & Map.merge(&1, &2))
    IO.puts "JSON decoded: #{inspect json}"

    {:ok, delay_srv} = GenServer.start(Delay, [])

    sleep_from = if x = json["sleep_from"], do: x |> String.to_integer |> Kernel.*(1_000) , else: 1_000
    sleep_to = if x = json["sleep_to"], do: x |> String.to_integer |> Kernel.*(1_000), else: 5_000

    result = delay_srv |> GenServer.call({:delay, sleep_from, sleep_to}, 10_000)

    IO.puts "Process #{inspect delay_srv} is now #{if delay_srv |> Process.alive?, do: ~s(alive), else: ~s(dead)}"

    json conn, %{nothing: "nothing", json: json, result: result}
  end
end
