class StadiumsController < ApplicationController
	def list
	  	@stadiums = Stadium.all
	end
	def show
		@stadium = Stadium.find(params[:id])
	end
	def new
	end
	def edit
	end
	def create
	end
end
