module ApplicationHelper

	# Converts integer to currency string where integer is amount in hundredths
	# ie 420 returns $4.20 with no options
	def integer_to_currency(amount, options={})
		options[:unit] = "$" if options[:unit].nil?
		options[:separator] = "." if options[:separator].nil?

		amount_str = amount.to_s
		cents = amount_str[-2,2]
		dollars = amount_str[0..-3]

		return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"

	end

	# parse order details string
	# in the form "item_id qty item_id qty item_id qty ..."
	# returns Hash: {item_id => qty, item_id => qty ... }
	def parse_order_details(order_details)
		order_details = order_details.split
		order_details = order_details.map.with_index { |v, i|[order_details[i].to_i, order_details[i+1].to_i] if i.even? && order_details[i+1].to_i != 0 }
		order_details.reject! { |v| v.nil? }
		order_details = Hash[order_details]

		return order_details
	end

	#converts a orders details hash:  Hash: {item_id => qty, item_id => qty ... }
	# to a hash:
	# Hash: { "item_name" => qty, "item_name" => qty }

	def convert_details_to_description(order_details)
		description = ""
		order_details.each { |id, qty| description = description + "#{qty} #{Item.find(id).name}\n"}

		description
	end

end
