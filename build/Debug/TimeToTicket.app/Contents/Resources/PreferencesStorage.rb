class PrefsStorage < OSX::NSObject

	def initAll	
		$settings = {}
		$settings[:redminePassword] = unArchive(getDefaultsValue('redminePassword')).to_s
		$settings[:redmineUser] = unArchive(getDefaultsValue('redmineUser')).to_s

		$settings[:dbname] = unArchive(getDefaultsValue('dbname')).to_s
		$settings[:dbuser] = unArchive(getDefaultsValue('dbuser')).to_s
		$settings[:dbhost] = unArchive(getDefaultsValue('dbhost')).to_s
		$settings[:dbpass] = unArchive(getDefaultsValue('dbpassword')).to_s

		$settings[:popupInterval] = getDefaultsValue('popupInterval').to_i * 60
		if $settings[:popupInterval] < 900 
			$settings[:popupInterval] = 15 * 60
		end

		$settings[:tunnelEnable] = getDefaultsValue('sshtunnelActive').to_i
		$settings[:tunnelHost] = unArchive(getDefaultsValue('sshtunnelHost')).to_s
		$settings[:tunnelUser] = unArchive(getDefaultsValue('sshtunnelUser')).to_s
		$settings[:tunnelPass] = unArchive(getDefaultsValue('sshtunnelPassword')).to_s
	end

	def debugSettings
		$settings.each {|set|
			puts set
		}
		puts $settings[:popupInterval]
	end

	def getDefaultsValue(key)
		OSX::NSUserDefaultsController.sharedUserDefaultsController.values.valueForKey(key)
	end

	def unArchive(data)
		if ! data 
			return
		else
			return OSX::NSUnarchiver.unarchiveObjectWithData(data)
		end
	end
end
