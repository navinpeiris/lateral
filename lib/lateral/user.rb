require 'lateral/api'
require 'lateral/preference'
require 'lateral/similar'

module Lateral
  class User
    attr_reader :id, :created_at, :updated_at

    def initialize(args)
      @id         = args.fetch :id
      @created_at = DateTime.parse(args.fetch :created_at)
      @updated_at = DateTime.parse(args.fetch :updated_at)
    end

    def self.all
      api.get_paginated '/users'
    end

    def self.get(user_id)
      api.get "/users/#{user_id}"
    end

    def self.create
      api.post '/users'
    end

    def self.delete(user_id)
      api.delete "/users/#{user_id}"
    end

    def self.recommendations(user_id, select_from: nil, number: nil)
      api.get "/users/#{user_id}/recommendations",
              query:        { select_from: select_from, number: number },
              result_class: Similar
    end

    def self.preferences(user_id)
      api.get "/users/#{user_id}/preferences", result_class: Preference
    end

    def self.preference(user_id, document_id)
      api.get "/users/#{user_id}/preferences/#{document_id}", result_class: Preference
    end

    def self.create_preference(user_id, document_id)
      api.post "/users/#{user_id}/preferences/#{document_id}", result_class: Preference
    end

    def self.delete_preference(user_id, document_id)
      api.delete "/users/#{user_id}/preferences/#{document_id}", result_class: Preference
    end

    def self.api
      @api ||= API.new(User)
    end
  end
end
