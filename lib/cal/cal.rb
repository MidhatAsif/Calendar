require 'date'
require_relative 'event.rb'
require 'curses'
require 'colorize'

# NOTE:
# - Set console width to 80x24
# - The calendar year is assumed to be the latest one, i.e.
# when the Calendar object is instantiated.
class Calendar
  def initialize
    @events = {}
  end

  def add_event?(month, date, title, venue)
    begin  
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      if @events.key?(:"#{day}")
        @events[:"#{day}"] << Event.new(title, venue)
        return true  
      else
        @events.merge!("#{day}": [Event.new(title, venue)])
        return true
      end
    end  
    return false
  end

  def delete_event(month, date, title)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      @events[:"#{day}"].reject!{|e| e.title == title}
    end
  end

  def edit_event_title(month, date, new_title)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      @events[:"#{day}"].find {|e| e.edit_title(new_title)}
    end
  end

  def edit_event_venue(month, date, new_venue)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      @events[:"#{day}"].find {|e| e.edit_venue(new_venue)}
    end
  end

  def print_calendar
    months = [0..11]
    (0..11).each {|i| months[i] = false}

    @events.keys.sort.each { |key| 
      day = Date.parse("#{key}")
      month = day.month

      if months[month] == false
        puts "Month: #{month}"
        months[month] = true
      end
        
      puts "\tDate: #{day.mday}"
      @events[:"#{key}"].each do |e|
        e.print_event
      end
      puts
    }
  end

  def print_calendar_in_month_view
    (1..12).each do |i|
      self.print_month_view(i)
    end
  end

  def print_month_view(month)
    begin
      date = Date.parse("#{1}-#{month}-#{2019}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct month next time.'
    else
      days_arr = []
      7.times{|i| days_arr.push(Date::DAYNAMES[i])}

      Curses.stdscr.scrollok true
      Curses.init_screen

      Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLUE) #####
      Curses.attrset(Curses.color_pair(2) | Curses::A_BOLD)
      
      begin
        col = 10
        Curses.attrset(Curses.color_pair(2) | Curses::A_STANDOUT)
        Curses.setpos(0, 0)  #Curses.init_screen row 0, column 0
        Curses.addstr(Date::MONTHNAMES[month].center(80).to_s)

        Curses.attrset(Curses.color_pair(2) | Curses::A_BOLD)
        Curses.setpos(2, 5)
        Curses.addstr("------------------------------------------------------------------------")
        Curses.setpos(4, 5)
        Curses.addstr("------------------------------------------------------------------------")
        
        rows = %w"Su Mo Tu We Th Fr Sa"

        rows.each do |d|
          Curses.setpos(3, col)
          Curses.addstr(d)
          col += 10
        end

        Curses.attrset(Curses.color_pair(2) | Curses::A_NORMAL)
        day = date.strftime("%A")
        totaldaysin = days_in_month(month)
        col = 10
        datescursor = days_arr.index(day)
        startdate = 1
        rowcursor = 5
        rowcursor_digits = 5
        for r in (5..10) do
          for c in (datescursor..6) do
            col_cursor = (c+1) * col 
            Curses.setpos(rowcursor, col_cursor)
            if startdate <= totaldaysin
              Curses.addstr(startdate.to_s)

              #printing the events
              date = Date.parse("#{startdate}-#{month}-#{2019}")
              events_arr = @events[:"#{date}"]
              #Curses.addstr(events_arr.to_s)
              unless events_arr.nil?
                rowcursor_digits = rowcursor
                events_arr.each_with_index do |e, index|
                    rowcursor = rowcursor + 1
                    Curses.setpos(rowcursor, col_cursor)
                    Curses.addstr(e.title.to_s[0..4])
                end
              end
            else
              break
            end
            startdate += 1
            datescursor = 0
          end
          rowcursor += 1
        end
        Curses.getch
      ensure
        Curses.close_screen
      end
    end
  end

  def print_month(month)
    if (1..12) === month
      months = [0..11]
      (0..11).each {|i| months[i] = false}

      @events.keys.sort.each do |key| 
        day = Date.parse("#{key}")
        if day.month == month
          if months[month] == false
            puts "Month: #{month}"
            months[month] = true
          end
          puts "\tDate: #{day.mday}"
          @events[:"#{key}"].each do |e|
            e.print_event
          end
        end
        puts
      end
      else
        puts 'Invalid month entered.'
      end
  end

  def print_day(month, date)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
        @events.keys.sort.each { |key| 
        day = Date.parse("#{key}")
        if day.month == month && day.mday == date
          puts "Month: #{day.month}"
          puts "\tDate: #{day.mday}"
          @events[:"#{key}"].each do |e|
            e.print_event
          end
        end
        puts
      }
    end
  end

  def get_number_of_events_in_a_day (month, date)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
        @events.each do |key, events_arr|
          day = Date.parse("#{key}")
          if date == day.mday && month == day.month
            return events_arr.size
          end
        end
    end
  end

  def get_event(month, date, title)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
      if @events.key?(:"#{day}")
        found = @events[:"#{day}"].detect { |e| e.title == title }
        unless found.nil?
          return found
        end
      end
    end
    return nil
  end

  def event?(month, date, title)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      if @events.key?(:"#{day}")
        found = @events[:"#{day}"].detect { |e| e.title == title }
        unless found.nil?
          return true
        end
      end 
    end
    return false
  end

  private

  def days_in_month(month)
    begin
      return Date.new(2019, month, -1).day
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    end
  end

  def get_events_in_a_day(month, date)
    begin
      day = Date.parse("#{date}-#{month}-#{Date.today.year}")
    rescue ArgumentError
      puts 'Invalid Value: Please enter a correct date next time.'
    else
      if @events.key?(:"#{day}")
        return @events[:"#{day}"]
      end
    end
    return nil
  end
end
