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
      c = config.dup

      EM.defer {
        WebSocket.new do
          set :port, c[:websocket_port]
        end.run!
      }

      EM.defer {
        IRCClient.new do
          set :server, c[:host] || '127.0.0.1'
          set :port, c[:port] || '6667'
          set :channel_list, c[:channel_list] || []
          set :username, c[:username]
          set :password, c[:password]
        end.run!
      }
    end
  end
end
