class ReceiptMailer < ActionMailer::Base
  default from: "shnackapp@gmail.com"

  def receipt_email(order)
  	@order = order

  	@user = @order.user
    @owner = @order.owner
    @items = Hash[@owner.menu.items.map{|it| [it.id, it]}]
    @order_details = @order.details_hash
	mail(to: @user.email, subject: "Confirmation For Order ##{@order.id}")
  end
end
