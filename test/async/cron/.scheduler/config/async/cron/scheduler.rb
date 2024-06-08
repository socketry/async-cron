hourly do
	puts "Hourly task"
end

daily do
	puts "Daily task"
end

weekly do
	puts "Weekly task"
end

monthly do
	puts "Monthly task"
end

periodic "*/5 * * * *" do
	puts "Every 5 minutes"
end
