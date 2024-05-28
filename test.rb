#!/usr/bin/env async-service

require 'async/cron/environment/scheduler'

service "cron" do
	include Async::Cron::Environment::Scheduler
	
	scheduler do
		super().tap do |scheduler|
			schedule = Async::Cron::Schedule.parse("*/10 * * * * * D")
			
			scheduler.add(schedule) do
				Console.info("Hello, World!")
			end
		end
	end
end
