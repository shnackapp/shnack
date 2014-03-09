class LocationsController < ApplicationController

	def index
	  	@locations = Location.all
	end
	def show
		@locations = Location.find(params[:id])
	end
	def new
		@locations = Location.new
	end
	def edit
		@locations = Location.find(params[:id])
	end
	def update
		@locations = Location.find(params[:id])
		@locations.update_attributes(params[:location])
		redirect_to @locations
	end
	def create
		@locations = Location.create(params[:location])
		redirect_to @locations
	end
	def destroy
		Location.find(params[:id]).destroy
		redirect_to :action => :index
	end
end
