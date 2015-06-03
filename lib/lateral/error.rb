module Lateral
  class LateralError < StandardError
    attr_reader :code

    def initialize(code, message)
      super message
      @code = code
    end

    def self.from_response(response)
      message = begin
        JSON.parse(response.body)['message']
      rescue JSON::ParserError
        response.body
      end

      new(response.code, message)
    end
  end
end
