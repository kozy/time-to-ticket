require 'osx/cocoa'

class AppController < OSX::NSObject

	def init
		#puts $LOAD_PATH
		init_prefs

		$timerController = Clock.new
		$timerController.resetTime
		$timerController.timeDelta

		$TunnelController = Tunnel.new

		setPopupTimer

		if (@statusItem == nil)
			@statusItem = OSX::NSStatusBar.systemStatusBar.statusItemWithLength(OSX::NSVariableStatusItemLength)
			@statusItem.setImage_(OSX::NSImage.imageNamed_("test2"))
			@statusItem.setHighlightMode_(true)
			menu = OSX::NSMenu.alloc.initWithTitle("")
			menu.addItemWithTitle_action_keyEquivalent("Time To Ticket",:showLogTime,"")
			menu.addItemWithTitle_action_keyEquivalent("Preferences",:showPreferences,"")
			menu.addItemWithTitle_action_keyEquivalent("Quit",:quitApplication,"")
			menu.addItemWithTitle_action_keyEquivalent(getVersion,nil,"")

			@statusItem.setMenu(menu)
			menu.release
			return self
		end
	end

	def	setPopupTimer
		@timer = OSX::NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_( $settings[:popupInterval] , self, :tick, nil, true)
	end

	def getVersion
		infoDictionary = OSX::NSBundle.mainBundle.infoDictionary
		infoDictionary.objectForKey("CFBundleShortVersionString") + ' ('+ infoDictionary.objectForKey("CFBundleVersion") +')'
	end
	def init_prefs
		$prefs = PrefsStorage.new
		$prefs.initAll	
	end

	def tick
		openLogTimeWindow(self)
	end

	ib_action :showPreferences
	def showPreferences(sender)
		if not @prefsController
			@prefsController = PreferencesController.alloc.init
		end
		@prefsController.showWindow(self)
	end

	ib_action :showLogTime
	def showLogTime(sender)
		setPopupTimer
		openLogTimeWindow(self)
	end

	def openLogTimeWindow(sender)
		if not $LogTimeContr
			$LogTimeContr = LogTimeController.alloc.init
		end

		$LogTimeContr.openW
	end

	def test(x)
	end

	def applicationDidFinishLaunching(n10n)
		p "Window Loaded!"
	end

	def	applicationWillTerminate(n10n)
		p "App terminated!"
	end

	def quitApplication(x)
		OSX::NSApp.terminate_(nil)
	end
end
