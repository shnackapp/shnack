Rails.configuration.stripe = {
  :secret_key => 'sk_test_xDJ5KS0I8VgJvHSQT1Iuxy56',
  :publishable_key      => 'pk_test_AUn823FKTadliNg29onudWm0'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]