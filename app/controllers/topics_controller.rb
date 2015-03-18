class TopicsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @topic = Topic.find(params[:id])
    @instructionals = @topic.descendant_instructionals.recent.paginate(page: params[:page])
  end
end
