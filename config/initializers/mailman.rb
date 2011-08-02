Mailman.config.pop3 = {
  :username => 'test@groundswellenterprises.com',
  :password => 'gr0undsw3ll',
  :server   => 'pop.gmail.com',
  :port     => 995, # defaults to 110
  :ssl      => true # defaults to false
}

Mailman.config.logger = Logger.new('log/mailman.log')