module LoginHelper
	def target
		begin
		  target ="http://api2.vcap.me"
		  client = CFoundry::V2::Client.new(target)
		  return client
		rescue CFoundry::InvalidTarget => e
		  p "Target refused connection."
		end
    end

	def login client,u, p
		credentials = {
        :username => u,
        :password => p
		}
		auth_token = client.login(credentials)
		return auth_token
	end




end
