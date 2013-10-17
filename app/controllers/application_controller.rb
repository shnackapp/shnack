class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup

  def setup
  	unless params[:stadium_id].nil?
  		@stadium = Stadium.find(params[:stadium_id])
  	end
  end

  def select_stadium
  	@stadiums = Stadium.all
  end
end
