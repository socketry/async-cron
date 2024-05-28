# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/cron/schedule/periodic'

describe Async::Cron::Schedule::Periodic do
	with "a basic hourly schedule" do
		let(:schedule) {subject.parse("0 0 * * * *")}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should parse the schedule" do
			time = schedule.increment(self.time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 1, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 2, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 3, 0, 0, 0)
		end
	end
	
	with "a basic 2-hourly schedule" do
		let(:schedule) {subject.parse("0 0 */2 * * *")}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should parse the schedule" do
			time = schedule.increment(self.time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 2, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 4, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 6, 0, 0, 0)
		end
	end
	
	with "the first friday of every month" do
		let(:schedule) {subject.parse("0 0 0 6 1-7 *")}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should parse the schedule" do
			time = schedule.increment(self.time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 5, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 1, 2, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 2, 1, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 3, 5, 0, 0, 0, 0)
		end
	end
	
	with "the last friday of every month" do
		let(:schedule) {subject.parse("0 0 0 6 -7..-1 *")}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should parse the schedule" do
			time = schedule.increment(self.time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 26, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 1, 23, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 2, 29, 0, 0, 0, 0)
			
			time = schedule.increment(time)
			expect(time).to be == Async::Cron::Time.new(2024, 3, 26, 0, 0, 0, 0)
		end
	end
	
	with "a basic hourly schedule with drop flag" do
		let(:schedule) {subject.parse("0 0 * * * * D")}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should parse the schedule" do
			expect(schedule.flags).to be(:drop?)
			
			time = schedule.increment(self.time)
			expect(time).to be == Async::Cron::Time.new(2024, 0, 0, 1, 0, 0, 0)
		end
	end
end
