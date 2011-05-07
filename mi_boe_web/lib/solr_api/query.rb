module SolrAPI
  
  class Query < ActiveResource::Base
    
    self.format = :json
    self.site = 'http://188.40.66.148:8090/solr/select/'
    
  end
  
end