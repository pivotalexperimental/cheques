AUTHENTICATION_CONFIGURATION = YAML.load_file("#{Rails.root}/config/authentication.yml")[Rails.env]

$htaccessUsername = AUTHENTICATION_CONFIGURATION['username']
$htaccessPassword = AUTHENTICATION_CONFIGURATION['password']
