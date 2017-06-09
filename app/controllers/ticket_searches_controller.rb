class TicketSearchesController < ApplicationController
  respond_to :js

  def new
    @project = Project.find(params[:project_id])
    authorize @project, :show?

    if search_terms.present?
      ticket_search = TicketSearch.new search_terms
      @tickets = ticket_search.search(project: @project, search_mode: search_mode)
    else
      @tickets = @project.tickets
    end
  end

  private

    def search_terms
      params[:search_terms]
    end

    def search_mode
      if ["regular_search", "exact_match_search", "at_least_one_match_search"].include?(params[:search_mode]) 
        params[:search_mode]
      else
        raise "Unsupported search mode."
      end
    end
end
