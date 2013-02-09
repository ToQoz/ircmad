class Ircmad
  class IRCClient
    include Configurable

    def initialize(&block)
      instance_eval(&block) if block_given?

      unless @zircon
        @zircon = Zircon.new config

        @zircon.send(:login) if @zircon.respond_to?(:login, true)
        config[:channel_list].each do |channel|
          @zircon.join channel
        end
      end
      @zircon
    end

    def run!
      Ircmad.post_channel.subscribe do |msg|
        data = JSON.parse(msg, :symbolize_names => true) rescue nil
        privmsg data[:channel], ":#{data[:message]}"
      end

      on_privmsg do |msg|
        Ircmad.get_channel << msg
      end

      @zircon.run!
    end

    def method_missing(action, *args, &block)
      @zircon.send(action.to_s, *args, &block)
    end
  end
end
