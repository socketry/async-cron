# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'time'

module Async
	module Cron
		class Period
			# Parse a string into a period.
			# @parameter string [String | Nil] The string to parse.
			def self.parse(string)
				value, divisor = string&.split('/', 2)
				
				if divisor
					divisor = Integer(divisor)
				else
					divisor = 1
				end
				
				if value == '*'
					value = nil
				elsif value
					value = value.split(',').map do |part|
						if part =~ /\A(\d+)-(\d+)\z/
							Range.new(Integer($1), Integer($2))
						elsif part =~ /\A(-?\d+)\.\.(-?\d+)\z/
							Range.new(Integer($1), Integer($2))
						else
							Integer(part)
						end
					end
				end
				
				self.new(value, divisor)
			end
			
			RANGE = nil
			
			def initialize(value = nil, divisor = 1, range: self.class::RANGE)
				@value = value
				@divisor = divisor
				@range = range
				
				if @values = divide(expand(@value))
					# This is an optimization to avoid recalculating the successors every time:
					@successors = successors(@values)
				end
			end
			
			def to_a
				@values
			end
			
			# Increment the specific time unit to the next possible value.
			# @parameter time [Time] The time to increment, must be normalized.
			def increment(time)
				time.seconds = @successors[time.seconds]
			end
			
			def step(time)
				time = Time.from(time).normalize!
				
				increment(time)
				
				return time
			end
			
			# Reset the specific time unit to the first value.
			def reset(time)
				time.seconds = @values.first
			end
			
			def include?(time)
				if @values
					return @values.include?(value_from(time.normalize!))
				else
					return true
				end
			end
			
		private
			
			def value_from(time)
				time.seconds
			end
			
			def expand(values)
				case values
				when Array
					flatten(values)
				when Range
					values.to_a
				when Integer
					[values]
				when nil
					@range&.to_a
				else
					raise ArgumentError, "Invalid value: #{values.inspect}"
				end
			end
			
			def flatten(values)
				values = values.flat_map do |value|
					case value
					when Array
						flatten(value)
					when Range
						value.to_a
					else
						value
					end
				end
				
				values.sort!
				values.uniq!
				
				return values
			end
			
			def divide(values)
				return values if @divisor == 1 or values.size <= 1
				raise ArgumentError, "Invalid divisor: #{@divisor}" unless @divisor > 1
				
				offset = values.first
				filtered = {}
				
				values.each do |value|
					key = ((value - offset) / @divisor).floor
					filtered[key] ||= value
				end
				
				return filtered.values
			end
			
			def successors(values)
				mapped = @range.to_a
				
				current = 0
				
				values.each do |value|
					while current < value
						mapped[current] = value
						current += 1
					end
				end
				
				while current < mapped.size
					mapped[current] = values.first + mapped.size
					current += 1
				end
				
				return mapped
			end
		end
		
		class Seconds < Period
			RANGE = 0..59
		end
		
		class Minutes < Period
			RANGE = 0..59
			
			def increment(time)
				time.minutes = @successors[time.minutes]
			end
			
			def reset(time)
				time.minutes = @values.first
			end
			
			def value_from(time)
				time.minutes
			end
		end
		
		class Hours < Period
			RANGE = 0..23
			
			def increment(time)
				time.hours = @successors[time.hours]
			end
			
			def reset(time)
				time.hours = @values.first
			end
			
			def value_from(time)
				time.hours
			end
		end
		
		class Weekday < Period
			RANGE = 0..6
			
			def increment(time)
				time.weekday = @successors[time.weekday]
			end
			
			def reset(time)
				time.weekday = @values.first
			end
			
			def value_from(time)
				time.weekday
			end
		end
		
		class Monthday < Period
			def increment(time)
				current_time = time.dup
				monthday = @successors[time.days] || @values.first
				
				time.monthday = monthday
				
				while time <= current_time
					time.months += 1
					time.monthday = monthday
				end
			end
			
			def reset(time)
				if @values&.any?
					time.monthday = @values.first
				else
					time.monthday = 0
				end
			end
			
			def value_from(time)
				time.days
			end
		end
		
		class Month < Period
			RANGE = 0..11
			
			def increment(time)
				time.months = @successors[time.months]
			end
			
			def reset(time)
				time.months = @values.first
			end
			
			def value_from(time)
				time.months
			end
		end
	end
end
