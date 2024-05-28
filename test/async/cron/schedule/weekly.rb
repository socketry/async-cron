require 'async/cron/schedule/weekly'

describe Async::Cron::Schedule::Weekly do
	let(:schedule) {subject.new}
	let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
	
	it "should increment time" do
		time = schedule.increment(self.time)
		expect(time).to be == Async::Cron::Time.new(2024, 0, 6, 0, 0, 0, 0)
		
		# Check that it's Sunday:
		date = time.to_date
		expect(date.wday).to be == 0
	end
end
