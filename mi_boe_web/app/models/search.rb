class Search < ActiveRecord::Base
  attr_accessor :responseHeader
  attr_accessor :response
  attr_accessor :facet_counts
  attr_accessor :highlighting

  DOCS_PER_QUERY = 10
end
