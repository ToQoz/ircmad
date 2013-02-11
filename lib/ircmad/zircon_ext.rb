class Ircmad
  class Zircon::Message
    def to_json
      fencoding = -> s { s.respond_to?(:force_encoding) ? s.force_encoding('UTF-8') : s }
      {
        from: fencoding.call(from),
        to: fencoding.call(to),
        body: fencoding.call(body),
        type: fencoding.call(type),
        raw: fencoding.call(raw)
      }.to_json
    end

    # temporary monkey patch
    def params
      @params ||= begin
        params = []
        case
        when !@rest[0].empty?
          middle, trailer, = *@rest
          params = middle.split(" ")
        when !@rest[2].nil? && !@rest[2].empty?
          middle, trailer, = *@rest[2, 2]
          params = middle.split(" ")
        when @rest[1]
          trailer = @rest[1]
        when @rest[3]
          trailer = @rest[3]
        end
        params << trailer if trailer
        params
      end
    end
  end
end
