require 'httparty'

require 'lateral/error'
require 'lateral/paginated_array'

module Lateral
  class API
    include HTTParty

    base_uri 'https://api.lateral.io'
    format :json
    # debug_output $stdout

    query_string_normalizer proc { |query|
                              query.map do |key, value|
                                "#{key}=#{value}" unless value.nil?
                              end.compact.join('&')
                            }

    def initialize(result_class)
      self.class.headers 'Content-Type'     => 'application/json',
                         'Subscription-Key' => Lateral.configuration.api_key

      @result_class = result_class
    end

    def get(path, query: nil, result_class: @result_class)
      convert self.class.get(path, query: query), result_class: result_class
    end

    def get_paginated(path, page: 1, per_page: Lateral.configuration.default_per_page, result_class: @result_class)
      response = self.class.get path, query: { page: page, per_page: per_page }

      convert_paginated response, path: path, page: page, per_page: per_page, result_class: result_class
    end

    def post(path, data: {}, result_class: @result_class)
      convert self.class.post(path, body: data.to_json), result_class: result_class
    end

    def put(path, data: {})
      convert self.class.put(path, body: data)
    end

    def delete(path, result_class: @result_class)
      convert self.class.delete(path), result_class: result_class
    end

    private

    attr_reader :result_class

    def convert(response, result_class: @result_class)
      verify! response

      return if response.body.nil?

      content = JSON.parse(response.body, symbolize_names: true)
      content.is_a?(Array) ? content.map { |c| result_class.new c } : result_class.new(content)
    end

    def convert_paginated(response, path:, page:, per_page:, result_class: @result_class)
      verify! response

      elements = JSON.parse(response.body, symbolize_names: true).map { |e| result_class.new(e) }

      page_getter = lambda do |new_page_number|
        get_paginated(path, page: new_page_number, per_page: per_page, result_class: result_class)
      end

      Lateral::PaginatedArray.new elements,
                                  current_page: page,
                                  per_page:     response.headers['Per-Page'].to_i,
                                  total:        response.headers['Total'].to_i,
                                  &page_getter
    end

    def verify!(response)
      fail Lateral::Error.from_response response unless response.success?
    end
  end
end
