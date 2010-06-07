require 'osx/cocoa'

class TreeController < OSX::NSObject
	kvc_accessor :projects, :timevalues

	ib_outlets :logTimeController
	ib_outlets :outlineView, :treeController, :window, :activeProject
	ib_outlets :activeTicket, :extra_notes
	ib_outlets :newhour, :newminutes, :newsecs
	ib_outlets :activeTicketId, :activeProjectId
	ib_outlets :tickButton

	def init
		if super_init

			@tick = true
			@timevalues = [:secs => $timerController.secDelta, :min=> $timerController.minDelta, :hour => $timerController.hourDelta ]
			OSX::NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(1.0, self, :updateTime, nil, true)

			p 'init redmine'
			connectToRedMine
			populateProjects

			return self
		end
	end

	def connectToRedMine
		if $settings[:tunnelEnable] == 1
			$TunnelController.createTunnel
			$mySQLPort = $TunnelController.currentPort
			$mySQLHost = '127.0.0.1'
			p $mySQLPort
		else
			$mySQLPort = 3306
			$mySQLHost = $settings[:dbhost]
		end

		ActiveRecord::Base.logger = Logger.new($stderr)
		ActiveRecord::Base.colorize_logging = false
		ActiveRecord::Base.establish_connection({
			:adapter 	=> 'mysql',
			:host 		=> $mySQLHost,
			:socket		=> nil,
			:username 	=> $settings[:dbuser],
			:password 	=> $settings[:dbpass],
			:database 	=> $settings[:dbname],
			:port 		=> $mySQLPort
		})

	end

	def populateProjects
		begin
			@projects = Project.find(:all, :select => 'id,name, parent_id', :conditions => {:parent_id => nil}).to_activerecord_proxies

			#@issues = Issue.find(:all)
			#@issues.each do |issue|
			#	if issue.spent_hours >0
			#		puts issue.spent_hours.to_s
			#	end 
			#end

			$noConnection=false
		rescue Exception => msg

			@alert = OSX::NSAlert.alloc.init
			@alert.setMessageText("Something went wrong ("+msg+")")
			@alert.setAlertStyle(OSX::NSCriticalAlertStyle)
			@alert.addButtonWithTitle("OK")
			@alert.runModal
			puts "Something went wrong ("+msg+")"
			$noConnection=true
		end  
	end

	def updateTime(x)
		if @tick == true
			@newsecs.setIntValue($timerController.secDelta)
			@newminutes.setIntValue($timerController.minDelta)
			@newhour.setIntValue($timerController.hourDelta)
		end
		self
	end

	#move to ltcontroller
	ib_action :toggleTicking
	def toggleTicking
		if @tick
			@tick=false
			@tickButton.setTitle('start ticking')
		else
			@tick=true
			@tickButton.setTitle('stop ticking')
		end
	end

	#move to ltcontroller
	ib_action :refreshData
	def refreshData
		populateProjects
		@treeController.fetch_
		@treeController.objc_methods.sort.each do |m| 
			p m
		end
	end

	#move to ltcontroller
	ib_action :forgetTime
	def forgetTime
		$timerController.resetTime
		closeWindow
	end

	def closeWindow
		if $settings[:tunnelEnable] == 1
			$TunnelController.closeTunnel
		end
		@logTimeController.hideW
	end

	#move to ltcontroller
	ib_action :goOn
	def goOn
		closeWindow
	end

	ib_action :commitTime
	def commitTime
		if @activeTicketId.intValue.to_i == 0
			msg='You did not select a ticket'
			@alert = OSX::NSAlert.alloc.init
			@alert.setMessageText( msg)
			@alert.setAlertStyle(OSX::NSCriticalAlertStyle)
			@alert.addButtonWithTitle("OK")
			@alert.runModal
			return
		end

		begin
			@user = User.find(:first,:conditions => [ "login = '#{$settings[:redmineUser]}'"])
			@issue = Issue.find(@activeTicketId.intValue.to_i)
			@project = Project.find(@activeProjectId.intValue.to_i)

			timedelta = @newsecs.intValue.to_i + (@newminutes.intValue.to_i * 60) + (@newhour.intValue.to_i * 60 * 60)
			@newtime = $timerController.to_hfloat(timedelta)

			@comments = @extra_notes.stringValue.to_s.strip

			#:activity_id

			@time_entry = TimeEntry.new(:project => @project, :issue => @issue , :user => @user, :spent_on => Date.today, :activity_id => 10,:updated_on => Date.today,:created_on => Date.today , :hours=> @newtime , :comments=> @comments)
			#@time_entry.attributes = params[:time_entry]

			$timerController.timeDelta
			@time_entry.save

			$timerController.resetTime
			@tick=true
			
			closeWindow
		rescue 
			@alert = OSX::NSAlert.alloc.init
			@alert.setMessageText("The connection died. Try clicking SyncDb from the menu.")
			@alert.setAlertStyle(OSX::NSCriticalAlertStyle)
			@alert.addButtonWithTitle("OK")
			@alert.runModal
		end
	end

	def storePositions
		$treePosition = @treeController.selectionIndexPath
#		$treePosition = @outlineView._selectableColumnIndexes
		#@outlineView.objc_methods.sort.each do |m| 
		#	p m
		#end
	end

	def retrievePositions
		if !$treePosition.nil?
			@treeController.setSelectionIndexPath($treePosition)
		end
	end

	ib_action :closeTicket
	def closeTicket
		sql1="update issue WHERE ticket_id=#{ticketid} set status=5"	
		sql2="insert journal"
		sql3="insert journal details"

		# Set ticket status to 5 but also insert journal

		#id 	tracker_id 	project_id 	subject 	description 	due_date 	category_id 	status_id 	assigned_to_id 	priority_id 	fixed_version_id 	author_id 	lock_version 	created_on 	updated_on 	start_date 	done_ratio 	estimated_hours
		#843  	1  	66  	start kicking is not reset after logging time  	confusing  	NULL  	NULL  	5  	NULL  	5  	168  	5  	1  	2008-05-19 17:27:36  	2008-05-20 00:04:04  	2008-05-19  	0  	0.1

		#	  	id 	journalized_id 	journalized_type 	user_id 	notes 	created_on
		#	   	1089  	843  	Issue  	5  	   	2008-05-20 00:04:04

		#		id 	journal_id 	property 	prop_key 	old_value 	value
		#		1719  	1089  	attr  	status_id  	1  	5

	end
end
