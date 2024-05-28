
describe Async::Cron::Schedule::Generic do
	let(:schedule) {subject.new}
	
	it "should increment time" do
		expect(schedule.increment).to be_a(Async::Cron::Time)
	end
end
