# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'generic'
require_relative '../period'

module Async
	module Cron
		module Schedule
			# A schedule that runs once per hour, on the hour.
			class Hourly < Generic
				def increment(time = nil)
					time = Time.from(time) || Time.now
					
					time.seconds = 0
					time.minutes = 0
					time.hours += 1
					
					return time.normalize!
				end
			end
		end
	end
end

