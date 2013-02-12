# Ircmad

Bringing IRC into WebSocket.
```
IRC <-> WebSoket Server(This product) <-> WebSocket Client
```
If you use this gateway, you can assess IRC from browser easily.

Data format is JSON.
```
WebSocket Server - '{"from":"ToQoz","to":"#channel1","body":"hello world","type":"privmsg"}' -> WebSocket Client
WebSocket Server <- '{"to":"#channel1","body":"yes!!!"}' -> WebSocket Client
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ircmad'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install ircmad
```

## Usage

```ruby
# proxy.rb
require 'ircmad'
Ircmad.new do
  set :host, '127.0.0.1'
  set :port, 6667
  set :channel_list, [ '#channel', '#channel2' ]
  set :username, 'username'
  set :password, 'password'  # if required
  set :websocket_port, 3333  # [default is unused port selected automatically]
end.run!
```
$
```sh
$ ruby proxy.rb
```

In browser
```javascript
var socket = new WebSocket('ws://localhost:3333')

// Send
socket.send(JSON.stringify({ to: '#channel1', body: 'yeah', type: 'privmsg' }))
socket.send(JSON.stringify({ type: 'join', to: '#ruby' }))

// Get
socket.onmessage = function(msg) { console.log(msg.data) };
// => '{"from":"ToQoz","to":"#channel1","body":"hello world","type":"privmsg"}'

// => {"from":"ToQoz","to":"#ruby","body":null,"type":"join"}
// => {"from":"hybrid7.debian.local","to":"ToQoz","body":"@","type":"353"}
// => {"from":"hybrid7.debian.local","to":"ToQoz","body":"#ruby","type":"366"}
```


## Examples

In examples/


## Links
Blog entry that is introduction of this product. (In Japanese) [WebSocketからIRC繋げるやつ作った](http://toqoz.hateblo.jp/entry/2013/02/09/185713)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
