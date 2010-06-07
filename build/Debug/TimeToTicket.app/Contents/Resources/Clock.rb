#
#  Clock.rb
#  TimeToTicket
#
#  Created by Pim Snel on 11-05-08.
#  Copyright (c) 2008 Lingewoud BV. All rights reserved.
#

class Clock
	def resetTime
		$beginTime = Time.new
	end

	def timeDelta
		timeNow = Time.new

		difference = timeNow.tv_sec - $beginTime.tv_sec

		difference.to_f
		puts difference
		hours = difference/60/60.to_f
		minutes = difference/60.to_f
		puts hours
		puts minutes

		return difference
	end

	def minDelta
		timeNow = Time.new
		sec_in = timeNow.tv_sec - $beginTime.tv_sec
		seconds    =  sec_in % 60
		sec_in = (sec_in - seconds) / 60
		minutes    =  sec_in % 60
		return minutes
	end

	def secDelta
		timeNow = Time.new
		sec_in = timeNow.tv_sec - $beginTime.tv_sec
		seconds    =  sec_in % 60
		return seconds
	end

	def hourDelta
		timeNow = Time.new
		sec_in = timeNow.tv_sec - $beginTime.tv_sec
		seconds    =  sec_in % 60
		sec_in = (sec_in - seconds) / 60
		minutes    =  sec_in % 60
		sec_in = (sec_in - minutes) / 60
		hours      =  sec_in % 24
		return hours
	end

	def to_hfloat(sec_in)
		hfloat = sec_in/60/60.to_f
		return hfloat
	end

	def to_seconds(sec_in)
		seconds    =  sec_in % 60
		return seconds
	end

	def to_minutes(sec_in)
		seconds    =  sec_in % 60
		sec_in = (sec_in - seconds) / 60
		minutes    =  sec_in % 60

		return minutes
	end

	def to_hours(sec_in)
		seconds    =  sec_in % 60
		sec_in = (sec_in - seconds) / 60
		minutes    =  sec_in % 60
		sec_in = (sec_in - minutes) / 60
		hours      =  sec_in % 24

		return hours
	end
end
