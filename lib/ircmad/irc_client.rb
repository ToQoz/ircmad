class Ircmad
  class IRCClient
    include Configurable

    def initialize(&block)
      instance_eval(&block) if block_given?

      @client = Zircon.new config

      @client.send(:login) if @client.respond_to?(:login, true)
      config[:channel_list].each { |channel| @client.join channel }
    end

    def run!
      Ircmad.post_channel.subscribe do |msg|
        parsed_msg = begin
         JSON.parse(msg, :symbolize_names => true) rescue nil
        rescue JSON::ParserError
          puts "#{msg} is invalid json"
        rescue  => e
          puts "Unexpected error"
          puts e.message
          puts e.backtrace.join("\n")
        end

        if parsed_msg && parsed_msg[:channel] && parsed_msg[:message]
          privmsg parsed_msg[:channel], ":#{parsed_msg[:message]}"
        end
      end

      on_privmsg do |msg|
        Ircmad.get_channel << msg
      end

      @client.run!
    end

    def method_missing(action, *args, &block)
      @client.send(action.to_s, *args, &block)
    end
  end
end
