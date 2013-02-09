require 'ircmad'

Ircmad.new do
  set :host, '127.0.0.1'
  set :port, 6667
  set :channel_list, [ '#channel', '#channel2' ]
  set :username, 'username'
  set :password, 'password'  # if required
  set :websocket_port, 3333  # [default is unused port selected automatically]
end.run!
