module Lateral
  class Similar
    attr_reader :id, :similarity

    def initialize(args)
      @id         = args.fetch :id
      @similarity = args.fetch :similarity
    end
  end
end
