module Lateral
  class Preference
    attr_reader :user_id, :document_id, :created_at, :updated_at

    def initialize(args)
      @user_id     = args.fetch :user_id
      @document_id = args.fetch :document_id
      @created_at  = DateTime.parse(args.fetch :created_at)
      @updated_at  = DateTime.parse(args.fetch :updated_at)
    end
  end
end
