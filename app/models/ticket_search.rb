class TicketSearch
  attr_reader :search_terms
    
  def initialize search_terms
    @search_terms = search_terms
  end

  def search project:, search_mode:
    project.tickets.send search_mode, terms
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
