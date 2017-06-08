require "rails_helper"

RSpec.feature "Users can search for tickets matching specific criteria" do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }

  let(:open) { State.create(name: "Open", default: true) }
  let(:closed) { State.create(name: "Closed") }

  let!(:ticket_1) do
    FactoryGirl.create(:ticket, name: "Create projects",
                       project: project, author: user, tag_names: "iteration_1",
                       state: open)
  end

  let!(:ticket_2) do
    FactoryGirl.create(:ticket, name: "Create users",
                       project: project, author: user, tag_names: "iteration_2",
                       state: closed)
  end

  let!(:ticket_3) do
    FactoryGirl.create(:ticket, name: "Create tickets",
                       project: project, author: user, tag_names: "iteration_1, iteration_2",
                       state: closed)
  end

  before do
    assign_role!(user, :manager, project)
    login_as(user)
    visit project_path(project)
  end

  context "searching by tag" do

    scenario "when some tags match" do
      fill_in "Search", with: "iteration_1"
      click_button "Search"
      within("#tickets") do
        expect(page).to have_link "Create projects"
        expect(page).to_not have_link "Create users"
      end
    end

    scenario "when tags match exactly" do
      fill_in "Search", with: "iteration_1"
      check "Exact match"
      click_button "Search"
      within("#tickets") do
        expect(page).to have_link "Create projects"
        expect(page).to_not have_link "Create users"
        expect(page).to_not have_link "Create tickets"
      end
    end

  end


  scenario "when clicking on a tag" do
    click_link "Create projects"
    click_link "iteration_1"
    within("#tickets") do
      expect(page).to have_content "Create projects"
      expect(page).to_not have_content "Create users"
    end
  end
end
