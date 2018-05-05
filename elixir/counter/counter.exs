
defmodule Counter do

  def counter_loop(val) do
     receive do
        {:QUERY, pid} -> 
            send pid, val
            counter_loop(val)
        {:INCREMENT} ->
            counter_loop(val+1)
     end

  end

  def start_counter_loop() do
    spawn fn -> counter_loop(0) end
  end
 
end
