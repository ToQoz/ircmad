class Ircmad
  class Zircon::Message
    def to_json
      fencoding = -> s { s.respond_to?(:force_encoding) ? s.force_encoding('UTF-8') : s }
      {
        username: fencoding.call(from),
        channel: fencoding.call(to),
        body: fencoding.call(body),
        type: fencoding.call(type)
      }.to_json
    end
  end
end
