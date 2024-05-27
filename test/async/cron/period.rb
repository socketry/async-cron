# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/cron/period'

describe Async::Cron::Period do
	it "fails with invalid divisor" do
		expect{subject.parse(1, "foo")}.to raise_exception(ArgumentError)
		expect{subject.parse(1, 0)}.to raise_exception(ArgumentError)
	end
	
	it "fails with invalid values" do
		expect{subject.new("foo")}.to raise_exception(ArgumentError)
	end
	
	it "should expand ranges and arrays" do
		expect(subject.new(1..3).to_a).to be == [1, 2, 3]
		expect(subject.new([1, 3]).to_a).to be == [1, 3]
		expect(subject.new([1..2, [3]]).to_a).to be == [1, 2, 3]
	end
	
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
		
		with "#include?" do
			it "should include specified values" do
				expect(period.include?(time)).to be == true
				
				time.seconds = 10
				expect(period.include?(time)).to be == false
			end
		end
		
		with '#reset' do
			it 'should reset seconds' do
				time.seconds = 10
				period.reset(time)
				expect(time.seconds).to be == 0
			end
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
		
		with "#include?" do
			it "should include specified values" do
				expect(period.include?(time)).to be == true
				
				time.minutes = 10
				expect(period.include?(time)).to be == false
			end
			
			it "ignores seconds" do
				time.seconds = 10
				expect(period.include?(time)).to be == true
			end
		end
		
		with '#reset' do
			it 'should reset minutes' do
				time.minutes = 10
				period.reset(time)
				expect(time.minutes).to be == 0
			end
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
		
		with "#include?" do
			it "should include specified values" do
				expect(period.include?(time)).to be == true
				
				time.hours = 10
				expect(period.include?(time)).to be == false
			end
		end
		
		with '#reset' do
			it 'should reset hours' do
				time.hours = 10
				period.reset(time)
				expect(time.hours).to be == 0
			end
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
		
		with "#include?" do
			it "should include specified values" do
				time.weekday = 0
				expect(period.include?(time)).to be == true
				
				time.weekday = 1
				expect(period.include?(time)).to be == false
			end
		end
		
		with '#reset' do
			it 'should reset weekday' do
				time.weekday = 1
				period.reset(time)
				expect(time.weekday).to be == 0
			end
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
		
		with "#include?" do
			it "should include specified values" do
				time.days = 20
				expect(period.include?(time)).to be == true
				
				time.days = 10
				expect(period.include?(time)).to be == false
			end
		end
		
		with '#reset' do
			it 'should reset monthday' do
				time.days = 10
				period.reset(time)
				expect(time.days).to be == 20
			end
			
			with 'no specific values' do
				let(:period) {subject.new}
				
				it 'should reset monthday to 0' do
					time.days = 10
					period.reset(time)
					expect(time.days).to be == 0
				end
			end
		end
	end
	
	describe Async::Cron::Month do
		let(:period) {subject.new(0..11, 3)}
		let(:time) {Async::Cron::Time.new(2024, 0, 0, 0, 0, 0, 0)}
		
		it "should map values" do
			time = period.step(self.time)
			expect(time.months).to be == 3
			
			time = period.step(time)
			expect(time.months).to be == 6
			
			time = period.step(time)
			expect(time.months).to be == 9
			
			time = period.step(time).normalize!
			expect(time.months).to be == 0
			expect(time.years).to be == 2025
		end
		
		with "#include?" do
			it "should include specified values" do
				time.months = 3
				expect(period.include?(time)).to be == true
				
				time.months = 4
				expect(period.include?(time)).to be == false
			end
		end
		
		with '#reset' do
			it 'should reset months' do
				time.months = 10
				period.reset(time)
				expect(time.months).to be == 0
			end
		end
	end
end
