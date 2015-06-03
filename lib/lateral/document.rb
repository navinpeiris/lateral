module Lateral
  class Document
    attr_reader :id, :created_at, :text, :meta

    def initialize(args)
      @id         = args.fetch 'document_id'
      @created_at = args.fetch 'created_at'
      @text       = args.fetch 'text'
      @meta       = args.fetch 'meta', {}
    end
  end
end
