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
	
	with "#freeze" do
		it "can freeze" do
			expect(time.freeze).to be == time
			expect(time).to be(:frozen?)
		end
	end
	
	with "#to_time" do
		it "can convert to Time" do
			expect(time.to_time).to be == ::Time.utc(2024, 1, 1, 0, 0, 0)
		end
	end
	
	with "#to_datetime" do
		it "can convert to DateTime" do
			expect(time.to_datetime).to be == ::DateTime.new(2024, 1, 1, 0, 0, 0)
		end
	end
	
	with "#to_s" do
		it "can convert to string" do
			expect(time.to_s).to be == "2024+00+00 00:00:00 0"
		end
	end
	
	with "#hash" do
		let(:hash) {Hash.new}
		
		it "can store in hash" do
			hash[time] = true
			expect(hash[time]).to be == true
		end
	end
	
	with "#eql?" do
		let(:other) {Async::Cron::Time.new(2025, 0, 0, 0, 0, 0, 0)}
		
		it "can compare equality with different time" do
			expect(time.eql?(other)).to be == false
		end
		
		it "can compare equality with same time" do
			expect(time.eql?(time)).to be == true
		end
	end
	
	with ".from" do
		it "can create from Time" do
			time = Async::Cron::Time.from(::Time.utc(2024, 1, 1, 0, 0, 0))
			expect(time.to_s).to be == "2024+00+00 00:00:00 0"
		end
		
		it "can create from DateTime" do
			time = Async::Cron::Time.from(::DateTime.new(2024, 1, 1, 0, 0, 0))
			expect(time.to_s).to be == "2024+00+00 00:00:00 0"
		end
		
		it "can create from Date" do
			time = Async::Cron::Time.from(::Date.new(2024, 1, 1))
			expect(time.to_s).to be == "2024+00+00 00:00:00 0"
		end
	end
end