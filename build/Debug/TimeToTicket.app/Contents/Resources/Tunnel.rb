#
#  Tunnel.rb
#  TimeToTicket
#
#  Created by Pim Snel on 29-05-08.
#  Copyright (c) 2008 Lingewoud BV. All rights reserved.
#

class Tunnel
	def createTunnel
		begin
			@gateway = Net::SSH::Gateway.new($settings[:tunnelHost], $settings[:tunnelUser], :password => $settings[:tunnelPass])
			@tmpTunnelPort = @gateway.open($settings[:dbhost], 3306) 
		rescue Exception => msg
			@tmpTunnelPort = nil
			puts "No connection was possible ("+msg+")"
		end  
	end

	def currentPort
		return @tmpTunnelPort
	end

	def testTunnel
		createTunnel
		if @tmpTunnelPort.nil?
			return false
		else 
			closeTunnel
			return true
		end
	end

	def closeTunnel
		@gateway.shutdown!
	end


end
