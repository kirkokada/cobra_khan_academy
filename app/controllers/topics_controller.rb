class TopicsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @topic = Topic.find(params[:id])
    @instructionals = @topic.instructionals.paginate(page: params[:page])
    @related = @topic.descendant_instructionals
  end
end
