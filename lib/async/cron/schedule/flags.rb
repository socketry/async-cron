# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Cron
		module Schedule
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
		end
	end
end
