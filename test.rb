#!/usr/bin/env async-service

require 'async/cron/environment/scheduler'
require 'async/cron/schedule'

service "cron" do
	include Async::Cron::Environment::Scheduler
	
	scheduler do
		super().tap do |scheduler|
			schedule = Async::Cron::Schedule::Periodic.parse("*/10 * * * * * D")
			
			scheduler.add(schedule) do
				Console.info("Hello, World!")
			end
			
			scheduler.add(Async::Cron::Schedule::Hourly.new) do
				Console.info("Hourly schedule")
			end
			
			scheduler.add(Async::Cron::Schedule::Daily.new) do
				Console.info("Daily schedule")
			end
			
			scheduler.add(Async::Cron::Schedule::Weekly.new) do
				Console.info("Weekly schedule")
			end
			
			scheduler.add(Async::Cron::Schedule::Monthly.new) do
				Console.info("Monthly schedule")
			end
		end
	end
end
