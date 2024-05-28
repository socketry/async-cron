# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative '../service/scheduler'
require_relative '../scheduler'

module Async
	module Cron
		module Environment
			# Provides an environment for hosting a web application that uses a Falcon server.
			module Scheduler
				# The service class to use for the proxy.
				# @returns [Class]
				def service_class
					Service::Scheduler
				end
				
				def scheduler
					Cron::Scheduler.new
				end
				
				def container_options
					{count: 1}
				end
			end
		end
	end
end