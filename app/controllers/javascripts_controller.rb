class JavascriptsController < ApplicationController
	def dynamic_vendors
		@vendors = Vendor.find(:all)
	end
end
