require 'json'
require 'eventmachine'
require 'em-websocket'
require 'zircon'

require "ircmad/version"
require "ircmad/zircon_ext"
require "ircmad/configurable"
require "ircmad/irc_client"
require "ircmad/web_socket"

class Ircmad
  include Configurable

  class << self
    def post_channel
      @post_channel ||= EM::Channel.new
    end

    def get_channel
      @get_channel ||= EM::Channel.new
    end
  end

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def run!
    Thread.abort_on_exception = true
    EM.run do
      c = default_config.merge(config).dup

      EM.defer {
        WebSocket.new do
          set :port, c[:websocket_port]
        end.run!
      }

      EM.defer {
        IRCClient.new do
          set :server, c[:host]
          set :port, c[:port]
          set :channel, c[:channel_list].first
          set :channel_list, c[:channel_list]
          set :username, c[:username]
          set :password, c[:password]
        end.run!
      }
    end
  end

  def default_config
    {
      :server => '127.0.0.1',
      :port => '6667',
      :channel => '',
      :channel_list => [],
      :username => ''
    }
  end
end
