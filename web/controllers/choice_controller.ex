defmodule JsonApi.ChoiceController do
  use JsonApi.Web, :controller
  alias JsonApi.Helper

  def choose(conn, params) do
    json_params = params |> Helper.to_json
    from_ms = if x = json_params["from"], do: x |> Helper.parse_time, else: 1_000
    to_ms = if x = json_params["to"], do: x |> Helper.parse_time, else: 2_000
    choice_options = json_params["choices"] # Should be a list of options
    choice = choice_options |> make_choice
    Delay.delay(from_ms, to_ms)
    json conn, %{choice: choice, value: choice_options |> Enum.at(choice-1)}
  end

  defp make_choice(options) do
    number_of_options = options |> Enum.count
    choice_number = :rand.uniform (number_of_options * 100)
    IO.puts "choice number #{choice_number}"
    1..number_of_options
      |> Enum.reduce_while(nil,
        fn n, _acc ->
          if choice_number < n * 100, do: {:halt, n}, else: {:cont, nil}
        end)
  end
end
