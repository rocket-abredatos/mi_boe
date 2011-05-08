class SearchesController < ApplicationController
  # POST /searches
  # POST /searches.xml
  def create
    query = SolrAPI::Query.find(
      :one,
      :from => SolrAPI::Query.prefix,
      :params => {
        :q => (params[:search][:query].present? ? params[:search][:query] : '*:*'),
        :start => (params[:search][:start].present? ? params[:search][:start] : '0'),
        :fq => (params[:search][:fq].present? ? (params[:search][:fq].split(':')[0] + ":\"" + params[:search][:fq].split(':')[1] + "\"") : ''),
        :wt => 'json'
      }
    )
    @search = Search.new(query.attributes)

    respond_to do |format|
      format.html { render :action => 'show' }
      format.xml  { render :xml => @search, :status => :created, :location => @search }
    end
  end
end
