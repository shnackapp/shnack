class StadiaController < ApplicationController
	before_filter :check_manager

	def index
	  	@stadiums = Stadium.all
	end


	def show
		@stadium = Stadium.find(params[:id])
	end
	def new
		@stadium = Stadium.new
	end
	def edit
		@stadium = Stadium.find(params[:id])
	end
	def update
		@stadium = Stadium.find(params[:id])
		@stadium.update_attributes(params[:stadium])
		redirect_to @stadium
	end
	def create
		@stadium = Stadium.create(params[:stadium])
		redirect_to @stadium
	end
	def destroy
		Stadium.find(params[:id]).destroy
		redirect_to :action => :index
	end

	def check_manager
		redirect_to root_path unless user_signed_in? && current_user.is_super
	end
end
