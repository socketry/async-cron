# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'date'

module Async
	module Cron
		class Time
			include Comparable
			
			def self.from(time)
				case time
				when ::Time
					return self.new(time.year, time.month-1, time.day-1, time.hour, time.min, time.sec, time.utc_offset)
				when ::DateTime
					return self.new(time.year, time.month-1, time.day-1, time.hour, time.min, time.sec, time.offset)
				when ::Date
					return self.new(time.year, time.month-1, time.day-1, 0, 0, 0, 0)
				when self
					return time.dup
				end
			end
			
			def self.now
				return self.from(::Time.now)
			end
			
			# @parameter years [Integer] The number of years.
			# @parameter months [Integer] The number of months.
			# @parameter days [Integer] The number of days.
			# @parameter hours [Integer] The number of hours.
			# @parameter minutes [Integer] The number of minutes.
			# @parameter seconds [Integer] The number of seconds.
			# @parameter offset [Integer] The time zone offset.
			def initialize(years, months, days, hours, minutes, seconds, offset)
				@years = years
				@months = months
				@days = days
				@hours = hours
				@minutes = minutes
				@seconds = seconds
				@offset = offset
			end
			
			def freeze
				return self if frozen?
				
				@years.freeze
				@months.freeze
				@days.freeze
				@hours.freeze
				@minutes.freeze
				@seconds.freeze
				@offset.freeze
				
				super
			end
			
			attr_accessor :years
			attr_accessor :months
			attr_accessor :days
			
			attr_accessor :hours
			attr_accessor :minutes
			attr_accessor :seconds
			
			attr_accessor :offset
			
			def weekday
				to_date.wday
			end
			
			def weekday=(value)
				@days += value - weekday
			end
			
			def monthday=(value)
				if value >= 0
					@days = value
				else
					@days = ::Date.new(@years, @months+1, value).day
				end
			end
			
			def to_a
				[@years, @months, @days, @hours, @minutes, @seconds, @offset]
			end
			
			def <=> other
				to_a <=> other.to_a
			end
			
			def hash
				to_a.hash
			end
			
			def eql? other
				to_a.eql?(other.to_a)
			end
			
			def - other
				self.to_time - other.to_time
			end
			
			def sleep(delta = 0)
				duration = self - self.class.now + delta
				
				if duration > 0
					::Kernel.sleep(duration)
					return duration
				else
					return 0
				end
			end
			
			def to_time
				normalized = self.dup.normalize!
				
				return ::Time.new(normalized.years, normalized.months+1, normalized.days+1, normalized.hours, normalized.minutes, normalized.seconds, normalized.offset)
			end
			
			def to_datetime
				normalized = self.dup.normalize!
				
				return ::DateTime.new(normalized.years, normalized.months+1, normalized.days+1, normalized.hours, normalized.minutes, normalized.seconds, normalized.offset)
			end
			
			def to_date
				normalized = self.dup.normalize!
				
				return ::Date.new(normalized.years, normalized.months+1, normalized.days+1)
			end
			
			def normalize!
				seconds = self.seconds
				delta_minutes = seconds / 60
				seconds = seconds % 60
				
				minutes = self.minutes + delta_minutes
				delta_hours = minutes / 60
				minutes = minutes % 60
				
				hours = self.hours + delta_hours
				delta_days = hours / 24
				hours = hours % 24
				
				days = self.days + delta_days
				months = self.months
				years = self.years
				
				date = (Date.new(years, 1, 1) >> months) + days
				
				@years = date.year
				@months = date.month - 1
				@days = date.day - 1
				@hours = hours
				@minutes = minutes
				@seconds = seconds
				
				return self
			end
			
			def to_s
				sprintf("%04d+%02d+%02d %02d:%02d:%02d %d", years, months, days, hours, minutes, seconds, offset)
			end
		end
	end
end
