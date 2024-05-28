# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'generic'
require_relative '../period'

module Async
	module Cron
		module Schedule
			# A schedule that runs once per day, at midnight.
			class Weekly < Generic
				def increment(time = nil)
					time = Time.from(time) || Time.now
					
					time.seconds = 0
					time.minutes = 0
					time.hours = 0
					# 0-6, Sunday is zero
					time.weekday = 7
					
					return time.normalize!
				end
			end
		end
	end
end

