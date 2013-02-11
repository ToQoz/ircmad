class Ircmad
  class WebSocket
    class Buffer
      attr_reader :ary, :max

      def initialize(_max = 100)
        @max = _max
      end

      def push(element)
        if size > max
          shift
        end
        ary << element
      end
      alias_method :<<, :push

      def ary
        @ary ||= []
      end

      def method_missing(action, *args, &block)
        if ary.respond_to?(action.to_s)
          ary.send(action.to_s, *args, &block)
        else
          super
        end
      end
    end
  end
end
