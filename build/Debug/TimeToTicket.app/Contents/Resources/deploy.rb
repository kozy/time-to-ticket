#
#  deploy.rb
#  TimeToTicket
#
#  Created by Pim Snel on 24-06-08.
#  Copyright (c) 2008 Lingewoud BV. All rights reserved.
#

COCOA_APP_RESOURCES_DIR = File.dirname(__FILE__)
#STANDALONEIFY_PATH =File.join(COCOA_APP_RESOURCES_DIR, '..', 'Frameworks/RubyCocoa.framework/Versions/A/Tools/standaloneify.rb')
STANDALONEIFY_PATH =File.join(COCOA_APP_RESOURCES_DIR, 'standaloneify.rb')
APP_DIR = File.join(COCOA_APP_RESOURCES_DIR, '..','..','..','TimeToTicket.app')
OLD_APP_DIR = File.join(COCOA_APP_RESOURCES_DIR, '..','..','..','TimeToTicket_Orig.app')
STD_APP_DIR = File.join(COCOA_APP_RESOURCES_DIR, '..','..','..','TimeToTicket_Std.app')
RB_MAIN = File.join(STD_APP_DIR, 'Contents','Resources', 'rb_main.rb')

class Deploy

	def main
		require 'FileUtils'

		#copyToOrig
		stdfy
	#	moveStdToReal

	end

	def copyToOrig
		FileUtils.cp_r(APP_DIR, OLD_APP_DIR)
	end

	def moveStdToReal
		FileUtils.mv(APP_DIR, OLD_APP_DIR)
		FileUtils.mv(STD_APP_DIR, APP_DIR)
	end

	def stdfy
		stdcmd='ruby '+ STANDALONEIFY_PATH + ' -d ' + STD_APP_DIR + ' '+ APP_DIR
		puts stdcmd
		system (stdcmd)
	end
end

if File.basename($0) == File.basename(__FILE__)
	puts "Starting Deployment"
	depl= Deploy.new
	depl.main
else
	puts "not run from cli"
end
