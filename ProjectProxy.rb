class ProjectProxy < OSX::ActiveRecordProxy
	def rbValueForKey(key)
		super
	rescue ActiveRecord::StatementInvalid => e # that's apparently what it raises for a lost connection
		@alert = OSX::NSAlert.alloc.init
		@alert.setMessageText("The connection died. Try clicking SyncDb from the menu.")
		@alert.setAlertStyle(OSX::NSCriticalAlertStyle)
		@alert.addButtonWithTitle("OK")
		@alert.runModal
		puts e.message
		puts e.backtrace
	end
end
