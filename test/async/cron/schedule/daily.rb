require 'async/cron/schedule/daily'

describe Async::Cron::Schedule::Daily do
	let(:schedule) {subject.new}
	let(:time) {Async::Cron::Time.new(2024, 0, 0, 10, 10, 10, 0)}
	
	it "should increment time" do
		time = schedule.increment(self.time)
		expect(time).to be == Async::Cron::Time.new(2024, 0, 1, 0, 0, 0, 0)
	end
end
