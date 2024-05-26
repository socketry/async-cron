# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/cron/time'

describe Async::Cron::Time do
	let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
	
	it "can add seconds" do
		time.seconds += 120
		
		expect(time.seconds).to be == 120
		
		time.normalize!
		
		expect(time.seconds).to be == 0
		expect(time.minutes).to be == 2
	end
	
	it "can add minutes" do
		time.minutes += 120
		
		expect(time.minutes).to be == 120
		
		time.normalize!
		
		expect(time.minutes).to be == 0
		expect(time.hours).to be == 2
	end
	
	it "can add hours" do
		time.hours += 48
		
		expect(time.hours).to be == 48
		
		time.normalize!
		
		expect(time.hours).to be == 0
		expect(time.days).to be == 2
	end
end
