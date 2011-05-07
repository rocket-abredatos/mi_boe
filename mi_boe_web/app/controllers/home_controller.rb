class HomeController < ApplicationController
  # GET /
  def index
    @search = Search.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
