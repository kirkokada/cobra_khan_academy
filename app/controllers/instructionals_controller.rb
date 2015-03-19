class InstructionalsController < ApplicationController
  before_action :authenticate_user!

  def show
    @instructional = Instructional.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @instructional = @topic.instructionals.build
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @instructional = @topic.instructionals.build(instructional_params)
    if @instructional.save
      flash[:notice] = "Thanks for the link!"
      redirect_to @topic
    else
      render :new
    end
  end

  private

  def instructional_params
    params.require(:instructional).permit(:url)
  end
end
