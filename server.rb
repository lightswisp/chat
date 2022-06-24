#!/usr/bin/ruby

# Простой чат на сокетах, который работает по типу беседы всех со всеми. Так называемый "открытый канал".
# При подключении всем пользователям идет сообщение о том что подключился юзер, после ввода имени.
# Если пользователь резко отключиться, то на сервере сработает хендлер интерраптов при котором поток завершиться нормально и напишется сообщение на сервере. 

require 'socket'
require 'thread'

PORT = 9999 
server = TCPServer.open(PORT)
puts "Server is running on #{PORT}..."
clients = [] #we store our clients in the array for further communication between them


#There is an infinite loop, whenever client connects we create a new thread and put it inside an array.
#Inside the thread we use while loop so we can get users messages infinitely until the connection is closed
#When our client disconnects we remove clients thread from array and close the connection 

loop do
	clients << Thread.start(server.accept) do |client|
		begin
			Thread.current["client"] = client
			client.print("#{Time.now.ctime}\n#{clients.size} users is/are online \nEnter your name: ")
			#client.puts(Time.now.ctime)
			#client.print("#{clients.size} users is/are online \n") 
			#client.print("Enter your name: ")
			clientName = client.gets
			clientName = "Unknown ##{clients.size}" if clientName.to_s.chomp == ""
			clients.each do |clientThread| #Notify everybody that somebody has connected
				clientThread["client"].print("#{clientName.to_s.chomp} has connected! \n")
			end
			while clientInput = client.gets
				clients.each do |clientThread| #Send a message to everyone
					clientThread["client"].print("#{clientName.to_s.chomp}: #{clientInput.to_s.chomp} \n")
				end
			end		
		rescue
			
			#client.close()	
			puts "[Exception handler] Client has unexpectedly disconnected!"
		end
		clients.delete(Thread.current)
		clients.each do |clientThread| #Notify everybody that somebody has disconnected
			clientThread["client"].print("#{clientName.to_s.chomp} has disconnected! \n")
		end
	end
	print(clients, "\n")
end

