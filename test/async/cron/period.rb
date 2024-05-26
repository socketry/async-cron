# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/cron/period'

describe Async::Cron::Period do
	describe Async::Cron::Seconds do
		let(:period) {subject.new(0..59, 30)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.seconds).to be == 30
			
			time = period.step(time)
			expect(time.seconds).to be == 60
			
			time = period.step(time)
			expect(time.seconds).to be == 30
			expect(time.minutes).to be == 1
		end
	end
	
	describe Async::Cron::Minutes do
		let(:period) {subject.new(0..59, 30)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.minutes).to be == 30
			
			time = period.step(time)
			expect(time.minutes).to be == 60
			
			time = period.step(time)
			expect(time.minutes).to be == 30
			expect(time.hours).to be == 1
		end
	end
	
	describe Async::Cron::Hours do
		let(:period) {subject.new(0..23, 12)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.hours).to be == 12
			
			time = period.step(time)
			expect(time.hours).to be == 24
			
			time = period.step(time)
			expect(time.hours).to be == 12
			expect(time.days).to be == 1
		end
	end
	
	describe Async::Cron::Weekday do
		let(:period) {subject.new(0..6, 3)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.weekday).to be == 3
			expect(time.days).to be == 2
			
			time = period.step(time)
			expect(time.weekday).to be == 6
			expect(time.days).to be == 5
			
			time = period.step(time)
			expect(time.weekday).to be == 0
			expect(time.days).to be == 6
		end
	end
	
	describe Async::Cron::Monthday do
		let(:period) {subject.new(20, 1)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.days).to be == 20
			expect(time.months).to be == 0
			
			time = period.step(time).normalize!
			expect(time.days).to be == 20
			expect(time.months).to be == 1
			
			time = period.step(time).normalize!
			expect(time.days).to be == 20
			expect(time.months).to be == 2
		end
	end
end
