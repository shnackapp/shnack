path = File.join(Rails.root, "config/stripe.yml")
STRIPE_CONFIG = YAML.load(File.read(path))[Rails.env] || {'secret_key' => '', 'publishable_key' => ''}


Rails.configuration.stripe = {
  :secret_key => STRIPE_CONFIG['secret_key'],
  :publishable_key      => STRIPE_CONFIG['publishable_key']
}


Stripe.api_key = Rails.configuration.stripe[:secret_key]