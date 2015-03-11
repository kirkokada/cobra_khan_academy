class DisciplinesController < ApplicationController
  before_action :authenticate_user!

  def show
    @discipline = Discipline.find(params[:id])
  end

  def index
    
  end
end
