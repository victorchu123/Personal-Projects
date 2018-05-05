# compile with:
#    mix escript.build
# run with
#    ./chat server whatever@tenger
#    ./chat client whatever@tenger

defmodule Chat do

  def server_mainloop(chatlog, connectedusers) do
    receive do
      {:BROADCAST, pid, author, message} ->
         Enum.map(connectedusers, 
            fn({p,_,_})-> if p != pid do
                 send(p, {:SHOWMESSAGE, author, message}) 
               end
            end)
         server_mainloop(chatlog ++ [{author, message}], connectedusers)
      {:NEWUSER, pid, username} ->
         Enum.map(chatlog, fn({author, message}) -> send(pid, {:SHOWMESSAGE, author, message}) end)
         server_mainloop(chatlog, connectedusers ++ [{pid, username, Process.monitor(pid)}])
      {:DOWN, ref, _, _, _} ->
         server_mainloop(chatlog, Enum.filter(connectedusers, fn({_,_,m}) -> m != ref end))
    end
  end

  def do_server() do
    server_mainloop([], [])
  end



  def client_senderloop(receivepid, servernodename, username) do
    input = String.trim(IO.gets ">")
    send {:chatserver, servernodename}, {:BROADCAST, receivepid, username, input}
    client_senderloop(receivepid, servernodename, username)
  end

  def client_mainloop(servernodename, server_ref) do
    receive do
        {:SHOWMESSAGE, author, content} ->
           IO.puts "\n" <> author <> ": " <> content
           client_mainloop(servernodename, server_ref)
        {:DOWN, ^server_ref, _, _, _} ->
           IO.puts "Server disconnected"
    end
  end

  def do_client(servernodename) do
    username = String.trim(IO.gets "User name? ")
    server_ref = Process.monitor {:chatserver, servernodename}
    receivepid = self
    send {:chatserver, servernodename}, {:NEWUSER, receivepid, username}
    spawn_link fn -> client_senderloop(receivepid, servernodename, username) end
    client_mainloop(servernodename, server_ref)
  end

  def main(args) do
    case args do
       ["server", servernodename] ->
           Process.register(self, :chatserver)
           {:ok, _} = Node.start(String.to_atom(servernodename), :shortnames, 15000)
           do_server()
       ["client", servernodename] ->
           mynodename = String.to_atom("A"<>String.replace(to_string(:rand.uniform), ".", ""))
           {:ok, _} = Node.start(mynodename, :shortnames, 15000)
           do_client(String.to_atom(servernodename))
       _ -> 
           IO.puts "Please enter server or client, as well as the server address"
    end
  end
end
