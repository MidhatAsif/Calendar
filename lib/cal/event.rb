class Event

  attr_reader :title, :venue

  def initialize(title, venue)
    @title = title
    @venue = venue
  end

  def edit_title(title)
    @title = title
  end

  def edit_venue(venue)
    @venue = venue
  end

  def print_event
    s = "\t\t#{@title}:   #{@venue}"
    puts s
    s
  end
  
end