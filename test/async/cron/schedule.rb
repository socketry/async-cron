require 'async/cron/schedule'

require 'sus/fixtures/console/captured_logger'

describe Async::Cron::Schedule do
	include_context Sus::Fixtures::Console::CapturedLogger
	
	let(:flags) {Async::Cron::Schedule::Flags.new(drop: false)}
	let(:schedule) {Async::Cron::Schedule::Generic.new(flags)}
	
	it "should invoke the schedule" do
		invoked = 0
		
		schedule.run_once do |time|
			invoked += 1
		end
		
		expect(invoked).to be == 1
	end
	
	it "continues even if there is an error" do
		invoked = 0
		
		schedule.run_once do |time|
			invoked += 1
			raise "Oops!"
		end
		
		expect(invoked).to be == 1
		message = capture.last
		
		expect(message).to have_keys(
			event: have_keys(
				type: be == :failure,
				class: be == "RuntimeError",
				message: be == "Oops!"
			)
		)
	end
	
	with "#run" do
		it "can run several times" do
			invoked = 0
			
			schedule.run do |time|
				invoked += 1
				
				if invoked >= 3
					break
				end
			end
			
			expect(invoked).to be == 3
		end
	end
	
	with "dropping schedule" do
		let(:flags) {Async::Cron::Schedule::Flags.new(drop: true)}
		
		it "should fail to invoke the schedule" do
			invoked = 0
			
			expect do
				schedule.run_once do |time|
					invoked += 1
				end
			end.to raise_exception(RuntimeError, message: be =~ /time is not advancing/)
			
			expect(invoked).to be == 0
		end
	end
end