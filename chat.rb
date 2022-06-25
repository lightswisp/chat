#!/usr/bin/ruby

# Client implementation using sockets on ruby
# We use two thread so we can get info from the server at the same time as we get input (gets), so it doesn't block our main thread

require "socket"

ip = "localhost" 
PORT = 9999
socket = TCPSocket.new(ip, PORT)
threads = []

threads << Thread.new{
	loop do		
		input = gets.chomp
		socket.puts(input)
	end
}

threads << Thread.new{
	while data_from_server = socket.gets
		print data_from_server
	end
}


threads.each {|thread| thread.join}
socket.close
