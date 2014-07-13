module ApplicationHelper

	# Converts integer to currency string where integer is amount in hundredths
	# ie 420 returns $4.20 with no options
	def integer_to_currency(amount, options={})
		    options[:unit] = "$" if options[:unit].nil?
    options[:separator] = "." if options[:separator].nil?

    amount_str = amount.to_s
    cents = amount_str.length < 2 ? "00" : amount_str[-2,2]
    dollars = amount_str.length < 3 ? "0" : amount_str[0..-3]

    return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"

	end

	def mark_available_orders_as_withdrawn(vendor, transfer)
		orders = vendor.orders.available
		orders.each { |order| order.update_attributes(:withdrawn => true, :transfer_id => transfer.id) }
	end

end
