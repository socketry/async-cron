# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'flags'
require_relative '../time'

require 'console'

module Async
	module Cron
		module Schedule
			class Generic
				def initialize(flags = Flags.new)
					@flags = flags
				end
				
				attr :flags
				
				# Compute the next execution time after the given time.
				def increment(time = nil)
					Time.now
				end
				
				def run_once(time = Time.now, &block)
					# The number of times the schedule has been dropped because the scheduled time was in the past:
					dropped = 0
					
					while true
						# Compute the next scheduled time:
						scheduled_time = increment(time)
						
						# If the time is not advancing and we are dropping, then raise an error:
						if scheduled_time <= time and dropped > 0
							raise RuntimeError, "Scheduled time is not advancing: #{scheduled_time} <= #{time}"
						end
						
						# Compute the delta until the next scheduled time:
						delta = scheduled_time.delta
						
						Console.debug(self, "Next scheduled time.", delta: delta, scheduled_time: scheduled_time, block: block)
						
						# If the time is in the past, and we are dropping, then skip this schedule and try again:
						if delta < 0 and @flags.drop?
							# This would normally occur if the user code took too long to execute, causing the next scheduled time to be in the past.
							Console.warn(self, "Skipping schedule because it is in the past.", delta: delta, scheduled_time: scheduled_time, block: block, dropped: dropped)
							dropped += 1
							next
						end
						
						break
					end
					
					Console.debug(self, "Waiting for next scheduled time.", delta: delta, scheduled_time: scheduled_time, block: block)
					sleep(delta) if delta > 0
					
					begin
						invoke(scheduled_time, &block)
					rescue => error
						Console::Event::Failure.for(error).emit(self, delta: delta, scheduled_time: scheduled_time, block: block)
					end
					
					return time
				end
				
				def run(time = Time.now, &block)
					while true
						time = run_once(time, &block)
					end
				end
				
				def invoke(time, &block)
					yield(time)
				end
			end
		end
	end
end
