module Lateral
  class PaginatedArray < Array
    attr_reader :current_page, :per_page, :total, :total_pages, :page_getter

    def initialize(elements, current_page:, per_page:, total:, &block)
      super elements

      @current_page = current_page
      @per_page     = per_page
      @total        = total
      @page_getter  = block

      @total_pages = (total.to_f / per_page).ceil
    end

    def next?
      current_page < total_pages
    end

    def next
      page current_page + 1
    end

    def page(number)
      page_getter.call number
    end
  end
end
