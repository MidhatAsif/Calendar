require_relative "cal/cal.rb"
require 'colorize'

def get_date
  puts "Enter date: (in digits)"
  date = gets.chomp.to_i
  puts "Enter month: (in digits)"
  month = gets.chomp.to_i
  yield(date, month)
end


cal = Calendar.new
puts "Choose Option:
1. Print the entire calendar details.
2. Print the entire calendar in month view.
3. DAY VIEW (print events for a specific date)
4. MONTH VIEW (print the events for a specific month)
5. Add an event
6. Get total number of events in a day
7. Edit an event title
8. Edit an event venue
9. Delete an event
a. Exit
"

while true
  puts
  puts "Enter your option: "
  n = gets.chomp.to_i

  case n
  when 1
    cal.print_calendar
  when 2
    cal.print_calendar_in_month_view
  when 3
    get_date do |date, month|
      cal.print_day(month, date)
    end
  when 4
    puts "Enter month:"
    month = gets.chomp.to_i
    cal.print_month_view(month)
  when 5
    get_date do |date, month|
      puts "Enter title:"
      title = gets.chomp.to_s
      puts "Enter venue:"
      venue = gets.chomp.to_s
      cal.add_event?(month, date, title, venue)
    end
  when 6
    get_date do |date, month|
      puts cal.get_number_of_events_in_a_day(month, date)
    end
  when 7
    get_date do |date, month|
      puts "Enter title:"
      title = gets.chomp.to_s
      cal.edit_event_title(month, date, title)
    end
  when 8
    get_date do |date, month|
      puts "Enter venue:"
      venue = gets.chomp.to_s
      cal.edit_event_venue(month, date, venue)
    end
  when 9
    get_date do |date, month|
      puts "Enter title:"
      title = gets.chomp.to_s
      puts cal.delete_event(month, date, title)
    end
  else 
    puts "Exited!"
    break
end
end