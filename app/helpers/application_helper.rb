module ApplicationHelper

	# Converts integer to currency string where integer is amount in hundredths
	# ie 420 returns $4.20 with no options
	def integer_to_currency(amount, options={})
		options[:unit] = "$" if options[:unit].nil?
		options[:separator] = "." if options[:separator].nil?
    return "Free" if amount == 0

		amount_str = amount.to_s
		cents = amount_str[-2,2]
		dollars = amount_str[0..-3]

		return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"

	end

end
