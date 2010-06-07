#
#  PreferencesController.rb
#
#  Copyright (c) 2008 Elucidata (www.elucidata.net). All rights reserved.

class PreferencesController < OSX::NSWindowController
	include OSX

	kvc_accessor :dbsettings

	ib_outlets :generalPrefsView,
		:advancedPrefsView,
		:databasePrefsView,
		:userInfoPrefsView,
		:sshTunnelPrefsView,
		:happyImage,
		:sadImage,
		:mainWindow

	# This is the target action for the toolbar items
	ib_action :selectPrefPanel do |sender|
		tag =  sender.tag
		view, title = self.viewForTag(tag)
		previousView, prevTitle = self.viewForTag(@currentViewTag)
		@currentViewTag = tag
		newFrame = self.newFrameForNewContentView(view)
		window.title = "#{title} Preferences"
		# Using an animation grouping because we may be changing the duration
		NSAnimationContext.beginGrouping
		# Call the animator instead of the view / window directly
		window.contentView.animator.replaceSubview_with(previousView, view)
		window.animator.setFrame_display newFrame, true
		NSAnimationContext.endGrouping
	end

	ib_action :testTunnelSettings
	def testTunnelSettings
		$prefs.initAll		
		if $TunnelController.testTunnel
			p "tunnel is created"
			p $TunnelController.currentPort
			@happyImage.setHidden(false)
			@sadImage.setHidden(true)
		else
			p "no tunnel"
			p $TunnelController.currentPort
			@happyImage.setHidden(true)
			@sadImage.setHidden(false)
		end
	end

	ib_action :applySettings
	def applySettings
		$prefs.initAll		
	end

	def init
		if super_init 
			@dbsettings = []
		end
		self if self.initWithWindowNibName_owner('Preferences', self)
	end

	# Delegate method that returns the itemIdentifiers for the selectable items 
	# (in our case, all of 'em)
	def toolbarSelectableItemIdentifiers(toolbar)
		@toolbaritemidents ||= begin
								   window.toolbar.items.map {|item| item.itemIdentifier }
							   end
	end

	def awakeFromNib
		# Select the first toolbar item when the window loads
		window.toolbar.selectedItemIdentifier = window.toolbar.items[0].itemIdentifier
		# Show the initial preference pane
		window.setContentSize @generalPrefsView.frame.size 
		window.contentView.addSubview @generalPrefsView
		window.title = "General Preferences"
		@currentViewTag = 0
		# Will use CoreAnimation for the panel changes:
		window.contentView.wantsLayer = true
	end

	def viewForTag(tag)
		case tag
		when 0: [@generalPrefsView,  "General"]
		when 1: [@advancedPrefsView, "Advanced"]
		when 2: [@databasePrefsView, "Database"]
		when 4: [@userInfoPrefsView, "User"]
		when 5: [@sshTunnelPrefsView, "SSHTunnel"]
		end
	end

	def newFrameForNewContentView(view)
		newFrameRect = window.frameRectForContentRect(view.frame)
		oldFrameRect = window.frame
		newSize = newFrameRect.size
		oldSize = oldFrameRect.size
		frame = window.frame
		frame.size = newSize
		frame.origin.y = frame.origin.y - (newSize.height - oldSize.height)
		frame
	end
end
