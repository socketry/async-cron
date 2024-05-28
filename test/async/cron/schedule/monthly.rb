require 'async/cron/schedule/monthly'

describe Async::Cron::Schedule::Monthly do
	let(:schedule) {subject.new}
	let(:time) {Async::Cron::Time.new(2024, 0, 10, 10, 10, 10, 0)}
	
	it "should increment time" do
		time = schedule.increment(self.time)
		expect(time).to be == Async::Cron::Time.new(2024, 1, 0, 0, 0, 0, 0)
	end
end
