require 'gem_config'

require 'lateral/version'
require 'lateral/document'

module Lateral
  include GemConfig::Base

  with_configuration do
    has :api_key, classes: String
    has :default_per_page, classes: Integer, default: 25
  end

  def self.delete_all_data
    API.new(Object).delete('/delete-all-data')
  end
end
