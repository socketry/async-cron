# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/cron/schedule/periodic'

describe Async::Cron::Schedule::Flags do
	it "fails to parse invalid flag" do
		expect do
			Async::Cron::Schedule::Flags.parse("X")
		end.to raise_exception(ArgumentError)
	end
	
	with "#drop?" do
		it "should parse flags" do
			expect(Async::Cron::Schedule::Flags.parse("D").drop?).to be == true
			expect(Async::Cron::Schedule::Flags.parse("d").drop?).to be == false
		end
	end
end
