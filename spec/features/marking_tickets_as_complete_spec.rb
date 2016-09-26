require "rails_helper"

RSpec.feature "Users can mark tickets as complete" do
  before do
    project = FactoryGirl.create(:project, name: "Sublime Text 3")
    @ticket = FactoryGirl.create(:ticket)
    project.tickets << @ticket

    visit "/"
    click_link "Sublime Text 3"
  end


  scenario "when everything is valid" do
    ticket_table_row = "[data-ticket-id='#{@ticket.id}']" 
    within ticket_table_row do
      check "ticket[completed]" 
    end

    expect(page).to have_css('.completed')
  end

end
