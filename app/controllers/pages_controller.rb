class PagesController < ApplicationController
  def home
    if current_user
      @new_instructionals = Instructional.recent.limit(5)
    end
  end
end
