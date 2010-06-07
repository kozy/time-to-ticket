class IssueProxy < OSX::ActiveRecordProxy
	def rbValueForKey(key)
		super
	rescue ActiveRecord::StatementInvalid => e # that's apparently what it raises for a lost connection
		# do some reporting and reconnect or what have you not...
		#make general class method for this one
		@alert = OSX::NSAlert.alloc.init
		@alert.setMessageText("The connection died. Try clicking SyncDb from the menu.")
		@alert.setAlertStyle(OSX::NSCriticalAlertStyle)
		@alert.addButtonWithTitle("OK")
		@alert.runModal
		puts e.message
		puts e.backtrace
	end

	#	on_get :spent_hours, :return => 
	#def spent_hours
	#	Issue.spent_hours
	#end
end
