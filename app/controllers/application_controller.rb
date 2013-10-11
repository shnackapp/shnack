class ApplicationController < ActionController::Base
  protect_from_forgery
  def index
  	@s = Stadium.first || Stadium.create(:name => "Dodgers Stadium")
  end

  def select_stadium
  	@stadiums = Stadium.all
  end
end
