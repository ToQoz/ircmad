class Ircmad
  class IRCClient
    attr_accessor :client
    include Configurable

    def initialize(&block)
      instance_eval(&block) if block_given?

      Ircmad.post_channel.subscribe(&on_post)
    end

    def run!
      self.client ||= Zircon.new config
      client.on_join do |message|
        config[:channel_list].each { |channel| client.join channel }
      end
      client.on_privmsg { |msg| Ircmad.get_channel << msg; }
      client.run!
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EPIPE => e
      puts "#{e}\nRetry Now!"
      close_client
      sleep 1
      retry
    rescue ArgumentError
      msg = $!.message
      if /Invalid message:.*/ =~ msg
        retry
      else
        puts 'Unexpected Error!'
        puts msg
        exit!
      end
    rescue => e
      puts 'Unexpected Error!'
      puts e
      exit!
    end

    def on_post
      proc { |msg|
        m = begin
         JSON.parse(msg, :symbolize_names => true)
        rescue JSON::ParserError
          puts "#{msg} is invalid json"
        end

        if m && client
          m[:type] ||= 'privmsg'

          case m[:type]
          when 'privmsg'
            client.privmsg m[:channel], ":#{m[:message]}"
          end
        end
      }
    end



    def close_client
      # oh...
      if @client
        socket = @client.instance_variable_get(:@socket)
        if socket.respond_to?(:closed?) && !socket.closed?
          socket.close
        end
        @client = nil
      end
    end

    def method_missing(action, *args, &block)
      client.send(action.to_s, *args, &block)
    end
  end
end
