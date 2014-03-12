module OrdersHelper

	def generate_fake_email
		email = (0...8).map { (65 + rand(26)).chr }.join
		email = email + "@shnackapp.com"
		email
	end
end
