path = File.join(Rails.root, "config/twilio.yml")
TWILIO_CONFIG = YAML.load(File.read(path))[Rails.env] || {'sid' => '', 'from' => '', 'token' => ''}

Rails.configuration.twilio =  {
	:sid => TWILIO_CONFIG['sid'],
	:from => TWILIO_CONFIG['from'],
	:token => TWILIO_CONFIG['token']
}