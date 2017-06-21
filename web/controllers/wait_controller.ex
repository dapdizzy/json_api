defmodule JsonApi.WaitController do
  use JsonApi.Web, :controller
  alias JsonApi.Helper

  def wait(conn, options) do
    json_args = options |> Helper.to_json
    from_ms = if x = json_args["from"], do: x |> parse_time, else: 1_000
    to_ms = if x = json_args["to"], do: x |> parse_time, else: 2_000
    result = Delay.delay(from_ms, to_ms)

    json conn, %{waited: result}
  end

  defp parse_time(time) do
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
