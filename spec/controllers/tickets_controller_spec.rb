require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  it "toggles completed flag on ticket through ajax" do
    ticket = FactoryGirl.create(:ticket)

    xhr :patch, :complete, format: "js", id: ticket.id

    ticket.reload!
    expect(ticket.completed).to be true
  end

end
