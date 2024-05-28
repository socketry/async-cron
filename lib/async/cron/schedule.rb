# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'time'
require_relative 'period'

require 'console'

module Async
	module Cron
		class Schedule
			class Flags
				def self.parse(string)
					options = {}
					
					string&.each_char do |character|
						case character
						when 'D'
							options[:drop] = true
						when 'd'
							options[:drop] = false
						else
							raise ArgumentError, "Invalid flag: #{character}"
						end
					end
					
					self.new(**options)
				end
				
				def initialize(drop: true)
					@drop = drop
				end
				
				def drop?
					@drop
				end
			end
			
			def self.parse(string)
				parts = string.split(/\s+/)
				
				if parts.last =~ /[a-zA-Z]/
					flags = Flags.parse(parts.pop)
				else
					flags = Flags.new
				end
				
				seconds = Seconds.parse(parts[0])
				minutes = Minutes.parse(parts[1])
				hours = Hours.parse(parts[2])
				weekday = Weekday.parse(parts[3])
				monthday = Monthday.parse(parts[4])
				month = Month.parse(parts[5])
				
				return self.new(seconds, minutes, hours, weekday, monthday, month, flags)
			end
			
			# Create a new schedule with the given parameters.
			def initialize(seconds, minutes, hours, weekday, monthday, month, flags = Flags.new)
				@seconds = seconds
				@minutes = minutes
				@hours = hours
				@weekday = weekday
				@monthday = monthday
				@month = month
				@flags = flags
			end
			
			# Compute the next execution time after the given time.
			def increment(time = nil)
				time = Time.from(time) || Time.now
				
				units = [@seconds, @minutes, @hours, @weekday, @monthday, @month]
				index = 1
				
				# Step the smallest unit first:
				units[0].increment(time)
				
				# Now try to fit the rest of the schedule:
				while index < units.length
					unit = units[index]
					
					# puts "Checking #{unit} at #{index}... -> #{time}"
					
					# If the unit is not already at the desired time, increment it:
					unless unit.include?(time)
						# puts "Incrementing #{unit} at #{index}..."
						unit.increment(time)
						# puts "-> #{time}"
						
						# Reset all smaller units:
						units[0...index].each do |unit|
							# puts "Resetting #{unit}..."
							unit.reset(time)
						end
					end
					
					index += 1
				end
				
				return time.normalize!
			end
			
			def run(time = Time.now, &block)
				while true
					time = increment(time)
					delta = time.delta
					
					# If the time is in the past, and we are dropping, then skip this schedule and try again:
					if delta < 0 and @flags.drop?
						# This would normally occur if the user code took too long to execute, causing the next scheduled time to be in the past.
						Console.warn(self, "Skipping schedule because it is in the past.", delta: delta, time: time, block: block)
						next
					end
					
					time.sleep
					
					begin
						invoke(time, &block)
					rescue => error
						Console.failure(self, error, delta: delta, time: time, block: block)
					end
				end
			end
			
			def invoke(time, &block)
				yield(time)
			end
		end
	end
end
