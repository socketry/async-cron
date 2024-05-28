# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2024, by Samuel Williams.
# Copyright, 2020, by Daniel Evans.

require_relative '../schedule'

module Async
	module Cron
		module Service
			class Scheduler < Async::Service::Generic
				# Setup the container with the application instance.
				# @parameter container [Async::Container::Generic]
				def setup(container)
					container_options = @evaluator.container_options
					
					container.run(name: self.name, **container_options) do |instance|
						evaluator = @environment.evaluator
						
						Async do |task|
							scheduler = evaluator.scheduler
							
							task = Async do
								scheduler.run
							end
							
							instance.ready!
							
							task.wait
						end
					end
				end
			end
		end
	end
end
