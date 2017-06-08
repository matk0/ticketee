class TicketSearch
  attr_reader :search_terms
    
  def initialize search_terms
    @search_terms = search_terms
  end

  def search project:, exact_match: false, at_least_one_match: false
    if exact_match
      tickets = project.tickets.search_by_tags terms
      tickets.select { |ticket| ticket.tags.count == normalized_terms.count }
    elsif at_least_one_match
      project.tickets.search_with_at_least_one_matching_tag terms
    else
      project.tickets.search_by_tags terms
    end
  end

  private

    def terms
      normalized_terms.map do |term|
        term.gsub('?', '_').gsub('*', '%')
      end
    end

    def normalized_terms
      search_terms.gsub(/\s+/, '').split(",")
    end
end
