class ShnackController < ApplicationController
	def logged_in
		redirect_to :action => "index"
	end

	def index
	end
end
