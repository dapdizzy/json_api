defmodule JsonApi.HandoverController do
  use JsonApi.Web, :controller
  alias JsonApi.Helper

  def wait(conn, options) do
    json = options |> Helper.to_json
    result = if items = json["items"], do: items |> Enum.count |> Kernel.*(1_000) |> delay(1_000), else: Delay.delay(2_000, 5_000)
    json conn, %{result: result}
  end

  defp delay(max_wait_time, min_wait_time) do
    Delay.delay(min_wait_time, max_wait_time)
  end
end
