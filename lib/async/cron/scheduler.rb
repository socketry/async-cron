# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async'
require 'async/barrier'

module Async
	module Cron
		class Scheduler
			class Loader
				def initialize(scheduler)
					@scheduler = scheduler
				end
				
				def add(schedule, &block)
					@scheduler.add(schedule, &block)
				end
				
				def hourly(&block)
					add(Schedule::Hourly.new, &block)
				end
				
				def daily(&block)
					add(Schedule::Daily.new, &block)
				end
				
				def weekly(&block)
					add(Schedule::Weekly.new, &block)
				end
				
				def monthly(&block)
					add(Schedule::Monthly.new, &block)
				end
				
				def periodic(specification, &block)
					add(Schedule::Periodic.parse(specification), &block)
				end
			end
			
			PATH = "config/async/cron/scheduler.rb"
			
			def self.load(root = Dir.pwd)
				path = ::File.join(root, PATH)
				
				if ::File.exist?(path)
					return self.load_file(path)
				end
			end
			
			def self.load_file(path)
				scheduler = self.new
				loader = Loader.new(scheduler)
				
				loader.instance_eval(::File.read(path), path)
				
				return scheduler
			end
			
			def initialize
				@schedules = Hash.new.compare_by_identity
			end
			
			attr :schedules
			
			def add(schedule, &block)
				@schedules[schedule] = block
			end
			
			def run
				Sync do
					barrier = Async::Barrier.new
					
					@schedules.each do |schedule, block|
						barrier.async do
							schedule.run(&block)
						end
					end
					
					barrier.wait
				end
			end
		end
	end
end
