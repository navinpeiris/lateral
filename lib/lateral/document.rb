require 'lateral/api'
require 'lateral/preference'
require 'lateral/similar'

module Lateral
  class Document
    attr_reader :id, :text, :meta, :created_at, :updated_at

    def initialize(args)
      @id         = args.fetch :id
      @text       = args.fetch :text
      @meta       = args.fetch :meta, {}
      @created_at = DateTime.parse(args.fetch(:created_at))
      @updated_at = DateTime.parse(args.fetch(:updated_at))
    end

    def self.all
      api.get_paginated '/documents'
    end

    def self.get(id)
      api.get "/documents/#{id}"
    end

    def self.create(text, meta = {})
      api.post '/documents', data: { text: text, meta: meta.to_json }
    end

    def self.update(id, text, meta = {})
      api.put "/documents/#{id}", data: { text: text, meta: meta.to_json }
    end

    def self.delete(id)
      api.delete "/documents/#{id}"
    end

    def self.preferences(id)
      api.get_paginated "/documents/#{id}/preferences", result_class: Preference
    end

    def self.similar(id, select_from: nil, number: nil)
      api.get "/documents/#{id}/similar", query: { select_from: select_from, number: number }, result_class: Similar
    end

    def self.similar_to_text(text, select_from: nil, number: nil)
      api.post '/documents/similar-to-text',
               data:         { text: text, select_from: select_from, number: number },
               result_class: Similar
    end

    def self.api
      @api ||= API.new(Document)
    end
  end
end
