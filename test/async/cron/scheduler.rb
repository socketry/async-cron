require 'async/cron/schedule'
require 'async/cron/scheduler'

require 'sus/fixtures/console/captured_logger'

describe Async::Cron::Scheduler do
	include_context Sus::Fixtures::Console::CapturedLogger
	
	let(:flags) {Async::Cron::Schedule::Flags.new(drop: false)}
	let(:schedule) {Async::Cron::Schedule::Generic.new(flags)}
	let(:scheduler) {Async::Cron::Scheduler.new}
	
	it "should invoke the schedule" do
		invoked = 0
		
		scheduler.add(schedule) do |time|
			invoked += 1
			
			if invoked >= 3
				raise Async::Stop
			end
		end
		
		scheduler.run
		
		expect(invoked).to be == 3
	end
end