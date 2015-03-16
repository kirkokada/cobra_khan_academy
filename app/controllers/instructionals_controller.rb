class InstructionalsController < ApplicationController
  before_action :authenticate_user!
  def show
    @instructional = Instructional.find(params[:id])
  end
end
