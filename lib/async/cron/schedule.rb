# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

# These are mostly just for convenience:
require_relative 'schedule/hourly'
require_relative 'schedule/daily'
require_relative 'schedule/weekly'
require_relative 'schedule/monthly'

# This one gives you a lot of flexibility at the expense of being sgightly more verbose:
require_relative 'schedule/periodic'
