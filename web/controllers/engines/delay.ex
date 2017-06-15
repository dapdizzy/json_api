defmodule Delay do
  use GenServer

  def delay(from_ms, to_ms) do
    {:ok, server} = GenServer.start(__MODULE__, [])
    server |> GenServer.call({:delay, from_ms, to_ms})
  end

  def handle_call({:delay, from_ms, to_ms}, from, _state) do
    timeout = from_ms + :rand.uniform(to_ms - from_ms)
    Process.send_after(self(), {:reply, from, "Slept for #{timeout} ms, given sleep from #{from_ms} to #{to_ms}"}, timeout)
    {:noreply, :no_state}
  end

  def handle_info({:reply, from, result}, _state) do
    reply_result(from, result)
    {:stop, :normal, :no_state}
  end

  def reply_result(from, result) do
    GenServer.reply from, result
  end
end
