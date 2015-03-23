class SearchController < ApplicationController
  before_action :authenticate_user!

  def search
    if params[:query].nil?
      @instructionals = []
    else
      @instructionals = Instructional.search(params[:query])
    end
  end

  def autocomplete
    render json: Instructional.search(params[:term]).map(&:title)
  end
end
