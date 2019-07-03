require '/home/midhat/Documents/Assignment/main.rb'

describe Calendar do 
  let(:cal) {Calendar.new}

  it "adds the event 'Visit uni' at 1st April, to the calendar" do
    expect(cal.add_event?(4, 1, "Visit uni", "FAST")).to eq true
  end

  context 'Editing an event: ' do
    it "edits the title of the event" do
      cal.add_event?(4, 1, "Visit uni", "FAST")
      expect(cal.event?(4,1,"Visit uni")).to eq true
      cal.edit_event_title(4,1,"Proj Sub")
      expect(cal.event?(4,1,"Proj Sub")).to eq true
    end
    it "edits the venue of the event" do
      cal.add_event?(4, 1, "Visit uni", "FAST")
      e = cal.get_event(4,1,"Visit uni")
      expect(e).not_to eq nil
      cal.edit_event_venue(4,1,"LUMS")
      expect(e.venue).to eq "LUMS"
    end
  end

  it 'deletes the event' do
    cal.add_event?(4, 1, "Visit uni", "FAST")
    expect(cal.event?(4,1,"Visit uni")).to eq true
    cal.delete_event(4,1,"Visit uni")
    expect(cal.event?(4,1,"Visit uni")).to eq false
  end

  it 'returns the total number of events in a day' do
    cal.add_event?(4, 5, "Project", "FAST")
    cal.add_event?(4, 5, "Project Submission", "FAST")
    cal.add_event?(4, 5, "Project Submission 2", "FAST")
    expect(cal.get_number_of_events_in_a_day(4,5)).to eq 3
  end

  it 'tells whether an event is present or not' do
    cal.add_event?(4, 5, "Project Submission", "FAST")
    expect(cal.event?(4,5, "Project Submission")).to eq true
  end

  it 'returns an event' do
    cal.add_event?(4, 5, "Project", "FAST")
    expect(cal.get_event(4,5, "Project").title).to eq "Project"
  end
end


describe Event do
  before(:all) {@e = Event.new("Project Submission", "uni")}

  it 'edits the event' do
    expect(@e.edit_title("Project delayed")).to eq "Project delayed"
  end

  it 'edits the venue' do
    expect(@e.edit_venue("FAST")).to eq "FAST"
  end

  it 'prints the event details' do
    expect(@e.print_event).to eq "\t\t#{@e.title}:   #{@e.venue}"
  end
end