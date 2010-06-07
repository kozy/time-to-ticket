require 'osx/cocoa'

class LogTimeController < OSX::NSWindowController
	ib_outlets :redmine
	ib_outlets :theWindow 
	ib_outlets :treeController

	def init
		super_init
		#self if self.initWithWindowNibName_owner('logtime', self)
	end

	def WindowVisible
		if @loaded and @theWindow.isVisible
			return true
		else
			return false
		end
	end

	ib_action :reloadWindow
	def reloadWindow
		@theWindow.orderOut_(false)
		@loaded = nil
		openW
	end

	def hideW
		@theWindow.orderOut_(false)
	end


	def openW
		if not @loaded
			@loaded = OSX::NSBundle.loadNibNamed_owner("logtime", self)
		end

		@treeController.connectToRedMine
		@treeController.retrievePositions

		OSX::NSApp.activateIgnoringOtherApps(true)
		@theWindow.makeKeyAndOrderFront(nil)

		if $noConnection
			@theWindow.orderOut_(false)
		end
		self
	end

	def awakeFromNib
		puts 'logtime awake'	
	end
end
