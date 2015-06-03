require 'httparty'

require_relative 'document'
require_relative 'recommendation'
require_relative 'error'

module Lateral
  class TextMatcher
    include HTTParty

    base_uri 'https://recommender-api.lateral.io'
    format :json
    # debug_output $stdout

    def initialize(api_key)
      TextMatcher.default_params 'subscription-key' => api_key
    end

    API_METHODS = {
      add:               { method: :post, endpoint: '/add/', result_class: Document },
      delete:            { method: :post, endpoint: '/delete/', result_class: Document },
      delete_all:        { method: :post, endpoint: '/delete-all/' },
      fetch:             { method: :get, endpoint: '/fetch/', result_class: Document },
      list:              { method: :get, endpoint: '/list/' },
      recommend_by_id:   { method: :post, endpoint: '/recommend-by-id/', result_class: Recommendation },
      recommend_by_text: { method: :post, endpoint: '/recommend-by-text/', result_class: Recommendation },
      update_meta:       { method: :post, endpoint: '/update-meta/', result_class: Document },
      update_text:       { method: :post, endpoint: '/update-text/', result_class: Document }
    }

    API_METHODS.each do |method, options|
      define_method(method) do |args = nil|
        call_api(args, options, raise_error_on_failure: false)
      end

      define_method("#{method}!") do |args = nil|
        call_api(args, options, raise_error_on_failure: true)
      end
    end

    private

    def call_api(args, options, raise_error_on_failure: false)
      response = self.class.send(options[:method], options[:endpoint], body: args)

      if response.success?
        return nil if response.body.nil? || response.body.empty?

        result = JSON.parse(response.body)

        if (result_class = options[:result_class])
          result = result.is_a?(Array) ? (result.map { |r| result_class.new(r) }) : result_class.new(result)
        end

        result
      else
        fail LateralError.from_response(response) if raise_error_on_failure
      end
    end
  end
end
