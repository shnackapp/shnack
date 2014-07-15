class ReceiptMailer < ActionMailer::Base
  default from: "shnackapp@gmail.com"

  def receipt_email(order)
  	@order = order

    @customer = @order.customer
    @owner = @order.owner
    @items = Hash[@owner.menu.items.map{|it| [it.id, it]}]
    @order_items = @order.order_items
	mail(to: @customer.email, subject: "Confirmation For Order ##{@order.order_number}")
  end



end
