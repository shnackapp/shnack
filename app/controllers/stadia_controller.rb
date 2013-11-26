class StadiaController < ApplicationController
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

end
