class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :setup

  def setup
  	unless params[:stadium_id].nil?
  		@stadium = Stadium.find(params[:stadium_id])
  	end
  end

  def select_stadium
  	@stadiums = Stadium.all

    # An example of the token sent back when a device registers for notifications
    token = "<2410d83b 257e501b 73cb9bc6 c44a9b4e fa46aab1 99694c8e fb01088c 3c5aca75>"

    # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
    notification = Houston::Notification.new(device: token)
    notification.alert = "Hello, World!"

    # Notifications can also change the badge count, have a custom sound, indicate available Newsstand content, or pass along arbitrary data.
    notification.badge = 57
    notification.sound = "sosumi.aiff"
    notification.content_available = true
    notification.custom_data = {foo: "bar"}

    # And... sent! That's all it takes.
    APN.push(notification)
  end

	def select_vendor
		@stadium = Stadium.find(params[:object_id])
		@vendors = Vendor.all
	end

	def select_items
		@vendor = Vendor.find(params[:object_id])
		@stadium = @vendor.stadium
	end


end
