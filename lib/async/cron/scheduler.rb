require 'async/barrier'

module Async
	module Cron
		class Scheduler
			def initialize
				@schedules = Hash.new.compare_by_identity
			end
			
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
