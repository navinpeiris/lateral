module Lateral
  class Recommendation
    attr_reader :document_id, :distance

    def initialize(args)
      @document_id = args.fetch 'document_id'
      @distance    = args.fetch 'distance'
    end
  end
end
