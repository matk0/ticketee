class TicketSearchesController < ApplicationController
  respond_to :js

  def new
    @project = Project.find(params[:project_id])
    authorize @project, :show?

    if search_terms.present?
      ticket_search = TicketSearch.new search_terms
      @tickets = ticket_search.search(project: @project,
                                     exact_match: exact_match,
                                     at_least_one_match: at_least_one_match)
    else
      @tickets = @project.tickets
    end
  end

  private

    def search_terms
      params[:search_terms]
    end

    def exact_match
      params[:exact_match] == "true" ? true : false
    end

    def at_least_one_match
      params[:at_least_one_match] == "true" ? true : false
    end

end
